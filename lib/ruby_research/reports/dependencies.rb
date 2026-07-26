# frozen_string_literal: true

module RubyResearch
  module Reports
    # The gem dependency graph, in both directions.
    #
    # Answers README's "which C extension gems are effectively required in
    # the Ruby community, because of broad usage?" and provides the
    # dependent-count cohort key other reports can slice by.
    #
    # Reads only the cached compact index, so it needs no network. Note
    # that the compact index carries **runtime dependencies only** —
    # development dependencies from the gemspec never appear — so these
    # counts describe what gems require to run, not what they build with.
    #
    # Edges come from the latest release of each gem, so this is the
    # dependency graph as it stands today rather than a historical union.
    class Dependencies
      TOP_N = 100
      FANOUT_BUCKETS = ['0', '1', '2-3', '4-6', '7-10', '11-20', '21+'].freeze

      def initialize(client: CompactIndexClient.new, reports_dir: REPORTS_DIR, sample: nil, seed: 42)
        @client = client
        @reports_dir = reports_dir
        @sample = sample
        @seed = seed
      end

      def run
        names = selected_names
        dependents = Hash.new(0)
        dependency_counts = {}
        errors = []

        progress = Progress.new(label: 'dependencies')
        names.each_with_index do |name, index|
          progress.tick(index + 1, names.size)
          dependencies = dependencies_of(name)
          next if dependencies.nil?

          dependency_counts[name] = dependencies.size
          dependencies.each { dependents[it] += 1 }
        rescue StandardError => e
          errors << { gem: name, error: e.message }
        end
        progress.finish

        analyzed = dependency_counts.size
        # Only count gems we actually analyzed: a sampled run sees edges
        # pointing at gems outside the sample, which are not ours to tally.
        depended_on = dependents.keys.count { dependency_counts.key?(it) }
        no_dependents = analyzed - depended_on
        data = {
          corpus_size: @client.names.size,
          sampled: @sample,
          analyzed: analyzed,
          errors: errors,
          dependency_kind: 'runtime only (the compact index omits development dependencies)',
          edge_count: dependency_counts.values.sum,
          distinct_gems_depended_on: dependents.keys.size,
          gems_depended_on_by_someone: depended_on,
          gems_depended_on_by_nobody: no_dependents,
          gems_with_no_dependencies: dependency_counts.values.count(&:zero?),
          most_depended_on: dependents.sort_by { |name, count| [-count, name] }.first(TOP_N).to_h,
          most_depended_on_native: most_depended_on_native(dependents),
          dependent_count_buckets: bucket(dependents.select { dependency_counts.key?(it) }.values, no_dependents),
          dependency_count_buckets: bucket(dependency_counts.values, 0)
        }
        writer = ReportWriter.new(name: 'dependencies', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data))
      end

      private

      def selected_names
        names = @client.names
        return names unless @sample

        names.sample(@sample, random: Random.new(@seed))
      end

      # Dependency names of the gem's latest release, or nil when it has
      # no releases at all.
      def dependencies_of(name)
        versions = @client.versions_of(name)
        latest = versions.rfind { it[:platform] == 'ruby' } || versions.last
        return nil unless latest

        latest[:dependencies].map { it[:name] }
      end

      # README asks which C extension gems are "effectively required in the
      # Ruby community because of broad usage". Ranking native gems by
      # dependent count answers it directly. Reads the c-extensions report
      # if it has been generated; returns nil rather than failing if not.
      def most_depended_on_native(dependents)
        native = native_gem_names
        return nil if native.nil?

        dependents.slice(*native)
                  .sort_by { |name, count| [-count, name] }
                  .first(TOP_N)
                  .to_h
      end

      def native_gem_names
        path = File.join(@reports_dir, 'latest', 'c_extensions.json')
        return nil unless File.exist?(path)

        JSON.parse(File.read(path)).fetch('native_gems').to_set { it.fetch('gem') }
      rescue StandardError
        nil
      end

      def bucket(counts, zero_padding)
        tally = Hash.new(0)
        tally['0'] = zero_padding
        counts.each { tally[bucket_for(it)] += 1 }
        FANOUT_BUCKETS.to_h { [it, tally[it]] }
      end

      def bucket_for(count)
        case count
        when 0 then '0'
        when 1 then '1'
        when 2..3 then '2-3'
        when 4..6 then '4-6'
        when 7..10 then '7-10'
        when 11..20 then '11-20'
        else '21+'
        end
      end

      def markdown_for(data)
        lines = []
        lines << '# Gem dependency graph on RubyGems.org'
        lines << ''
        scope = Scope.describe(sampled: data[:sampled], analyzed: data[:analyzed])
        lines << "Edges from the latest release of #{scope}, out of #{data[:corpus_size]} on RubyGems.org."
        lines << ''
        lines << "Dependency kind: **#{data[:dependency_kind]}**."
        lines << ''
        lines << "Edges: **#{data[:edge_count]}**. Gems depended on by at least one other gem: " \
                 "**#{data[:gems_depended_on_by_someone]}**. Gems declaring no runtime dependencies: " \
                 "**#{data[:gems_with_no_dependencies]}**."
        lines << ''
        lines << '## Most depended-on gems'
        lines << ''
        lines << '| Gem | Dependents |'
        lines << '|---|---|'
        data[:most_depended_on].each { |name, count| lines << "| #{name} | #{count} |" }
        lines << ''
        if data[:most_depended_on_native]
          lines << '## Most depended-on native (C extension) gems'
          lines << ''
          lines << 'The gems the community effectively cannot drop: native extensions that many other gems'
          lines << 'require at runtime. Cross-joined with the c-extensions report.'
          lines << ''
          lines << '| Native gem | Dependents |'
          lines << '|---|---|'
          data[:most_depended_on_native].each { |name, count| lines << "| #{name} | #{count} |" }
          lines << ''
        end
        lines << '## How many gems depend on each gem'
        lines << ''
        lines << '| Dependents | Gems |'
        lines << '|---|---|'
        data[:dependent_count_buckets].each { |bucket, count| lines << "| #{bucket} | #{count} |" }
        lines << ''
        lines << '## How many dependencies each gem declares'
        lines << ''
        lines << '| Dependencies | Gems |'
        lines << '|---|---|'
        data[:dependency_count_buckets].each { |bucket, count| lines << "| #{bucket} | #{count} |" }
        lines << ''
        lines << "Errors: #{data[:errors].size}"

        lines.join("\n")
      end
    end
  end
end
