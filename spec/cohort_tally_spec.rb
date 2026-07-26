# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RubyResearch::CohortTally do
  subject(:tally) { described_class.new(cohorts: cohorts) }

  let(:cohorts) do
    RubyResearch::Cohorts.new(
      client: RubyResearch::CompactIndexClient.new(cache_dir: File.join(FIXTURES_DIR, 'compact_index'))
    )
  end

  before do
    # aclize last shipped 2020, rails 2026, nokogiri (fixture) 2009.
    tally.record('aclize', %w[rescue_clause])
    tally.record('rails', %w[rescue_clause ensure_block])
    tally.record('nokogiri', %w[rescue_clause])
  end

  it 'counts how many gems in each cohort exhibit each finding' do
    expect(tally.counts['rescue_clause']).to eq('2020+' => 2, 'pre-2015' => 1)
    expect(tally.counts['ensure_block']).to eq('2020+' => 1)
  end

  it 'records the size of each cohort as the denominator' do
    expect(tally.cohort_sizes).to eq('2020+' => 2, 'pre-2015' => 1)
  end

  # The point of the class: cohorts are different sizes, so raw counts
  # mislead. ensure_block is in 1 of 2 modern gems and 0 of 1 old ones.
  it 'reports each finding as a share of its cohort' do
    expect(tally.shares['ensure_block']).to eq('2020+' => 50.0, 'pre-2015' => 0.0)
    expect(tally.shares['rescue_clause']).to eq('2020+' => 100.0, 'pre-2015' => 100.0)
  end

  it 'counts a gem once per finding however often it occurred' do
    tally.record('aclize', %w[ensure_block ensure_block])

    expect(tally.counts['ensure_block']['2020+']).to eq(2)
  end

  describe 'site composition' do
    before do
      # rails: 3 of 4 sites are rescue. nokogiri: 1 of 4.
      tally.record_sites('rails', { 'rescue_clause' => 3, 'ensure_block' => 1 })
      tally.record_sites('nokogiri', { 'rescue_clause' => 1, 'ensure_block' => 3 })
    end

    it 'reports each finding as a share of the cohort own sites' do
      expect(tally.site_composition['rescue_clause']).to eq('2020+' => 75.0, 'pre-2015' => 25.0)
      expect(tally.site_composition['ensure_block']).to eq('2020+' => 25.0, 'pre-2015' => 75.0)
    end

    it 'has columns that sum to 100% per cohort, since it is a composition' do
      totals = Hash.new(0.0)
      tally.site_composition.each_value { |row| row.each { |cohort, pct| totals[cohort] += pct } }

      expect(totals.values).to all(be_within(0.1).of(100.0))
    end
  end

  describe 'site density' do
    it 'is nil when no node counts were supplied' do
      tally.record_sites('rails', { 'rescue_clause' => 3 })

      expect(tally.site_density).to be_nil
    end

    # The property the whole class exists for: a big gem and a small gem
    # that mutate at the same rate must show the same density, even though
    # the big one has far more sites. Gem-share and raw counts both fail this.
    it 'is scale-free — unaffected by how much code a gem contains' do
      tally.record_sites('rails', { 'rescue_clause' => 100 }, total_nodes: 1_000_000)
      tally.record_sites('nokogiri', { 'rescue_clause' => 1 }, total_nodes: 10_000)

      density = tally.site_density['rescue_clause']

      expect(density['2020+']).to eq(density['pre-2015'])
      expect(density['2020+']).to eq(10.0)
    end
  end
end
