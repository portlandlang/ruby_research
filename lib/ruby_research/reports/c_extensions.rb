# frozen_string_literal: true

module RubyResearch
  module Reports
    # Answers: "How many C extension gems are on RubyGems.org?" and
    # "How many are actively maintained, by year?"
    #
    # For each gem (all or a sample), fetches the full gemspec of the
    # latest version — via a ranged read of the .gem's metadata.gz, since
    # the quick-index marshaled specs strip `extensions` — and checks its
    # `extensions` field. Gems with native extensions are tallied overall,
    # by extension kind (extconf.rb = C, Cargo.toml = Rust, etc), and by
    # last-release year so the maintained-vs-abandoned split is visible.
    class CExtensions
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
        native_gems = []
        pure_count = 0
        errors = []

        progress = Progress.new(label: 'c-extensions')
        names.each_with_index do |name, index|
          progress.tick(index + 1, names.size)
          record = native_record_for(name)
          next if record == :skipped

          if record.nil?
            pure_count += 1
          else
            native_gems << record
          end
        rescue StandardError => e
          errors << { gem: name, error: e.message }
        end
        progress.finish

        analyzed = pure_count + native_gems.size
        data = {
          corpus_size: @compact_index.names.size,
          sampled: @sample,
          analyzed: analyzed,
          errors: errors,
          native_count: native_gems.size,
          native_percent: analyzed.zero? ? 0 : (native_gems.size * 100.0 / analyzed).round(2),
          extension_kind_histogram: native_gems.flat_map { it[:kinds] }.tally.sort_by { |_kind, count| -count }.to_h,
          native_by_last_release_year: native_gems.map { it[:last_release_year] }.tally.sort.to_h,
          native_gems: native_gems.sort_by { it[:gem] }
        }
        writer = ReportWriter.new(name: 'c_extensions', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data))
      end

      private

      def selected_names
        names = @compact_index.names
        return names unless @sample

        names.sample(@sample, random: Random.new(@seed))
      end

      # Returns nil for a pure-Ruby gem, :skipped when there are no
      # versions, or a hash describing the native gem.
      def native_record_for(name)
        versions = @compact_index.versions_of(name)
        latest = versions.rfind { it[:platform] == 'ruby' } || versions.last
        return :skipped unless latest

        spec = @sources.full_gemspec(name, latest[:version], platform: latest[:platform])
        extensions = Array(spec.extensions)
        return nil if extensions.empty?

        {
          gem: name,
          version: latest[:version],
          extensions: extensions,
          kinds: extensions.map { kind_of(it) }.uniq,
          last_release_year: versions.last[:created_at]&.slice(0, 4)
        }
      end

      def kind_of(extension)
        case extension
        when /extconf\.rb/ then 'c (extconf.rb)'
        when /Cargo\.toml/ then 'rust (Cargo.toml)'
        when /CMakeLists/ then 'cmake'
        when /configure/ then 'configure'
        when /Rakefile|\.rake/ then 'rake'
        else "other (#{extension})"
        end
      end

      def markdown_for(data)
        lines = []
        lines << '# Native (C extension) gems on RubyGems.org'
        lines << ''
        scope = Scope.describe(sampled: data[:sampled], analyzed: data[:analyzed])
        lines << "Based on the latest release of #{scope}, out of #{data[:corpus_size]} gems on RubyGems.org."
        lines << ''
        lines << "Gems with native extensions: **#{data[:native_count]}** (#{data[:native_percent]}% of analyzed)."
        lines << ''
        lines << '## Extension kinds'
        lines << ''
        lines << '| Kind | Gems |'
        lines << '|---|---|'
        data[:extension_kind_histogram].each { |kind, count| lines << "| #{kind} | #{count} |" }
        lines << ''
        lines << '## Native gems by last release year'
        lines << ''
        lines << '| Year | Gems |'
        lines << '|---|---|'
        data[:native_by_last_release_year].each { |year, count| lines << "| #{year || 'unknown'} | #{count} |" }
        lines << ''
        lines << '## Native gems'
        lines << ''
        data[:native_gems].each do |gem|
          lines << "- **#{gem[:gem]}** #{gem[:version]} (last release #{gem[:last_release_year]}): #{gem[:extensions].join(', ')}"
        end
        lines << ''
        lines << "Errors: #{data[:errors].size}"

        lines.join("\n")
      end
    end
  end
end
