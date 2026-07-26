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
end
