# frozen_string_literal: true

module RubyResearch
  module Reports
    # Lists every set of gems on RubyGems.org whose names differ only in
    # letter case (`Abundance` / `abundance`).
    #
    # These are distinct gems sharing one name under case folding, which
    # collides on case-insensitive filesystems — macOS (APFS) and Windows
    # — for anything that stores a gem per file. This harness hit exactly
    # that bug in its own cache; see METHODOLOGY.md "Cache keys".
    #
    # Reads only the cached compact index, so it needs no network. The
    # release dates come from the index too, which makes it possible to
    # tell whether the collisions are a historical artifact or something
    # still being created.
    class CaseCollisions
      def initialize(client: CompactIndexClient.new, reports_dir: REPORTS_DIR)
        @client = client
        @reports_dir = reports_dir
      end

      def run
        groups = collision_groups
        errors = []

        detailed = groups.filter_map do |folded, names|
          variants = names.sort.map { detail_for(it) }
          { folded: folded, collision_created: collision_created(variants), variants: variants }
        rescue StandardError => e
          errors << { gems: names, error: e.message }
          nil
        end
        detailed.sort_by! { it[:folded] }

        last_releases = detailed.flat_map { |group| group[:variants].filter_map { it[:last_release] } }
        data = {
          corpus_size: @client.names.size,
          errors: errors,
          group_count: detailed.size,
          gems_involved: detailed.sum { it[:variants].size },
          group_size_histogram: detailed.map { it[:variants].size }.tally.sort.to_h,
          newest_release_among_collisions: last_releases.max,
          collision_created_year_histogram: detailed.filter_map { it[:collision_created]&.slice(0, 4) }.tally.sort.to_h,
          newest_collision_created: detailed.filter_map { it[:collision_created] }.max,
          groups_with_a_release_since: release_recency(detailed),
          groups: detailed
        }
        writer = ReportWriter.new(name: 'case_collisions', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data))
      end

      private

      def collision_groups
        @client.names.group_by(&:downcase).select { |_folded, names| names.size > 1 }
      end

      # A collision starts existing when the second gem of the pair is
      # first published — that, not the latest release, says whether the
      # registry still lets new ones be created.
      def collision_created(variants)
        firsts = variants.filter_map { it[:first_release] }.sort
        firsts.size < 2 ? nil : firsts.last
      end

      def detail_for(name)
        versions = @client.versions_of(name)
        {
          name: name,
          version_count: versions.size,
          latest_version: versions.last&.dig(:version),
          first_release: versions.first&.dig(:created_at)&.slice(0, 10),
          last_release: versions.last&.dig(:created_at)&.slice(0, 10)
        }
      end

      # How many groups have any variant released in or after each year —
      # shows whether collisions are historical or still being minted.
      def release_recency(groups)
        years = groups.filter_map do |group|
          group[:variants].filter_map { it[:last_release]&.slice(0, 4) }.max
        end
        %w[2015 2018 2020 2022 2024 2026].to_h do |cutoff|
          [cutoff, years.count { it >= cutoff }]
        end
      end

      def markdown_for(data)
        lines = []
        lines << '# Gems whose names differ only in case'
        lines << ''
        lines << "**#{data[:group_count]}** name collisions covering **#{data[:gems_involved]}** distinct gems, " \
                 "out of #{data[:corpus_size]} on RubyGems.org."
        lines << ''
        lines << 'These are separate gems that fold to the same name, so any tool storing one gem per file'
        lines << 'on a case-insensitive filesystem (macOS APFS, Windows) will have them overwrite each other.'
        lines << ''
        lines << "Newest release among any colliding gem: **#{data[:newest_release_among_collisions]}** — " \
                 'several of these gems are still actively maintained.'
        lines << ''
        lines << '## When each collision was created'
        lines << ''
        lines << 'Dated by the first release of the *second* gem in each pair, i.e. when the two names first'
        lines << 'coexisted. RubyGems.org appears to have added case-insensitive name validation after this:'
        lines << "the most recent collision was created **#{data[:newest_collision_created]}**, and none since."
        lines << 'So this is legacy data in the index rather than an open validation hole.'
        lines << ''
        lines << '| Year created | Collisions |'
        lines << '|---|---|'
        data[:collision_created_year_histogram].each { |year, count| lines << "| #{year} | #{count} |" }
        lines << ''
        lines << '## Group sizes'
        lines << ''
        lines << '| Gems in group | Groups |'
        lines << '|---|---|'
        data[:group_size_histogram].each { |size, count| lines << "| #{size} | #{count} |" }
        lines << ''
        lines << '## Groups with a release on or after'
        lines << ''
        lines << '| Year | Groups |'
        lines << '|---|---|'
        data[:groups_with_a_release_since].each { |year, count| lines << "| #{year} | #{count} |" }
        lines << ''
        lines << '## Every collision'
        lines << ''
        lines << '| Folded name | Gem | Versions | Latest | First release | Last release | Collision since |'
        lines << '|---|---|---|---|---|---|---|'
        data[:groups].each do |group|
          group[:variants].each do |variant|
            lines << "| `#{group[:folded]}` | `#{variant[:name]}` | #{variant[:version_count]} | " \
                     "#{variant[:latest_version]} | #{variant[:first_release]} | #{variant[:last_release]} | " \
                     "#{group[:collision_created]} |"
          end
        end
        lines << ''
        lines << "Errors: #{data[:errors].size}"

        lines.join("\n")
      end
    end
  end
end
