# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RubyResearch::Reports::PercentLiterals do
  subject(:report) { described_class.new }

  def tally_of(source)
    tally = report.send(:new_tally)
    report.send(:collect, Prism.parse(source).value, tally)
    tally
  end

  describe 'members' do
    it 'reads each member off the opening, the bare form included' do
      tally = tally_of(<<~'RUBY')
        a = %w[rose city]
        b = %i[rose city]
        c = %q(it's "quoted")
        d = %Q{#{a}}
        e = %(bare)
        f = %s(name)
        g = %r{/path/}
        h = %x(ls)
        i = %W[#{a} b]
        j = %I[#{a} b]
      RUBY

      expect(tally[:member]).to eq('%w' => 1, '%i' => 1, '%q' => 1, '%Q' => 1, '%' => 1, '%s' => 1,
                                   '%r' => 1, '%x' => 1, '%W' => 1, '%I' => 1)
      expect(tally[:total]).to eq(10)
    end

    it 'counts the words inside a %w[] as no literal of their own' do
      expect(tally_of('%w[a b c]')[:total]).to eq(1)
    end

    it 'leaves plain strings, arrays, and heredocs alone' do
      expect(tally_of(%(x = ["a", 'b', <<~EOS]\n  body\nEOS\n))[:total]).to eq(0)
    end
  end

  describe 'delimiters' do
    it 'pairs the brackets and doubles the rest' do
      tally = tally_of("%w[a]\n%w{a}\n%w(a)\n%w<a>\n%w|a|\n%w!a!\n%r/a/\n")

      expect(tally[:delimiter]).to eq('[]' => 1, '{}' => 1, '()' => 1, '<>' => 1, '||' => 1, '!!' => 1, '//' => 1)
      expect(tally[:delimiter_by_member]['%w']['[]']).to eq(1)
    end
  end

  describe 'content' do
    it 'notices an escaped delimiter' do
      tally = tally_of('%w[a \] b]')

      expect(tally[:escaped_delimiter]).to eq('%w' => 1)
      expect(tally[:nested_delimiter]).to eq({})
    end

    it 'notices a nested delimiter' do
      tally = tally_of('%w[a [b] c]')

      expect(tally[:nested_delimiter]).to eq('%w' => 1)
      expect(tally[:escaped_delimiter]).to eq({})
    end

    it 'sorts the string members by the quotes in their body' do
      tally = tally_of(<<~RUBY)
        %q(it's)
        %Q(say "hi")
        %(it's "both")
        %q(plain)
      RUBY

      expect(tally[:quotes]).to eq('a single quote' => 1, 'a double quote' => 1, 'both quote characters' => 1,
                                   'no quote character' => 1)
    end

    it 'does not sort the array members by quotes' do
      expect(tally_of("%w[it's]")[:quotes]).to eq({})
    end
  end
end
