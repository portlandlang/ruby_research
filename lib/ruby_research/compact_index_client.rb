# frozen_string_literal: true

require 'fileutils'
require 'net/http'
require 'uri'

module RubyResearch
  # Fetches and caches RubyGems.org compact index files.
  #
  # - /names          : every gem name ever published
  # - /info/<gem>     : every version of a gem, with platform,
  #                     dependency, ruby and rubygems requirements
  #
  # Responses are cached on disk under data/compact_index/ so repeated
  # runs (and interrupted full-corpus runs) don't refetch.
  class CompactIndexClient
    HOST = 'https://rubygems.org'

    def initialize(cache_dir: File.join(DATA_DIR, 'compact_index'), http: HttpClient.new)
      @cache_dir = cache_dir
      @http = http
    end

    attr_reader :cache_dir

    def names
      body = cached_fetch(path: '/names', cache_file: 'names.txt')
      lines = body.lines(chomp: true)
      lines.shift if lines.first == '---'
      lines
    end

    # Returns an array of version hashes for a gem:
    #   { version:, platform:, ruby:, rubygems:, created_at: }
    def versions_of(gem_name)
      body = cached_fetch(path: "/info/#{gem_name}", cache_file: File.join('info', gem_name))
      parse_info(body)
    end

    def cached?(gem_name) = File.exist?(File.join(cache_dir, 'info', gem_name))

    private

    def cached_fetch(path:, cache_file:)
      full_path = File.join(cache_dir, cache_file)
      return File.read(full_path) if File.exist?(full_path)

      body = @http.get("#{HOST}#{path}")
      FileUtils.mkdir_p(File.dirname(full_path))
      File.write(full_path, body)
      body
    end

    def parse_info(body)
      lines = body.lines(chomp: true)
      lines.shift if lines.first == '---'

      lines.filter_map do |line|
        version_part, rest = line.split(' ', 2)
        next unless version_part

        version, platform = version_part.split('-', 2)
        requirements = rest.to_s.split('|').last.to_s
        {
          version: version,
          platform: platform || 'ruby',
          ruby: requirement_from(requirements, key: 'ruby'),
          rubygems: requirement_from(requirements, key: 'rubygems'),
          created_at: requirement_from(requirements, key: 'created_at')
        }
      end
    end

    def requirement_from(requirements, key:)
      entry = requirements.split(',').find { it.start_with?("#{key}:") }
      entry&.delete_prefix("#{key}:")
    end
  end
end
