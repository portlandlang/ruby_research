# frozen_string_literal: true

module RubyResearch
  module Reports
    # Answers: "What is the histogram threshold of very old/unmaintained?"
    #
    # For each gem (all or a sample), takes the created_at of its most
    # recent release from the compact index and builds a histogram of
    # last-release years. This is the raw data for choosing an
    # "unmaintained" cutoff by year.
    class GemAges
      def initialize(client: CompactIndexClient.new, reports_dir: REPORTS_DIR, sample: nil, seed: 42)
        @client = client
        @reports_dir = reports_dir
        @sample = sample
        @seed = seed
      end

      def run
        names = selected_names
        last_release_years = {}
        errors = []

        progress = Progress.new(label: 'gem-ages')
        names.each_with_index do |name, index|
          progress.tick(index + 1, names.size)
          versions = @client.versions_of(name)
          created_at = versions.last&.dig(:created_at)
          last_release_years[name] = created_at && created_at[0, 4]
        rescue StandardError => e
          errors << { gem: name, error: e.message }
        end
        progress.finish

        histogram = last_release_years.values.tally.sort_by { |year, _count| year.to_s }.to_h

        data = {
          corpus_size: total_names_count,
          sampled: @sample,
          analyzed: last_release_years.size,
          errors: errors,
          last_release_year_histogram: histogram
        }
        writer = ReportWriter.new(name: 'gem_ages', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data))
      end

      private

      def total_names_count = @client.names.size

      def selected_names
        names = @client.names
        return names unless @sample

        names.sample(@sample, random: Random.new(@seed))
      end

      def markdown_for(data)
        lines = []
        lines << '# Last release year across RubyGems.org'
        lines << ''
        scope = Scope.describe(sampled: data[:sampled], analyzed: data[:analyzed])
        lines << "Year of most recent release for #{scope}, out of #{data[:corpus_size]} gems on RubyGems.org."
        lines << ''
        lines << '| Last release year | Gems | % |'
        lines << '|---|---|---|'
        total = data[:analyzed]
        data[:last_release_year_histogram].each do |year, count|
          percent = (count * 100.0 / total).round(1)
          lines << "| #{year || 'unknown'} | #{count} | #{percent}% |"
        end
        lines << ''
        lines << "Errors: #{data[:errors].size}"

        lines.join("\n")
      end
    end
  end
end
