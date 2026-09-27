# frozen_string_literal: true

require 'fileutils'
require 'tmpdir'

module RubyResearch
  module Reports
    # One gem's half of the pdx-parse report, readiness level 0: does each
    # file under the gem's lib/ parse under Portland's parser, unedited? Runs
    # portland's `pdx --parse`, which takes many files in one process and
    # prints one line per failing file with its refusal. Kept apart from the
    # report's aggregation because its answers are cached per gem
    # (GemResults), keyed on this file and on the pdx binary.
    class PdxParseAnalysis
      # Where a sibling portland checkout builds its release binary; PDX
      # overrides it.
      DEFAULT_PDX = ENV.fetch('PDX', File.expand_path('../portland/target/release/pdx', ROOT))

      # A parser that loops forever on some file would stall a worker, so a
      # gem gets this long before its pdx is killed and the gem is recorded
      # as timed out.
      TIMEOUT_SECONDS = 60

      # Keeps each pdx invocation's argument list well under the OS limit.
      FILES_PER_RUN = 500

      FAILURE_LINE = /\Apdx --parse: (?<path>.+?) does not parse: (?<refusal>.*)\z/

      def initialize(compact_index: CompactIndexClient.new, pdx: [DEFAULT_PDX], sources: GemSourceClient.new)
        @compact_index = compact_index
        @pdx = pdx
        @sources = sources
      end

      # { files:, failed:, shapes: { shape => files }, first_refusal: } for
      # the gem's latest version, or nil when it has no release.
      def result_for(name)
        latest = @compact_index.latest_version_of(name)
        return nil unless latest

        Dir.mktmpdir('pdx-parse') do |directory|
          paths = write_lib_files(name, latest, directory)
          failures = paths.each_slice(FILES_PER_RUN).flat_map { failures_in(it, directory) }
          {
            files: paths.size,
            failed: failures.size,
            shapes: failures.map { |_path, refusal| shape_of(refusal) }.tally,
            first_refusal: failures.first&.join(': ')
          }
        end
      end

      # A refusal with its particulars folded out — quoted source, token
      # dumps, byte offsets, type names, numbers — so every instance of one
      # refusal ranks as one. A quoted character or two stays: which
      # character a lexer refused is the finding.
      def shape_of(refusal)
        # A possessive's apostrophe is set aside first, so it isn't read as
        # the start of a quoted span.
        refusal.gsub(/Token \{[^}]*kind: (\w+)[^}]*\}/, '\1')
               .gsub(/[\w:]+'s\b/, "X\u0001s")
               .gsub(/'([^']*)'/) { Regexp.last_match(1).match?(/\A\W{1,2}\z/) ? it : "'…'" }
               .tr("\u0001", "'")
               .gsub(/"[^"]*"/, '"…"')
               .gsub(/\b(struct|trait|enum|module) [A-Z]\w*/, '\1 X')
               .gsub(/\b\d+\b/, 'N')
      end

      private

      def write_lib_files(name, latest, directory)
        paths = []
        @sources.each_ruby_file(name, latest[:version], platform: latest[:platform]) do |path, source|
          next unless path.start_with?('lib/') && !path.split('/').include?('..')

          full_path = File.join(directory, path)
          FileUtils.mkdir_p(File.dirname(full_path))
          File.write(full_path, source)
          paths << path
        end
        paths
      end

      # [[path, refusal], ...] for the files of one pdx run that don't parse.
      def failures_in(paths, directory)
        errors_path = File.join(directory, '.pdx-errors')
        pid = Process.spawn(*@pdx, '--parse', *paths, chdir: directory, out: File::NULL, err: errors_path)
        wait_or_kill(pid)
        File.readlines(errors_path, chomp: true).filter_map do |line|
          match = FAILURE_LINE.match(line.scrub)
          [match[:path], match[:refusal]] if match
        end
      end

      def wait_or_kill(pid)
        deadline = Time.now + TIMEOUT_SECONDS
        loop do
          return if Process.wait(pid, Process::WNOHANG)

          if Time.now > deadline
            Process.kill('KILL', pid)
            Process.wait(pid)
            raise "pdx --parse ran past #{TIMEOUT_SECONDS}s"
          end
          sleep 0.01
        end
      end
    end
  end
end
