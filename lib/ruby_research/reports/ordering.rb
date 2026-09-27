# frozen_string_literal: true

require 'prism'

module RubyResearch
  module Reports
    # Census of how gems order values, feeding Portland's ruling on `<=>`,
    # `Comparable`, and whether a user's type can sort (portland#76).
    #
    #   definitions — gems defining `<=>`; of those, how many also
    #                 `include Comparable`; and what the `<=>` body does:
    #                 delegates to one `<=>` on a part (`age <=> other.age`),
    #                 compares an array of parts (`[a, b] <=> [o.a, o.b]`),
    #                 or computes something else
    #   call sites  — `sort` bare, `sort { }`, `sort_by`, `min`/`max` bare
    #                 and with a block, `min_by`/`max_by`, `<=>` written in
    #                 an expression outside a `<=>` def, `between?`, `clamp`
    #   results     — whether a `<=>` body's result is used as an integer
    #                 (arithmetic on it, `== 0`, `== -1`) anywhere in the gem
    class Ordering
      BODY_SHAPES = ['delegates to a part', 'compares parts as an array', 'computes'].freeze

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
        gems_by_key = Hash.new(0)
        analyzed = 0
        errors = []
        names = selected_names

        tally = CohortTally.new(cohorts: @cohorts)
        progress = Progress.new(label: 'ordering')
        names.each_with_index do |name, index|
          progress.tick(index + 1, names.size)
          gem_tally = tally_for(name)
          next if gem_tally.nil?

          analyzed += 1
          keys = gem_tally[:sites].keys + gem_tally[:body_shapes].keys.map { "<=> body #{it}" }
          keys << 'defines <=>' if gem_tally[:defines_spaceship].positive?
          keys << 'includes Comparable' if gem_tally[:includes_comparable].positive?
          keys << 'reads <=> result as an integer' if gem_tally[:integer_results].positive?
          keys.uniq.each { gems_by_key[it] += 1 }
          tally.record(name, keys.uniq)
          tally.record_sites(name, gem_tally[:sites], total_nodes: gem_tally[:nodes])
          merge_tally(totals, gem_tally)
        rescue StandardError => e
          errors << { gem: name, error: e.message }
        end
        progress.finish

        data = {
          corpus_size: @compact_index.names.size,
          sampled: @sample,
          analyzed: analyzed,
          errors: errors,
          defines_spaceship: totals[:defines_spaceship],
          includes_comparable: totals[:includes_comparable],
          integer_results: totals[:integer_results],
          body_shapes: sort_by_count(totals[:body_shapes]),
          sites: sort_by_count(totals[:sites]),
          gems_by_key: sort_by_count(gems_by_key),
          cohort_sizes: tally.cohort_sizes,
          share_by_era: tally.shares
        }
        writer = ReportWriter.new(name: 'ordering', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data))
      end

      private

      def new_tally
        {
          body_shapes: Hash.new(0),
          defines_spaceship: 0,
          includes_comparable: 0,
          integer_results: 0,
          nodes: 0,
          sites: Hash.new(0)
        }
      end

      def merge_tally(totals, gem_tally)
        totals[:nodes] += gem_tally[:nodes]
        totals[:defines_spaceship] += gem_tally[:defines_spaceship]
        totals[:includes_comparable] += gem_tally[:includes_comparable]
        totals[:integer_results] += gem_tally[:integer_results]
        %i[body_shapes sites].each do |key|
          gem_tally[key].each { |bucket, count| totals[key][bucket] += count }
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

      # Returns the number of nodes visited, for the density denominator.
      def collect(root, tally)
        visited = 0
        queue = [[root, false]]

        until queue.empty?
          visited += 1
          node, inside_spaceship = queue.pop
          inside = inside_spaceship || spaceship_def?(node)
          classify(node, inside_spaceship, tally)
          queue.concat(node.compact_child_nodes.map { [it, inside] })
        end

        visited
      end

      def spaceship_def?(node) = node.is_a?(Prism::DefNode) && node.name == :<=>

      def classify(node, inside_spaceship, tally)
        case node
        when Prism::DefNode
          return unless node.name == :<=>

          tally[:defines_spaceship] += 1
          tally[:body_shapes][body_shape_of(node)] += 1
        when Prism::CallNode
          classify_call(node, inside_spaceship, tally)
        end
      end

      def classify_call(node, inside_spaceship, tally)
        name = node.name
        if name == :include && node.arguments&.arguments&.any? { constant_named?(it, :Comparable) }
          tally[:includes_comparable] += 1
          return
        end
        case name
        when :<=>
          tally[:sites]['<=> in an expression'] += 1 unless inside_spaceship
        when :sort, :min, :max
          tally[:sites]["#{name}#{' with a block' if node.block}"] += 1
        when :sort_by, :min_by, :max_by, :between?, :clamp
          tally[:sites][name.to_s] += 1
        when :==, :<, :>, :<=, :>=, :*, :-, :+
          tally[:integer_results] += 1 if spaceship_operand?(node)
        end
      end

      def constant_named?(node, name)
        node.is_a?(Prism::ConstantReadNode) && node.name == name
      end

      # `(a <=> b) == 0`, `(a <=> b) * -1`: the result read as an integer.
      def spaceship_operand?(node)
        receiver = unwrap(node.receiver)
        argument = unwrap(node.arguments&.arguments&.first)
        [receiver, argument].any? { it.is_a?(Prism::CallNode) && it.name == :<=> }
      end

      def unwrap(node)
        node = node.body&.body&.first if node.is_a?(Prism::ParenthesesNode)
        node
      end

      # `def <=>(other) = age <=> other.age` delegates; `[a, b] <=> [o.a, o.b]`
      # compares parts as an array; anything else computes.
      def body_shape_of(node)
        statements = node.body.is_a?(Prism::StatementsNode) ? node.body.body : [node.body].compact
        return 'computes' unless statements.size == 1

        expression = unwrap(statements.first)
        return 'computes' unless expression.is_a?(Prism::CallNode) && expression.name == :<=>
        return 'compares parts as an array' if expression.receiver.is_a?(Prism::ArrayNode)

        'delegates to a part'
      end

      def markdown_for(data)
        lines = []
        lines << '# Ordering census across RubyGems.org'
        lines << ''
        scope = Scope.describe(sampled: data[:sampled], analyzed: data[:analyzed])
        lines << "Based on #{scope}, out of #{data[:corpus_size]} on RubyGems.org."
        lines << ''
        lines << '## Who defines an ordering'
        lines << ''
        lines << '| Fact | Sites | Gems | % of analyzed gems |'
        lines << '|---|---:|---:|---:|'
        lines << "| defines `<=>` | #{data[:defines_spaceship]} | #{data[:gems_by_key]['defines <=>'].to_i} | " \
                 "#{share(data[:gems_by_key]['defines <=>'].to_i, data[:analyzed])} |"
        lines << "| `include Comparable` | #{data[:includes_comparable]} | #{data[:gems_by_key]['includes Comparable'].to_i} | " \
                 "#{share(data[:gems_by_key]['includes Comparable'].to_i, data[:analyzed])} |"
        lines << "| reads a `<=>` result as an integer | #{data[:integer_results]} | " \
                 "#{data[:gems_by_key]['reads <=> result as an integer'].to_i} | " \
                 "#{share(data[:gems_by_key]['reads <=> result as an integer'].to_i, data[:analyzed])} |"
        lines << ''
        lines << '## What a `<=>` body does'
        lines << ''
        lines << '| Shape | Definitions | % of definitions |'
        lines << '|---|---:|---:|'
        data[:body_shapes].each do |shape, count|
          lines << "| #{shape} | #{count} | #{share(count, data[:defines_spaceship])} |"
        end
        lines << ''
        lines << '## Ordering at the call site'
        lines << ''
        lines << '| Call | Sites | Gems | % of analyzed gems |'
        lines << '|---|---:|---:|---:|'
        data[:sites].each do |call, count|
          gems = data[:gems_by_key][call].to_i
          lines << "| `#{call}` | #{count} | #{gems} | #{share(gems, data[:analyzed])} |"
        end
        lines << ''
        lines << '## By era'
        lines << ''
        lines << 'Share of gems in each cohort exhibiting the row.'
        lines << ''
        lines.concat(CohortTable.render(shares: data[:share_by_era], cohort_sizes: data[:cohort_sizes], label: 'Fact'))
        lines << ''
        lines << "Errors: #{data[:errors].size}"

        lines.join("\n")
      end

      def share(count, total) = total.zero? ? '0%' : "#{(count * 100.0 / total).round(1)}%"
    end
  end
end
