# frozen_string_literal: true

require 'time'

module RubyResearch
  module Reports
    # Per-gem readiness as one JSON file for portlandlang.com's gem
    # dashboards (#14), read the way /spec/ reads its data. Built from what
    # pdx-parse (level 0) and portland-compatibility already recorded per
    # gem; downloads come from the RubyGems API, which is rate limited, so
    # they are fetched only for the gems that pass level 0 and only for as
    # long as the budget allows — the API cache makes a rerun resume, and
    # a gem whose downloads aren't cached yet is left out of the list, not
    # guessed at.
    class GemReadinessExport
      LISTED = 500

      def initialize(api: RubygemsApiClient.new,
                     compact_index: CompactIndexClient.new,
                     minutes: nil,
                     reports_dir: REPORTS_DIR,
                     sources: GemSourceClient.new)
        @api = api
        @compact_index = compact_index
        @minutes = minutes
        @reports_dir = reports_dir
        @sources = sources
      end

      def run
        parsing = PdxParse.new(compact_index: @compact_index).recorded
        compatibility = PortlandCompatibility.new(compact_index: @compact_index).recorded
        features = PortlandCompatibilityAnalysis.new.features
        passing = parsing.select { |_name, entry| (result = entry[:result]) && result[:files].positive? && result[:failed].zero? }
        downloads = downloads_for(passing.keys)
        rows = downloads.map do |name, count|
          latest = @compact_index.latest_version_of(name)
          row_for(name: name, version: latest[:version], downloads: count, dependencies: latest[:dependencies].size,
                  native: latest[:platform] != 'ruby', matched: compatibility.dig(name, :result) || [],
                  features: features)
        end
        write(summary(parsing, passing, downloads), rows.sort_by { -it[:downloads] }.first(LISTED))
      end

      # One gem's row: its listed differences by kind, and its grade — the
      # hardest kind it touches, as portland-compatibility grades.
      def row_for(name:, version:, downloads:, dependencies:, native:, matched:, features:)
        used = features.select { matched.include?(it['name']) }
        open = used.select { it['difference'] == 'gap' || it['status'] == 'undecided' }
        thesis = (used - open).select { it['difference'] == 'thesis' }
        taste = (used - open).select { it['difference'] == 'taste' }
        grade = if open.any? then 'gap or undecided'
                elsif thesis.any? then 'thesis'
                elsif taste.any? then 'taste only'
                else 'runs as is'
                end
        { name: name, version: version, downloads: downloads, dependencies: dependencies, native: native,
          grade: grade, open_questions: open.map { it['name'] }, thesis: thesis.map { it['name'] },
          taste: taste.map { it['name'] } }
      end

      private

      # Downloads for as many gems as the budget allows, cached ones free.
      def downloads_for(names)
        deadline = @minutes ? Time.now + (@minutes * 60) : nil
        names.each_with_object({}) do |name, found|
          next if deadline && Time.now > deadline && !@api.gem_cached?(name)

          found[name] = @api.gem_info(name)[:downloads].to_i
        rescue StandardError => e
          warn "  gem-readiness-export: #{name}: #{e.message}"
        end
      end

      def summary(parsing, passing, downloads)
        {
          generated_at: Time.now.utc.iso8601,
          corpus_size: @compact_index.names.size,
          gems_with_lib_files: parsing.count { |_name, entry| entry[:result] && entry[:result][:files].positive? },
          gems_parsing: passing.size,
          gems_listed_from: downloads.size
        }
      end

      def write(summary, rows)
        data = summary.merge(gems: rows)
        writer = ReportWriter.new(name: 'gem_readiness', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data))
      end

      def markdown_for(data)
        lines = ['# Gem readiness', '']
        lines << "Of #{data[:corpus_size]} gems, #{data[:gems_with_lib_files]} have Ruby files under lib/, and " \
                 "#{data[:gems_parsing]} parse under pdx unedited. The JSON beside this lists the " \
                 "#{data[:gems].size} most downloaded of the #{data[:gems_listed_from]} whose downloads are " \
                 'cached, for portlandlang.com/gems/.'
        lines.join("\n")
      end
    end
  end
end
