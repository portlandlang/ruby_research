# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RubyResearch::Reports::FirstGemCandidates do
  subject(:report) { described_class.new }

  describe '#funnel' do
    let(:facts) do
      {
        'parses_and_passes' => { parses: true, runtime_dependencies: 0, native: false, open_questions: [],
                                 test_files: 3 },
        'no_tests' => { parses: true, runtime_dependencies: 0, native: false, open_questions: [], test_files: 0 },
        'open' => { parses: true, runtime_dependencies: 0, native: false, open_questions: %w[regex], test_files: 2 },
        'native' => { parses: true, runtime_dependencies: 0, native: true, open_questions: [], test_files: 2 },
        'deps' => { parses: true, runtime_dependencies: 2, native: false, open_questions: [], test_files: 2 },
        'broken' => { parses: false, runtime_dependencies: 0, native: false, open_questions: [], test_files: 2 }
      }
    end

    it 'narrows stage by stage, counting the gems left after each' do
      stages = report.funnel(facts)

      expect(stages.map { [it[:stage], it[:gems].size] }).to eq(
        [
          ['every lib/ file parses under pdx', 5],
          ['no runtime dependencies', 4],
          ['pure Ruby, no C extension', 3],
          ['no open question (gap or undecided)', 2],
          ['ships its own tests', 1]
        ]
      )
      expect(stages.last[:gems]).to eq(%w[parses_and_passes])
    end
  end
end
