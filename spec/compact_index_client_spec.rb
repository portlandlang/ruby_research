# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RubyResearch::CompactIndexClient do
  subject(:client) { described_class.new(cache_dir: File.join(FIXTURES_DIR, 'compact_index')) }

  describe '#names' do
    it 'returns gem names without the leading document marker' do
      expect(client.names).to eq(%w[aclize nokogiri rails])
    end
  end

  describe '#versions_of' do
    it 'parses versions with requirements and release timestamps' do
      versions = client.versions_of('aclize')

      expect(versions.size).to eq(6)
      expect(versions.first).to include(
        version: '0.1.0',
        platform: 'ruby',
        created_at: '2015-11-19T18:47:26Z'
      )
      expect(versions.last[:version]).to eq('1.0.1')
    end

    it 'returns nil ruby requirement when none is recorded' do
      expect(client.versions_of('aclize').first[:ruby]).to be_nil
    end
  end
end
