# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RubyResearch::Reports::Ordering do
  subject(:report) { described_class.new }

  def tally_of(source)
    tally = report.send(:new_tally)
    report.send(:collect, Prism.parse(source).value, tally)
    tally
  end

  describe 'definitions' do
    it 'counts <=> definitions and Comparable includes' do
      tally = tally_of(<<~RUBY)
        class Version
          include Comparable
          def <=>(other) = parts <=> other.parts
        end
      RUBY

      expect(tally[:defines_spaceship]).to eq(1)
      expect(tally[:includes_comparable]).to eq(1)
      expect(tally[:body_shapes]).to eq('delegates to a part' => 1)
    end

    it 'tells the three body shapes apart' do
      tally = tally_of(<<~RUBY)
        def <=>(other) = [major, minor] <=> [other.major, other.minor]
        def <=>(other)
          return 1 if other.nil?
          age <=> other.age
        end
      RUBY

      expect(tally[:body_shapes]).to eq('compares parts as an array' => 1, 'computes' => 1)
    end

    it 'does not count the delegation inside a <=> body as an expression site' do
      tally = tally_of("def <=>(other) = age <=> other.age\n")

      expect(tally[:sites]).to eq({})
    end
  end

  describe 'call sites' do
    it 'counts the ordering calls, blocks noted' do
      tally = tally_of(<<~RUBY)
        list.sort
        list.sort { |a, b| b <=> a }
        list.sort_by { it.age }
        list.min
        list.max { |a, b| a.size <=> b.size }
        list.min_by { it.age }
        x.between?(1, 5)
        x.clamp(1, 5)
        a <=> b
      RUBY

      expect(tally[:sites]).to eq(
        'sort' => 1, 'sort with a block' => 1, 'sort_by' => 1, 'min' => 1, 'max with a block' => 1,
        'min_by' => 1, 'between?' => 1, 'clamp' => 1, '<=> in an expression' => 3
      )
    end

    it 'notices a <=> result read as an integer' do
      tally = tally_of("(a <=> b) == 0\n(a <=> b) * -1\nx = a <=> b\n")

      expect(tally[:integer_results]).to eq(2)
    end
  end
end
