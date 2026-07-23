# frozen_string_literal: true

require 'fileutils'
require 'net/http'
require 'uri'

module RubyResearch
  module Reports
    # Answers: "What parts of Ruby are discouraged by the language itself?"
    # and "What is disallowed on which versions of Ruby?"
    #
    # Fetches the official NEWS file for each Ruby minor release from the
    # ruby/ruby repository and extracts every top-level bullet that
    # mentions deprecation, removal, or obsoletion. This yields a
    # per-version timeline of what the language itself has walked away
    # from. NEWS files are cached under data/ruby_news/.
    class RubyDeprecations
      NEWS_FILES = {
        '2.0' => 'doc/NEWS/NEWS-2.0.0',
        '2.1' => 'doc/NEWS/NEWS-2.1.0',
        '2.2' => 'doc/NEWS/NEWS-2.2.0',
        '2.3' => 'doc/NEWS/NEWS-2.3.0',
        '2.4' => 'doc/NEWS/NEWS-2.4.0',
        '2.5' => 'doc/NEWS/NEWS-2.5.0',
        '2.6' => 'doc/NEWS/NEWS-2.6.0',
        '2.7' => 'doc/NEWS/NEWS-2.7.0',
        '3.0' => 'doc/NEWS/NEWS-3.0.0.md',
        '3.1' => 'doc/NEWS/NEWS-3.1.0.md',
        '3.2' => 'doc/NEWS/NEWS-3.2.0.md',
        '3.3' => 'doc/NEWS/NEWS-3.3.0.md',
        '3.4' => 'doc/NEWS/NEWS-3.4.0.md',
        '4.0' => 'doc/NEWS/NEWS-4.0.0.md',
        'head' => 'NEWS.md'
      }.freeze

      PATTERN = /deprecat|removed|no longer|obsolete/i

      def initialize(cache_dir: File.join(DATA_DIR, 'ruby_news'), http: HttpClient.new, reports_dir: REPORTS_DIR)
        @cache_dir = cache_dir
        @http = http
        @reports_dir = reports_dir
      end

      def run
        by_version = NEWS_FILES.to_h do |version, path|
          [version, matching_bullets(news_for(version, path))]
        end

        data = {
          pattern: PATTERN.source,
          sources: NEWS_FILES,
          entries_by_version: by_version,
          entry_counts: by_version.transform_values(&:size)
        }
        writer = ReportWriter.new(name: 'ruby_deprecations', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data))
      end

      private

      def news_for(version, path)
        full_path = File.join(@cache_dir, "NEWS-#{version}.md")
        return File.read(full_path) if File.exist?(full_path)

        body = @http.get("https://raw.githubusercontent.com/ruby/ruby/master/#{path}")
        FileUtils.mkdir_p(@cache_dir)
        File.write(full_path, body)
        body
      end

      # Collects full bullet items (bullet line plus indented continuation
      # lines) whose text matches PATTERN.
      def matching_bullets(news)
        bullets = []
        current = nil

        news.each_line do |line|
          if line.match?(/\A\s*[*-]\s/)
            bullets << current if current
            current = line.rstrip
          elsif current && line.match?(/\A\s+\S/)
            current += " #{line.strip}"
          else
            bullets << current if current
            current = nil
          end
        end
        bullets << current if current

        bullets.grep(PATTERN).map { squish(it) }
      end

      def squish(bullet) = bullet.sub(/\A\s*[*-]\s*/, '').gsub(/\s+/, ' ').strip

      def markdown_for(data)
        lines = []
        lines << '# Deprecations and removals in Ruby itself'
        lines << ''
        lines << 'Bullets mentioning deprecation/removal/obsoletion, extracted from the official'
        lines << 'NEWS file of each Ruby minor release (ruby/ruby repository).'
        lines << ''
        data[:entries_by_version].each do |version, entries|
          lines << "## Ruby #{version} (#{entries.size} entries)"
          lines << ''
          entries.each { lines << "- #{it}" }
          lines << ''
        end

        lines.join("\n")
      end
    end
  end
end
