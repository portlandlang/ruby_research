# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RubyResearch::Reports::GemReadinessExport do
  subject(:export) { described_class.new }

  describe '#row_for' do
    let(:features) do
      [
        { 'name' => 'regex', 'difference' => 'gap', 'status' => 'undecided' },
        { 'name' => 'raise-rescue', 'difference' => 'thesis', 'status' => 'decided' },
        { 'name' => 'for-in-loop', 'difference' => 'taste', 'status' => 'decided' }
      ]
    end

    it "sorts a gem's listed differences by kind and grades it by the hardest" do
      row = export.row_for(name: 'tidy', version: '1.0', downloads: 42, dependencies: 0, native: false,
                           matched: %w[for-in-loop raise-rescue], features: features)

      expect(row).to eq(name: 'tidy', version: '1.0', downloads: 42, dependencies: 0, native: false,
                        grade: 'thesis', open_questions: [], thesis: %w[raise-rescue], taste: %w[for-in-loop])
    end

    it 'grades a gem touching an open question by that' do
      row = export.row_for(name: 'wild', version: '2.0', downloads: 7, dependencies: 1, native: false,
                           matched: %w[regex], features: features)

      expect(row[:grade]).to eq('gap or undecided')
      expect(row[:open_questions]).to eq(%w[regex])
    end
  end
end
