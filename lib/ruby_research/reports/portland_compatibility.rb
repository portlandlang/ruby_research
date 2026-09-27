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
      REMOVALS_FILE = File.join(ROOT, 'config', 'portland_removals.yml')

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
                     reports_dir: REPORTS_DIR,
                     sample: nil,
                     seed: 42,
                     sources: GemSourceClient.new)
        @cohorts = cohorts
        @compact_index = compact_index
        @reports_dir = reports_dir
        @sample = sample
        @seed = seed
        @sources = sources
      end

      def run
        gems_by_feature = Hash.new { |hash, key| hash[key] = [] }
        features_by_gem = {}
        errors = []
        names = selected_names

        tally = CohortTally.new(cohorts: @cohorts)
        progress = Progress.new(label: 'portland-compatibility')
        names.each_with_index do |name, index|
          progress.tick(index + 1, names.size)
          usage = usage_for(name)
          next if usage.nil?

          matched = detectable_features.select { feature_used?(it, usage) }.map { it['name'] }
          features_by_gem[name] = matched
          tally.record(name, matched)
          matched.each { gems_by_feature[it] << name }
        rescue StandardError => e
          errors << { gem: name, error: e.message }
        end
        progress.finish

        clean_gems = features_by_gem.select { |_gem, used| used.empty? }.keys.sort
        grades = features_by_gem.values.map { grade(it) }.tally
        data = {
          corpus_size: @compact_index.names.size,
          sampled: @sample,
          analyzed: features_by_gem.size,
          errors: errors,
          removals_file: 'config/portland_removals.yml',
          gems_by_grade: GRADES.to_h { [it, grades.fetch(it, 0)] },
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

      private

      def features = @features ||= YAML.safe_load_file(REMOVALS_FILE).fetch('features')

      def grade(feature_names)
        used = features.select { feature_names.include?(it['name']) }
        return 'gap or undecided' if used.any? { it['difference'] == 'gap' || it['status'] == 'undecided' }
        return 'thesis' if used.any? { it['difference'] == 'thesis' }
        return 'taste only' if used.any?

        'runs as is'
      end

      def detectable_features
        features.select { it['node_types'] || it['method_names'] || it['constant_names'] }
      end

      def undetectable_features
        features.reject { it['node_types'] || it['method_names'] || it['constant_names'] }
      end

      def selected_names
        names = @compact_index.names
        return names unless @sample

        names.sample(@sample, random: Random.new(@seed))
      end

      def feature_used?(feature, usage)
        usage[:node_types].intersect?(Array(feature['node_types'])) ||
          usage[:method_names].intersect?(Array(feature['method_names'])) ||
          usage[:constant_names].intersect?(Array(feature['constant_names']))
      end

      # Collects the node types, called/defined method names, and constant
      # reads across a gem's Ruby files. Returns nil when the gem has no
      # release to analyze.
      def usage_for(name)
        latest = @compact_index.latest_version_of(name)
        return nil unless latest

        usage = { node_types: Set.new, method_names: Set.new, constant_names: Set.new }
        @sources.each_ruby_file(name, latest[:version], platform: latest[:platform]) do |_path, source|
          result = Prism.parse(source)
          collect(result.value, usage) if result.success?
        end
        usage
      end

      def collect(root, usage)
        queue = [root]
        until queue.empty?
          node = queue.pop
          usage[:node_types] << node.type.to_s
          case node
          when Prism::CallNode, Prism::DefNode then usage[:method_names] << node.name.to_s
          when Prism::ClassNode then usage[:node_types] << 'class_node_with_superclass' if node.superclass
          when Prism::ConstantReadNode then usage[:constant_names] << node.name.to_s
          end
          queue.concat(node.compact_child_nodes)
        end
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
