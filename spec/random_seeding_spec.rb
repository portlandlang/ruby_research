# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RubyResearch::Reports::RandomSeeding do
  subject(:report) { described_class.new }

  def tally_of(source, path: 'lib/thing.rb')
    tally = report.send(:new_tally)
    report.send(:collect, Prism.parse(source).value, tally, gem: 'thing', path: path)
    tally
  end

  describe 'constructs' do
    it 'counts the draws that name no seed' do
      tally = tally_of(<<~RUBY)
        a = rand
        b = rand(10)
        c = Kernel.rand(10)
        d = Random.rand(1.0)
        e = list.shuffle
        f = list.sample
        g = list.shuffle!
        h = Random.new
        srand
        i = Random.new_seed
        j = Random.bytes(4)
        k = Random.urandom(4)
      RUBY

      expect(tally[:construct]).to eq('rand' => 2, 'Kernel.rand' => 1, 'Random.rand' => 1, 'shuffle or sample' => 3,
                                      'Random.new with no seed' => 1, 'srand with no seed' => 1,
                                      'Random.new_seed' => 1, 'Random.bytes or urandom' => 2)
    end

    it 'counts the ways a seed is named' do
      tally = tally_of(<<~RUBY)
        srand(42)
        Kernel.srand(seed)
        Random.srand(1)
        a = Random.new(42)
        b = ::Random.new(seed)
        c = list.shuffle(random: generator)
        d = list.sample(2, random: Random.new(1))
      RUBY

      expect(tally[:construct]).to eq('srand with a seed' => 3, 'Random.new with a seed' => 3,
                                      'shuffle or sample with random:' => 2)
    end

    it 'counts a draw from a held value, the hidden generator by name, and SecureRandom apart' do
      tally = tally_of(<<~RUBY)
        a = generator.rand(10)
        b = Random.new(42).rand
        c = Random.seed
        d = Random::DEFAULT
        e = SecureRandom.hex(8)
        f = SecureRandom.rand(10)
      RUBY

      expect(tally[:construct]).to eq('rand on a held value' => 2, 'Random.new with a seed' => 1, 'Random.seed' => 1,
                                      'Random::DEFAULT' => 1, 'SecureRandom' => 2)
    end

    it 'leaves a bare shuffle, a seed that is another thing, and ordinary calls alone' do
      expect(tally_of("shuffle\nsample\nrecord.seed\nlist.sort\nRandom\n")[:total]).to eq(0)
    end
  end

  describe 'what the seed is' do
    it 'tells a number written down from one read from outside from one handed in' do
      tally = tally_of(<<~RUBY)
        srand(42)
        Random.new(1.5)
        srand(ENV["SEED"].to_i)
        Random.new(ENV.fetch("SEED", Random.new_seed).to_i)
        srand(Time.now.to_i)
        Random.new(Process.pid)
        srand($$)
        Random.new(Random.new_seed)
        srand(seed)
        Random.new(options[:seed])
      RUBY

      expect(tally[:seed]).to eq('an integer literal' => 1, 'another literal' => 1, 'the environment' => 2,
                                 'the clock, the process, or fresh entropy' => 4, 'a variable or call' => 2)
    end
  end

  describe 'what random: is handed' do
    it 'tells a generator seeded on the spot from the default from SecureRandom from a held one' do
      tally = tally_of(<<~RUBY)
        list.shuffle(random: Random.new(42))
        list.shuffle(random: Random.new)
        list.sample(random: Random)
        list.sample(random: Random::DEFAULT)
        list.shuffle(random: SecureRandom)
        list.sample(random: generator)
      RUBY

      expect(tally[:keyword]).to eq('a generator seeded on the spot' => 1, 'the default generator' => 3,
                                    'SecureRandom' => 1, 'a variable or call' => 1)
    end
  end

  describe 'places' do
    it 'reads where a file sits from its path' do
      places = {
        'lib/thing.rb' => 'the library',
        'lib/thing/spec_helpers.rb' => 'the library',
        'spec/thing_spec.rb' => 'tests',
        'test/test_thing.rb' => 'tests',
        'lib/thing/things_test.rb' => 'tests',
        'features/support/env.rb' => 'tests',
        'examples/demo.rb' => 'examples and benchmarks',
        'benchmark/speed.rb' => 'examples and benchmarks',
        'bin/thing' => 'executables and scripts',
        'script/load.rb' => 'executables and scripts',
        'Rakefile.rb' => 'elsewhere'
      }

      expect(places.keys.to_h { [it, report.send(:place_of, it)] }).to eq(places)
    end

    it 'counts seeded and unseeded sites by place, and the seed by place' do
      tally = tally_of("srand(42)\nrand\n", path: 'spec/thing_spec.rb')

      expect(tally[:place]).to eq('seeded' => { 'tests' => 1 }, 'unseeded' => { 'tests' => 1 })
      expect(tally[:seed_by_place]).to eq('an integer literal' => { 'tests' => 1 })
    end

    it 'keeps the source of a seeded site in the library as an example' do
      tally = tally_of("x = 1\ngenerator = Random.new(options[:seed])\n")

      expect(tally[:examples]).to eq([{ gem: 'thing', line: 2, path: 'lib/thing.rb',
                                        seed: 'a variable or call', source: 'Random.new(options[:seed])' }])
    end
  end

  describe 'a gem as a whole' do
    it 'says whether it seeds in the library, only outside it, or only draws' do
      library = tally_of("srand(1)\n")
      outside = tally_of("srand(1)\n", path: 'spec/thing_spec.rb')
      drawing = tally_of("rand\n")
      silent = tally_of("list.sort\n")

      profiles = [library, outside, drawing, silent].map { report.send(:profile_of, it) }

      expect(profiles).to eq(['seeds in the library', 'seeds only outside the library',
                              'draws and never seeds', nil])
    end
  end
end
