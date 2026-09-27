# frozen_string_literal: true

module RubyResearch
  module Reports
    # The gems most likely to be the first to run on Portland, unmodified
    # or linter-only, with their own tests passing (portland's "First gem
    # runs" milestone). A funnel over what the other reports already know
    # per gem — level 0 (pdx-parse), the open questions it touches
    # (portland-compatibility), its dependencies and platform (the compact
    # index), whether it ships tests (its own .gem) — ranked by downloads
    # at the end, where the set is small enough to ask the API.
    #
    # Reads pdx-parse's and portland-compatibility's recorded per-gem
    # results, so run those first; a gem either has not reached is left out.
    class FirstGemCandidates
      SHOWN = 60

      def initialize(api: RubygemsApiClient.new,
                     compact_index: CompactIndexClient.new,
                     reports_dir: REPORTS_DIR,
                     sources: GemSourceClient.new)
        @api = api
        @compact_index = compact_index
        @reports_dir = reports_dir
        @sources = sources
      end

      def run
        parsing = PdxParse.new(compact_index: @compact_index).recorded
        compatibility = PortlandCompatibility.new(compact_index: @compact_index).recorded
        features = PortlandCompatibilityAnalysis.new.features
        open_names = features.select { it['difference'] == 'gap' || it['status'] == 'undecided' }.map { it['name'] }

        facts = {}
        parsing.each do |name, entry|
          result = entry[:result]
          next unless result && result[:files].positive? && result[:failed].zero?

          facts[name] = facts_for(name, compatibility.dig(name, :result) || [], open_names)
        rescue StandardError => e
          warn "  first-gem-candidates: #{name}: #{e.message}"
        end
        stages = funnel(facts, total: parsing.size)
        write(stages, facts, compatibility, features)
      end

      # Each stage keeps the gems passing it and every stage before.
      def funnel(facts, total: nil)
        remaining = facts.select { |_name, fact| fact[:parses] }.keys
        stages = [{ stage: 'every lib/ file parses under pdx', gems: remaining, of: total }]
        [
          ['no runtime dependencies', ->(fact) { fact[:runtime_dependencies].zero? }],
          ['pure Ruby, no C extension', ->(fact) { !fact[:native] }],
          ['no open question (gap or undecided)', ->(fact) { fact[:open_questions].empty? }],
          ['ships its own tests', ->(fact) { fact[:test_files].positive? }]
        ].each do |label, keep|
          remaining = remaining.select { keep.call(facts.fetch(it)) }
          stages << { stage: label, gems: remaining }
        end
        stages
      end

      private

      def facts_for(name, matched_features, open_names)
        latest = @compact_index.latest_version_of(name)
        test_files = 0
        @sources.each_ruby_file(name, latest[:version], platform: latest[:platform]) do |path, _source|
          test_files += 1 if path.match?(%r{\A(test|spec)/.*(_test|_spec|test_.*)\.rb\z})
        end
        {
          parses: true,
          runtime_dependencies: latest[:dependencies].size,
          native: latest[:platform] != 'ruby' || native_extensions?(name, latest),
          open_questions: matched_features & open_names,
          test_files: test_files,
          version: latest[:version]
        }
      end

      def native_extensions?(name, latest)
        !@sources.full_gemspec(name, latest[:version], platform: latest[:platform]).extensions.empty?
      rescue StandardError
        false
      end

      def write(stages, facts, compatibility, features)
        finalists = stages.last[:gems].map do |name|
          info = @api.gem_info(name)
          matched = compatibility.dig(name, :result) || []
          {
            name: name,
            version: facts[name][:version],
            downloads: info[:downloads].to_i,
            test_files: facts[name][:test_files],
            thesis: features.select { matched.include?(it['name']) && it['difference'] == 'thesis' }.map { it['name'] },
            taste: features.select { matched.include?(it['name']) && it['difference'] == 'taste' }.map { it['name'] }
          }
        end
        ranked = finalists.sort_by { -it[:downloads] }
        data = { funnel: stages.map { { stage: it[:stage], gems: it[:gems].size } }, candidates: ranked }
        writer = ReportWriter.new(name: 'first_gem_candidates', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data, stages.first[:of]))
      end

      def markdown_for(data, total)
        lines = []
        lines << '# First-gem candidates'
        lines << ''
        lines << "The gems most likely to be the first to run on Portland with their own tests passing, out of #{total} " \
                 'gems with a pdx-parse result. Each stage keeps the gems passing it and every stage before.'
        lines << ''
        lines << '| Stage | Gems |'
        lines << '|---|---:|'
        data[:funnel].each { lines << "| #{it[:stage]} | #{it[:gems]} |" }
        lines << ''
        lines << "## The candidates, by downloads (first #{[SHOWN, data[:candidates].size].min})"
        lines << ''
        lines << 'Thesis and taste differences are the decided ones the gem still touches — the edits it needs, ' \
                 'or a linter could make — as `portland-compatibility` lists them.'
        lines << ''
        lines << '| Gem | Version | Downloads | Test files | Thesis differences | Taste differences |'
        lines << '|---|---|---:|---:|---|---|'
        data[:candidates].first(SHOWN).each do |gem|
          lines << "| #{gem[:name]} | #{gem[:version]} | #{gem[:downloads]} | #{gem[:test_files]} | " \
                   "#{gem[:thesis].join(', ')} | #{gem[:taste].join(', ')} |"
        end
        lines.join("\n")
      end
    end
  end
end
