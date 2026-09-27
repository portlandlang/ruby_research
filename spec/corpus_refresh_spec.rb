# frozen_string_literal: true

require 'fileutils'
require 'spec_helper'
require 'tmpdir'

RSpec.describe RubyResearch::CorpusRefresh do
  subject(:refresh) do
    described_class.new(compact_index: RubyResearch::CompactIndexClient.new(cache_dir: cache_dir),
                        names: File.read(File.join(FIXTURES_DIR, 'refresh', 'names')),
                        versions: File.read(File.join(FIXTURES_DIR, 'refresh', 'versions')))
  end

  # A copy, because applying a refresh rewrites the cache it reads.
  let(:cache_dir) { File.join(Dir.mktmpdir, 'compact_index') }

  before { FileUtils.cp_r(File.join(FIXTURES_DIR, 'compact_index'), cache_dir) }

  after { FileUtils.rm_rf(File.dirname(cache_dir)) }

  describe '#added' do
    it 'names gems rubygems.org lists that the cache has never seen' do
      expect(refresh.added).to eq(%w[newgem])
    end
  end

  describe '#removed' do
    it 'names cached gems rubygems.org no longer lists' do
      expect(refresh.removed).to eq(%w[rails])
    end
  end

  describe '#changed' do
    # The versions file appends a line per release, so a gem's last line
    # carries its current info checksum; aclize's earlier line is stale.
    it "names cached gems whose info checksum no longer matches the gem's last versions line" do
      expect(refresh.changed).to eq(%w[nokogiri])
    end
  end

  describe '#apply' do
    it 'drops the changed info files so the next read refetches them' do
      refresh.apply

      expect(File.exist?(File.join(cache_dir, 'info', 'nokogiri'))).to be(false)
      expect(File.exist?(File.join(cache_dir, 'info', 'aclize'))).to be(true)
    end

    it 'replaces the cached names with the fresh list' do
      refresh.apply

      expect(RubyResearch::CompactIndexClient.new(cache_dir: cache_dir).names).to eq(%w[aclize newgem nokogiri])
    end

    it 'leaves nothing changed when run again on the same data' do
      refresh.apply
      again = described_class.new(compact_index: RubyResearch::CompactIndexClient.new(cache_dir: cache_dir),
                                  names: File.read(File.join(FIXTURES_DIR, 'refresh', 'names')),
                                  versions: File.read(File.join(FIXTURES_DIR, 'refresh', 'versions')))

      expect([again.added, again.removed, again.changed]).to eq([[], [], []])
    end
  end
end
