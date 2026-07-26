# frozen_string_literal: true

module RubyResearch
  module Reports
    # Renders a CohortTally as a markdown table: one row per finding, one
    # column per cohort, each cell the share of that cohort's gems.
    #
    # Shares rather than counts, because cohorts are different sizes.
    # Compare a row against the corpus baseline printed underneath: a
    # finding whose 2020+ share is below the share of gems that are 2020+
    # is declining, above it is growing.
    module CohortTable
      def self.render(shares:, cohort_sizes:, label: 'Finding')
        return ['_No cohort data._'] if shares.empty?

        cohorts = cohort_sizes.keys
        total = cohort_sizes.values.sum
        lines = []
        lines << "| #{label} | #{cohorts.join(' | ')} |"
        lines << "|---|#{(['---'] * cohorts.size).join('|')}|"
        shares.each do |finding, row|
          lines << "| #{finding} | #{cohorts.map { "#{row[it]}%" }.join(' | ')} |"
        end
        lines << ''
        lines << "Cohort sizes: #{cohort_sizes.map { |name, size| "#{name} #{size}" }.join(', ')} " \
                 "(#{total} gems). Percentages are of the gems within each cohort, so rows are comparable " \
                 'across columns; compare a column against how large that cohort is overall.'
        lines
      end
    end
  end
end
