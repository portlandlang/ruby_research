# frozen_string_literal: true

require 'prism'

module RubyResearch
  module Reports
    # Census of Ruby's `%` literal family, feeding Portland's ruling on which
    # members survive (portland#29).
    #
    # Like heredocs, the family is invisible in the feature-usage report:
    # Prism folds `%w[a b]` into an ordinary array node and `%q(x)` into an
    # ordinary string node, and only the opening token tells them apart. This
    # report breaks the family out along the axes the ruling turns on:
    #
    #   member     — %w %W %i %I %q %Q % %s %r %x, read off the opening
    #   delimiter  — [] {} () <> || !! // and the long tail
    #   content    — whether the body escapes or nests its own delimiter,
    #                which sizes whether %w[]'s bracket rules matter to real
    #                code or only to Portland's own compiler
    #   quotes     — for %q/%Q/%, whether the body contains a quote character,
    #                which is the one reason to reach for them over '...'/"..."
    class PercentLiterals
      MEMBERS = %w[%w %W %i %I %q %Q % %s %r %x].freeze
      STRING_MEMBERS = %w[%q %Q %].freeze
      PAIRS = { '[' => ']', '{' => '}', '(' => ')', '<' => '>' }.freeze

      def initialize(cohorts: Cohorts.new,
                     compact_index: CompactIndexClient.new,
                     reports_dir: REPORTS_DIR,
                     sample: nil,
                     seed: 42,
                     sources: GemSourceClient.new)
        @cohorts = cohorts
        @compact_index = compact_index
        @reports_dir = reports_dir
        @sample = sample
        @seed = seed
        @sources = sources
      end

      def run
        totals = new_tally
        gems_by_member = Hash.new(0)
        gems_by_delimiter = Hash.new(0)
        literals_per_gem = {}
        analyzed = 0
        errors = []
        names = selected_names

        tally = CohortTally.new(cohorts: @cohorts)
        progress = Progress.new(label: 'percent-literals')
        names.each_with_index do |name, index|
          progress.tick(index + 1, names.size)
          gem_tally = tally_for(name)
          next if gem_tally.nil?

          analyzed += 1
          literals_per_gem[name] = gem_tally[:total] if gem_tally[:total].positive?
          # Only gems that write at least one member form the era denominator;
          # the gems that use none would drown the signal.
          if gem_tally[:total].positive?
            tally.record(name, gem_tally[:member].keys)
            tally.record_sites(name, gem_tally[:member], total_nodes: gem_tally[:nodes])
          end
          gem_tally[:member].each_key { gems_by_member[it] += 1 }
          gem_tally[:delimiter].each_key { gems_by_delimiter[it] += 1 }
          merge_tally(totals, gem_tally)
        rescue StandardError => e
          errors << { gem: name, error: e.message }
        end
        progress.finish

        ranked = literals_per_gem.sort_by { |_name, count| -count }
        data = {
          corpus_size: @compact_index.names.size,
          sampled: @sample,
          analyzed: analyzed,
          errors: errors,
          gems_with_literals: literals_per_gem.size,
          total_literals: totals[:total],
          top_gems_by_literal_count: ranked.first(10).to_h,
          top_5_gems_share_of_sites: share(ranked.first(5).sum { it[1] }, totals[:total]),
          member: sort_by_count(totals[:member]),
          gems_by_member: sort_by_count(gems_by_member),
          delimiter: sort_by_count(totals[:delimiter]),
          gems_by_delimiter: sort_by_count(gems_by_delimiter),
          delimiter_by_member: totals[:delimiter_by_member].transform_values { sort_by_count(it) },
          escaped_delimiter: sort_by_count(totals[:escaped_delimiter]),
          nested_delimiter: sort_by_count(totals[:nested_delimiter]),
          quotes_in_string_members: sort_by_count(totals[:quotes]),
          cohort_sizes: tally.cohort_sizes,
          share_by_era: tally.shares,
          site_totals_by_era: tally.site_totals,
          composition_by_era: tally.site_composition,
          node_totals_by_era: tally.node_totals,
          density_by_era: tally.site_density
        }
        writer = ReportWriter.new(name: 'percent_literals', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data))
      end

      private

      def new_tally
        {
          delimiter: Hash.new(0),
          delimiter_by_member: Hash.new { |hash, key| hash[key] = Hash.new(0) },
          escaped_delimiter: Hash.new(0),
          member: Hash.new(0),
          nested_delimiter: Hash.new(0),
          nodes: 0,
          quotes: Hash.new(0),
          total: 0
        }
      end

      def merge_tally(totals, gem_tally)
        totals[:nodes] += gem_tally[:nodes]
        totals[:total] += gem_tally[:total]
        %i[delimiter escaped_delimiter member nested_delimiter quotes].each do |key|
          gem_tally[key].each { |bucket, count| totals[key][bucket] += count }
        end
        gem_tally[:delimiter_by_member].each do |member, delimiters|
          delimiters.each { |delimiter, count| totals[:delimiter_by_member][member][delimiter] += count }
        end
      end

      def sort_by_count(tally) = tally.sort_by { |_key, count| -count }.to_h

      def selected_names
        names = @compact_index.names
        return names unless @sample

        names.sample(@sample, random: Random.new(@seed))
      end

      def tally_for(name)
        versions = @compact_index.versions_of(name)
        latest = versions.rfind { it[:platform] == 'ruby' } || versions.last
        return nil unless latest

        tally = new_tally
        @sources.each_ruby_file(name, latest[:version], platform: latest[:platform]) do |_path, source|
          result = Prism.parse(source)
          tally[:nodes] += collect(result.value, tally) if result.success?
        end
        tally
      end

      # Returns the number of nodes visited, for the density denominator.
      def collect(root, tally)
        visited = 0
        queue = [root]

        until queue.empty?
          visited += 1
          node = queue.pop
          classify(node, tally) if percent_literal?(node)
          queue.concat(node.compact_child_nodes)
        end

        visited
      end

      # Only the outermost literal carries the `%` opening: the words inside a
      # `%w[]` are string nodes with no opening of their own.
      def percent_literal?(node)
        node.respond_to?(:opening) && node.opening.to_s.start_with?('%')
      end

      def classify(node, tally)
        opening = node.opening
        member = member_of(opening)
        delimiter = delimiter_of(opening)
        tally[:total] += 1
        tally[:member][member] += 1
        tally[:delimiter][delimiter] += 1
        tally[:delimiter_by_member][member][delimiter] += 1

        content = node.slice[opening.length...-node.closing.to_s.length].to_s
        closing = PAIRS.fetch(opening[-1], opening[-1])
        tally[:escaped_delimiter][member] += 1 if content.include?("\\#{closing}") || content.include?("\\#{opening[-1]}")
        unescaped = content.gsub("\\#{opening[-1]}", '')
        tally[:nested_delimiter][member] += 1 if PAIRS.key?(opening[-1]) && unescaped.include?(opening[-1])
        tally[:quotes][quotes_in(content)] += 1 if STRING_MEMBERS.include?(member)
      end

      # `%w[` -> "%w", `%(` -> "%" (the bare form, same as %Q).
      def member_of(opening)
        letter = opening[1]
        letter.match?(/[A-Za-z]/) ? "%#{letter}" : '%'
      end

      def delimiter_of(opening)
        open = opening[-1]
        PAIRS.key?(open) ? "#{open}#{PAIRS[open]}" : "#{open}#{open}"
      end

      def quotes_in(content)
        double = content.include?('"')
        single = content.include?("'")
        return 'both quote characters' if double && single
        return 'a double quote' if double
        return 'a single quote' if single

        'no quote character'
      end

      def markdown_for(data)
        lines = []
        lines << '# `%` literal census across RubyGems.org'
        lines << ''
        scope = Scope.describe(sampled: data[:sampled], analyzed: data[:analyzed])
        lines << "Based on #{scope}, out of #{data[:corpus_size]} on RubyGems.org."
        lines << ''
        percent = data[:analyzed].zero? ? 0 : (data[:gems_with_literals] * 100.0 / data[:analyzed]).round(1)
        lines << "**#{data[:total_literals]}** `%` literals across **#{data[:gems_with_literals]}** gems " \
                 "(#{percent}% of gems use at least one member)."
        lines << ''
        lines << "The top 5 gems hold #{data[:top_5_gems_share_of_sites]} of all sites, so prefer the per-gem columns " \
                 'over raw site counts.'
        lines << ''
        lines << '## Members'
        lines << ''
        lines << '| Member | Sites | % of sites | Gems | % of analyzed gems |'
        lines << '|---|---:|---:|---:|---:|'
        data[:member].each do |member, count|
          gems = data[:gems_by_member][member].to_i
          lines << "| `#{member}` | #{count} | #{share(count, data[:total_literals])} | #{gems} | " \
                   "#{share(gems, data[:analyzed])} |"
        end
        lines << ''
        lines << '## Delimiters'
        lines << ''
        lines << '| Delimiter | Sites | % of sites | Gems |'
        lines << '|---|---:|---:|---:|'
        data[:delimiter].each do |delimiter, count|
          lines << "| `#{delimiter}` | #{count} | #{share(count, data[:total_literals])} | " \
                   "#{data[:gems_by_delimiter][delimiter].to_i} |"
        end
        lines << ''
        lines << '### Delimiters by member'
        lines << ''
        lines << '| Member | Delimiters (sites) |'
        lines << '|---|---|'
        data[:delimiter_by_member].each do |member, delimiters|
          spelled = delimiters.map { |delimiter, count| "`#{delimiter}` #{count}" }.join(', ')
          lines << "| `#{member}` | #{spelled} |"
        end
        lines << ''
        lines << '## Content that escapes or nests its own delimiter'
        lines << ''
        lines << 'Sizes whether delimiter escapes and balanced nesting matter to real code.'
        lines << ''
        lines << '| Member | Escaped delimiter | Nested delimiter |'
        lines << '|---|---:|---:|'
        data[:member].each_key do |member|
          lines << "| `#{member}` | #{data[:escaped_delimiter][member].to_i} | #{data[:nested_delimiter][member].to_i} |"
        end
        lines << ''
        lines << '## Why `%q`, `%Q`, and bare `%` are reached for'
        lines << ''
        lines << "The one thing they buy over `'...'` and `\"...\"` is a body with quotes in it."
        lines << ''
        lines << '| Body contains | Sites | % of string-member sites |'
        lines << '|---|---:|---:|'
        string_total = data[:quotes_in_string_members].values.sum
        data[:quotes_in_string_members].each do |bucket, count|
          lines << "| #{bucket} | #{count} | #{share(count, string_total)} |"
        end
        lines << ''
        lines << '## By era'
        lines << ''
        lines << 'Share of `%`-using gems in each cohort that write each member.'
        lines << ''
        lines.concat(CohortTable.render(shares: data[:share_by_era], cohort_sizes: data[:cohort_sizes], label: 'Member'))
        lines << ''
        lines << '### Composition of sites'
        lines << ''
        lines.concat(CohortTable.composition(composition: data[:composition_by_era],
                                             site_totals: data[:site_totals_by_era],
                                             label: 'Member'))
        lines << ''
        lines << '### Density'
        lines << ''
        lines.concat(CohortTable.density(density: data[:density_by_era],
                                         node_totals: data[:node_totals_by_era],
                                         label: 'Member'))
        lines << ''
        lines << '## Gems with the most `%` literals'
        lines << ''
        lines << '| Gem | Sites |'
        lines << '|---|---:|'
        data[:top_gems_by_literal_count].each { |gem, count| lines << "| #{gem} | #{count} |" }
        lines << ''
        lines << "Errors: #{data[:errors].size}"

        lines.join("\n")
      end

      def share(count, total) = total.zero? ? '0%' : "#{(count * 100.0 / total).round(1)}%"
    end
  end
end
