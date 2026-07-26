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
    #   { version:, platform:, dependencies:, ruby:, rubygems:, created_at: }
    def versions_of(gem_name)
      body = cached_fetch(path: "/info/#{gem_name}", cache_file: info_cache_file(gem_name))
      parse_info(body)
    end

    def cached?(gem_name) = File.exist?(File.join(cache_dir, info_cache_file(gem_name)))

    def info_cache_file(gem_name) = File.join('info', CacheKey.for(gem_name))

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
        dependency_part, requirements = rest.to_s.split('|', 2)
        {
          version: version,
          platform: platform || 'ruby',
          dependencies: parse_dependencies(dependency_part),
          ruby: requirement_from(requirements.to_s, key: 'ruby'),
          rubygems: requirement_from(requirements.to_s, key: 'rubygems'),
          created_at: requirement_from(requirements.to_s, key: 'created_at')
        }
      end
    end

    # "actionpack:< 7&>= 5.0,i18n:~> 1.0" =>
    #   [{ name: "actionpack", requirement: "< 7&>= 5.0" }, ...]
    #
    # Commas separate dependencies; multiple constraints on one dependency
    # are joined with "&", so splitting on comma is safe. The compact index
    # carries runtime dependencies only — development dependencies from the
    # gemspec never appear here.
    def parse_dependencies(dependency_part)
      dependency_part.to_s.split(',').filter_map do |entry|
        name, requirement = entry.split(':', 2)
        next if name.nil? || name.empty?

        { name: name, requirement: requirement }
      end
    end

    def requirement_from(requirements, key:)
      entry = requirements.split(',').find { it.start_with?("#{key}:") }
      entry&.delete_prefix("#{key}:")
    end
  end
end
