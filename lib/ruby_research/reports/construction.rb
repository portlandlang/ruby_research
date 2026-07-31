# frozen_string_literal: true

require 'prism'

module RubyResearch
  module Reports
    # Census of object construction, feeding the impl repo's object-model
    # session (constructor ceremony, named entry points, `self.new`).
    #
    # Four questions, each moving a specific decision:
    #
    #   1. What do `initialize` bodies contain? Classified with overlapping
    #      flags — pure ivar assignment, derivation, validation-that-raises,
    #      side effects — plus `pure` for bodies that are (a) and nothing
    #      else. Sizes how much construction logic is real vs ceremony, and
    #      how much construction is genuinely fallible.
    #   2. How are objects constructed at call sites? `Const.new` versus
    #      named class-method constructors (`of`/`for`/`from_*`/`parse`/...).
    #   3. How common is overriding `def self.new`, and does it call super?
    #   4. Are `initialize` signatures positional, keyword, or mixed?
    #
    # Gems and occurrences are counted separately throughout: an idiom in 3%
    # of gems ten thousand times is a different fact from one in 40% of gems
    # once each.
    #
    # Heuristics, stated plainly: validation = any raise/fail in the body
    # (wherever it sits); side effects = calls from a curated IO/registration
    # name list or global-variable receivers, a lower bound; named
    # constructors are receiver-blind beyond requiring a constant receiver,
    # and `create` is inflated by ActiveRecord's persistence method.
    class Construction
      COUNTERS = %w[
        initialize_def
        init_empty
        init_pure
        init_with_super
        init_derivation
        init_validation
        init_side_effect
        init_sig_none
        init_sig_positional
        init_sig_keyword
        init_sig_mixed
        call_const_new
        call_named_constructor
        def_self_new
        def_self_new_super
      ].freeze

      NAMED_CONSTRUCTORS = %i[of for from build create parse wrap load].freeze
      SIDE_EFFECT_NAMES = %i[
        at_exit open p pp print puts register spawn subscribe syswrite system warn write
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
        progress = Progress.new(label: 'construction')
        names.each_with_index do |name, index|
          progress.tick(index + 1, names.size)
          scan = counts_for(name)
          next if scan.nil?

          analyzed += 1
          tally.record(name, scan.select { |_counter, count| count.positive? }.keys)
          scan.each do |counter, count|
            site_counts[counter] += count
            gem_counts[counter] += 1 if count.positive?
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
          site_counts: COUNTERS.to_h { [it, site_counts[it]] },
          gem_coverage: COUNTERS.to_h { [it, gem_counts[it]] },
          cohort_sizes: tally.cohort_sizes,
          share_by_era: tally.shares
        }
        writer = ReportWriter.new(name: 'construction', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data))
      end

      private

      def selected_names
        names = @compact_index.names
        return names unless @sample

        names.sample(@sample, random: Random.new(@seed))
      end

      def counts_for(name)
        versions = @compact_index.versions_of(name)
        latest = versions.rfind { it[:platform] == 'ruby' } || versions.last
        return nil unless latest

        counts = Hash.new(0)
        @sources.each_ruby_file(name, latest[:version], platform: latest[:platform]) do |_path, source|
          result = Prism.parse(source)
          collect(result.value, counts) if result.success?
        end
        counts
      end

      def collect(root, counts)
        queue = [[root, false]]
        until queue.empty?
          node, in_singleton = queue.pop
          case node
          when Prism::DefNode then classify_def(node, counts, in_singleton: in_singleton)
          when Prism::CallNode then classify_call(node, counts)
          end
          inside = in_singleton || node.is_a?(Prism::SingletonClassNode)
          node.compact_child_nodes.each { queue << [it, inside] }
        end
      end

      def classify_def(node, counts, in_singleton:)
        if node.name == :new && (node.receiver.is_a?(Prism::SelfNode) || in_singleton)
          counts['def_self_new'] += 1
          counts['def_self_new_super'] += 1 if contains_super?(node.body)
        end
        return unless node.name == :initialize && node.receiver.nil?

        counts['initialize_def'] += 1
        classify_signature(node.parameters, counts)
        classify_body(node.body, counts)
      end

      def classify_signature(params, counts)
        return counts['init_sig_none'] += 1 if params.nil?

        positional = params.requireds.any? || params.optionals.any? || !params.rest.nil?
        keyword = params.keywords.any? || !params.keyword_rest.nil?
        key =
          if positional && keyword then 'init_sig_mixed'
          elsif keyword then 'init_sig_keyword'
          elsif positional then 'init_sig_positional'
          else 'init_sig_none'
          end
        counts[key] += 1
      end

      def classify_body(body, counts)
        return counts['init_empty'] += 1 if body.nil?

        statements = top_level_statements(body)
        derivation = statements.any? { !pure_statement?(it) }
        validation = raises?(body)
        side_effect = side_effects?(body)

        counts['init_with_super'] += 1 if statements.any? { super_node?(it) }
        counts['init_derivation'] += 1 if derivation
        counts['init_validation'] += 1 if validation
        counts['init_side_effect'] += 1 if side_effect
        counts['init_pure'] += 1 unless derivation || validation || side_effect
      end

      def top_level_statements(body)
        case body
        when Prism::StatementsNode then body.body
        when Prism::BeginNode then Array(body.statements&.body)
        else [body]
        end
      end

      # A statement that is nothing beyond ivar assignment: `@x = x`,
      # `@x = literal`, `@x = x || default`. A bare super also passes —
      # it is boilerplate forwarding, counted separately via init_with_super.
      def pure_statement?(node)
        return true if super_node?(node)
        return false unless node.is_a?(Prism::InstanceVariableWriteNode)

        pure_value?(node.value)
      end

      def pure_value?(value)
        case value
        when Prism::LocalVariableReadNode, Prism::StringNode, Prism::SymbolNode, Prism::IntegerNode,
             Prism::FloatNode, Prism::TrueNode, Prism::FalseNode, Prism::NilNode, Prism::ArrayNode,
             Prism::HashNode
          true
        when Prism::OrNode
          value.left.is_a?(Prism::LocalVariableReadNode) && pure_value?(value.right)
        else
          false
        end
      end

      def super_node?(node) = node.is_a?(Prism::SuperNode) || node.is_a?(Prism::ForwardingSuperNode)

      def contains_super?(body)
        walk(body).any? { super_node?(it) }
      end

      def raises?(body)
        walk(body).any? { it.is_a?(Prism::CallNode) && %i[raise fail].include?(it.name) }
      end

      def side_effects?(body)
        walk(body).any? do |node|
          node.is_a?(Prism::CallNode) &&
            (SIDE_EFFECT_NAMES.include?(node.name) || node.receiver.is_a?(Prism::GlobalVariableReadNode))
        end
      end

      # Enumerates body without descending into nested defs.
      def walk(body)
        return [] if body.nil?

        nodes = []
        queue = [body]
        until queue.empty?
          node = queue.pop
          nodes << node
          queue.concat(node.compact_child_nodes.grep_v(Prism::DefNode))
        end
        nodes
      end

      def classify_call(node, counts)
        receiver = node.receiver
        return unless receiver.is_a?(Prism::ConstantReadNode) || receiver.is_a?(Prism::ConstantPathNode)

        if node.name == :new
          counts['call_const_new'] += 1
        elsif NAMED_CONSTRUCTORS.include?(node.name) || node.name.to_s.start_with?('from_')
          counts['call_named_constructor'] += 1
        end
      end

      def markdown_for(data)
        n = data[:analyzed]
        s = data[:site_counts]
        g = data[:gem_coverage]
        init = s['initialize_def']
        construction = s['call_const_new'] + s['call_named_constructor']
        lines = []
        lines << '# Construction census across RubyGems.org'
        lines << ''
        scope = Scope.describe(sampled: data[:sampled], analyzed: n)
        lines << "Based on #{scope}, out of #{data[:corpus_size]} on RubyGems.org. " \
                 "#{init} `initialize` definitions and #{construction} constant-receiver construction calls."
        lines << ''
        lines << '## What initialize bodies contain'
        lines << ''
        lines << 'Overlapping flags — one body can derive *and* validate. `pure` means ivar assignment'
        lines << '(defaults included) and nothing else.'
        lines << ''
        lines << '| Body | Occurrences | % of initializes | Gems |'
        lines << '|---|---|---|---|'
        %w[init_pure init_empty init_with_super init_derivation init_validation init_side_effect].each do |k|
          lines << "| #{k.delete_prefix('init_')} | #{s[k]} | #{percent(s[k], init)} | #{g[k]} |"
        end
        lines << ''
        lines << '## initialize signatures'
        lines << ''
        lines << '| Signature | Occurrences | % of initializes | Gems |'
        lines << '|---|---|---|---|'
        %w[init_sig_none init_sig_positional init_sig_keyword init_sig_mixed].each do |k|
          lines << "| #{k.delete_prefix('init_sig_')} | #{s[k]} | #{percent(s[k], init)} | #{g[k]} |"
        end
        lines << ''
        lines << '## How construction is spelled at call sites'
        lines << ''
        lines << 'Constant-receiver calls only. Named constructors are `of for from_* build create parse'
        lines << 'wrap load`; `create` is inflated by ActiveRecord persistence, so treat it as an upper bound.'
        lines << ''
        lines << '| Spelling | Occurrences | % of construction calls | Gems |'
        lines << '|---|---|---|---|'
        %w[call_const_new call_named_constructor].each do |k|
          lines << "| #{k.delete_prefix('call_')} | #{s[k]} | #{percent(s[k], construction)} | #{g[k]} |"
        end
        lines << ''
        lines << '## Overriding `def self.new`'
        lines << ''
        lines << "#{s['def_self_new']} overrides across #{g['def_self_new']} gems " \
                 "(#{percent(g['def_self_new'], n)} of gems); #{s['def_self_new_super']} call `super`."
        lines << ''
        lines << '## By era (share of gems)'
        lines << ''
        lines.concat(CohortTable.render(shares: data[:share_by_era], cohort_sizes: data[:cohort_sizes],
                                        label: 'Counter'))
        lines << ''
        lines << "Errors: #{data[:errors].size}"

        lines.join("\n")
      end

      def percent(count, total) = total.zero? ? '0%' : "#{(count * 100.0 / total).round(1)}%"
    end
  end
end
