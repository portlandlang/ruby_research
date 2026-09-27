# frozen_string_literal: true

require 'digest'
require 'fileutils'
require 'json'

module RubyResearch
  # A report's per-gem answers, kept on disk so a full-corpus run can stop
  # and resume. A full source report is over two hours of CPU; with this, a
  # run takes as many gems as its time budget allows, across forked
  # workers, and the next run starts where it stopped.
  #
  # Results live under directory/<inputs digest>/ as JSON lines, one part
  # file per worker. The digest covers the report's own source and config,
  # so changing either starts afresh. Each line records the gem's version,
  # so a gem with a new release is analyzed again.
  class GemResults
    def initialize(directory:, inputs:)
      digest = Digest::SHA256.hexdigest(inputs.map { File.read(it) }.join("\0"))[0, 16]
      @directory = File.join(directory, digest)
    end

    # Every recorded gem: { name => { version:, result: } }, or
    # { version:, error: } where analyzing it raised.
    def all
      Dir.glob(File.join(@directory, '*.jsonl')).each_with_object({}) do |path, recorded|
        File.foreach(path) do |line|
          entry = JSON.parse(line, symbolize_names: true)
          recorded[entry[:gem]] = entry.except(:gem)
        end
      end
    end

    def done?(name, version) = recorded_versions[name] == version

    # Runs the block for each [name, version] pair, across `workers` forked
    # processes when more than one, taking no new gem after the deadline.
    def compute(entries, deadline:, workers: 1, &)
      FileUtils.mkdir_p(@directory)
      return compute_slice(entries, deadline, 'part-main', &) if workers == 1

      slices = entries.each_slice((entries.size / workers.to_f).ceil.clamp(1, nil)).to_a
      slices.each_with_index do |slice, index|
        fork do
          compute_slice(slice, deadline, "part-#{Process.pid}-#{index}", &)
          exit!(0)
        end
      end
      Process.waitall
    end

    private

    def recorded_versions = @recorded_versions ||= all.transform_values { it[:version] }

    def compute_slice(entries, deadline, part, &)
      File.open(File.join(@directory, "#{part}.jsonl"), 'a') do |file|
        entries.each do |name, version|
          break if Time.now > deadline

          file.puts(JSON.generate(entry_for(name, version, &)))
          file.flush
        end
      end
    end

    def entry_for(name, version)
      { gem: name, version: version, result: yield(name, version) }
    rescue StandardError => e
      { gem: name, version: version, error: e.message }
    end
  end
end
