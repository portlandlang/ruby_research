# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RubyResearch::Reports::Construction do
  subject(:report) { described_class.new }

  def counts_for(source)
    counts = Hash.new(0)
    report.send(:collect, Prism.parse(source).value, counts)
    counts
  end

  describe 'initialize body classification' do
    it 'calls pure ivar assignment pure, defaults included' do
      counts = counts_for(<<~RUBY)
        class Point
          def initialize(x, y = 0)
            @x = x
            @y = y || 0
            @label = "point"
          end
        end
      RUBY

      expect(counts['init_pure']).to eq(1)
      expect(counts['init_derivation']).to eq(0)
    end

    it 'flags derivation when an ivar is computed' do
      counts = counts_for(<<~RUBY)
        class Name
          def initialize(raw)
            @name = raw.strip.downcase
          end
        end
      RUBY

      expect(counts['init_derivation']).to eq(1)
      expect(counts['init_pure']).to eq(0)
    end

    it 'flags validation wherever a raise sits' do
      counts = counts_for(<<~RUBY)
        class Age
          def initialize(years)
            raise ArgumentError, "negative" if years.negative?
            @years = years
          end
        end
      RUBY

      expect(counts['init_validation']).to eq(1)
      expect(counts['init_pure']).to eq(0)
    end

    it 'flags side effects from the IO and registration list' do
      counts = counts_for(<<~RUBY)
        class Plugin
          def initialize(name)
            @name = name
            warn "loading"
          end
        end
      RUBY

      expect(counts['init_side_effect']).to eq(1)
    end

    it 'lets a bare super ride along without disqualifying pure' do
      counts = counts_for(<<~RUBY)
        class Sub
          def initialize(x)
            super
            @x = x
          end
        end
      RUBY

      expect(counts['init_pure']).to eq(1)
      expect(counts['init_with_super']).to eq(1)
    end
  end

  describe 'signature classification' do
    it 'splits positional, keyword, and mixed' do
      counts = counts_for(<<~RUBY)
        class A; def initialize(a, b); end; end
        class B; def initialize(a:, b: 1); end; end
        class C; def initialize(a, b:); end; end
        class D; def initialize; end; end
      RUBY

      expect(counts['init_sig_positional']).to eq(1)
      expect(counts['init_sig_keyword']).to eq(1)
      expect(counts['init_sig_mixed']).to eq(1)
      expect(counts['init_sig_none']).to eq(1)
    end
  end

  describe 'construction call sites' do
    it 'splits Const.new from named constructors' do
      counts = counts_for(<<~RUBY)
        a = Point.new(1, 2)
        b = Money.from_cents(100)
        c = Pathname.of(dir)
        d = JSON.parse(text)
        e = point.new
      RUBY

      expect(counts['call_const_new']).to eq(1)
      expect(counts['call_named_constructor']).to eq(3)
    end
  end

  describe 'def self.new overrides' do
    it 'finds both spellings and whether they call super' do
      counts = counts_for(<<~RUBY)
        class Interned
          def self.new(name)
            cache[name] ||= super
          end
        end
        class Blocked
          class << self
            def new = raise NotImplementedError
          end
        end
      RUBY

      expect(counts['def_self_new']).to eq(2)
      expect(counts['def_self_new_super']).to eq(1)
    end
  end
end
