# frozen_string_literal: true

module RubyResearch
  module Reports
    # How gems' own tests are written (#13), for portland#117: which test
    # framework the corpus uses, the same among the gems that parse under
    # pdx and among those with no open question left, and which methods the
    # shipped tests of the parsing gems call — the smallest subset of a
    # framework that would run them. Resumable like portland-compatibility.
    class TestFrameworks
      CALLS_SHOWN = 60

      def initialize(compact_index: CompactIndexClient.new,
                     minutes: nil,
                     reports_dir: REPORTS_DIR,
                     results_dir: File.join(DATA_DIR, 'results', 'test_frameworks'),
                     sources: GemSourceClient.new,
                     workers: 1)
        @analysis = TestFrameworksAnalysis.new(compact_index: compact_index, sources: sources)
        @compact_index = compact_index
        @minutes = minutes
        @reports_dir = reports_dir
        @results = GemResults.new(directory: results_dir, inputs: [File.join(__dir__, 'test_frameworks_analysis.rb')])
        @workers = workers
      end

      def run
        entries = @compact_index.names.filter_map do |name|
          latest = @compact_index.latest_version_of(name)
          [name, "#{latest[:version]}-#{latest[:platform]}"] if latest
        end
        pending = entries.reject { |name, version| @results.done?(name, version) }
        deadline = @minutes ? Time.now + (@minutes * 60) : Time.now + (365 * 24 * 3600)
        warn "  test-frameworks: #{pending.size} of #{entries.size} gems to read, #{@workers} workers"
        @results.compute(pending, deadline: deadline, workers: @workers) { |name, _version| @analysis.result_for(name) }

        recorded = @results.all
        remaining = entries.count { |name, version| recorded.dig(name, :version) != version }
        if remaining.positive?
          warn "  test-frameworks: #{remaining} gems still to read — rerun to continue"
          return []
        end

        write(recorded)
      end

      private

      def write(recorded)
        results = recorded.filter_map { |name, entry| [name, entry[:result]] if entry[:result] }.to_h
        groups = { 'all gems' => results.keys, 'parse under pdx' => parsing_names,
                   'no open question' => no_open_question_names }
        data = {
          frameworks: groups.transform_values { |names| framework_shares(names, results) },
          shipping_tests: groups.transform_values { |names| names.count { results.dig(it, :test_files).to_i.positive? } },
          calls: top_calls(groups['parse under pdx'], results)
        }
        writer = ReportWriter.new(name: 'test_frameworks', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data, groups.transform_values(&:size)))
      end

      def parsing_names
        PdxParse.new(compact_index: @compact_index).recorded.filter_map do |name, entry|
          result = entry[:result]
          name if result && result[:files].positive? && result[:failed].zero?
        end
      end

      def no_open_question_names
        features = PortlandCompatibilityAnalysis.new.features
        open = features.select { it['difference'] == 'gap' || it['status'] == 'undecided' }.map { it['name'] }
        compatibility = PortlandCompatibility.new(compact_index: @compact_index).recorded
        parsing_names.reject { Array(compatibility.dig(it, :result)).intersect?(open) }
      end

      # Framework => gems naming it, plus the gems naming none.
      def framework_shares(names, results)
        tally = Hash.new(0)
        names.each do |name|
          frameworks = results.dig(name, :frameworks) || []
          frameworks = ['none named'] if frameworks.empty?
          frameworks.each { tally[it] += 1 }
        end
        tally.sort_by { -it[1] }.to_h
      end

      def top_calls(names, results)
        tally = Hash.new(0)
        names.each { |name| (results.dig(name, :calls) || {}).each { |call, count| tally[call.to_s] += count } }
        tally.sort_by { -it[1] }.first(CALLS_SHOWN).to_h
      end

      def markdown_for(data, sizes)
        lines = ['# How gems test themselves', '']
        lines << 'The test framework each gem\'s gemspec names among its development dependencies, for all gems, ' \
                 'the gems that parse under pdx, and those of them with no open question left (portland#117).'
        data[:frameworks].each do |group, shares|
          lines << '' << "## #{group} (#{sizes[group]} gems, #{data[:shipping_tests][group]} ship tests in the .gem)"
          lines << '' << '| Framework | Gems |' << '|---|---:|'
          shares.each { |framework, count| lines << "| #{framework} | #{count} |" }
        end
        lines << '' << '## What their shipped tests call' << ''
        lines << 'Method names called across the shipped test files of the gems that parse under pdx, most first ' \
                 '(the no-open-question group ships too few tests to say much).'
        lines << '' << '| Call | Times |' << '|---|---:|'
        data[:calls].each { |call, count| lines << "| `#{call}` | #{count} |" }
        lines.join("\n")
      end
    end
  end
end
