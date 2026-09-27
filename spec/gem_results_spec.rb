# frozen_string_literal: true

require 'fileutils'
require 'spec_helper'
require 'tmpdir'

RSpec.describe RubyResearch::GemResults do
  subject(:results) { described_class.new(directory: directory, inputs: inputs) }

  let(:directory) { Dir.mktmpdir }
  let(:inputs) { [File.join(FIXTURES_DIR, 'refresh', 'names')] }
  let(:far_future) { Time.now + 3600 }

  after { FileUtils.rm_rf(directory) }

  describe '#compute' do
    it 'records one result per gem, which a fresh instance reads back' do
      results.compute([%w[aclize 1.0.1], %w[nokogiri 1.3.0]], deadline: far_future) { |name, _version| name.upcase }

      expect(described_class.new(directory: directory, inputs: inputs).all).to eq(
        'aclize' => { version: '1.0.1', result: 'ACLIZE' },
        'nokogiri' => { version: '1.3.0', result: 'NOKOGIRI' }
      )
    end

    it 'records an error in place of a result, so the gem counts as done' do
      results.compute([%w[aclize 1.0.1]], deadline: far_future) { raise 'no source' }

      expect(results.all).to eq('aclize' => { version: '1.0.1', error: 'no source' })
      expect(results.done?('aclize', '1.0.1')).to be(true)
    end

    it 'takes no new gems once the deadline has passed' do
      results.compute([%w[aclize 1.0.1]], deadline: Time.now - 1) { |name, _version| name }

      expect(results.all).to eq({})
    end

    it 'splits the work across forked workers and gathers every result' do
      entries = (1..20).map { ["gem#{it}", '1.0'] }
      results.compute(entries, deadline: far_future, workers: 4) { |name, _version| name.length }

      expect(results.all.keys.sort).to eq(entries.map(&:first).sort)
    end
  end

  describe '#done?' do
    it 'is false for a gem whose recorded version is not the current one' do
      results.compute([%w[aclize 1.0.0]], deadline: far_future) { 'old' }

      expect(results.done?('aclize', '1.0.1')).to be(false)
    end
  end

  it 'starts afresh when an input changes' do
    results.compute([%w[aclize 1.0.1]], deadline: far_future) { 'before' }
    changed = described_class.new(directory: directory, inputs: [File.join(FIXTURES_DIR, 'refresh', 'versions')])

    expect(changed.all).to eq({})
  end
end
