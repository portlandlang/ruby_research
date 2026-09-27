# frozen_string_literal: true

module RubyResearch
  module Reports
    # Readiness level 0 across RubyGems.org: how many gems' lib/ files parse
    # under Portland's own parser, unedited, and which refusals stop the
    # rest — ranked by the gems they appear in, and by the gems for which a
    # refusal is the only one (fix what it names and they parse). The first
    # ranking is a to-do list for the parsers where a refusal is a gap, and
    # a count of the price where it is a thesis difference.
    #
    # Needs a built portland: `cargo build --release` in a sibling checkout,
    # or PDX pointing at a pdx binary. Resumable like portland-compatibility
    # (--workers, --minutes).
    class PdxParse
      SHAPES_SHOWN = 60
      PARSING_SAMPLE_SIZE = 100

      def initialize(compact_index: CompactIndexClient.new,
                     minutes: nil,
                     reports_dir: REPORTS_DIR,
                     results_dir: File.join(DATA_DIR, 'results', 'pdx_parse'),
                     sample: nil,
                     seed: 42,
                     sources: GemSourceClient.new,
                     workers: 1)
        @analysis = PdxParseAnalysis.new(compact_index: compact_index, sources: sources)
        @compact_index = compact_index
        @minutes = minutes
        @reports_dir = reports_dir
        analysis_file = File.join(__dir__, 'pdx_parse_analysis.rb')
        @results = GemResults.new(directory: results_dir, inputs: [analysis_file, PdxParseAnalysis::DEFAULT_PDX])
        @sample = sample
        @seed = seed
        @workers = workers
      end

      def run
        entries = selected_names.filter_map do |name|
          latest = @compact_index.latest_version_of(name)
          [name, "#{latest[:version]}-#{latest[:platform]}"] if latest
        end
        pending = entries.reject { |name, version| @results.done?(name, version) }
        deadline = @minutes ? Time.now + (@minutes * 60) : Time.now + (365 * 24 * 3600)
        warn "  pdx-parse: #{pending.size} of #{entries.size} gems to parse, #{@workers} workers"
        @results.compute(pending, deadline: deadline, workers: @workers) { |name, _version| @analysis.result_for(name) }

        recorded = @results.all
        remaining = entries.count { |name, version| recorded.dig(name, :version) != version }
        if remaining.positive?
          warn "  pdx-parse: #{remaining} gems still to parse — rerun to continue"
          return []
        end

        write(entries.to_h { |name, _version| [name, recorded.fetch(name)] })
      end

      # The corpus-wide counts, from each gem's recorded result.
      def summarize(recorded)
        results = recorded.filter_map { |name, entry| [name, entry[:result]] if entry[:result] }.to_h
        with_files = results.select { |_name, result| result[:files].positive? }
        {
          gems_with_lib_files: with_files.size,
          gems_without_lib_files: results.size - with_files.size,
          gems_parsing: with_files.count { |_name, result| result[:failed].zero? },
          parsing_sample: with_files.select { |_name, result| result[:failed].zero? }.keys.sort.first(PARSING_SAMPLE_SIZE),
          files: with_files.sum { |_name, result| result[:files] },
          files_failing: with_files.sum { |_name, result| result[:failed] },
          shapes: shapes_of(with_files.values),
          errors: recorded.filter_map { |name, entry| { gem: name, error: entry[:error] } if entry[:error] }
        }
      end

      private

      def shapes_of(results)
        shapes = Hash.new { |hash, key| hash[key] = { gems: 0, files: 0, only_shape_for: 0 } }
        results.each do |result|
          result[:shapes].each do |shape, files|
            shapes[shape.to_s][:gems] += 1
            shapes[shape.to_s][:files] += files
          end
          shapes[result[:shapes].keys.first.to_s][:only_shape_for] += 1 if result[:shapes].size == 1
        end
        shapes.sort_by { |_shape, count| -count[:gems] }.to_h
      end

      def selected_names
        names = @compact_index.names
        return names unless @sample

        names.sample(@sample, random: Random.new(@seed))
      end

      def write(recorded)
        data = summarize(recorded).merge(corpus_size: @compact_index.names.size, sampled: @sample)
        writer = ReportWriter.new(name: 'pdx_parse', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data))
      end

      def percent(part, whole) = whole.zero? ? 0 : (part * 100.0 / whole).round(1)

      def markdown_for(data)
        lines = []
        lines << '# Readiness level 0: gems that parse under pdx, unedited'
        lines << ''
        scope = Scope.describe(sampled: data[:sampled], analyzed: data[:gems_with_lib_files])
        lines << "Based on #{scope} with Ruby files under lib/, out of #{data[:corpus_size]} on RubyGems.org " \
                 "(#{data[:gems_without_lib_files]} more have none). Each gem's lib/ files, as published, " \
                 "through portland's `pdx --parse`."
        lines << ''
        lines << "- Gems whose every lib/ file parses: **#{data[:gems_parsing]}** " \
                 "(#{percent(data[:gems_parsing], data[:gems_with_lib_files])}%)"
        lines << "- Files that parse: #{data[:files] - data[:files_failing]} of #{data[:files]} " \
                 "(#{percent(data[:files] - data[:files_failing], data[:files])}%)"
        lines << ''
        lines << '## Refusals, by the gems they appear in'
        lines << ''
        lines << 'A refusal with its particulars folded out (quoted source becomes `…`, numbers `N`). ' \
                 '"Only refusal" counts the gems for which it is the only kind that stops them: fix ' \
                 'what it names and they parse.'
        lines << ''
        lines << '| Refusal | Gems | Files | Only refusal |'
        lines << '|---|---:|---:|---:|'
        data[:shapes].first(SHAPES_SHOWN).each do |shape, count|
          lines << "| #{shape.gsub('|', '\\|')} | #{count[:gems]} | #{count[:files]} | #{count[:only_shape_for]} |"
        end
        lines << ''
        lines << "#{data[:shapes].size} refusal shapes in all; the JSON has every one."
        lines << ''
        lines << '## Gems that parse'
        lines << ''
        lines << "#{data[:gems_parsing]} gems. First #{data[:parsing_sample].size}, alphabetically:"
        lines << ''
        data[:parsing_sample].each { lines << "- #{it}" }
        lines << ''
        lines << "Errors: #{data[:errors].size}"
        lines.join("\n")
      end
    end
  end
end
