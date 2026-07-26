# frozen_string_literal: true

require 'prism'

module RubyResearch
  module Reports
    # Answers: "What parts of Ruby language are used in gems published to
    # RubyGems.org?" and "Are there parts fully unused?"
    #
    # For each gem (sampled — full corpus means downloading every gem),
    # downloads the latest release, parses every .rb file with Prism, and
    # tallies AST node types two ways:
    #   - occurrences: total count of each node type across all sources
    #   - gem coverage: how many gems use each node type at least once
    # Node types that Prism defines but no sampled gem produces are listed
    # as unused. Files Prism can't parse are counted as parse errors —
    # those gems no longer even parse under current Ruby.
    class FeatureUsage
      # A gem whose newest release predates this is treated as stale for the
      # "only used by unmaintained gems" question. 2020 sits well past the
      # 2014 peak in the gem-ages histogram without being so recent that
      # ordinary maintained-but-quiet gems get swept in.
      STALE_CUTOFF = '2020'
      DEPENDENT_RANK = { '0' => 0, '1-3' => 1, '4-10' => 2, '11-100' => 3, '100+' => 4 }.freeze

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
        names = selected_names
        occurrences = Hash.new(0)
        gems_using = Hash.new { |hash, key| hash[key] = [] }
        parse_errors = []
        errors = []
        analyzed = []

        @tally = CohortTally.new(cohorts: @cohorts)
        progress = Progress.new(label: 'feature-usage')
        names.each_with_index do |name, index|
          progress.tick(index + 1, names.size)
          node_types = node_types_for(name, parse_errors: parse_errors)
          next if node_types.nil?

          analyzed << name
          # Every node is counted here already, so the density denominator
          # is just the sum — no extra traversal needed.
          @tally.record(name, node_types.keys.map(&:to_s))
          @tally.record_sites(name, node_types.transform_keys(&:to_s), total_nodes: node_types.values.sum)
          node_types.each do |type, count|
            occurrences[type] += count
            gems_using[type] << name
          end
        rescue StandardError => e
          errors << { gem: name, error: e.message }
        end
        progress.finish

        all_node_types = Prism.constants.grep(/Node\z/).map { prism_node_type(it) }.compact.sort
        used_types = occurrences.keys.map(&:to_s).sort
        unused_types = all_node_types - used_types

        data = {
          corpus_size: @compact_index.names.size,
          sampled: @sample,
          analyzed: analyzed.size,
          errors: errors,
          parse_error_count: parse_errors.size,
          parse_errors: parse_errors,
          prism_node_type_count: all_node_types.size,
          used_node_type_count: used_types.size,
          unused_node_types: unused_types,
          gem_coverage: gems_using.transform_values(&:size).sort_by { |_type, count| -count }.to_h,
          occurrences: occurrences.sort_by { |_type, count| -count }.to_h
        }.merge(cohort_data(gems_using))
        writer = ReportWriter.new(name: 'feature_usage', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data))
      end

      private

      # Corpus-wide counts weight a gem abandoned in 2009 the same as rails.
      # Slicing each node type by the cohort of the gems using it answers
      # README's "are there parts of the language only used by very
      # old/unmaintained gems?" — a type whose newest user last shipped
      # years ago, or whose users nobody depends on, is dead in practice
      # even though the corpus-wide count is non-zero.
      def cohort_data(gems_using)
        keys = @cohorts.by_gem
        by_era = {}
        newest_release = {}
        peak_dependents = {}

        gems_using.each do |type, users|
          cohorts = users.filter_map { keys[it] }
          by_era[type] = cohorts.map { it[:era] }.tally.sort.to_h
          newest_release[type] = cohorts.filter_map { it[:last_release_year] }.max
          peak_dependents[type] = cohorts.map { DEPENDENT_RANK.fetch(it[:dependents], 0) }.max.to_i
        end

        {
          stale_cutoff_year: STALE_CUTOFF,
          usage_by_era: by_era.sort.to_h,
          era_cohort_sizes: @tally.cohort_sizes,
          share_by_era: @tally.shares,
          site_totals_by_era: @tally.site_totals,
          composition_by_era: @tally.site_composition,
          # No density here: this report's "sites" ARE AST nodes, so its
          # density is composition times a constant. Reporting both would
          # imply two independent measurements.
          node_totals_by_era: @tally.node_totals,
          newest_using_gem_by_type: newest_release.sort.to_h,
          types_only_in_stale_gems: stale_types(newest_release),
          types_only_in_undepended_gems: peak_dependents.select { |_type, rank| rank.zero? }.keys.sort
        }
      end

      def stale_types(newest_release)
        stale = newest_release.select { |_type, year| year && year < STALE_CUTOFF }
        stale.sort_by { |_type, year| year }.to_h
      end

      def selected_names
        names = @compact_index.names
        return names unless @sample

        names.sample(@sample, random: Random.new(@seed))
      end

      # Ask Prism for the node's own type symbol rather than deriving it
      # from the class name: acronyms don't survive naive snake-casing
      # (XStringNode is :x_string_node, not :xstring_node).
      def prism_node_type(constant_name)
        constant = Prism.const_get(constant_name)
        return nil unless constant.is_a?(Class) && constant < Prism::Node && constant.respond_to?(:type)

        constant.type.to_s
      end

      # Returns a tally of node types across the gem's Ruby files, or nil
      # when the gem has no ruby-platform release to analyze.
      def node_types_for(name, parse_errors:)
        versions = @compact_index.versions_of(name)
        latest = versions.rfind { it[:platform] == 'ruby' } || versions.last
        return nil unless latest

        tally = Hash.new(0)
        @sources.each_ruby_file(name, latest[:version], platform: latest[:platform]) do |path, source|
          result = Prism.parse(source)
          if result.success?
            count_nodes(result.value, tally)
          else
            parse_errors << { gem: name, file: path }
          end
        end
        tally
      end

      def count_nodes(root, tally)
        queue = [root]
        until queue.empty?
          node = queue.pop
          tally[node.type] += 1
          queue.concat(node.compact_child_nodes)
        end
      end

      def markdown_for(data)
        lines = []
        lines << '# Ruby language feature usage across RubyGems.org'
        lines << ''
        scope = Scope.describe(sampled: data[:sampled], analyzed: data[:analyzed])
        lines << "Prism AST node tally for the latest release of #{scope}, " \
                 "out of #{data[:corpus_size]} gems on RubyGems.org."
        lines << ''
        lines << "Prism defines #{data[:prism_node_type_count]} node types; #{data[:used_node_type_count]} appear in the sample."
        lines << "Files that no longer parse under current Ruby: #{data[:parse_error_count]}."
        lines << ''
        lines << '## Node types unused by any sampled gem'
        lines << ''
        data[:unused_node_types].each { lines << "- #{it}" }
        lines << ''
        lines << "## Node types last used before #{data[:stale_cutoff_year]}"
        lines << ''
        lines << 'Alive in the corpus but not in maintained code: no gem using these has shipped a release'
        lines << "since #{data[:stale_cutoff_year]}. Listed with the year of the newest gem that uses them."
        lines << ''
        if data[:types_only_in_stale_gems].empty?
          lines << '_None — every node type is used by at least one recently released gem._'
        else
          lines << '| Node type | Newest using gem |'
          lines << '|---|---|'
          data[:types_only_in_stale_gems].each { |type, year| lines << "| #{type} | #{year} |" }
        end
        lines << ''
        lines << '## Node types used only by gems nobody depends on'
        lines << ''
        if data[:types_only_in_undepended_gems].empty?
          lines << '_None — every node type is used by at least one gem with dependents._'
        else
          data[:types_only_in_undepended_gems].each { lines << "- #{it}" }
        end
        lines << ''
        lines << '## By era'
        lines << ''
        lines << 'Share of gems in each cohort using the node type, then what share of that cohort\'s AST'
        lines << 'the type accounts for. The second is scale-free; the first is not.'
        lines << ''
        lines.concat(CohortTable.render(shares: data[:share_by_era],
                                        cohort_sizes: data[:era_cohort_sizes],
                                        label: 'Node type'))
        lines << ''
        lines << '### Composition of the AST'
        lines << ''
        lines.concat(CohortTable.composition(composition: data[:composition_by_era],
                                             site_totals: data[:site_totals_by_era],
                                             label: 'Node type'))
        lines << ''
        lines << '## Gem coverage (how many gems use each node type)'
        lines << ''
        lines << '| Node type | Gems | % of gems | Total occurrences |'
        lines << '|---|---|---|---|'
        total = data[:analyzed]
        data[:gem_coverage].each do |type, count|
          percent = (count * 100.0 / total).round(1)
          lines << "| #{type} | #{count} | #{percent}% | #{data[:occurrences][type]} |"
        end
        lines << ''
        lines << "Errors: #{data[:errors].size}"

        lines.join("\n")
      end
    end
  end
end
