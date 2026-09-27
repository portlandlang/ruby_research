# frozen_string_literal: true

require 'fileutils'

module RubyResearch
  # Keeps the corpus at one version per gem. After a refresh, a gem with a
  # new release has its old .gem and gemspec beside the new ones, and a gem
  # rubygems.org no longer lists still has all of its files. Reports only
  # ever read each listed gem's latest version (CompactIndexClient
  # #latest_version_of), so everything else here is dead weight.
  class CorpusPrune
    def initialize(compact_index:, sources:)
      @compact_index = compact_index
      @sources = sources
    end

    def stale_files
      @stale_files ||= cached_files.reject { kept_files.include?(it) }
    end

    # Deletes the stale files and answers how many bytes that freed.
    def apply
      stale_files.sum do |path|
        size = File.size(path)
        FileUtils.rm_f(path)
        size
      end
    end

    private

    def cached_files
      Dir.glob(File.join(@sources.cache_dir, '*.gem')) +
        Dir.glob(File.join(@sources.metadata_cache_dir, '*.yaml')) +
        Dir.glob(File.join(@compact_index.cache_dir, 'info', '*'))
    end

    def kept_files
      @kept_files ||= begin
        uncached = @compact_index.names.reject { @compact_index.cached?(it) }
        if uncached.any?
          raise "#{uncached.size} listed #{uncached.one? ? 'gem has' : 'gems have'} no cached version list " \
                '— run script/fetch index first'
        end

        latest_files
      end
    end

    def latest_files
      @compact_index.names.each_with_object(Set.new) do |name, kept|
        kept << File.join(@compact_index.cache_dir, @compact_index.info_cache_file(name))
        latest = @compact_index.latest_version_of(name)
        next unless latest

        kept << @sources.gem_path(name, latest[:version], platform: latest[:platform])
        kept << @sources.metadata_path(name, latest[:version], platform: latest[:platform])
      end
    end
  end
end
