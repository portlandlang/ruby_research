# frozen_string_literal: true

require 'prism'

module RubyResearch
  module Reports
    # One gem's half of the test-frameworks report (#13): which test
    # framework its gemspec's development dependencies name, and — where the
    # published .gem ships its tests — which methods those tests call. Feeds
    # portland#117, how a gem's own tests run on pdx: the smallest useful
    # subset of a framework is the calls its candidates actually make.
    class TestFrameworksAnalysis
      # Development dependency name => framework.
      FRAMEWORKS = {
        'bacon' => 'bacon', 'cutest' => 'cutest', 'minitest' => 'minitest', 'rspec' => 'rspec',
        'rspec-core' => 'rspec', 'rspec-expectations' => 'rspec', 'shoulda' => 'test-unit', 'test-unit' => 'test-unit'
      }.freeze

      TEST_FILE = %r{\A(test|spec)/.*(_test|_spec|/test_[^/]*)\.rb\z}

      def initialize(compact_index: CompactIndexClient.new, sources: GemSourceClient.new)
        @compact_index = compact_index
        @sources = sources
      end

      # { frameworks: [...], test_files:, calls: { name => count } }, or nil
      # for a gem with no release.
      def result_for(name)
        latest = @compact_index.latest_version_of(name)
        return nil unless latest

        spec = @sources.full_gemspec(name, latest[:version], platform: latest[:platform])
        calls = Hash.new(0)
        test_files = 0
        @sources.each_ruby_file(name, latest[:version], platform: latest[:platform]) do |path, source|
          next unless path.match?(TEST_FILE)

          test_files += 1
          calls_in(source).each { |call, count| calls[call] += count }
        end
        { frameworks: frameworks_in(spec.development_dependencies.map(&:name)), test_files: test_files, calls: calls }
      end

      def frameworks_in(dependency_names) = dependency_names.filter_map { FRAMEWORKS[it] }.uniq.sort

      # Every method name called in one test file, tallied.
      def calls_in(source)
        tally = Hash.new(0)
        result = Prism.parse(source)
        return tally unless result.success?

        queue = [result.value]
        until queue.empty?
          node = queue.pop
          tally[node.name.to_s] += 1 if node.is_a?(Prism::CallNode)
          queue.concat(node.compact_child_nodes)
        end
        tally
      end
    end
  end
end
