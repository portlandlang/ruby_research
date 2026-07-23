# frozen_string_literal: true

require 'fileutils'

module RubyResearch
  # Writes a report in both human readable (Markdown) and
  # machine readable (JSON) forms.
  #
  # Each run is versioned by timestamp so change over time is visible:
  #   reports/<timestamp>/<name>.md
  #   reports/<timestamp>/<name>.json
  # and the newest copy is also mirrored to reports/latest/ for stable paths.
  class ReportWriter
    def self.run_timestamp = @run_timestamp ||= Time.now.strftime('%Y-%m-%dT%H-%M-%S')

    def initialize(name:, reports_dir: REPORTS_DIR, timestamp: self.class.run_timestamp)
      @name = name
      @reports_dir = reports_dir
      @timestamp = timestamp
    end

    attr_reader :name, :reports_dir, :timestamp

    def write(data:, markdown:)
      markdown += "\n" unless markdown.end_with?("\n")
      json = "#{JSON.pretty_generate(data)}\n"

      [run_dir, latest_dir].each do |directory|
        FileUtils.mkdir_p(directory)
        File.write(File.join(directory, "#{name}.json"), json)
        File.write(File.join(directory, "#{name}.md"), markdown)
      end

      [File.join(run_dir, "#{name}.md"), File.join(run_dir, "#{name}.json")]
    end

    def run_dir = File.join(reports_dir, timestamp)
    def latest_dir = File.join(reports_dir, 'latest')
  end
end
