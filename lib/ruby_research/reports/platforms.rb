# frozen_string_literal: true

module RubyResearch
  module Reports
    # Answers (partially): "Which gems only work on Intel architecture?"
    # and provides the platform landscape for the C-extension questions.
    #
    # For each gem (all or a sample), looks at the platforms of its latest
    # version number across all published platform variants. A gem whose
    # latest release ships only x86/x64 native platforms — with no "ruby"
    # (source) platform and no arm variant — is flagged intel_only.
    class Platforms
      INTEL_PATTERN = /x86|x64|i386|i686/
      ARM_PATTERN = /arm|aarch64/

      def initialize(client: CompactIndexClient.new, reports_dir: REPORTS_DIR, sample: nil, seed: 42)
        @client = client
        @reports_dir = reports_dir
        @sample = sample
        @seed = seed
      end

      def run
        names = selected_names
        platform_tally = Hash.new(0)
        intel_only_gems = []
        errors = []

        names.each_with_index do |name, index|
          versions = @client.versions_of(name)
          next if versions.empty?

          latest_number = versions.last[:version]
          platforms = versions.select { it[:version] == latest_number }.map { it[:platform] }.uniq
          platforms.each { platform_tally[it] += 1 }
          intel_only_gems << name if intel_only?(platforms)
          warn "  #{index + 1}/#{names.size} gems" if ((index + 1) % 100).zero?
        rescue StandardError => e
          errors << { gem: name, error: e.message }
        end

        data = {
          corpus_size: total_names_count,
          sampled: @sample,
          analyzed: names.size,
          errors: errors,
          intel_only_count: intel_only_gems.size,
          intel_only_gems: intel_only_gems.sort,
          platform_histogram: platform_tally.sort_by { |_platform, count| -count }.to_h
        }
        writer = ReportWriter.new(name: 'platforms', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data))
      end

      private

      def total_names_count = @client.names.size

      def selected_names
        names = @client.names
        return names unless @sample

        names.sample(@sample, random: Random.new(@seed))
      end

      def intel_only?(platforms)
        return false if platforms.include?('ruby')
        return false if platforms.none? { it.match?(INTEL_PATTERN) }

        platforms.none? { it.match?(ARM_PATTERN) }
      end

      def markdown_for(data)
        lines = []
        lines << '# Gem platforms across RubyGems.org'
        lines << ''
        scope = data[:sampled] ? "a random sample of #{data[:analyzed]} gems (seeded, reproducible)" : "all #{data[:analyzed]} gems"
        lines << "Based on the latest release of #{scope}, out of #{data[:corpus_size]} gems on RubyGems.org."
        lines << ''
        lines << '## Platform histogram (latest release, all variants)'
        lines << ''
        lines << '| Platform | Gems |'
        lines << '|---|---|'
        data[:platform_histogram].each do |platform, count|
          lines << "| #{platform} | #{count} |"
        end
        lines << ''
        lines << '## Intel-only gems (no source fallback, no arm variant)'
        lines << ''
        lines << "Count: #{data[:intel_only_count]}"
        lines << ''
        data[:intel_only_gems].each { lines << "- #{it}" }
        lines << ''
        lines << "Errors: #{data[:errors].size}"

        lines.join("\n")
      end
    end
  end
end
