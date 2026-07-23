# frozen_string_literal: true

require 'prism'

module RubyResearch
  module Reports
    # Census of real-world error handling, feeding Portland's
    # exceptions-vs-results decision.
    #
    # For each sampled gem, counts the shapes that matter to that decision:
    # rescue with a specific class vs bare rescue, rescues that re-raise vs
    # swallow, `foo rescue nil` modifiers, ensure blocks, retry, raise
    # sites, and custom error class hierarchies (classes inheriting from
    # something named *Error / Exception). Reported as site counts plus
    # gem coverage.
    class ErrorHandling
      SHAPES = %w[
        raise_site
        rescue_clause
        rescue_specific_class
        rescue_bare
        rescue_reraises
        rescue_swallows
        rescue_modifier
        ensure_block
        retry_site
        custom_error_class
      ].freeze

      def initialize(compact_index: CompactIndexClient.new,
                     sources: GemSourceClient.new,
                     reports_dir: REPORTS_DIR,
                     sample: 100,
                     seed: 42)
        @compact_index = compact_index
        @sources = sources
        @reports_dir = reports_dir
        @sample = sample
        @seed = seed
      end

      def run
        site_counts = Hash.new(0)
        gem_counts = Hash.new(0)
        errors = []
        analyzed = 0
        names = selected_names

        names.each_with_index do |name, index|
          warn "  #{index + 1}/#{names.size} gems (#{name})" if ((index + 1) % 10).zero?
          gem_sites = sites_for(name)
          next if gem_sites.nil?

          analyzed += 1
          gem_sites.each do |shape, count|
            site_counts[shape] += count
            gem_counts[shape] += 1 if count.positive?
          end
        rescue StandardError => e
          errors << { gem: name, error: e.message }
        end

        data = {
          corpus_size: @compact_index.names.size,
          sampled: @sample,
          analyzed: analyzed,
          errors: errors,
          site_counts: SHAPES.to_h { [it, site_counts[it]] },
          gem_coverage: SHAPES.to_h { [it, gem_counts[it]] }
        }
        writer = ReportWriter.new(name: 'error_handling', reports_dir: @reports_dir)
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
          when Prism::CallNode then sites['raise_site'] += 1 if %i[raise fail].include?(node.name)
          when Prism::RescueNode then collect_rescue(node, sites)
          when Prism::RescueModifierNode then sites['rescue_modifier'] += 1
          when Prism::EnsureNode then sites['ensure_block'] += 1
          when Prism::RetryNode then sites['retry_site'] += 1
          when Prism::ClassNode then sites['custom_error_class'] += 1 if error_superclass?(node)
          end
          queue.concat(node.compact_child_nodes)
        end
      end

      def collect_rescue(node, sites)
        sites['rescue_clause'] += 1
        node.exceptions.empty? ? sites['rescue_bare'] += 1 : sites['rescue_specific_class'] += 1
        reraises?(node) ? sites['rescue_reraises'] += 1 : sites['rescue_swallows'] += 1
      end

      # Does this rescue body (not counting nested rescues) call raise/fail?
      def reraises?(rescue_node)
        queue = rescue_node.statements ? [rescue_node.statements] : []
        until queue.empty?
          node = queue.pop
          next if node.is_a?(Prism::RescueNode) || node.is_a?(Prism::BeginNode)
          return true if node.is_a?(Prism::CallNode) && %i[raise fail].include?(node.name)

          queue.concat(node.compact_child_nodes)
        end
        false
      end

      def error_superclass?(class_node)
        superclass = class_node.superclass
        return false unless superclass.is_a?(Prism::ConstantReadNode) || superclass.is_a?(Prism::ConstantPathNode)

        superclass.slice.match?(/Error\z|Exception\z/)
      end

      def markdown_for(data)
        lines = []
        lines << '# Error-handling census across RubyGems.org'
        lines << ''
        lines << "Sampled #{data[:analyzed]} gems (seeded, reproducible) out of #{data[:corpus_size]} on RubyGems.org."
        lines << ''
        lines << '| Shape | Sites | Gems using it | % of gems |'
        lines << '|---|---|---|---|'
        data[:site_counts].each_key do |shape|
          gems = data[:gem_coverage][shape]
          percent = (gems * 100.0 / data[:analyzed]).round(1)
          lines << "| #{shape} | #{data[:site_counts][shape]} | #{gems} | #{percent}% |"
        end
        lines << ''
        lines << 'Notes: rescue_reraises means the rescue body contains a raise/fail call; rescue_swallows is the complement.'
        lines << 'custom_error_class counts classes whose superclass name ends in Error/Exception.'
        lines << ''
        lines << "Errors: #{data[:errors].size}"

        lines.join("\n")
      end
    end
  end
end
