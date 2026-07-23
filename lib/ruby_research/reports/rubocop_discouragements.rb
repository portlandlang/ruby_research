# frozen_string_literal: true

module RubyResearch
  module Reports
    # Answers: "What parts of Ruby language are discouraged by RuboCop?"
    #
    # Reads RuboCop's shipped default.yml and reports every cop that is
    # enabled by default, grouped by department, with its description.
    # Cops enabled by default represent language usage the wider Ruby
    # community has agreed to discourage out of the box.
    class RubocopDiscouragements
      def initialize(reports_dir: REPORTS_DIR)
        @reports_dir = reports_dir
      end

      def run
        cops = default_cops
        data = {
          generated_with: "rubocop #{rubocop_version}",
          enabled_by_default_count: cops.count { it[:enabled] },
          disabled_by_default_count: cops.count { !it[:enabled] },
          cops: cops
        }
        writer = ReportWriter.new(name: 'rubocop_discouragements', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data))
      end

      private

      def rubocop_version
        require 'rubocop/version'
        RuboCop::Version::STRING
      end

      def default_config_path
        require 'rubocop'
        RuboCop::ConfigLoader::DEFAULT_FILE
      end

      def default_cops
        config = YAML.unsafe_load_file(default_config_path)
        config.filter_map do |key, value|
          next unless key.include?('/') && value.is_a?(Hash)

          {
            cop: key,
            department: key.split('/').first,
            description: value['Description'],
            enabled: value['Enabled'] == true,
            safe_autocorrect: value.fetch('SafeAutoCorrect', true),
            style_guide: value['StyleGuide']
          }
        end
      end

      def markdown_for(data)
        lines = []
        lines << '# RuboCop-discouraged Ruby'
        lines << ''
        lines << "Generated with #{data[:generated_with]}."
        lines << ''
        lines << "Cops enabled by default: #{data[:enabled_by_default_count]}. " \
                 "Disabled by default: #{data[:disabled_by_default_count]}."
        lines << ''

        data[:cops].group_by { it[:department] }.sort.each do |department, cops|
          enabled = cops.select { it[:enabled] }
          next if enabled.empty?

          lines << "## #{department} (#{enabled.size} enabled)"
          lines << ''
          enabled.sort_by { it[:cop] }.each do |cop|
            lines << "- **#{cop[:cop]}** — #{cop[:description]}"
          end
          lines << ''
        end

        lines.join("\n")
      end
    end
  end
end
