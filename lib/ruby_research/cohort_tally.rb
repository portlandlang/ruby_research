# frozen_string_literal: true

module RubyResearch
  # Breaks findings down by cohort, three ways. Each answers a different
  # question, and mixing them up produces wrong conclusions.
  #
  #   shares            — % of GEMS in the cohort exhibiting the finding.
  #                       "How many maintainers have adopted this?"
  #   site_composition  — % of the cohort's SITES that are this finding.
  #                       "Of the code of this kind, how much is this?"
  #                       Scale-free: unaffected by how big gems are.
  #   site_density      — sites per 100k AST nodes.
  #                       "How much of this per unit of code?"
  #
  # The distinction matters. Slicing mutation shapes by dependent count,
  # every shape rose monotonically with dependents — but only because
  # widely-depended-on gems contain more code, so they exhibit more of
  # everything. Gem-share cannot tell "popular gems mutate differently"
  # from "popular gems are bigger"; composition and density can.
  #
  # Raw counts are never comparable across cohorts, since the cohorts are
  # different sizes (pre-2015 holds 75,117 gems, 2020+ holds 57,101).
  class CohortTally
    NODES_PER_DENSITY_UNIT = 100_000

    def initialize(cohorts: Cohorts.new, dimension: :era)
      @keys = cohorts.by_gem
      @dimension = dimension
      @per_finding = Hash.new { |hash, key| hash[key] = Hash.new(0) }
      @cohort_sizes = Hash.new(0)
      @sites_per_finding = Hash.new { |hash, key| hash[key] = Hash.new(0) }
      @sites_per_cohort = Hash.new(0)
      @nodes_per_cohort = Hash.new(0)
    end

    # findings: the names of everything this gem exhibited, counted once
    # each however many times it occurred.
    def record(gem_name, findings)
      @cohort_sizes[cohort_for(gem_name)] += 1
      findings.uniq.each { @per_finding[it][cohort_for(gem_name)] += 1 }
    end

    # counts: { finding => number of sites in this gem }.
    # total_nodes: AST nodes walked in this gem, the density denominator.
    # Pass nil when the report cannot count nodes; density is then omitted
    # rather than silently wrong.
    def record_sites(gem_name, counts, total_nodes: nil)
      cohort = cohort_for(gem_name)
      counts.each do |finding, count|
        next unless count.positive?

        @sites_per_finding[finding][cohort] += count
        @sites_per_cohort[cohort] += count
      end
      @nodes_per_cohort[cohort] += total_nodes if total_nodes
    end

    def cohort_sizes = @cohort_sizes.sort.to_h
    def site_totals = @sites_per_cohort.sort.to_h
    def node_totals = @nodes_per_cohort.sort.to_h

    def counts = @per_finding.transform_values { it.sort.to_h }.sort.to_h
    def site_counts = @sites_per_finding.transform_values { it.sort.to_h }.sort.to_h

    # { finding => { cohort => % of that cohort's gems } }
    def shares = @per_finding.transform_values { normalize(it, @cohort_sizes) }.sort.to_h

    # { finding => { cohort => % of that cohort's sites } }. Columns sum to
    # 100% across findings, so this describes composition, not prevalence.
    def site_composition = @sites_per_finding.transform_values { normalize(it, @sites_per_cohort) }.sort.to_h

    # { finding => { cohort => sites per 100k AST nodes } }, or nil when no
    # node counts were supplied.
    def site_density
      return nil if @nodes_per_cohort.empty?

      @sites_per_finding.transform_values { |counts| density_row(counts) }.sort.to_h
    end

    private

    def cohort_for(gem_name) = @keys.dig(gem_name, @dimension) || 'unknown'

    def normalize(counts, totals)
      totals.keys.sort.to_h do |cohort|
        total = totals[cohort]
        [cohort, total.zero? ? 0.0 : (counts[cohort] * 100.0 / total).round(1)]
      end
    end

    def density_row(counts)
      @nodes_per_cohort.keys.sort.to_h do |cohort|
        nodes = @nodes_per_cohort[cohort]
        rate = nodes.zero? ? 0.0 : counts[cohort] * NODES_PER_DENSITY_UNIT.to_f / nodes
        [cohort, rate.round(1)]
      end
    end
  end
end
