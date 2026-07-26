# frozen_string_literal: true

module RubyResearch
  module Reports
    # Renders a CohortTally breakdown as a markdown table: one row per
    # finding, one column per cohort.
    #
    # Three flavors, because they answer different questions and a reader
    # who mistakes one for another will draw the wrong conclusion. Each
    # renderer states its own denominator in the footer.
    module CohortTable
      EMPTY = ['_No cohort data._'].freeze

      def self.render(shares:, cohort_sizes:, label: 'Finding')
        return EMPTY.dup if shares.empty?

        table(rows: shares, cohorts: cohort_sizes.keys, label: label, unit: '%') +
          ['', footer('Cohort sizes', cohort_sizes, 'gems') <<
               ' Cells are the share of gems in that cohort exhibiting the row, so columns are ' \
               'comparable to each other and to how large the cohort is overall.']
      end

      def self.composition(composition:, site_totals:, label: 'Finding')
        return EMPTY.dup if composition.empty?

        table(rows: composition, cohorts: site_totals.keys, label: label, unit: '%') +
          ['', footer('Sites per cohort', site_totals, 'sites') <<
               ' Cells are the share of that cohort\'s sites, so each column sums to 100%. ' \
               'This is scale-free: it says what the code is made of, not how much code there is.']
      end

      def self.density(density:, node_totals:, label: 'Finding')
        return ['_No density data — this report does not count AST nodes._'] if density.nil?
        return EMPTY.dup if density.empty?

        table(rows: density, cohorts: node_totals.keys, label: label, unit: '') +
          ['', footer('AST nodes per cohort', node_totals, 'nodes') <<
               ' Cells are sites per 100,000 AST nodes — how much of this construct per unit ' \
               'of code, independent of gem size.']
      end

      def self.table(rows:, cohorts:, label:, unit:)
        lines = ["| #{label} | #{cohorts.join(' | ')} |", "|---|#{(['---'] * cohorts.size).join('|')}|"]
        rows.each do |finding, row|
          lines << "| #{finding} | #{cohorts.map { "#{row[it]}#{unit}" }.join(' | ')} |"
        end
        lines
      end
      private_class_method :table

      def self.footer(title, totals, noun)
        "#{title}: #{totals.map { |name, size| "#{name} #{size}" }.join(', ')} (#{totals.values.sum} #{noun})."
      end
      private_class_method :footer
    end
  end
end
