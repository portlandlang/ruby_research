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
  end
end
