# frozen_string_literal: true

require 'rbconfig'
require 'spec_helper'

RSpec.describe RubyResearch::Reports::PdxParseAnalysis do
  subject(:analysis) do
    described_class.new(compact_index: compact_index,
                        pdx: [RbConfig.ruby, File.join(FIXTURES_DIR, 'bin', 'pdx')],
                        sources: RubyResearch::GemSourceClient.new(cache_dir: File.join(FIXTURES_DIR, 'gems')))
  end

  let(:compact_index) do
    RubyResearch::CompactIndexClient.new(cache_dir: File.join(FIXTURES_DIR, 'pdx_parse', 'compact_index'))
  end

  describe '#result_for' do
    it "parses every lib file of the gem's latest version and records each refusal's shape" do
      expect(analysis.result_for('digu')).to eq(
        files: 1,
        failed: 1,
        shapes: { "'…' is an instance variable, which Portland does not have — a field is read by its bare name, '…'" => 1 },
        # The stand-in pdx takes the first `@` word, here from an email
        # address in a comment; the real parser skips comments.
        first_refusal: "lib/digu.rb: '@gmail' is an instance variable, which Portland does not have — " \
                       "a field is read by its bare name, 'gmail'"
      )
    end

    it 'answers nil for a gem with no release' do
      expect(analysis.result_for('ghost')).to be_nil
    end
  end

  describe '#shape_of' do
    it 'folds the particulars out of a refusal so the same refusal ranks as one' do
      expect(analysis.shape_of("'class A < ::Engine' inherits — move ::Engine's shared methods into a trait and " \
                               "'include' it")).to eq(
                                 "'…' inherits — move X's shared methods into a trait and '…' it"
                               )
      expect(analysis.shape_of("'@id' is an instance variable — read 'id'")).to eq("'…' is an instance variable — read '…'")
      expect(analysis.shape_of('unexpected token Token { leading_space: true, kind: Equal, text: "=" }')).to eq(
        'unexpected token Equal'
      )
    end

    # Which character a lexer refused is the finding, so short quoted
    # spans stay.
    it 'keeps a quoted character or two' do
      expect(analysis.shape_of("unexpected character '$' at byte 1041")).to eq("unexpected character '$' at byte N")
      expect(analysis.shape_of('expected end to close struct Parser')).to eq('expected end to close struct X')
    end
  end
end
