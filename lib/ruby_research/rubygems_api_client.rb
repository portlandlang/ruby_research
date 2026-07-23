# frozen_string_literal: true

require 'fileutils'
require 'net/http'
require 'uri'

module RubyResearch
  # Fetches and caches per-gem data from the RubyGems.org API that the
  # compact index doesn't carry (release dates, downloads, etc).
  #
  # Rate limit is 10 requests/second; full-corpus runs are resumable
  # because every response is cached under data/api/.
  class RubygemsApiClient
    HOST = 'https://rubygems.org'
    THROTTLE_SECONDS = 0.12

    def initialize(cache_dir: File.join(DATA_DIR, 'api'), http: HttpClient.new)
      @cache_dir = cache_dir
      @http = http
    end

    attr_reader :cache_dir

    # All versions of a gem with created_at timestamps.
    def versions_of(gem_name)
      fetch_json(path: "/api/v1/versions/#{gem_name}.json", cache_file: File.join('versions', "#{gem_name}.json"))
    end

    # Gem-level metadata: downloads, latest version, source URIs, etc.
    def gem_info(gem_name)
      fetch_json(path: "/api/v1/gems/#{gem_name}.json", cache_file: File.join('gems', "#{gem_name}.json"))
    end

    def cached?(gem_name) = File.exist?(File.join(cache_dir, 'versions', "#{gem_name}.json"))

    private

    def fetch_json(path:, cache_file:)
      full_path = File.join(cache_dir, cache_file)
      return JSON.parse(File.read(full_path), symbolize_names: true) if File.exist?(full_path)

      body = @http.get("#{HOST}#{path}")
      FileUtils.mkdir_p(File.dirname(full_path))
      File.write(full_path, body)
      sleep(THROTTLE_SECONDS)
      JSON.parse(body, symbolize_names: true)
    end
  end
end
