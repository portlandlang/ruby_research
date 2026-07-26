# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RubyResearch::Cohorts do
  subject(:cohorts) do
    described_class.new(client: RubyResearch::CompactIndexClient.new(cache_dir: File.join(FIXTURES_DIR, 'compact_index')))
  end

  describe '#by_gem' do
    it 'assigns an era from the last release year' do
      # aclize's last release is 2020-05-22, nokogiri's fixture is 2009.
      expect(cohorts.by_gem['aclize'][:era]).to eq('2020+')
      expect(cohorts.by_gem['aclize'][:last_release_year]).to eq('2020')
      expect(cohorts.by_gem['nokogiri'][:era]).to eq('pre-2015')
    end

    it 'reports unspecified when no minimum ruby is declared' do
      expect(cohorts.by_gem['aclize'][:minimum_ruby]).to eq('unspecified')
    end

    it 'buckets gems by how many gems depend on them' do
      # Nothing in this fixture corpus depends on aclize.
      expect(cohorts.by_gem['aclize'][:dependents]).to eq('0')
    end

    it 'reads the declared minimum ruby version when there is one' do
      expect(cohorts.by_gem['rails'][:minimum_ruby]).to eq('3.2')
    end

    it 'covers every gem in the index' do
      expect(cohorts.by_gem.keys).to match_array(%w[aclize nokogiri rails])
    end
  end
end
