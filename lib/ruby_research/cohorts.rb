# frozen_string_literal: true

module RubyResearch
  # Per-gem cohort keys, so a report can break its findings down instead of
  # only reporting corpus-wide totals.
  #
  # Corpus-wide numbers answer "what is in the corpus", which weights a gem
  # abandoned in 2009 the same as rails. Slicing answers the more useful
  # question: is a feature used by gems people still maintain?
  #
  # Every key comes from the cached compact index, so building this needs
  # no network. Downloads would be the natural fifth key but are not
  # carried by the compact index — see TODO.md.
  class Cohorts
    ERAS = ['2020+', '2015-2019', 'pre-2015', 'unknown'].freeze
    DEPENDENT_BUCKETS = ['0', '1-3', '4-10', '11-100', '100+'].freeze

    def initialize(client: CompactIndexClient.new)
      @client = client
    end

    # { gem_name => { era:, last_release_year:, minimum_ruby:, dependents: } }
    def by_gem
      @by_gem ||= build
    end

    def keys_for(gem_name) = by_gem[gem_name]

    private

    def build
      names = @client.names
      dependents = dependent_counts(names)
      progress = Progress.new(label: 'cohorts')

      keys = names.each_with_index.to_h do |name, index|
        progress.tick(index + 1, names.size)
        [name, keys_from_index(name, dependents[name])]
      rescue StandardError
        [name, blank_keys]
      end
      progress.finish
      keys
    end

    def keys_from_index(name, dependent_count)
      versions = @client.versions_of(name)
      latest = versions.last
      return blank_keys unless latest

      year = latest[:created_at]&.slice(0, 4)
      {
        era: era_for(year),
        last_release_year: year,
        minimum_ruby: minimum_ruby_for(versions),
        dependents: dependent_bucket_for(dependent_count.to_i)
      }
    end

    def blank_keys = { era: 'unknown', last_release_year: nil, minimum_ruby: 'unspecified', dependents: '0' }

    def dependent_counts(names)
      counts = Hash.new(0)
      names.each do |name|
        versions = @client.versions_of(name)
        latest = versions.rfind { it[:platform] == 'ruby' } || versions.last
        next unless latest

        latest[:dependencies].each { counts[it[:name]] += 1 }
      rescue StandardError
        next
      end
      counts
    end

    def era_for(year)
      return 'unknown' if year.nil?

      case year
      when '2020'..'2099' then '2020+'
      when '2015'..'2019' then '2015-2019'
      else 'pre-2015'
      end
    end

    # Minor-version granularity, matching the ruby-requirements report.
    def minimum_ruby_for(versions)
      requirement = versions.rfind { it[:platform] == 'ruby' }&.dig(:ruby) || versions.last[:ruby]
      return 'unspecified' if requirement.nil? || requirement.strip.empty?

      bound = requirement.split('&').map(&:strip).find { it.start_with?('>=', '~>', '=') }
      return 'unspecified' unless bound

      segments = bound.sub(/\A(>=|~>|=)\s*/, '').split('.')
      return 'unspecified' if segments.first.to_i.zero?

      segments.first(2).join('.')
    end

    def dependent_bucket_for(count)
      case count
      when 0 then '0'
      when 1..3 then '1-3'
      when 4..10 then '4-10'
      when 11..100 then '11-100'
      else '100+'
      end
    end
  end
end
