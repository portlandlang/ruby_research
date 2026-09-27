# frozen_string_literal: true

require 'prism'

module RubyResearch
  module Reports
    # Answers: "Which gems use parts of Ruby that Portland is removing or
    # changing?" and "Which gems could Just Work™ in Portland?"
    #
    # Loads config/portland_removals.yml (derived from the Portland docs),
    # then scans each sampled gem's sources with Prism, matching removed
    # features by AST node type, called/defined method name, and constant
    # reference. Each gem is graded by the hardest difference it touches
    # (GRADES); a gem touching none is a Just Work™ candidate at the syntax
    # level. Semantic changes with no static detection (truthiness, ambient
    # nil, mutability) are reported separately since they affect nearly all
    # code via the type checker.
    class PortlandCompatibility
      REMOVALS_FILE = PortlandCompatibilityAnalysis::REMOVALS_FILE

      # At full corpus the candidate list runs to tens of thousands of gem
      # names. Listing them all made a 16MB report that no human could read
      # and that git had to store afresh every run, so record the count plus
      # a sample; the full list is reproducible by rerunning.
      CANDIDATE_SAMPLE_SIZE = 100

      # A gem's grade is the hardest difference it touches, easiest first:
      # nothing; only taste differences, each one a spelling the migration
      # linter can rewrite; a thesis difference, the language's price; or a
      # gap or undecided question, which no rewrite can answer yet.
      GRADES = ['runs as is', 'taste only', 'thesis', 'gap or undecided'].freeze

      def initialize(cohorts: Cohorts.new,
                     compact_index: CompactIndexClient.new,
                     minutes: nil,
                     reports_dir: REPORTS_DIR,
                     results_dir: File.join(DATA_DIR, 'results', 'portland_compatibility'),
                     sample: nil,
                     seed: 42,
                     sources: GemSourceClient.new,
                     workers: 1)
        @analysis = PortlandCompatibilityAnalysis.new(compact_index: compact_index, sources: sources)
        @cohorts = cohorts
        @compact_index = compact_index
        @minutes = minutes
        @reports_dir = reports_dir
        analysis_file = File.join(__dir__, 'portland_compatibility_analysis.rb')
        @results = GemResults.new(directory: results_dir, inputs: [analysis_file, REMOVALS_FILE])
        @sample = sample
        @seed = seed
        @workers = workers
      end

      # Analyzes every selected gem not already recorded, then writes the
      # report once all of them are. With a time budget (`minutes`), a run
      # that can't finish records what it reached and writes nothing; the
      # next run picks up there.
      def run
        entries = selected_names.filter_map do |name|
          latest = @compact_index.latest_version_of(name)
          [name, "#{latest[:version]}-#{latest[:platform]}"] if latest
        end
        pending = entries.reject { |name, version| @results.done?(name, version) }
        deadline = @minutes ? Time.now + (@minutes * 60) : Time.now + (365 * 24 * 3600)
        warn "  portland-compatibility: #{pending.size} of #{entries.size} gems to analyze, #{@workers} workers"
        @results.compute(pending, deadline: deadline, workers: @workers) { |name, _version| @analysis.matched_features(name) }

        recorded = @results.all
        remaining = entries.count { |name, version| recorded.dig(name, :version) != version }
        if remaining.positive?
          warn "  portland-compatibility: #{remaining} gems still to analyze — rerun to continue"
          return []
        end

        write(entries.to_h { |name, _version| [name, recorded.fetch(name)] })
      end

      private

      def write(recorded)
        gems_by_feature = Hash.new { |hash, key| hash[key] = [] }
        features_by_gem = {}
        errors = []
        tally = CohortTally.new(cohorts: @cohorts)
        recorded.each do |name, entry|
          if entry[:error]
            errors << { gem: name, error: entry[:error] }
            next
          end
          matched = entry[:result]
          next if matched.nil?

          features_by_gem[name] = matched
          tally.record(name, matched)
          matched.each { gems_by_feature[it] << name }
        end

        clean_gems = features_by_gem.select { |_gem, used| used.empty? }.keys.sort
        grades = features_by_gem.values.map { grade(it) }.tally
        data = {
          corpus_size: @compact_index.names.size,
          sampled: @sample,
          analyzed: features_by_gem.size,
          errors: errors,
          removals_file: 'config/portland_removals.yml',
          gems_by_grade: GRADES.to_h { [it, grades.fetch(it, 0)] },
          open_questions: unblocked_by(features_by_gem),
          just_work_candidates_count: clean_gems.size,
          just_work_candidates_sample: clean_gems.first(CANDIDATE_SAMPLE_SIZE),
          gems_affected_by_feature: gems_by_feature.transform_values(&:size).sort_by { |_feature, count| -count }.to_h,
          undetectable_semantic_changes: undetectable_features.map { it['name'] },
          cohort_sizes: tally.cohort_sizes,
          share_by_era: tally.shares
        }
        writer = ReportWriter.new(name: 'portland_compatibility', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data))
      end

      def features = @analysis.features

      def open_question?(feature) = feature['difference'] == 'gap' || feature['status'] == 'undecided'

      # For each gap or undecided feature: how many gems it is the only open
      # question for (answer it and they have only decided differences
      # left), and how many it is the only listed difference of any kind for
      # (answer it favorably and they run as is). Ranks the open questions
      # by the gems they hold back.
      def unblocked_by(features_by_gem)
        open_names = features.select { open_question?(it) }.map { it['name'] }
        counts = Hash.new { |hash, key| hash[key] = { sole_open_question: 0, sole_difference: 0 } }
        features_by_gem.each_value do |used|
          open_used = used & open_names
          next unless open_used.size == 1

          counts[open_used.first][:sole_open_question] += 1
          counts[open_used.first][:sole_difference] += 1 if used.size == 1
        end
        counts.sort_by { |_name, count| -count[:sole_open_question] }.to_h
      end

      def grade(feature_names)
        used = features.select { feature_names.include?(it['name']) }
        return 'gap or undecided' if used.any? { open_question?(it) }
        return 'thesis' if used.any? { it['difference'] == 'thesis' }
        return 'taste only' if used.any?

        'runs as is'
      end

      def undetectable_features
        features.reject { it['node_types'] || it['method_names'] || it['constant_names'] }
      end

      def selected_names
        names = @compact_index.names
        return names unless @sample

        names.sample(@sample, random: Random.new(@seed))
      end

      def markdown_for(data)
        lines = []
        lines << '# Portland compatibility across RubyGems.org'
        lines << ''
        scope = Scope.describe(sampled: data[:sampled], analyzed: data[:analyzed])
        lines << "Based on #{scope}, out of #{data[:corpus_size]} on RubyGems.org, " \
                 "scanned for the Ruby features Portland removes or changes (#{data[:removals_file]})."
        lines << ''
        lines << '## Gems by the hardest difference they touch'
        lines << ''
        lines << 'Each gem is graded by the hardest listed difference its source touches (principle 2): ' \
                 'none; only taste differences, spellings a linter can rewrite; a thesis difference, ' \
                 "the language's price; or a gap or undecided question, which no rewrite answers yet. " \
                 'Semantic changes with no static detection (below) apply to every gem and are not graded.'
        lines << ''
        lines << '| Grade | Gems | % of gems |'
        lines << '|---|---:|---:|'
        data[:gems_by_grade].each do |grade, count|
          grade_percent = data[:analyzed].zero? ? 0 : (count * 100.0 / data[:analyzed]).round(1)
          lines << "| #{grade} | #{count} | #{grade_percent}% |"
        end
        lines << ''
        lines << '## Open questions, by the gems they hold back'
        lines << ''
        lines << 'For each gap or undecided question: the gems for which it is the only open question ' \
                 '(answered, they have only decided differences left) and the gems for which it is the ' \
                 'only listed difference of any kind (answered favorably, they run as is).'
        lines << ''
        lines << '| Question | Owner | Only open question | Only difference |'
        lines << '|---|---|---:|---:|'
        data[:open_questions].each do |feature, count|
          owner = features.find { it['name'] == feature }['owner']
          lines << "| #{feature} | #{owner} | #{count[:sole_open_question]} | #{count[:sole_difference]} |"
        end
        lines << ''
        lines << '## Gems affected, by removed/changed feature'
        lines << ''
        lines << '| Feature | Difference | Status | Gems | % of gems |'
        lines << '|---|---|---|---:|---:|'
        data[:gems_affected_by_feature].each do |feature, count|
          feature_percent = (count * 100.0 / data[:analyzed]).round(1)
          listed = features.find { it['name'] == feature }
          lines << "| #{feature} | #{listed['difference']} | #{listed['status']} | #{count} | #{feature_percent}% |"
        end
        lines << ''
        lines << '## By era'
        lines << ''
        lines << 'Share of gems in each cohort touching each removal. A feature well below its cohort share'
        lines << 'is already fading on its own; one above it is still being written today.'
        lines << ''
        lines.concat(CohortTable.render(shares: data[:share_by_era], cohort_sizes: data[:cohort_sizes],
                                        label: 'Feature'))
        lines << ''
        lines << '## Semantic changes with no static detection'
        lines << ''
        lines << 'These affect nearly all code via the type checker rather than any syntax form:'
        lines << ''
        data[:undetectable_semantic_changes].each { lines << "- #{it}" }
        lines << ''
        lines << '## Just Work™ candidates'
        lines << ''
        lines << "#{data[:just_work_candidates_count]} gems touch no listed difference. First " \
                 "#{data[:just_work_candidates_sample].size}, alphabetically:"
        lines << ''
        data[:just_work_candidates_sample].each { lines << "- #{it}" }
        lines << ''
        lines << "Errors: #{data[:errors].size}"

        lines.join("\n")
      end
    end
  end
end
