# frozen_string_literal: true

require 'digest'
require 'fileutils'

module RubyResearch
  # Brings the cached compact index up to rubygems.org without refetching
  # all of it. Two fresh documents drive it: /names, every gem listed today,
  # and /versions, which appends one line per release, each ending in the
  # MD5 of that gem's /info file as it stood then. A gem's last line is its
  # current checksum, so a cached info file whose digest differs is stale.
  #
  # Applying the refresh deletes the stale info files, so the next
  # versions_of refetches them, and replaces the cached names. Removed gems
  # keep their files here; pruning those is script/fetch prune's job.
  class CorpusRefresh
    def initialize(compact_index:, names:, versions:)
      @compact_index = compact_index
      @fresh_names = parse_names(names)
      @checksums = parse_versions(versions)
    end

    def added = @fresh_names - cached_names

    def removed = cached_names - @fresh_names

    def changed
      @changed ||= (@fresh_names & cached_names).select do |name|
        path = info_path(name)
        File.exist?(path) && @checksums[name] && Digest::MD5.file(path).hexdigest != @checksums[name]
      end
    end

    def apply
      changed.each { FileUtils.rm_f(info_path(it)) }
      File.write(File.join(@compact_index.cache_dir, 'names.txt'), "---\n#{@fresh_names.join("\n")}\n")
    end

    private

    def cached_names = @cached_names ||= @compact_index.names

    def info_path(name) = File.join(@compact_index.cache_dir, @compact_index.info_cache_file(name))

    def parse_names(body)
      lines = body.lines(chomp: true)
      lines.shift if lines.first == '---'
      lines
    end

    def parse_versions(body)
      lines = body.lines(chomp: true)
      lines = lines.drop(lines.index('---') + 1) if lines.include?('---')
      lines.each_with_object({}) do |line, checksums|
        name, _versions, checksum = line.split
        checksums[name] = checksum if checksum
      end
    end
  end
end
