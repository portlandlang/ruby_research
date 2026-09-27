# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RubyResearch::Reports::PortlandCompatibility do
  subject(:report) { described_class.new }

  def usage_of(source)
    usage = { node_types: Set.new, method_names: Set.new, constant_names: Set.new }
    report.send(:collect, Prism.parse(source).value, usage)
    usage
  end

  def features_in(source)
    usage = usage_of(source)
    report.send(:detectable_features).select { report.send(:feature_used?, it, usage) }.map { it['name'] }
  end

  describe 'the removals list' do
    it 'tags every feature with a difference, a status, and an owner' do
      features = report.send(:features)

      expect(features.map { it['difference'] }.uniq.sort).to eq(%w[gap taste thesis])
      expect(features.map { it['status'] }.uniq.sort).to eq(%w[decided undecided])
      expect(features.reject { it['owner'] }).to eq([])
    end
  end

  describe 'detection' do
    # Prism gives every class one node type, so the report marks the
    # inheriting ones itself.
    it 'tells an inheriting class from a plain one' do
      expect(features_in("class Token < Node\nend\n")).to eq(%w[inheritance])
      expect(features_in("class Token\nend\n")).to eq([])
    end

    it 'separates instance-variable reads from writes' do
      expect(features_in("def text = @text\n")).to eq(%w[instance-variable-reads])
      expect(features_in("def bump\n  @count += 1\nend\n")).to eq(%w[instance-variable-writes])
    end
  end

  describe 'grading a gem' do
    def grade(*names) = report.send(:grade, names)

    it 'grades a gem by the hardest difference it touches' do
      expect(grade).to eq('runs as is')
      expect(grade('for-in-loop', 'fetch-retired')).to eq('taste only')
      expect(grade('for-in-loop', 'raise-rescue')).to eq('thesis')
      expect(grade('raise-rescue', 'regex')).to eq('gap or undecided')
    end

    it 'counts an undecided taste difference as undecided' do
      expect(grade('bitwise-operators')).to eq('gap or undecided')
    end
  end
end
