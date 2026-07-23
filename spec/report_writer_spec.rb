# frozen_string_literal: true

require 'spec_helper'
require 'tmpdir'

RSpec.describe RubyResearch::ReportWriter do
  it 'writes timestamped and latest copies of markdown and json' do
    Dir.mktmpdir do |reports_dir|
      writer = described_class.new(name: 'example', reports_dir: reports_dir, timestamp: '2026-07-22T00-00-00')
      writer.write(data: { answer: 42 }, markdown: '# Example')

      run_json = File.join(reports_dir, '2026-07-22T00-00-00', 'example.json')
      latest_markdown = File.join(reports_dir, 'latest', 'example.md')

      expect(JSON.parse(File.read(run_json))).to eq('answer' => 42)
      expect(File.read(latest_markdown)).to eq("# Example\n")
    end
  end
end
