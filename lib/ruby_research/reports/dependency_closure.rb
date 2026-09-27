# frozen_string_literal: true

module RubyResearch
  module Reports
    # Readiness level 2 (#11): a gem is only as ready as its runtime
    # dependencies. For every gem whose own lib/ parses under pdx (level 0),
    # walk its whole runtime dependency closure through each dependency's
    # latest version, from the compact index already cached, and grade it by
    # the worst: no dependencies, every dependency parses too, or held back
    # by one that doesn't. The dependencies that hold back the most parsing
    # gems are the ones worth porting first.
    class DependencyClosure
      BLOCKERS_SHOWN = 50

      def initialize(compact_index: CompactIndexClient.new, reports_dir: REPORTS_DIR)
        @compact_index = compact_index
        @reports_dir = reports_dir
      end

      def run
        parsing = PdxParse.new(compact_index: @compact_index).recorded.filter_map do |name, entry|
          result = entry[:result]
          name if result && result[:files].positive? && result[:failed].zero?
        end
        dependencies = @compact_index.names.to_h do |name|
          latest = @compact_index.latest_version_of(name)
          [name, latest ? latest[:dependencies].map { it[:name] } : []]
        rescue StandardError
          [name, []]
        end
        data = summarize(dependencies: dependencies, parsing: parsing)
        writer = ReportWriter.new(name: 'dependency_closure', reports_dir: @reports_dir)
        writer.write(data: data, markdown: markdown_for(data))
      end

      def summarize(dependencies:, parsing:)
        parses = parsing.to_set
        blockers = Hash.new(0)
        counts = { no_dependencies: 0, dependencies_all_parse: 0, blocked_by_a_dependency: 0 }
        parsing.each do |name|
          reached = closure_of(name, dependencies)
          failing = reached.reject { parses.include?(it) }
          if reached.empty? then counts[:no_dependencies] += 1
          elsif failing.empty? then counts[:dependencies_all_parse] += 1
          else
            counts[:blocked_by_a_dependency] += 1
            failing.each { blockers[it] += 1 }
          end
        end
        { parsing: parsing.size, **counts, blockers: blockers.sort_by { -it[1] }.first(BLOCKERS_SHOWN).to_h }
      end

      private

      # Every gem reachable through runtime dependencies, the gem itself not
      # included, cycles walked once.
      def closure_of(name, dependencies)
        seen = Set.new
        queue = dependencies.fetch(name, []).dup
        until queue.empty?
          dependency = queue.shift
          next if dependency == name || !seen.add?(dependency)

          queue.concat(dependencies.fetch(dependency, []))
        end
        seen
      end

      def markdown_for(data)
        lines = ['# Readiness level 2: a gem is only as ready as its dependencies', '']
        lines << "Of the #{data[:parsing]} gems whose every lib/ file parses under pdx, following each one's " \
                 'runtime dependencies all the way down through their latest versions:'
        lines << ''
        lines << "- No runtime dependencies: **#{data[:no_dependencies]}**"
        lines << "- Every dependency parses too: **#{data[:dependencies_all_parse]}**"
        lines << "- Held back by a dependency that doesn't: #{data[:blocked_by_a_dependency]}"
        lines << '' << '## The dependencies holding back the most parsing gems' << ''
        lines << '| Dependency | Parsing gems it holds back |' << '|---|---:|'
        data[:blockers].each { |name, count| lines << "| #{name} | #{count} |" }
        lines.join("\n")
      end
    end
  end
end
