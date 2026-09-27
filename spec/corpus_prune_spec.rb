# frozen_string_literal: true

require 'fileutils'
require 'spec_helper'
require 'tmpdir'

RSpec.describe RubyResearch::CorpusPrune do
  subject(:prune) do
    described_class.new(compact_index: RubyResearch::CompactIndexClient.new(cache_dir: File.join(data_dir, 'compact_index')),
                        sources: RubyResearch::GemSourceClient.new(cache_dir: File.join(data_dir, 'gems'),
                                                                   metadata_cache_dir: File.join(data_dir, 'gem_metadata')))
  end

  # A copy, because pruning deletes from the cache it reads.
  let(:data_dir) { Dir.mktmpdir }

  before { FileUtils.cp_r("#{File.join(FIXTURES_DIR, 'prune')}/.", data_dir) }

  after { FileUtils.rm_rf(data_dir) }

  def remaining(directory) = Dir.children(File.join(data_dir, directory)).sort

  describe '#stale_files' do
    # aclize's latest is 1.0.1 and nokogiri's is 1.3.0; gone is no longer
    # listed at all.
    it "lists every cached file that isn't a listed gem's latest version" do
      expect(prune.stale_files.map { File.basename(it) }.sort).to eq(
        %w[aclize-0.1.0.yaml aclize-1.0.0.gem gone gone-2.2.2.gem gone-2.2.2.yaml]
      )
    end
  end

  describe '#apply' do
    it 'deletes the stale files and keeps the latest versions' do
      prune.apply

      expect([remaining('gems'), remaining('gem_metadata'), remaining('compact_index/info')]).to eq(
        [%w[aclize-1.0.1.gem nokogiri-1.3.0.gem], %w[aclize-1.0.1.yaml], %w[aclize nokogiri]]
      )
    end

    it 'answers the bytes it freed' do
      stale_bytes = prune.stale_files.sum { File.size(it) }

      expect(prune.apply).to eq(stale_bytes)
    end

    # Right after a refresh, a changed gem's version list is gone until
    # `script/fetch index` refetches it, so its latest version is unknown
    # and its files can't be told apart from stale ones.
    it 'refuses while a listed gem has no cached version list' do
      FileUtils.rm_f(File.join(data_dir, 'compact_index', 'info', 'nokogiri'))

      expect { prune.apply }.to raise_error(RuntimeError, /1 listed gem has no cached version list/)
      expect(remaining('gems')).to include('aclize-1.0.0.gem')
    end
  end
end
