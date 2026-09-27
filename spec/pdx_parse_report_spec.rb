# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RubyResearch::Reports::PdxParse do
  subject(:report) { described_class.new }

  describe '#summarize' do
    let(:recorded) do
      {
        'clean' => { version: '1.0-ruby', result: { files: 2, failed: 0, shapes: {}, first_refusal: nil } },
        'empty' => { version: '1.0-ruby', result: { files: 0, failed: 0, shapes: {}, first_refusal: nil } },
        'ivars' => { version: '1.0-ruby', result: { files: 3, failed: 2, shapes: { ivar: 2 }, first_refusal: 'x' } },
        'mixed' => { version: '1.0-ruby', result: { files: 4, failed: 3, shapes: { ivar: 1, rescue: 2 },
                                                    first_refusal: 'y' } },
        'broken' => { version: '1.0-ruby', error: 'pdx --parse ran past 60s' },
        'none' => { version: '1.0-ruby', result: nil }
      }
    end

    it 'counts gems and files that parse, and ranks refusal shapes by the gems they appear in' do
      summary = report.summarize(recorded)

      expect(summary.slice(:gems_with_lib_files, :gems_parsing, :gems_without_lib_files, :files, :files_failing))
        .to eq(gems_with_lib_files: 3, gems_parsing: 1, gems_without_lib_files: 1, files: 9, files_failing: 5)
      expect(summary[:shapes]).to eq('ivar' => { gems: 2, files: 3, only_shape_for: 1 },
                                     'rescue' => { gems: 1, files: 2, only_shape_for: 0 })
      expect(summary[:errors]).to eq([{ gem: 'broken', error: 'pdx --parse ran past 60s' }])
    end
  end
end
