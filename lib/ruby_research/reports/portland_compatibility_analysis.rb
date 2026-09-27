# frozen_string_literal: true

require 'prism'

module RubyResearch
  module Reports
    # One gem's half of portland-compatibility: which listed features its
    # source touches. Kept apart from the report's aggregation because its
    # answers are cached per gem (GemResults), keyed on this file and the
    # removals list — so rewording the report doesn't redo two hours of
    # parsing, and changing how a gem is read does.
    class PortlandCompatibilityAnalysis
      REMOVALS_FILE = File.join(ROOT, 'config', 'portland_removals.yml')

      def initialize(compact_index: CompactIndexClient.new, sources: GemSourceClient.new)
        @compact_index = compact_index
        @sources = sources
      end

      def features = @features ||= YAML.safe_load_file(REMOVALS_FILE).fetch('features')

      def detectable_features
        features.select { it['node_types'] || it['method_names'] || it['constant_names'] }
      end

      # The names of the listed features a gem's source touches, or nil when
      # the gem has no release to analyze.
      def matched_features(name)
        usage = usage_for(name)
        return nil if usage.nil?

        features_in(usage)
      end

      def features_in(usage) = detectable_features.select { used?(it, usage) }.map { it['name'] }

      # The node types, called/defined method names, and constant reads in
      # one parsed tree, added to usage.
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

      def empty_usage = { node_types: Set.new, method_names: Set.new, constant_names: Set.new }

      private

      def used?(feature, usage)
        usage[:node_types].intersect?(Array(feature['node_types'])) ||
          usage[:method_names].intersect?(Array(feature['method_names'])) ||
          usage[:constant_names].intersect?(Array(feature['constant_names']))
      end

      def usage_for(name)
        latest = @compact_index.latest_version_of(name)
        return nil unless latest

        usage = empty_usage
        @sources.each_ruby_file(name, latest[:version], platform: latest[:platform]) do |_path, source|
          result = Prism.parse(source)
          collect(result.value, usage) if result.success?
        end
        usage
      end
    end
  end
end
