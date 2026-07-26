# frozen_string_literal: true

require 'prism'

module RubyResearch
  module Reports
    # Accumulator-shape analysis of in-place mutation sites, feeding
    # Portland's mutable-values / `<<`-as-rebinding decision.
    #
    # For every method definition in sampled gem sources, classifies each
    # receiver-mutation site (`<<`, push, merge!, []=, ...):
    #
    #   accumulator     — receiver is a local initialized to a fresh
    #                     container ([] {} "" Array.new ...) in the same
    #                     method and never passed out of it mid-build.
    #                     These migrate to rebinding `<<` verbatim.
    #   escaped_local   — fresh local, but also passed as an argument /
    #                     stored in an ivar somewhere in the method, so
    #                     aliasing is possible.
    #   aliased_local   — local receiver that isn't a fresh container
    #                     (parameter, method result, etc).
    #   shared_receiver — ivar/gvar/constant/call-result receiver: mutation
    #                     of state that outlives or escapes the method.
    #   implicit_self   — mutator called with no explicit receiver.
    #
    # This is a static heuristic: escape detection is conservative
    # (argument passing counts as escape even on the final line), and
    # receiver-blind method names mean e.g. `delete` on a custom class
    # counts as a mutator.
    class MutationShapes
      MUTATORS = %i[
        << []= append clear compact! concat delete delete_at delete_if
        downcase! flatten! gsub! insert map! merge! pop prepend push
        reject! replace reverse! select! shift sort! squeeze! store strip!
        sub! uniq! unshift upcase!
      ].freeze

      FRESH_CONSTRUCTORS = %i[new].freeze
      FRESH_CONSTANTS = %w[Array Hash Set String].freeze
      SHAPES = %w[accumulator escaped_local aliased_local shared_receiver implicit_self].freeze

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
        dependents_tally = CohortTally.new(cohorts: @cohorts, dimension: :dependents)
        progress = Progress.new(label: 'mutation-shapes')
        names.each_with_index do |name, index|
          progress.tick(index + 1, names.size)
          scan = sites_for(name)
          next if scan.nil?

          analyzed += 1
          gem_sites = scan[:sites]
          present = gem_sites.select { |_shape, count| count.positive? }.keys
          tally.record(name, present)
          tally.record_sites(name, gem_sites, total_nodes: scan[:nodes])
          dependents_tally.record(name, present)
          dependents_tally.record_sites(name, gem_sites, total_nodes: scan[:nodes])
          gem_sites.each do |shape, count|
            site_counts[shape] += count
            gem_counts[shape] += 1 if count.positive?
          end
        rescue StandardError => e
          errors << { gem: name, error: e.message }
        end
        progress.finish

        total_sites = site_counts.values.sum
        data = {
          corpus_size: @compact_index.names.size,
          sampled: @sample,
          analyzed: analyzed,
          errors: errors,
          total_mutation_sites: total_sites,
          site_counts: SHAPES.to_h { [it, site_counts[it]] },
          site_percentages: SHAPES.to_h { [it, total_sites.zero? ? 0 : (site_counts[it] * 100.0 / total_sites).round(1)] },
          gem_coverage: SHAPES.to_h { [it, gem_counts[it]] },
          cohort_sizes: tally.cohort_sizes,
          share_by_era: tally.shares,
          site_totals_by_era: tally.site_totals,
          composition_by_era: tally.site_composition,
          node_totals_by_era: tally.node_totals,
          density_by_era: tally.site_density,
          dependents_cohort_sizes: dependents_tally.cohort_sizes,
          share_by_dependents: dependents_tally.shares,
          site_totals_by_dependents: dependents_tally.site_totals,
          composition_by_dependents: dependents_tally.site_composition,
          node_totals_by_dependents: dependents_tally.node_totals,
          density_by_dependents: dependents_tally.site_density
        }
        writer = ReportWriter.new(name: 'mutation_shapes', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data))
      end

      private

      def selected_names
        names = @compact_index.names
        return names unless @sample

        names.sample(@sample, random: Random.new(@seed))
      end

      # Returns { sites:, nodes: } — the mutation-site tally plus the total
      # AST nodes walked, which is the density denominator. Counting nodes
      # is free here because finding the method definitions already visits
      # every node.
      def sites_for(name)
        versions = @compact_index.versions_of(name)
        latest = versions.rfind { it[:platform] == 'ruby' } || versions.last
        return nil unless latest

        sites = Hash.new(0)
        nodes = 0
        @sources.each_ruby_file(name, latest[:version], platform: latest[:platform]) do |_path, source|
          result = Prism.parse(source)
          next unless result.success?

          nodes += each_def_node(result.value) { classify_method(it, sites) }
        end
        { sites: sites, nodes: nodes }
      end

      # Yields every DefNode and returns the number of nodes visited.
      def each_def_node(root, &)
        visited = 0
        queue = [root]
        until queue.empty?
          visited += 1
          node = queue.pop
          yield node if node.is_a?(Prism::DefNode)
          queue.concat(node.compact_child_nodes)
        end
        visited
      end

      def classify_method(def_node, sites)
        body = def_node.body
        return unless body

        fresh = fresh_locals(body)
        escaped = escaped_locals(body)

        each_in_method(body) do |node|
          next unless node.is_a?(Prism::CallNode) && MUTATORS.include?(node.name)

          sites[shape_for(node.receiver, fresh: fresh, escaped: escaped)] += 1
        end
      end

      def shape_for(receiver, fresh:, escaped:)
        case receiver
        when nil then 'implicit_self'
        when Prism::LocalVariableReadNode
          return 'aliased_local' unless fresh.include?(receiver.name)

          escaped.include?(receiver.name) ? 'escaped_local' : 'accumulator'
        else
          'shared_receiver'
        end
      end

      # Locals assigned a fresh container literal or constructor in this method.
      def fresh_locals(body)
        fresh = Set.new
        each_in_method(body) do |node|
          next unless node.is_a?(Prism::LocalVariableWriteNode)

          fresh << node.name if fresh_value?(node.value)
        end
        fresh
      end

      def fresh_value?(value)
        case value
        when Prism::ArrayNode, Prism::HashNode, Prism::StringNode, Prism::InterpolatedStringNode then true
        when Prism::CallNode
          FRESH_CONSTRUCTORS.include?(value.name) &&
            value.receiver.is_a?(Prism::ConstantReadNode) &&
            FRESH_CONSTANTS.include?(value.receiver.name.to_s)
        else
          false
        end
      end

      # Locals that leave the method mid-build: passed as a call argument,
      # stored into an ivar/gvar/constant, or yielded.
      def escaped_locals(body)
        escaped = Set.new
        each_in_method(body) do |node|
          case node
          when Prism::CallNode, Prism::YieldNode
            Array(node.arguments&.arguments).each do |argument|
              escaped << argument.name if argument.is_a?(Prism::LocalVariableReadNode)
            end
          when Prism::InstanceVariableWriteNode, Prism::GlobalVariableWriteNode, Prism::ConstantWriteNode
            escaped << node.value.name if node.value.is_a?(Prism::LocalVariableReadNode)
          end
        end
        escaped
      end

      # Walks a method body without descending into nested defs (each def
      # is classified on its own).
      def each_in_method(body)
        queue = [body]
        until queue.empty?
          node = queue.pop
          yield node
          queue.concat(node.compact_child_nodes.grep_v(Prism::DefNode))
        end
      end

      def markdown_for(data)
        lines = []
        lines << '# Mutation-site shapes across RubyGems.org'
        lines << ''
        scope = Scope.describe(sampled: data[:sampled], analyzed: data[:analyzed])
        lines << "Based on #{scope}, out of #{data[:corpus_size]} on RubyGems.org; " \
                 "#{data[:total_mutation_sites]} receiver-mutation sites classified inside method bodies."
        lines << ''
        lines << '| Shape | Sites | % of sites | Gems |'
        lines << '|---|---|---|---|'
        data[:site_counts].each_key do |shape|
          lines << "| #{shape} | #{data[:site_counts][shape]} | #{data[:site_percentages][shape]}% | #{data[:gem_coverage][shape]} |"
        end
        lines << ''
        lines << '## By era'
        lines << ''
        lines << '### Share of gems'
        lines << ''
        lines.concat(CohortTable.render(shares: data[:share_by_era], cohort_sizes: data[:cohort_sizes], label: 'Shape'))
        lines << ''
        lines << '### Composition of mutation sites'
        lines << ''
        lines.concat(CohortTable.composition(composition: data[:composition_by_era],
                                             site_totals: data[:site_totals_by_era],
                                             label: 'Shape'))
        lines << ''
        lines << '### Density'
        lines << ''
        lines.concat(CohortTable.density(density: data[:density_by_era],
                                         node_totals: data[:node_totals_by_era],
                                         label: 'Shape'))
        lines << ''
        lines << '## By how many gems depend on the gem'
        lines << ''
        lines << 'Whether widely-depended-on gems mutate differently from leaf gems.'
        lines << ''
        lines << '**Read the composition and density tables, not the gem-share one.** Every shape rises'
        lines << 'monotonically with dependent count in the gem-share view, but only because widely-used gems'
        lines << 'contain more code and so exhibit more of everything. Gem share cannot separate "popular gems'
        lines << 'mutate differently" from "popular gems are bigger"; the other two views can.'
        lines << ''
        lines << '### Share of gems (confounded by code volume — see above)'
        lines << ''
        lines.concat(CohortTable.render(shares: data[:share_by_dependents],
                                        cohort_sizes: data[:dependents_cohort_sizes],
                                        label: 'Shape'))
        lines << ''
        lines << '### Composition of mutation sites'
        lines << ''
        lines.concat(CohortTable.composition(composition: data[:composition_by_dependents],
                                             site_totals: data[:site_totals_by_dependents],
                                             label: 'Shape'))
        lines << ''
        lines << '### Density'
        lines << ''
        lines.concat(CohortTable.density(density: data[:density_by_dependents],
                                         node_totals: data[:node_totals_by_dependents],
                                         label: 'Shape'))
        lines << ''
        lines << 'accumulator sites (fresh local container, never escapes its method mid-build) migrate to'
        lines << 'rebinding `<<` verbatim. escaped_local and shared_receiver sites are the aliasing population'
        lines << 'that a behavior change would need loud lints for. Static heuristic — escape detection is'
        lines << 'conservative and mutator matching is receiver-blind; treat accumulator as a lower bound.'
        lines << ''
        lines << "Errors: #{data[:errors].size}"

        lines.join("\n")
      end
    end
  end
end
