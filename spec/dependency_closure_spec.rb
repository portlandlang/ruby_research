# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RubyResearch::Reports::DependencyClosure do
  subject(:closure) { described_class.new }

  # app -> web -> rack (parses); app -> json (fails); tool -> rack; lone.
  let(:dependencies) do
    { 'app' => %w[web json], 'web' => %w[rack], 'rack' => [], 'json' => [], 'tool' => %w[rack], 'lone' => [],
      'loop_a' => %w[loop_b], 'loop_b' => %w[loop_a] }
  end
  let(:parsing) { %w[app web rack tool lone loop_a loop_b] }

  describe '#summarize' do
    it 'grades each parsing gem by its dependency closure and ranks the blockers' do
      summary = closure.summarize(dependencies: dependencies, parsing: parsing)

      expect(summary.slice(:parsing, :no_dependencies, :dependencies_all_parse, :blocked_by_a_dependency)).to eq(
        parsing: 7, no_dependencies: 2, dependencies_all_parse: 4, blocked_by_a_dependency: 1
      )
      expect(summary[:blockers]).to eq('json' => 1)
    end
  end
end
