# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RubyResearch::Reports::CohortTable do
  let(:rows) do
    { 'accumulator' => { '2020+' => 37.0, 'pre-2015' => 32.9 } }
  end

  describe '.render' do
    it 'renders gem shares with a cohort-size footer' do
      lines = described_class.render(shares: rows, cohort_sizes: { '2020+' => 2, 'pre-2015' => 1 })

      expect(lines.first).to eq('| Finding | 2020+ | pre-2015 |')
      expect(lines).to include('| accumulator | 37.0% | 32.9% |')
      expect(lines.last).to start_with('Cohort sizes: 2020+ 2, pre-2015 1 (3 gems).')
    end
  end

  describe '.composition' do
    it 'labels its denominator as sites, not gems' do
      lines = described_class.composition(composition: rows, site_totals: { '2020+' => 40, 'pre-2015' => 60 })

      expect(lines.last).to start_with('Sites per cohort: 2020+ 40, pre-2015 60 (100 sites).')
      expect(lines.last).to include('sums to 100%')
    end
  end

  describe '.density' do
    it 'renders without a percent sign, since it is a rate not a share' do
      lines = described_class.density(density: rows, node_totals: { '2020+' => 1000, 'pre-2015' => 2000 })

      expect(lines).to include('| accumulator | 37.0 | 32.9 |')
      expect(lines.last).to include('per 100,000 AST nodes')
    end

    it 'says so plainly when the report cannot count nodes' do
      expect(described_class.density(density: nil, node_totals: {})).to eq(
        ['_No density data — this report does not count AST nodes._']
      )
    end
  end

  it 'handles an empty tally without blowing up' do
    expect(described_class.render(shares: {}, cohort_sizes: {})).to eq(['_No cohort data._'])
  end
end
