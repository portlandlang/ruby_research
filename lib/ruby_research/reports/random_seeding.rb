# frozen_string_literal: true

require 'prism'

module RubyResearch
  module Reports
    # Census of random numbers and their seeds, for portland#548: whether an
    # unseeded `rand` may draw from the system's generator, with the Mersenne
    # Twister kept only for a program that names a seed.
    #
    # The proposal changes nothing a program can observe unless it names a
    # seed, so the questions are how often a seed is named, how, and whether
    # the code that names one wants the same numbers twice:
    #
    #   construct — the draws that name no seed (`rand`, `Kernel.rand`,
    #               `Random.rand`, `shuffle`/`sample`, `Random.new`, a bare
    #               `srand`), the ways a seed is named (`srand(seed)`,
    #               `Random.new(seed)`, `shuffle(random: generator)`), a
    #               `rand` on a held value, the hidden generator by name
    #               (`Random.seed`, `Random::DEFAULT`), and `SecureRandom`
    #   seed      — what `srand` or `Random.new` is handed: an integer written
    #               down, the environment (`ENV["SEED"]`), the clock or the
    #               process or fresh entropy (which asks for different numbers
    #               each run), or a variable or call (a seed handed in)
    #   place     — where the file sits in the gem: the library, tests,
    #               examples and benchmarks, executables and scripts
    #   profile   — a gem as a whole: seeds in the library, seeds only outside
    #               it, or draws and never seeds
    class RandomSeeding
      BENCHMARK_DIRECTORIES = %w[bench benchmark benchmarks demo demos example examples perf sample samples].freeze
      EXAMPLES_PER_SEED = 15
      EXECUTABLE_DIRECTORIES = %w[bin exe script scripts].freeze
      FRESH_CONSTANTS = %w[Process SecureRandom Time].freeze
      FRESH_METHODS = %w[new_seed rand urandom].freeze
      KEYWORD_SITE = 'shuffle or sample with random:'
      SEEDED = ['srand with a seed', 'Random.new with a seed', KEYWORD_SITE].freeze
      SEED_TAKERS = ['srand with a seed', 'Random.new with a seed'].freeze
      SOURCE_LIMIT = 120
      TEST_DIRECTORIES = %w[features spec specs test tests].freeze
      UNSEEDED = ['rand', 'Kernel.rand', 'Random.rand', 'shuffle or sample', 'Random.new with no seed',
                  'srand with no seed'].freeze
      WALKERS = %w[sample shuffle shuffle!].freeze

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
        gems_by_construct = Hash.new(0)
        gems_by_library_seed = Hash.new(0)
        gems_by_profile = Hash.new(0)
        examples = Hash.new { |hash, key| hash[key] = [] }
        seeded_library_sites = {}
        analyzed = 0
        errors = []
        names = selected_names

        tally = CohortTally.new(cohorts: @cohorts)
        progress = Progress.new(label: 'random-seeding')
        names.each_with_index do |name, index|
          progress.tick(index + 1, names.size)
          gem_tally = tally_for(name)
          next if gem_tally.nil?

          analyzed += 1
          profile = profile_of(gem_tally)
          tally.record(name, gem_tally[:construct].keys + [profile].compact)
          tally.record_sites(name, gem_tally[:construct], total_nodes: gem_tally[:nodes])
          gems_by_profile[profile] += 1 if profile
          gem_tally[:construct].each_key { gems_by_construct[it] += 1 }
          library_seeds_of(gem_tally).each { gems_by_library_seed[it] += 1 }
          library_sites = gem_tally[:place]['seeded']['the library']
          seeded_library_sites[name] = library_sites if library_sites.positive?
          keep_examples(examples, gem_tally[:examples])
          merge_tally(totals, gem_tally)
        rescue StandardError => e
          errors << { gem: name, error: e.message }
        end
        progress.finish

        ranked = seeded_library_sites.sort_by { |_name, count| -count }
        data = {
          corpus_size: @compact_index.names.size,
          sampled: @sample,
          analyzed: analyzed,
          errors: errors,
          total_sites: totals[:total],
          construct: sort_by_count(totals[:construct]),
          gems_by_construct: sort_by_count(gems_by_construct),
          gems_by_profile: sort_by_count(gems_by_profile),
          place: totals[:place].transform_values { sort_by_count(it) },
          seed: sort_by_count(totals[:seed]),
          seed_by_place: totals[:seed_by_place].transform_values { sort_by_count(it) },
          gems_by_library_seed: sort_by_count(gems_by_library_seed),
          keyword: sort_by_count(totals[:keyword]),
          examples: examples,
          top_gems_by_seeded_library_sites: ranked.first(15).to_h,
          cohort_sizes: tally.cohort_sizes,
          share_by_era: tally.shares,
          site_totals_by_era: tally.site_totals,
          composition_by_era: tally.site_composition,
          node_totals_by_era: tally.node_totals,
          density_by_era: tally.site_density
        }
        writer = ReportWriter.new(name: 'random_seeding', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data))
      end

      private

      def new_tally
        {
          construct: Hash.new(0),
          examples: [],
          keyword: Hash.new(0),
          nodes: 0,
          place: Hash.new { |hash, key| hash[key] = Hash.new(0) },
          seed: Hash.new(0),
          seed_by_place: Hash.new { |hash, key| hash[key] = Hash.new(0) },
          total: 0
        }
      end

      def merge_tally(totals, gem_tally)
        totals[:nodes] += gem_tally[:nodes]
        totals[:total] += gem_tally[:total]
        %i[construct keyword seed].each do |key|
          gem_tally[key].each { |bucket, count| totals[key][bucket] += count }
        end
        %i[place seed_by_place].each do |key|
          gem_tally[key].each do |outer, counts|
            counts.each { |inner, count| totals[key][outer][inner] += count }
          end
        end
      end

      def keep_examples(examples, found)
        found.each do |example|
          kept = examples[example[:seed]]
          kept << example if kept.size < EXAMPLES_PER_SEED && kept.none? { it[:gem] == example[:gem] }
        end
      end

      def sort_by_count(tally) = tally.sort_by { |_key, count| -count }.to_h

      def selected_names
        names = @compact_index.names
        return names unless @sample

        names.sample(@sample, random: Random.new(@seed))
      end

      def tally_for(name)
        latest = @compact_index.latest_version_of(name)
        return nil unless latest

        tally = new_tally
        @sources.each_ruby_file(name, latest[:version], platform: latest[:platform]) do |path, source|
          result = Prism.parse(source)
          tally[:nodes] += collect(result.value, tally, gem: name, path: path) if result.success?
        end
        tally
      end

      # Returns the number of nodes visited, for the density denominator.
      def collect(root, tally, gem:, path:)
        place = place_of(path)
        visited = 0
        each_node(root) do |node|
          visited += 1
          classify(node, tally, gem: gem, path: path, place: place)
        end
        visited
      end

      def each_node(root)
        queue = [root]
        until queue.empty?
          node = queue.pop
          yield node
          queue.concat(node.compact_child_nodes)
        end
      end

      def classify(node, tally, gem:, path:, place:)
        construct = construct_of(node)
        return if construct.nil?

        tally[:total] += 1
        tally[:construct][construct] += 1
        tally[:place]['seeded'][place] += 1 if SEEDED.include?(construct)
        tally[:place]['unseeded'][place] += 1 if UNSEEDED.include?(construct)
        tally[:keyword][keyword_kind(random_keyword(node))] += 1 if construct == KEYWORD_SITE
        return unless SEED_TAKERS.include?(construct)

        seed = seed_kind(arguments_of(node).first)
        tally[:seed][seed] += 1
        tally[:seed_by_place][seed][place] += 1
        return unless place == 'the library'

        tally[:examples] << { gem: gem, line: node.location.start_line, path: path, seed: seed,
                              source: source_of(node) }
      end

      def construct_of(node)
        case node
        when Prism::CallNode         then call_construct(node)
        when Prism::ConstantPathNode then 'Random::DEFAULT' if constant_name(node) == 'Random::DEFAULT'
        end
      end

      def call_construct(node)
        owner = constant_name(node.receiver)
        return 'SecureRandom' if owner == 'SecureRandom'

        case node.name.to_s
        when 'bytes', 'urandom' then 'Random.bytes or urandom' if owner == 'Random'
        when 'new'              then seeded_or_not(node, 'Random.new') if owner == 'Random'
        when 'new_seed'         then 'Random.new_seed' if owner == 'Random'
        when 'rand'             then rand_construct(node, owner)
        when 'seed'             then 'Random.seed' if owner == 'Random'
        when 'srand'            then seeded_or_not(node, 'srand') if hidden_generator?(node, owner)
        when *WALKERS           then walker_construct(node)
        end
      end

      def hidden_generator?(node, owner) = node.receiver.nil? || %w[Kernel Random].include?(owner)

      def rand_construct(node, owner)
        return 'rand' if node.receiver.nil?
        return "#{owner}.rand" if %w[Kernel Random].include?(owner)

        'rand on a held value'
      end

      def seeded_or_not(node, name) = arguments_of(node).empty? ? "#{name} with no seed" : "#{name} with a seed"

      def walker_construct(node)
        return nil if node.receiver.nil?

        random_keyword(node) ? KEYWORD_SITE : 'shuffle or sample'
      end

      def arguments_of(node) = node.arguments&.arguments || []

      # `Random`, `::Random`, and `Random::DEFAULT` by name; nil for anything
      # that is not a constant.
      def constant_name(node)
        case node
        when Prism::ConstantReadNode then node.name.to_s
        when Prism::ConstantPathNode
          return node.name.to_s if node.parent.nil?

          parent = constant_name(node.parent)
          parent && "#{parent}::#{node.name}"
        end
      end

      def random_keyword(node)
        keywords = arguments_of(node).last
        return nil unless keywords.is_a?(Prism::KeywordHashNode)

        keywords.elements.find { random_pair?(it) }&.value
      end

      def random_pair?(element)
        element.is_a?(Prism::AssocNode) && element.key.is_a?(Prism::SymbolNode) && element.key.unescaped == 'random'
      end

      def keyword_kind(value)
        name = constant_name(value)
        return 'SecureRandom' if name == 'SecureRandom'
        return 'the default generator' if %w[Random Random::DEFAULT].include?(name)
        return 'a variable or call' unless value.is_a?(Prism::CallNode) && construct_of(value)&.start_with?('Random.new')

        arguments_of(value).empty? ? 'the default generator' : 'a generator seeded on the spot'
      end

      def seed_kind(argument)
        case argument
        when Prism::IntegerNode                                       then return 'an integer literal'
        when Prism::FloatNode, Prism::RationalNode, Prism::StringNode then return 'another literal'
        end
        return 'the environment' if mentions_environment?(argument)
        return 'the clock, the process, or fresh entropy' if mentions_fresh_source?(argument)

        'a variable or call'
      end

      def mentions_environment?(argument)
        found = false
        each_node(argument) { found = true if constant_name(it) == 'ENV' }
        found
      end

      def mentions_fresh_source?(argument)
        found = false
        each_node(argument) do |node|
          found = true if FRESH_CONSTANTS.include?(constant_name(node))
          found = true if node.is_a?(Prism::GlobalVariableReadNode) && node.name == :$$
          found = true if node.is_a?(Prism::CallNode) && FRESH_METHODS.include?(node.name.to_s)
        end
        found
      end

      def place_of(path)
        *directories, file = path.split('/')
        return 'tests' if test_path?(directories, file)
        return 'examples and benchmarks' if directories.intersect?(BENCHMARK_DIRECTORIES)
        return 'executables and scripts' if directories.intersect?(EXECUTABLE_DIRECTORIES)
        return 'the library' if directories.first == 'lib'

        'elsewhere'
      end

      def test_path?(directories, file)
        directories.intersect?(TEST_DIRECTORIES) || file.start_with?('test_') || file.end_with?('_test.rb', '_spec.rb')
      end

      def profile_of(gem_tally)
        seeded = gem_tally[:place]['seeded']
        return 'seeds in the library' if seeded['the library'].positive?
        return 'seeds only outside the library' if seeded.values.sum.positive?

        'draws and never seeds' if gem_tally[:place]['unseeded'].values.sum.positive?
      end

      def library_seeds_of(gem_tally)
        gem_tally[:seed_by_place].select { |_seed, places| places['the library'].positive? }.keys
      end

      def source_of(node)
        source = node.slice.gsub(/\s+/, ' ')
        source.length > SOURCE_LIMIT ? "#{source[0, SOURCE_LIMIT]}…" : source
      end

      def markdown_for(data)
        lines = []
        lines << '# Random numbers and their seeds across RubyGems.org'
        lines << ''
        scope = Scope.describe(sampled: data[:sampled], analyzed: data[:analyzed])
        lines << "Based on #{scope}, out of #{data[:corpus_size]} on RubyGems.org."
        lines << ''
        lines << 'For portland#548: whether an unseeded `rand` may draw from the system\'s generator, with the ' \
                 'Mersenne Twister kept only for a program that names a seed. Nothing a program can observe changes ' \
                 'unless it names a seed, so the questions are how often one is named, how, and whether the code ' \
                 'that names one wants the same numbers twice.'
        lines << ''
        lines << '## Gems as a whole'
        lines << ''
        lines << 'A gem seeds when it calls `srand` or `Random.new` with an argument, or hands `random:` to ' \
                 '`shuffle` or `sample`. Where it does so is read from the file\'s path.'
        lines << ''
        lines << '| Profile | Gems | % of analyzed gems |'
        lines << '|---|---:|---:|'
        data[:gems_by_profile].each do |profile, count|
          lines << "| #{profile} | #{count} | #{share(count, data[:analyzed])} |"
        end
        silent = data[:analyzed] - data[:gems_by_profile].values.sum
        lines << "| no random number anywhere | #{silent} | #{share(silent, data[:analyzed])} |"
        lines << ''
        lines << '## Constructs'
        lines << ''
        lines << '| Construct | Names a seed | Sites | Gems | % of analyzed gems |'
        lines << '|---|---|---:|---:|---:|'
        data[:construct].each do |construct, count|
          gems = data[:gems_by_construct][construct].to_i
          lines << "| `#{construct}` | #{seeding_of(construct)} | #{count} | #{gems} | " \
                   "#{share(gems, data[:analyzed])} |"
        end
        lines << ''
        lines << '`shuffle` and `sample` are counted by name on any receiver, so a method of that name on something ' \
                 'other than an array is in the count. A `rand` on a held value is a draw from a generator the ' \
                 'program holds, or a method of that name on another library\'s object.'
        lines << ''
        lines << '## Where the sites are'
        lines << ''
        lines << '| Place | Seeded sites | % of seeded | Unseeded sites | % of unseeded |'
        lines << '|---|---:|---:|---:|---:|'
        seeded = data[:place].fetch('seeded', {})
        unseeded = data[:place].fetch('unseeded', {})
        (seeded.keys | unseeded.keys).each do |place|
          lines << "| #{place} | #{seeded[place].to_i} | #{share(seeded[place].to_i, seeded.values.sum)} | " \
                   "#{unseeded[place].to_i} | #{share(unseeded[place].to_i, unseeded.values.sum)} |"
        end
        lines << ''
        lines << '## What the seed is'
        lines << ''
        lines << 'For `srand(seed)` and `Random.new(seed)`. An integer written down, the environment, and a seed ' \
                 'handed in all ask for the same numbers twice. The clock, the process, or fresh entropy asks for ' \
                 'different numbers each run, which is what no seed gives.'
        lines << ''
        places = data[:seed_by_place].values.flat_map(&:keys).uniq
        lines << "| Seed | Sites | % of sites | #{places.join(' | ')} | Gems with it in the library |"
        lines << "|---|---:|---:|#{'---:|' * places.size}---:|"
        seed_total = data[:seed].values.sum
        data[:seed].each do |seed, count|
          by_place = places.map { data[:seed_by_place].fetch(seed, {})[it].to_i }
          lines << "| #{seed} | #{count} | #{share(count, seed_total)} | #{by_place.join(' | ')} | " \
                   "#{data[:gems_by_library_seed][seed].to_i} |"
        end
        lines << ''
        lines << '## What `random:` is handed'
        lines << ''
        lines << '| Value | Sites | % of sites |'
        lines << '|---|---:|---:|'
        keyword_total = data[:keyword].values.sum
        data[:keyword].each do |value, count|
          lines << "| #{value} | #{count} | #{share(count, keyword_total)} |"
        end
        lines << ''
        lines << '## Seeded sites in library code'
        lines << ''
        lines << "Up to #{EXAMPLES_PER_SEED} per kind of seed, one per gem, in the order the gems were read."
        lines << ''
        data[:examples].each do |seed, examples|
          lines << "### #{seed}"
          lines << ''
          lines << '| Gem | File | Source |'
          lines << '|---|---|---|'
          examples.each do |example|
            source = example[:source].gsub('|', '\\|')
            lines << "| #{example[:gem]} | `#{example[:path]}:#{example[:line]}` | `#{source}` |"
          end
          lines << ''
        end
        lines << '## By era'
        lines << ''
        lines << 'Share of gems in each cohort with each construct or profile at least once.'
        lines << ''
        lines.concat(CohortTable.render(shares: data[:share_by_era], cohort_sizes: data[:cohort_sizes],
                                        label: 'Construct or profile'))
        lines << ''
        lines << '### Composition of sites'
        lines << ''
        lines.concat(CohortTable.composition(composition: data[:composition_by_era],
                                             site_totals: data[:site_totals_by_era],
                                             label: 'Construct'))
        lines << ''
        lines << '### Density'
        lines << ''
        lines.concat(CohortTable.density(density: data[:density_by_era],
                                         node_totals: data[:node_totals_by_era],
                                         label: 'Construct'))
        lines << ''
        lines << '## Gems with the most seeded sites in the library'
        lines << ''
        lines << '| Gem | Sites |'
        lines << '|---|---:|'
        data[:top_gems_by_seeded_library_sites].each { |gem, count| lines << "| #{gem} | #{count} |" }
        lines << ''
        lines << "Errors: #{data[:errors].size}"

        lines.join("\n")
      end

      def seeding_of(construct)
        return 'yes' if SEEDED.include?(construct)
        return 'no' if UNSEEDED.include?(construct)

        ''
      end

      def share(count, total) = total.zero? ? '0%' : "#{(count * 100.0 / total).round(1)}%"
    end
  end
end
