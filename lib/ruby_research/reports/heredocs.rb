# frozen_string_literal: true

require 'prism'

module RubyResearch
  module Reports
    # Census of heredoc usage, feeding Portland's heredoc design decision.
    #
    # Heredocs are invisible in the feature-usage report because Prism
    # folds them into ordinary string nodes; only the opening token
    # distinguishes them. This report breaks them out along every axis the
    # decision turns on:
    #
    #   indentation — `<<` (plain), `<<-` (dash), `<<~` (squiggly)
    #   quoting     — bare, single-quoted (literal), double-quoted,
    #                 backtick (shell execution — a heredoc that runs)
    #   interpolation — whether the body actually interpolates
    #   terminator  — EOF / SQL / HTML / RUBY / ... : what heredocs are FOR
    #   body size   — line-count distribution
    #   position    — heredoc passed as a call argument vs assigned/other
    #   stacking    — two or more heredocs opened on the same line, the
    #                 hairiest thing the grammar allows
    class Heredocs
      SIZE_BUCKETS = ['1 line', '2-5 lines', '6-20 lines', '21+ lines'].freeze

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
        gems_by_casing = Hash.new(0)
        gems_by_indentation = Hash.new(0)
        gems_by_quoting = Hash.new(0)
        heredocs_per_gem = {}
        analyzed = 0
        errors = []
        names = selected_names

        tally = CohortTally.new(cohorts: @cohorts)
        progress = Progress.new(label: 'heredocs')
        names.each_with_index do |name, index|
          progress.tick(index + 1, names.size)
          gem_tally = tally_for(name)
          next if gem_tally.nil?

          analyzed += 1
          heredocs_per_gem[name] = gem_tally[:total] if gem_tally[:total].positive?
          # Only gems that actually use a heredoc form part of the
          # denominator here; including the 84% that use none would drown
          # the signal.
          if gem_tally[:total].positive?
            tally.record(name, gem_tally[:indentation].keys + gem_tally[:quoting].keys)
            # Site tally uses indentation only. Adding quoting would count
            # each heredoc twice, and composition columns would sum to 200%.
            tally.record_sites(name, gem_tally[:indentation], total_nodes: gem_tally[:nodes])
          end
          gem_tally[:casing].each_key { gems_by_casing[it] += 1 }
          gem_tally[:indentation].each_key { gems_by_indentation[it] += 1 }
          gem_tally[:quoting].each_key { gems_by_quoting[it] += 1 }
          merge_tally(totals, gem_tally)
        rescue StandardError => e
          errors << { gem: name, error: e.message }
        end
        progress.finish

        ranked = heredocs_per_gem.sort_by { |_name, count| -count }
        data = {
          corpus_size: @compact_index.names.size,
          sampled: @sample,
          analyzed: analyzed,
          errors: errors,
          gems_with_heredocs: heredocs_per_gem.size,
          total_heredocs: totals[:total],
          top_gems_by_heredoc_count: ranked.first(10).to_h,
          top_5_gems_share_of_sites: share(ranked.first(5).sum { it[1] }, totals[:total]),
          casing: sort_by_count(totals[:casing]),
          gems_by_casing: sort_by_count(gems_by_casing),
          gems_by_indentation: sort_by_count(gems_by_indentation),
          gems_by_quoting: sort_by_count(gems_by_quoting),
          non_uppercase_terminators: totals[:terminators].keys.reject { casing_of(it) == 'UPPERCASE' }.sort,
          indentation: sort_by_count(totals[:indentation]),
          quoting: sort_by_count(totals[:quoting]),
          interpolating: totals[:interpolating],
          non_interpolating: totals[:total] - totals[:interpolating],
          stacked_on_one_line: totals[:stacked],
          as_call_argument: totals[:as_call_argument],
          body_size: SIZE_BUCKETS.to_h { [it, totals[:body_size][it]] },
          terminators: sort_by_count(totals[:terminators]).first(40).to_h,
          cohort_sizes: tally.cohort_sizes,
          share_by_era: tally.shares,
          site_totals_by_era: tally.site_totals,
          composition_by_era: tally.site_composition,
          node_totals_by_era: tally.node_totals,
          density_by_era: tally.site_density
        }
        writer = ReportWriter.new(name: 'heredocs', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data))
      end

      private

      def new_tally
        {
          as_call_argument: 0,
          body_size: Hash.new(0),
          casing: Hash.new(0),
          indentation: Hash.new(0),
          interpolating: 0,
          nodes: 0,
          quoting: Hash.new(0),
          stacked: 0,
          terminators: Hash.new(0),
          total: 0
        }
      end

      # UPPERCASE is the convention, but the grammar allows any identifier.
      def casing_of(terminator)
        case terminator
        when /\A[A-Z][A-Z0-9_]*\z/ then 'UPPERCASE'
        when /\A[a-z][a-z0-9_]*\z/ then 'lowercase'
        else 'MixedCase'
        end
      end

      def merge_tally(totals, gem_tally)
        totals[:nodes] += gem_tally[:nodes]
        totals[:total] += gem_tally[:total]
        totals[:interpolating] += gem_tally[:interpolating]
        totals[:stacked] += gem_tally[:stacked]
        totals[:as_call_argument] += gem_tally[:as_call_argument]
        %i[body_size casing indentation quoting terminators].each do |key|
          gem_tally[key].each { |bucket, count| totals[key][bucket] += count }
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
        opening_lines = Hash.new(0)
        visited = 0
        queue = [root]

        until queue.empty?
          visited += 1
          node = queue.pop
          count_call_arguments(node, tally)

          if heredoc?(node)
            tally[:total] += 1
            tally[:interpolating] += 1 if node.is_a?(Prism::InterpolatedStringNode)
            classify_opening(node.opening, tally)
            tally[:body_size][size_bucket_for(node)] += 1
            opening_lines[node.opening_loc.start_line] += 1
          end

          queue.concat(node.compact_child_nodes)
        end

        tally[:stacked] += opening_lines.count { |_line, count| count > 1 }
        visited
      end

      def heredoc?(node)
        node.respond_to?(:heredoc?) && node.heredoc?
      end

      def count_call_arguments(node, tally)
        return unless node.is_a?(Prism::CallNode)

        Array(node.arguments&.arguments).each { tally[:as_call_argument] += 1 if heredoc?(it) }
      end

      # `<<~"EOF"` -> indentation "<<~", quoting "double-quoted", terminator "EOF"
      def classify_opening(opening, tally)
        rest = opening.delete_prefix('<<')
        indentation =
          case rest[0]
          when '~' then '<<~ (squiggly)'
          when '-' then '<<- (dash)'
          else '<< (plain)'
          end
        rest = rest[1..] if ['~', '-'].include?(rest[0])

        quoting =
          case rest[0]
          when "'" then 'single-quoted (no interpolation)'
          when '"' then 'double-quoted'
          when '`' then 'backtick (shell execution)'
          else 'bare'
          end

        terminator = rest.delete("'\"`")
        tally[:indentation][indentation] += 1
        tally[:quoting][quoting] += 1
        tally[:terminators][terminator] += 1
        tally[:casing][casing_of(terminator)] += 1
      end

      def size_bucket_for(node)
        lines = node.closing_loc.start_line - node.opening_loc.start_line - 1
        case lines
        when ..1 then '1 line'
        when 2..5 then '2-5 lines'
        when 6..20 then '6-20 lines'
        else '21+ lines'
        end
      end

      def markdown_for(data)
        lines = []
        lines << '# Heredoc census across RubyGems.org'
        lines << ''
        scope = Scope.describe(sampled: data[:sampled], analyzed: data[:analyzed])
        lines << "Based on #{scope}, out of #{data[:corpus_size]} on RubyGems.org."
        lines << ''
        percent = data[:analyzed].zero? ? 0 : (data[:gems_with_heredocs] * 100.0 / data[:analyzed]).round(1)
        lines << "**#{data[:total_heredocs]}** heredocs across **#{data[:gems_with_heredocs]}** gems " \
                 "(#{percent}% of gems use at least one)."
        lines << ''
        lines << "Heredoc counts are concentrated: the top 5 gems hold #{data[:top_5_gems_share_of_sites]} of all sites"
        lines << '(generated SDKs and DSL-heavy gems dominate), so prefer the per-gem columns over raw site counts.'
        lines << ''
        lines << '## Indentation syntax'
        lines << ''
        lines << '| Syntax | Heredocs | % of sites | Gems | % of heredoc-using gems |'
        lines << '|---|---|---|---|---|'
        data[:indentation].each do |syntax, count|
          gems = data[:gems_by_indentation][syntax].to_i
          lines << "| `#{syntax}` | #{count} | #{share(count,
                                                       data[:total_heredocs])} | #{gems} | #{share(gems, data[:gems_with_heredocs])} |"
        end
        lines << ''
        lines << '## Quoting'
        lines << ''
        lines << '| Quoting | Heredocs | % of sites | Gems | % of heredoc-using gems |'
        lines << '|---|---|---|---|---|'
        data[:quoting].each do |quoting, count|
          gems = data[:gems_by_quoting][quoting].to_i
          lines << "| #{quoting} | #{count} | #{share(count,
                                                      data[:total_heredocs])} | #{gems} | #{share(gems, data[:gems_with_heredocs])} |"
        end
        lines << ''
        lines << '## By era'
        lines << ''
        lines << 'Share of *heredoc-using* gems in each cohort. `<<~` only exists since Ruby 2.3, so its'
        lines << 'standing among maintained gems matters more than its corpus-wide share.'
        lines << ''
        lines << '### Share of heredoc-using gems'
        lines << ''
        lines.concat(CohortTable.render(shares: data[:share_by_era], cohort_sizes: data[:cohort_sizes], label: 'Form'))
        lines << ''
        lines << '### Composition of heredoc sites'
        lines << ''
        lines << 'Indentation flavor only — counting quoting too would tally each heredoc twice. The gem-share'
        lines << 'table above counts a gem once per form it uses anywhere, so a gem writing one `<<~` and forty'
        lines << '`<<-` appears in both rows; this table says which form the corpus actually writes.'
        lines << ''
        lines.concat(CohortTable.composition(composition: data[:composition_by_era],
                                             site_totals: data[:site_totals_by_era],
                                             label: 'Form'))
        lines << ''
        lines << '### Density'
        lines << ''
        lines.concat(CohortTable.density(density: data[:density_by_era],
                                         node_totals: data[:node_totals_by_era],
                                         label: 'Form'))
        lines << ''
        lines << '## Terminator casing'
        lines << ''
        lines << 'UPPERCASE is convention, not grammar — any identifier is legal.'
        lines << ''
        lines << '| Casing | Heredocs | % of sites | Gems | % of heredoc-using gems |'
        lines << '|---|---|---|---|---|'
        data[:casing].each do |casing, count|
          gems = data[:gems_by_casing][casing].to_i
          lines << "| #{casing} | #{count} | #{share(count, data[:total_heredocs])} | #{gems} | " \
                   "#{share(gems, data[:gems_with_heredocs])} |"
        end
        lines << ''
        lines << "Non-uppercase terminators seen: #{data[:non_uppercase_terminators].map { "`#{it}`" }.join(', ')}"
        lines << ''
        lines << '## Interpolation, position, stacking'
        lines << ''
        lines << '| Property | Heredocs | % |'
        lines << '|---|---|---|'
        lines << "| body interpolates | #{data[:interpolating]} | #{share(data[:interpolating], data[:total_heredocs])} |"
        lines << "| body is literal | #{data[:non_interpolating]} | #{share(data[:non_interpolating], data[:total_heredocs])} |"
        lines << "| passed as a call argument | #{data[:as_call_argument]} | #{share(data[:as_call_argument], data[:total_heredocs])} |"
        lines << "| lines opening 2+ heredocs | #{data[:stacked_on_one_line]} | — |"
        lines << ''
        lines << '## Body size'
        lines << ''
        lines << '| Size | Heredocs | % |'
        lines << '|---|---|---|'
        data[:body_size].each { |bucket, count| lines << "| #{bucket} | #{count} | #{share(count, data[:total_heredocs])} |" }
        lines << ''
        lines << '## Terminator names (top 40)'
        lines << ''
        lines << 'What heredocs are used for — SQL, HTML, RUBY, and friends name their content.'
        lines << ''
        lines << '| Terminator | Heredocs |'
        lines << '|---|---|'
        data[:terminators].each { |terminator, count| lines << "| `#{terminator}` | #{count} |" }
        lines << ''
        lines << '## Gems with the most heredocs'
        lines << ''
        lines << '| Gem | Heredocs |'
        lines << '|---|---|'
        data[:top_gems_by_heredoc_count].each { |gem, count| lines << "| #{gem} | #{count} |" }
        lines << ''
        lines << "Errors: #{data[:errors].size}"

        lines.join("\n")
      end

      def share(count, total) = total.zero? ? '0%' : "#{(count * 100.0 / total).round(1)}%"
    end
  end
end
