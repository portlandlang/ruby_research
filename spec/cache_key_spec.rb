# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RubyResearch::CacheKey do
  describe '.for' do
    it 'leaves an all-lowercase name untouched, so existing caches stay valid' do
      expect(described_class.for('nokogiri')).to eq('nokogiri')
      expect(described_class.for('active_record-pool')).to eq('active_record-pool')
    end

    it 'leaves a name with no letters untouched' do
      expect(described_class.for('_')).to eq('_')
    end

    it 'suffixes a name carrying uppercase' do
      expect(described_class.for('CnpOnline')).to start_with('CnpOnline@')
    end

    # The bug this guards: macOS folds case, so these two real gems shared
    # one cache file and one silently served the other's data.
    it 'gives names that differ only in case distinct keys, even case-folded' do
      upper = described_class.for('CnpOnline')
      lower = described_class.for('cnponline')

      expect(upper.downcase).not_to eq(lower.downcase)
    end

    it 'separates with a character that is not legal in a gem name' do
      expect(described_class::SEPARATOR).to eq('@')
      expect(described_class.for('Foo')).to match(/\AFoo@[0-9a-f]{8}\z/)
    end
  end
end
