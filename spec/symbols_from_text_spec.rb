# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RubyResearch::Reports::SymbolsFromText do
  subject(:report) { described_class.new }

  def tally_of(source)
    tally = report.send(:new_tally)
    report.send(:collect, Prism.parse(source).value, tally)
    tally
  end

  describe 'constructs' do
    it 'counts every way a symbol is built from text' do
      tally = tally_of(<<~'RUBY')
        a = name.to_sym
        b = text.intern
        c = :"pre_#{name}"
        d = JSON.parse(body, symbolize_names: true)
        e = options.symbolize_keys
        f = options.deep_symbolize_keys
        g = params.transform_keys(&:to_sym)
        h = hash.with_indifferent_access
      RUBY

      expect(tally[:construct]).to eq('to_sym' => 1, 'intern' => 1, 'interpolated symbol' => 1, 'symbolize_names:' => 1,
                                      'symbolize_keys' => 1, 'deep_symbolize_keys' => 1,
                                      'transform_keys(&:to_sym)' => 1, 'with_indifferent_access' => 1)
      expect(tally[:total]).to eq(8)
    end

    it 'leaves literal symbols and ordinary calls alone' do
      expect(tally_of("a = :paid\nb = name.to_s\nc = list.transform_keys(&:to_s)\n")[:total]).to eq(0)
    end
  end

  describe 'receivers' do
    it 'tells a string literal from an assembled name from text the program did not write' do
      tally = tally_of(<<~'RUBY')
        "abc".to_sym
        "pre_#{name}".to_sym
        name.to_sym
        read.intern
      RUBY

      expect(tally[:receiver]).to eq('a string literal' => 1, 'an interpolated string' => 1, 'a variable or call' => 2)
    end
  end

  describe 'consumers' do
    it 'sees a hash key, an index, a comparison, a case, and a membership test' do
      tally = tally_of(<<~RUBY)
        { name.to_sym => 1 }
        table[name.to_sym]
        table[name.to_sym] = 2
        name.to_sym == :fast
        :fast == name.to_sym
        case kind.to_sym
        when :a then 1
        end
        allowed.include?(name.to_sym)
      RUBY

      expect(tally[:consumer]).to eq('a hash key' => 3, 'a comparison with a literal symbol' => 2,
                                     'a case subject' => 1, 'a membership test' => 1)
    end

    it 'sees the metaprogramming consumers that Portland removed regardless' do
      tally = tally_of(<<~'RUBY')
        send(name.to_sym)
        public_send(name.to_sym, 1)
        const_get(name.to_sym)
        define_method(name.to_sym) { }
        instance_variable_get(:"@#{name}")
      RUBY

      expect(tally[:consumer]).to eq('a metaprogramming call' => 5)
    end

    it 'sees a binding, another method, and a comparison with a non-literal' do
      tally = tally_of(<<~RUBY)
        key = name.to_sym
        register(name.to_sym)
        name.to_sym == other
        name.to_sym.to_s
        name.to_sym.upcase
      RUBY

      expect(tally[:consumer]).to eq('a binding' => 1, 'an argument to another method' => 1,
                                     'a comparison with a non-literal' => 1,
                                     'a receiver of to_s or to_proc' => 1, 'a receiver of another method' => 1)
    end

    it 'does not ask a consumer of the key-converting constructs' do
      tally = tally_of("x = options.symbolize_keys\n")

      expect(tally[:consumer]).to eq({})
      expect(tally[:construct]).to eq('symbolize_keys' => 1)
    end
  end
end
