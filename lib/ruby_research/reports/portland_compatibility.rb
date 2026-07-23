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
    # reference. A gem touching no decided removal is a Just Work™
    # candidate at the syntax level; semantic changes with no static
    # detection (truthiness, ambient nil, mutability) are reported
    # separately since they affect nearly all code via the type checker.
    class PortlandCompatibility
      REMOVALS_FILE = File.join(ROOT, 'config', 'portland_removals.yml')

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
        gems_by_feature = Hash.new { |hash, key| hash[key] = [] }
        features_by_gem = {}
        errors = []
        names = selected_names

        names.each_with_index do |name, index|
          warn "  #{index + 1}/#{names.size} gems (#{name})" if ((index + 1) % 10).zero?
          usage = usage_for(name)
          next if usage.nil?

          matched = detectable_features.select { feature_used?(it, usage) }.map { it['name'] }
          features_by_gem[name] = matched
          matched.each { gems_by_feature[it] << name }
        rescue StandardError => e
          errors << { gem: name, error: e.message }
        end

        decided = detectable_features.select { it['status'] == 'decided' }.map { it['name'] }
        clean_gems = features_by_gem.reject { |_gem, used| used.intersect?(decided) }.keys.sort
        data = {
          corpus_size: @compact_index.names.size,
          sampled: @sample,
          analyzed: features_by_gem.size,
          errors: errors,
          removals_file: 'config/portland_removals.yml',
          just_work_candidates_count: clean_gems.size,
          just_work_candidates: clean_gems,
          gems_affected_by_feature: gems_by_feature.transform_values(&:size).sort_by { |_feature, count| -count }.to_h,
          undetectable_semantic_changes: undetectable_features.map { it['name'] },
          features_by_gem: features_by_gem.sort.to_h
        }
        writer = ReportWriter.new(name: 'portland_compatibility', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data))
      end

      private

      def features = @features ||= YAML.safe_load_file(REMOVALS_FILE).fetch('features')

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
        versions = @compact_index.versions_of(name)
        latest = versions.rfind { it[:platform] == 'ruby' } || versions.last
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
          when Prism::ConstantReadNode then usage[:constant_names] << node.name.to_s
          end
          queue.concat(node.compact_child_nodes)
        end
      end

      def markdown_for(data)
        lines = []
        lines << '# Portland compatibility across RubyGems.org'
        lines << ''
        lines << "Sampled #{data[:analyzed]} gems (seeded, reproducible) out of #{data[:corpus_size]} on RubyGems.org, " \
                 "scanned for the Ruby features Portland removes or changes (#{data[:removals_file]})."
        lines << ''
        percent = data[:analyzed].zero? ? 0 : (data[:just_work_candidates_count] * 100.0 / data[:analyzed]).round(1)
        lines << "Just Work™ candidates (no decided removal detected): **#{data[:just_work_candidates_count]}** (#{percent}%)."
        lines << ''
        lines << '## Gems affected, by removed/changed feature'
        lines << ''
        lines << '| Feature | Gems | % of gems |'
        lines << '|---|---|---|'
        data[:gems_affected_by_feature].each do |feature, count|
          feature_percent = (count * 100.0 / data[:analyzed]).round(1)
          lines << "| #{feature} | #{count} | #{feature_percent}% |"
        end
        lines << ''
        lines << '## Semantic changes with no static detection'
        lines << ''
        lines << 'These affect nearly all code via the type checker rather than any syntax form:'
        lines << ''
        data[:undetectable_semantic_changes].each { lines << "- #{it}" }
        lines << ''
        lines << '## Just Work™ candidates'
        lines << ''
        data[:just_work_candidates].each { lines << "- #{it}" }
        lines << ''
        lines << "Errors: #{data[:errors].size}"

        lines.join("\n")
      end
    end
  end
end
