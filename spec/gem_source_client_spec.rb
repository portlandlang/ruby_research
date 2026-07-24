# frozen_string_literal: true

require 'spec_helper'
require 'tmpdir'

RSpec.describe RubyResearch::GemSourceClient do
  subject(:client) do
    described_class.new(
      cache_dir: File.join(FIXTURES_DIR, 'gems'),
      metadata_cache_dir: Dir.mktmpdir
    )
  end

  describe '#each_ruby_file' do
    it 'yields every .rb file inside the cached gem' do
      files = {}
      client.each_ruby_file('digu', '0.3') { |path, source| files[path] = source }

      expect(files.keys).to all(end_with('.rb'))
      expect(files).not_to be_empty
    end
  end

  describe '#full_gemspec' do
    it 'reads the full spec, including fields the quick index strips, from the local gem' do
      spec = client.full_gemspec('digu', '0.3')

      expect(spec.name).to eq('digu')
      expect(spec.version.to_s).to eq('0.3')
      expect(spec.extensions).to eq([])
    end

    # Gemspecs from ancient RubyGems versions store require_paths as
    # [["lib"]]; RubyGems loads them but warns to stderr about each one,
    # which would smear the fetch progress ticker.
    it 'loads a legacy gemspec with nested require_paths without warning' do
      legacy_client = described_class.new(
        cache_dir: File.join(FIXTURES_DIR, 'gems'),
        metadata_cache_dir: File.join(FIXTURES_DIR, 'gem_metadata')
      )

      spec = nil
      expect { spec = legacy_client.full_gemspec('booru', '0.0.1') }.not_to output.to_stderr

      expect(spec.name).to eq('booru')
      expect(spec.require_paths).to eq(['lib'])
      expect(spec.extensions).to eq([])
    end
  end
end
