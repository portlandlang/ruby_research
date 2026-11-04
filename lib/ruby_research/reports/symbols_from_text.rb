# frozen_string_literal: true

require 'prism'

module RubyResearch
  module Reports
    # Census of symbols built from text at runtime, feeding Portland's
    # re-opening of ADR 0023 §3 (no `String#to_sym`).
    #
    # Portland cut `to_sym` so that every symbol is written literally and a
    # declared vocabulary can be checked at compile time. The proposal is to
    # allow a symbol from text everywhere a symbol is a plain value and refuse
    # it only where a declared vocabulary is expected. Whether that carve-out
    # covers real code turns on where runtime symbols actually go, so this
    # report counts the makers and, for each, the consumer:
    #
    #   construct — `to_sym`, `intern`, an interpolated symbol, `symbolize_names:`,
    #               `symbolize_keys` and its deep/ActiveSupport cousins,
    #               `transform_keys(&:to_sym)`, `with_indifferent_access`
    #   receiver  — for `to_sym`/`intern`: a string literal (`"abc".to_sym`,
    #               which could have been `:abc`), an interpolated string
    #               (`"#{name}".to_sym`, a name assembled from parts), or
    #               anything else (a variable or call — the honest case)
    #   consumer  — what the runtime symbol feeds: a hash key or index, a
    #               comparison or `case` against literal symbols, a membership
    #               test, a metaprogramming call (`send`, `const_get`,
    #               `define_method`, `instance_variable_get`…), another
    #               method's argument, a binding, or something else
    class SymbolsFromText
      MAKERS = %w[to_sym intern].freeze
      KEY_MAKERS = %w[symbolize_keys deep_symbolize_keys symbolize_keys! deep_symbolize_keys!
                      with_indifferent_access].freeze
      METAPROGRAMMING = %w[send public_send __send__ respond_to? method instance_method
                           instance_variable_get instance_variable_set instance_variable_defined?
                           const_get const_set const_defined? define_method remove_method
                           attr_accessor attr_reader attr_writer alias_method class_variable_get
                           class_variable_set define_singleton_method singleton_method].freeze
      MEMBERSHIP = %w[include? key? has_key? member? fetch dig delete values_at].freeze
      COMPARISONS = %w[== != === eql? equal?].freeze

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
        totals = new_tally
        gems_by_construct = Hash.new(0)
        gems_by_consumer = Hash.new(0)
        sites_per_gem = {}
        analyzed = 0
        errors = []
        names = selected_names

        tally = CohortTally.new(cohorts: @cohorts)
        progress = Progress.new(label: 'symbols-from-text')
        names.each_with_index do |name, index|
          progress.tick(index + 1, names.size)
          gem_tally = tally_for(name)
          next if gem_tally.nil?

          analyzed += 1
          tally.record(name, gem_tally[:construct].keys)
          tally.record_sites(name, gem_tally[:construct], total_nodes: gem_tally[:nodes])
          sites_per_gem[name] = gem_tally[:total] if gem_tally[:total].positive?
          gem_tally[:construct].each_key { gems_by_construct[it] += 1 }
          gem_tally[:consumer].each_key { gems_by_consumer[it] += 1 }
          merge_tally(totals, gem_tally)
        rescue StandardError => e
          errors << { gem: name, error: e.message }
        end
        progress.finish

        ranked = sites_per_gem.sort_by { |_name, count| -count }
        data = {
          corpus_size: @compact_index.names.size,
          sampled: @sample,
          analyzed: analyzed,
          errors: errors,
          gems_with_sites: sites_per_gem.size,
          total_sites: totals[:total],
          top_gems_by_site_count: ranked.first(10).to_h,
          construct: sort_by_count(totals[:construct]),
          gems_by_construct: sort_by_count(gems_by_construct),
          receiver: sort_by_count(totals[:receiver]),
          consumer: sort_by_count(totals[:consumer]),
          gems_by_consumer: sort_by_count(gems_by_consumer),
          consumer_by_construct: totals[:consumer_by_construct].transform_values { sort_by_count(it) },
          cohort_sizes: tally.cohort_sizes,
          share_by_era: tally.shares,
          site_totals_by_era: tally.site_totals,
          composition_by_era: tally.site_composition,
          node_totals_by_era: tally.node_totals,
          density_by_era: tally.site_density
        }
        writer = ReportWriter.new(name: 'symbols_from_text', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data))
      end

      private

      def new_tally
        {
          construct: Hash.new(0),
          consumer: Hash.new(0),
          consumer_by_construct: Hash.new { |hash, key| hash[key] = Hash.new(0) },
          nodes: 0,
          receiver: Hash.new(0),
          total: 0
        }
      end

      def merge_tally(totals, gem_tally)
        totals[:nodes] += gem_tally[:nodes]
        totals[:total] += gem_tally[:total]
        %i[construct consumer receiver].each do |key|
          gem_tally[key].each { |bucket, count| totals[key][bucket] += count }
        end
        gem_tally[:consumer_by_construct].each do |construct, consumers|
          consumers.each { |consumer, count| totals[:consumer_by_construct][construct][consumer] += count }
        end
      end

      def sort_by_count(tally) = tally.sort_by { |_key, count| -count }.to_h

      def selected_names
        names = @compact_index.names
        return names unless @sample

        names.sample(@sample, random: Random.new(@seed))
      end

      def tally_for(name)
        latest = @compact_index.latest_version_of(name)
        return nil unless latest

        tally = new_tally
        @sources.each_ruby_file(name, latest[:version], platform: latest[:platform]) do |_path, source|
          result = Prism.parse(source)
          tally[:nodes] += collect(result.value, tally) if result.success?
        end
        tally
      end

      # Walks the tree with each node's ancestors in hand, since what a
      # runtime symbol feeds is a question about its parents. Returns the
      # number of nodes visited, for the density denominator.
      def collect(root, tally)
        visited = 0
        queue = [[root, []]]

        until queue.empty?
          visited += 1
          node, ancestors = queue.pop
          classify(node, ancestors, tally)
          lineage = [node, *ancestors].first(3)
          node.compact_child_nodes.each { queue << [it, lineage] }
        end

        visited
      end

      def classify(node, ancestors, tally)
        construct = construct_of(node)
        return if construct.nil?

        tally[:total] += 1
        tally[:construct][construct] += 1
        tally[:receiver][receiver_kind(node)] += 1 if MAKERS.include?(construct)
        return unless MAKERS.include?(construct) || construct == 'interpolated symbol'

        consumer = consumer_of(node, ancestors)
        tally[:consumer][consumer] += 1
        tally[:consumer_by_construct][construct][consumer] += 1
      end

      def construct_of(node)
        case node
        when Prism::InterpolatedSymbolNode then 'interpolated symbol'
        when Prism::AssocNode
          key = node.key
          'symbolize_names:' if key.is_a?(Prism::SymbolNode) && key.unescaped == 'symbolize_names'
        when Prism::CallNode
          name = node.name.to_s
          return name if MAKERS.include?(name)
          return name if KEY_MAKERS.include?(name)

          'transform_keys(&:to_sym)' if name.start_with?('transform_keys') && to_sym_block?(node.block)
        end
      end

      def to_sym_block?(block)
        block.is_a?(Prism::BlockArgumentNode) &&
          block.expression.is_a?(Prism::SymbolNode) &&
          block.expression.unescaped == 'to_sym'
      end

      def receiver_kind(node)
        case node.receiver
        when Prism::StringNode then 'a string literal'
        when Prism::InterpolatedStringNode then 'an interpolated string'
        when nil then 'no receiver'
        else 'a variable or call'
        end
      end

      # The nearest ancestor that says what the symbol is for.
      def consumer_of(node, ancestors)
        parent, grandparent = ancestors
        return 'other' if parent.nil?

        return 'a hash key' if parent.is_a?(Prism::AssocNode) && parent.key.equal?(node)
        return consumer_from_call(node, parent) if parent.is_a?(Prism::CallNode)
        return consumer_from_arguments(grandparent) if parent.is_a?(Prism::ArgumentsNode) && grandparent.is_a?(Prism::CallNode)
        return 'a case subject' if parent.is_a?(Prism::CaseNode) || parent.is_a?(Prism::CaseMatchNode)
        return 'a binding' if parent.class.name.end_with?('WriteNode')
        return 'a comparison with a literal symbol' if parent.is_a?(Prism::WhenNode)

        'other'
      end

      # The symbol is the receiver of `parent`, or `parent` is an operator
      # call whose other operand is a literal symbol.
      def consumer_from_call(node, parent)
        name = parent.name.to_s
        if COMPARISONS.include?(name)
          other = parent.receiver.equal?(node) ? parent.arguments&.arguments&.first : parent.receiver
          return 'a comparison with a literal symbol' if other.is_a?(Prism::SymbolNode)

          return 'a comparison with a non-literal'
        end
        return 'a receiver of to_s or to_proc' if %w[to_s to_proc name].include?(name)

        'a receiver of another method'
      end

      def consumer_from_arguments(call)
        name = call.name.to_s
        if COMPARISONS.include?(name)
          return 'a comparison with a literal symbol' if call.receiver.is_a?(Prism::SymbolNode)

          return 'a comparison with a non-literal'
        end
        return 'a hash key' if %w[[] []=].include?(name)
        return 'a metaprogramming call' if METAPROGRAMMING.include?(name)
        return 'a membership test' if MEMBERSHIP.include?(name)

        'an argument to another method'
      end

      def markdown_for(data)
        lines = []
        lines << '# Symbols built from text across RubyGems.org'
        lines << ''
        scope = Scope.describe(sampled: data[:sampled], analyzed: data[:analyzed])
        lines << "Based on #{scope}, out of #{data[:corpus_size]} on RubyGems.org."
        lines << ''
        percent = data[:analyzed].zero? ? 0 : (data[:gems_with_sites] * 100.0 / data[:analyzed]).round(1)
        lines << "**#{data[:total_sites]}** sites across **#{data[:gems_with_sites]}** gems " \
                 "(#{percent}% of analyzed gems build a symbol from text somewhere)."
        lines << ''
        lines << 'For portland ADR 0023 §3, re-opened: Portland has no `String#to_sym`, so every symbol is literal and a ' \
                 'declared vocabulary can be checked. The proposal is to allow a symbol from text wherever a symbol is a ' \
                 'plain value and refuse it only where a declared vocabulary is expected. The consumer column is the ' \
                 'question: how much of this feeds hash keys and comparisons (open positions, allowed under the proposal), ' \
                 'how much feeds metaprogramming (gone regardless), and how much would meet a checked position.'
        lines << ''
        lines << '## Constructs'
        lines << ''
        lines << '| Construct | Sites | % of sites | Gems | % of analyzed gems |'
        lines << '|---|---:|---:|---:|---:|'
        data[:construct].each do |construct, count|
          gems = data[:gems_by_construct][construct].to_i
          lines << "| `#{construct}` | #{count} | #{share(count, data[:total_sites])} | #{gems} | " \
                   "#{share(gems, data[:analyzed])} |"
        end
        lines << ''
        lines << '## What `to_sym` and `intern` are called on'
        lines << ''
        lines << 'A string literal receiver could have been a symbol literal; an interpolated string is a name assembled ' \
                 'from parts; a variable or call is text the program did not write.'
        lines << ''
        lines << '| Receiver | Sites | % of to_sym/intern sites |'
        lines << '|---|---:|---:|'
        receiver_total = data[:receiver].values.sum
        data[:receiver].each do |receiver, count|
          lines << "| #{receiver} | #{count} | #{share(count, receiver_total)} |"
        end
        lines << ''
        lines << '## What the runtime symbol feeds'
        lines << ''
        lines << 'For `to_sym`, `intern`, and interpolated-symbol sites: the nearest ancestor that says what the ' \
                 'symbol is for.'
        lines << ''
        lines << '| Consumer | Sites | % of sites | Gems |'
        lines << '|---|---:|---:|---:|'
        consumer_total = data[:consumer].values.sum
        data[:consumer].each do |consumer, count|
          lines << "| #{consumer} | #{count} | #{share(count, consumer_total)} | #{data[:gems_by_consumer][consumer].to_i} |"
        end
        lines << ''
        lines << '### Consumer by construct'
        lines << ''
        lines << '| Construct | Consumers (sites) |'
        lines << '|---|---|'
        data[:consumer_by_construct].each do |construct, consumers|
          spelled = consumers.map { |consumer, count| "#{consumer} #{count}" }.join(', ')
          lines << "| `#{construct}` | #{spelled} |"
        end
        lines << ''
        lines << '## By era'
        lines << ''
        lines << 'Share of gems in each cohort that use each construct at least once.'
        lines << ''
        lines.concat(CohortTable.render(shares: data[:share_by_era], cohort_sizes: data[:cohort_sizes],
                                        label: 'Construct'))
        lines << ''
        lines << '### Composition of sites'
        lines << ''
        lines.concat(CohortTable.composition(composition: data[:composition_by_era],
                                             site_totals: data[:site_totals_by_era],
                                             label: 'Construct'))
        lines << ''
        lines << '### Density'
        lines << ''
        lines.concat(CohortTable.density(density: data[:density_by_era],
                                         node_totals: data[:node_totals_by_era],
                                         label: 'Construct'))
        lines << ''
        lines << '## Gems with the most sites'
        lines << ''
        lines << '| Gem | Sites |'
        lines << '|---|---:|'
        data[:top_gems_by_site_count].each { |gem, count| lines << "| #{gem} | #{count} |" }
        lines << ''
        lines << "Errors: #{data[:errors].size}"

        lines.join("\n")
      end

      def share(count, total) = total.zero? ? '0%' : "#{(count * 100.0 / total).round(1)}%"
    end
  end
end
