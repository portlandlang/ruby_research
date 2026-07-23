# frozen_string_literal: true

module RubyResearch
  module Reports
    # Answers: "Which gems on RubyGems.org work on which versions of Ruby?"
    #
    # For each gem (all of RubyGems.org, or a sample), reads the latest
    # version's required_ruby_version from the compact index and builds a
    # histogram of minimum Ruby versions. Cached fetches make full-corpus
    # runs resumable — rerun the script and it picks up where it left off.
    class RubyRequirements
      def initialize(client: CompactIndexClient.new, reports_dir: REPORTS_DIR, sample: nil, seed: 42)
        @client = client
        @reports_dir = reports_dir
        @sample = sample
        @seed = seed
      end

      def run
        names = selected_names
        results = {}
        errors = []

        names.each_with_index do |name, index|
          versions = @client.versions_of(name)
          latest = versions.last
          results[name] = latest && latest[:ruby]
          warn "  #{index + 1}/#{names.size} gems" if ((index + 1) % 100).zero?
        rescue StandardError => e
          errors << { gem: name, error: e.message }
        end

        histogram = results.values.tally.sort_by { |_requirement, count| -count }.to_h
        minimum_versions = minimum_version_histogram(results)

        data = {
          corpus_size: total_names_count,
          sampled: @sample,
          analyzed: results.size,
          errors: errors,
          minimum_ruby_version_histogram: minimum_versions,
          requirement_histogram: histogram
        }
        writer = ReportWriter.new(name: 'ruby_requirements', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data))
      end

      private

      def total_names_count = @client.names.size

      def selected_names
        names = @client.names
        return names unless @sample

        names.sample(@sample, random: Random.new(@seed))
      end

      # Reduces a requirement string like ">= 2.7.0" or "~> 3.0" to the
      # lowest Ruby minor version that satisfies it (best effort).
      def minimum_version_histogram(results)
        results.values
               .map { minimum_version(it) }
               .tally
               .sort_by { |version, _count| sort_key_for(version) }
               .to_h
      end

      def minimum_version(requirement)
        return 'unspecified' if requirement.nil? || requirement.strip.empty?

        bound = requirement.split('&').map(&:strip).find { it.start_with?('>=', '~>', '=') }
        return "other (#{requirement})" unless bound

        version = bound.sub(/\A(>=|~>|=)\s*/, '')
        segments = version.split('.')
        return 'unspecified' if segments.first.to_i.zero?

        segments.first(2).join('.')
      end

      def sort_key_for(version)
        segments = version.split('.').map { Integer(it, exception: false) }
        return [999, 0] if segments.any?(&:nil?) || segments.empty?

        segments + ([0] * (2 - segments.size))
      end

      def markdown_for(data)
        lines = []
        lines << '# Minimum Ruby versions across RubyGems.org'
        lines << ''
        scope = data[:sampled] ? "a random sample of #{data[:analyzed]} gems (seeded, reproducible)" : "all #{data[:analyzed]} gems"
        lines << "Based on the latest published version of #{scope}, out of #{data[:corpus_size]} gems on RubyGems.org."
        lines << ''
        lines << '## Minimum Ruby version (latest release of each gem)'
        lines << ''
        lines << '| Minimum Ruby | Gems | % |'
        lines << '|---|---|---|'
        total = data[:analyzed]
        data[:minimum_ruby_version_histogram].each do |version, count|
          percent = (count * 100.0 / total).round(1)
          lines << "| #{version} | #{count} | #{percent}% |"
        end
        lines << ''
        lines << '## Raw requirement strings (top 25)'
        lines << ''
        lines << '| Requirement | Gems |'
        lines << '|---|---|'
        data[:requirement_histogram].first(25).each do |requirement, count|
          lines << "| `#{requirement || 'unspecified'}` | #{count} |"
        end
        lines << ''
        lines << "Errors: #{data[:errors].size}"

        lines.join("\n")
      end
    end
  end
end
