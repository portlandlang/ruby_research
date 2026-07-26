# frozen_string_literal: true

require 'prism'

module RubyResearch
  module Reports
    # Census of nil-handling idioms, feeding Portland's optionals design
    # and sizing the polyfill/autocorrect work.
    #
    # Counts, per sampled gem: nil? checks, == nil / != nil comparisons,
    # safe navigation (&.), || defaults and ||= memoization, `foo rescue
    # nil`, truthiness tests on bare variables (`if x` / `unless x`), nil
    # literals, and the fetch arity breakdown (bare / with default / with
    # block) that sizes the three-row fetch retirement table.
    class NilIdioms
      SHAPES = %w[
        nil_predicate
        nil_equality
        safe_navigation
        or_default
        or_assign
        rescue_nil
        truthiness_on_variable
        nil_literal
        fetch_bare
        fetch_with_default
        fetch_with_block
      ].freeze

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
        site_counts = Hash.new(0)
        gem_counts = Hash.new(0)
        errors = []
        analyzed = 0
        names = selected_names

        tally = CohortTally.new(cohorts: @cohorts)
        progress = Progress.new(label: 'nil-idioms')
        names.each_with_index do |name, index|
          progress.tick(index + 1, names.size)
          gem_sites = sites_for(name)
          next if gem_sites.nil?

          analyzed += 1
          tally.record(name, gem_sites.select { |_shape, count| count.positive? }.keys)
          gem_sites.each do |shape, count|
            site_counts[shape] += count
            gem_counts[shape] += 1 if count.positive?
          end
        rescue StandardError => e
          errors << { gem: name, error: e.message }
        end
        progress.finish

        data = {
          corpus_size: @compact_index.names.size,
          sampled: @sample,
          analyzed: analyzed,
          errors: errors,
          site_counts: SHAPES.to_h { [it, site_counts[it]] },
          gem_coverage: SHAPES.to_h { [it, gem_counts[it]] },
          cohort_sizes: tally.cohort_sizes,
          share_by_era: tally.shares
        }
        writer = ReportWriter.new(name: 'nil_idioms', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data))
      end

      private

      def selected_names
        names = @compact_index.names
        return names unless @sample

        names.sample(@sample, random: Random.new(@seed))
      end

      def sites_for(name)
        versions = @compact_index.versions_of(name)
        latest = versions.rfind { it[:platform] == 'ruby' } || versions.last
        return nil unless latest

        sites = Hash.new(0)
        @sources.each_ruby_file(name, latest[:version], platform: latest[:platform]) do |_path, source|
          result = Prism.parse(source)
          collect(result.value, sites) if result.success?
        end
        sites
      end

      def collect(root, sites)
        queue = [root]
        until queue.empty?
          node = queue.pop
          case node
          when Prism::CallNode then collect_call(node, sites)
          when Prism::NilNode then sites['nil_literal'] += 1
          when Prism::OrNode then sites['or_default'] += 1
          when Prism::RescueModifierNode
            sites['rescue_nil'] += 1 if node.rescue_expression.is_a?(Prism::NilNode)
          when Prism::IfNode, Prism::UnlessNode
            sites['truthiness_on_variable'] += 1 if variable_read?(node.predicate)
          when Prism::LocalVariableOrWriteNode, Prism::InstanceVariableOrWriteNode,
               Prism::ClassVariableOrWriteNode, Prism::ConstantOrWriteNode,
               Prism::GlobalVariableOrWriteNode, Prism::CallOrWriteNode, Prism::IndexOrWriteNode
            sites['or_assign'] += 1
          end
          queue.concat(node.compact_child_nodes)
        end
      end

      def collect_call(node, sites)
        sites['safe_navigation'] += 1 if node.safe_navigation?
        case node.name
        when :nil? then sites['nil_predicate'] += 1
        when :==, :!=
          argument = node.arguments&.arguments&.first
          sites['nil_equality'] += 1 if argument.is_a?(Prism::NilNode)
        when :fetch then collect_fetch(node, sites)
        end
      end

      def collect_fetch(node, sites)
        argument_count = node.arguments&.arguments&.size || 0
        if node.block
          sites['fetch_with_block'] += 1
        elsif argument_count >= 2
          sites['fetch_with_default'] += 1
        else
          sites['fetch_bare'] += 1
        end
      end

      def variable_read?(node)
        node.is_a?(Prism::LocalVariableReadNode) || node.is_a?(Prism::InstanceVariableReadNode)
      end

      def markdown_for(data)
        lines = []
        lines << '# nil-idiom census across RubyGems.org'
        lines << ''
        scope = Scope.describe(sampled: data[:sampled], analyzed: data[:analyzed])
        lines << "Based on #{scope}, out of #{data[:corpus_size]} on RubyGems.org."
        lines << ''
        lines << '| Idiom | Sites | Gems using it | % of gems |'
        lines << '|---|---|---|---|'
        data[:site_counts].each_key do |shape|
          gems = data[:gem_coverage][shape]
          percent = (gems * 100.0 / data[:analyzed]).round(1)
          lines << "| #{shape} | #{data[:site_counts][shape]} | #{gems} | #{percent}% |"
        end
        lines << ''
        lines << '## By era'
        lines << ''
        lines << 'Share of gems in each cohort using each idiom — whether `&.` is displacing `.nil?` in'
        lines << 'maintained code, and whether truthiness testing is on the way out.'
        lines << ''
        lines.concat(CohortTable.render(shares: data[:share_by_era], cohort_sizes: data[:cohort_sizes], label: 'Idiom'))
        lines << ''
        lines << 'Notes: truthiness_on_variable counts `if x` / `unless x` where the condition is a bare local or'
        lines << 'instance variable — the sites the booleans-only rule turns into compile errors. or_default counts'
        lines << 'all `a || b` sites (some are boolean logic, not defaulting); fetch rows are receiver-blind.'
        lines << ''
        lines << "Errors: #{data[:errors].size}"

        lines.join("\n")
      end
    end
  end
end
