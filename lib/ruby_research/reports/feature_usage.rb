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
      def initialize(compact_index: CompactIndexClient.new,
                     sources: GemSourceClient.new,
                     reports_dir: REPORTS_DIR,
                     sample: nil,
                     seed: 42)
        @compact_index = compact_index
        @sources = sources
        @reports_dir = reports_dir
        @sample = sample
        @seed = seed
      end

      def run
        names = selected_names
        occurrences = Hash.new(0)
        gems_using = Hash.new { |hash, key| hash[key] = [] }
        parse_errors = []
        errors = []
        analyzed = []

        progress = Progress.new(label: 'feature-usage')
        names.each_with_index do |name, index|
          progress.tick(index + 1, names.size)
          node_types = node_types_for(name, parse_errors: parse_errors)
          next if node_types.nil?

          analyzed << name
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
        }
        writer = ReportWriter.new(name: 'feature_usage', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data))
      end

      private

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
