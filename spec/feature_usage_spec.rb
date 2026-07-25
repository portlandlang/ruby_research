# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RubyResearch::Reports::FeatureUsage do
  subject(:report) { described_class.new }

  describe 'Prism node type names' do
    # Deriving these by snake-casing the class name silently mangles
    # acronyms — XStringNode became "xstring_node", so backtick literals
    # looked unused across the whole corpus while also being counted.
    it 'matches the type symbol Prism itself reports' do
      expect(report.send(:prism_node_type, :XStringNode)).to eq('x_string_node')
      expect(report.send(:prism_node_type, :InterpolatedXStringNode)).to eq('interpolated_x_string_node')
      expect(report.send(:prism_node_type, :DefNode)).to eq('def_node')
    end

    it 'covers every node type a parse can produce' do
      known = Prism.constants.grep(/Node\z/).filter_map { report.send(:prism_node_type, it) }
      observed = Prism.parse('`ls`; a = <<~X
        hi
      X
      ').value.compact_child_nodes.flat_map { [it.type.to_s] }

      expect(known).to include(*observed)
    end
  end
end
