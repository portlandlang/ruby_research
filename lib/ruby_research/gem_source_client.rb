# frozen_string_literal: true

require 'fileutils'
require 'net/http'
require 'rubygems/package'
require 'uri'
require 'zlib'

module RubyResearch
  # Downloads .gem files from RubyGems.org and yields their Ruby sources.
  #
  # Downloaded gems are cached under data/gems/ so full-corpus feature
  # analysis is resumable without refetching. Extraction happens in memory
  # via Gem::Package — nothing is unpacked to disk.
  class GemSourceClient
    HOST = 'https://rubygems.org'

    # metadata.gz is the first tar entry and usually only a few KB; 16KB
    # covers the common case and the fallback fetches exactly the missing
    # bytes when it doesn't.
    METADATA_PROBE_BYTES = 16_384

    def initialize(cache_dir: File.join(DATA_DIR, 'gems'),
                   http: HttpClient.new,
                   metadata_cache_dir: File.join(DATA_DIR, 'gem_metadata'))
      @cache_dir = cache_dir
      @http = http
      @metadata_cache_dir = metadata_cache_dir
    end

    attr_reader :cache_dir, :metadata_cache_dir

    # Yields [path_inside_gem, source] for every .rb file in the gem.
    def each_ruby_file(name, version, platform: 'ruby', &)
      gem_path = download(name, version, platform: platform)
      package = Gem::Package.new(gem_path)
      package.gem.with_read_io do |io|
        Gem::Package::TarReader.new(io) do |tar|
          tar.each do |entry|
            next unless entry.full_name == 'data.tar.gz'

            each_ruby_entry(entry, &)
          end
        end
      end
    end

    # The full Gem::Specification (including `extensions`, which the
    # quick-index marshaled specs strip) from the gem's metadata.gz.
    # metadata.gz is the first entry in the .gem tar, so a small HTTP
    # Range request usually suffices instead of downloading the gem.
    # Parsed YAML specs are cached under data/gem_metadata/.
    def full_gemspec(name, version, platform: 'ruby')
      cache_path = File.join(metadata_cache_dir, "#{cache_basename(name, version, platform)}.yaml")

      unless File.exist?(cache_path)
        yaml = metadata_yaml(name, version, platform: platform)
        FileUtils.mkdir_p(File.dirname(cache_path))
        File.write(cache_path, yaml)
      end

      spec_from(File.read(cache_path))
    end

    def download(name, version, platform: 'ruby')
      full_path = File.join(cache_dir, "#{cache_basename(name, version, platform)}.gem")
      return full_path if File.exist?(full_path)

      body = @http.get("#{HOST}#{remote_path(name, version, platform)}")
      FileUtils.mkdir_p(cache_dir)
      File.binwrite(full_path, body)
      full_path
    end

    private

    # Cache filenames use a case-safe key; the remote path must use the
    # gem's real name.
    def cache_basename(name, version, platform) = "#{CacheKey.for(name)}-#{version_suffix(version, platform)}"

    def remote_path(name, version, platform) = "/gems/#{name}-#{version_suffix(version, platform)}.gem"

    def version_suffix(version, platform) = platform == 'ruby' ? version : "#{version}-#{platform}"

    # Gemspecs published by ancient RubyGems versions serialize
    # require_paths as [["lib"]] instead of ["lib"]. Gem::Specification
    # .from_yaml loads those fine but warns to stderr about every one,
    # which smears the fetch progress ticker. Use the same safe loader
    # from_yaml uses and normalize the field ourselves, quietly.
    def spec_from(yaml)
      Gem.load_yaml
      spec = Gem::SafeYAML.safe_load(Gem::Specification.normalize_yaml_input(yaml))
      raise "gemspec YAML did not load as a specification (got #{spec.class})" unless spec.is_a?(Gem::Specification)

      require_paths = spec.instance_variable_get(:@require_paths)
      spec.instance_variable_set(:@require_paths, require_paths.flatten) if require_paths.is_a?(Array)
      spec
    end

    def metadata_yaml(name, version, platform:)
      path = remote_path(name, version, platform)
      local_gem = File.join(cache_dir, "#{cache_basename(name, version, platform)}.gem")
      head =
        if File.exist?(local_gem)
          File.binread(local_gem, METADATA_PROBE_BYTES)
        else
          @http.get("#{HOST}#{path}", range: [0, METADATA_PROBE_BYTES - 1])
        end
      yaml = metadata_from_tar_head(head, path: path)
      return yaml if yaml

      # metadata.gz didn't fit in the ranged fetch; fall back to the full gem.
      gem_path = download(name, version, platform: platform)
      metadata_from_tar_head(File.binread(gem_path)) or raise "no metadata.gz found in #{path}"
    end

    # A .gem is a plain tar; walks entries in the given bytes looking for
    # metadata.gz. Returns its inflated YAML, or nil if the entry doesn't
    # fit within the bytes we have.
    def metadata_from_tar_head(bytes, path: nil)
      offset = 0
      while offset + 512 <= bytes.bytesize
        header = bytes.byteslice(offset, 512)
        entry_name = header[0, 100].delete("\0")
        break if entry_name.empty?

        size = header[124, 12].delete("\0").strip.to_i(8)
        if entry_name == 'metadata.gz'
          data = bytes.byteslice(offset + 512, size)
          data = @http.get("#{HOST}#{path}", range: [offset + 512, offset + 511 + size]) if data.bytesize < size && path
          return Zlib.gunzip(data) if data.bytesize == size

          return nil
        end
        offset += 512 + (((size + 511) / 512) * 512)
      end
      nil
    end

    def each_ruby_entry(data_tar_entry)
      Zlib::GzipReader.wrap(data_tar_entry) do |gzip|
        Gem::Package::TarReader.new(gzip) do |tar|
          tar.each do |entry|
            next unless entry.file? && entry.full_name.end_with?('.rb')

            yield entry.full_name, entry.read.to_s
          end
        end
      end
    end
  end
end
