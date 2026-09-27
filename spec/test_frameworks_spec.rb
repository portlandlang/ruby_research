# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RubyResearch::Reports::TestFrameworksAnalysis do
  subject(:analysis) do
    described_class.new(compact_index: RubyResearch::CompactIndexClient.new(cache_dir: File.join(FIXTURES_DIR,
                                                                                                 'pdx_parse',
                                                                                                 'compact_index')),
                        sources: RubyResearch::GemSourceClient.new(cache_dir: File.join(FIXTURES_DIR, 'gems')))
  end

  describe '#frameworks_in' do
    it 'names the test frameworks among development dependencies' do
      expect(analysis.frameworks_in(%w[rake rspec-core minitest])).to eq(%w[minitest rspec])
    end

    it 'answers none when no framework is listed' do
      expect(analysis.frameworks_in(%w[rake bundler])).to eq([])
    end
  end

  describe '#calls_in' do
    it 'tallies the method names a test file calls' do
      source = File.read(File.join(FIXTURES_DIR, 'test_frameworks', 'sample_test_file.rb'))

      expect(analysis.calls_in(source)).to eq('describe' => 1, 'it' => 2, 'expect' => 2, 'to' => 2, 'eq' => 2,
                                              'upcase' => 1, 'length' => 1)
    end
  end
end
