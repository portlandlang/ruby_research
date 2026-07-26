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

    # The dependency segment sits before the "|" and was previously
    # discarded, which hid the whole dependency graph from every report.
    it 'parses the runtime dependencies of each version' do
      expect(client.versions_of('aclize').first[:dependencies]).to eq(
        [
          { name: 'actionpack', requirement: '~> 4.0' },
          { name: 'i18n', requirement: '~> 0.7' }
        ]
      )
    end

    # Multiple constraints on one dependency are joined with "&", so a
    # comma still separates dependencies rather than splitting a requirement.
    it 'keeps multi-constraint requirements intact' do
      actionpack = client.versions_of('aclize').last[:dependencies].first

      expect(actionpack).to eq(name: 'actionpack', requirement: '< 7&>= 5.0')
    end

    it 'returns no dependencies when a version declares none' do
      expect(client.versions_of('nokogiri').first[:dependencies]).to eq([])
    end
  end
end
