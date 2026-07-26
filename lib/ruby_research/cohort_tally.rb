# frozen_string_literal: true

module RubyResearch
  # Counts how many gems in each cohort exhibit each finding, and — more
  # usefully — what share of that cohort they are.
  #
  # Raw per-cohort counts are not comparable: the pre-2015 cohort is far
  # larger than the 2020+ one, so a construct will "look" more common in old
  # gems simply because there are more of them. Share within the cohort is
  # the number that answers "is this growing or dying?".
  class CohortTally
    def initialize(cohorts: Cohorts.new, dimension: :era)
      @keys = cohorts.by_gem
      @dimension = dimension
      @per_finding = Hash.new { |hash, key| hash[key] = Hash.new(0) }
      @cohort_sizes = Hash.new(0)
    end

    # findings: the names of everything this gem exhibited, counted once
    # each however many times it occurred.
    def record(gem_name, findings)
      cohort = @keys.dig(gem_name, @dimension) || 'unknown'
      @cohort_sizes[cohort] += 1
      findings.uniq.each { @per_finding[it][cohort] += 1 }
    end

    def cohort_sizes = @cohort_sizes.sort.to_h

    def counts = @per_finding.transform_values { it.sort.to_h }.sort.to_h

    # { finding => { cohort => percent of that cohort's gems } }
    def shares
      @per_finding.transform_values { |counts| share_row(counts) }.sort.to_h
    end

    private

    def share_row(counts)
      @cohort_sizes.keys.sort.to_h do |cohort|
        size = @cohort_sizes[cohort]
        [cohort, size.zero? ? 0.0 : (counts[cohort] * 100.0 / size).round(1)]
      end
    end
  end
end
