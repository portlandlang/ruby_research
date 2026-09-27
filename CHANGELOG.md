
# Changelog

## 2026-09-27 (refresh)

- `dependency-closure` report, readiness level 2 (#11): for each of the 10,426 gems whose `lib/` parses under pdx, its whole runtime dependency closure through each dependency's latest version. 7,254 have no runtime dependencies, 41 have dependencies that all parse, and 3,131 are held back by one that doesn't. The dependencies holding back the most are Ruby's own default gems — `logger` 1,574, `base64` 1,373, `bigdecimal`, `json`, `benchmark`, `securerandom`, `ostruct`, `timeout` — then concurrent-ruby, i18n, activesupport, rake, and rack: a stdlib question (portland#78) as much as a porting one.
- `test-frameworks` report (#13), for portland#117: the test framework each gemspec names among its development dependencies — across the corpus RSpec 58,936 gems, Minitest 12,704, test-unit 5,362, and 120,687 naming none; among the 10,426 that parse under pdx, RSpec 2,107 to Minitest 486 — and, over the 915 parsing gems that ship tests in the `.gem`, which methods those tests call, most first: `it` 5,474, `should` 4,837, `expect` 2,895, `to`, `==`, `describe`, `eq`, `assert_equal` 1,746, `subject`, `context`, `let`, `before`, `raise_error`, and the mock tail (`receive`, `and_return`). 57,876 gems (29%) ship tests in the published `.gem`, more than the first-gem funnel suggested. Fixture files are out of RuboCop's reach now, since it had rewritten one.
- `gem-readiness` export (#14): one JSON file for portlandlang.com's `/gems/`, built from pdx-parse's and portland-compatibility's per-gem results — the corpus counts, and the 500 most downloaded of the gems whose every `lib/` file parses under pdx, each with its version, downloads, runtime dependency count, and its listed differences by kind (open questions, thesis, taste) with the grade they give. Downloads come from the rate-limited API only for the gems that parse, within `--minutes`; the API cache makes a rerun resume, and a gem not fetched yet is left out rather than guessed. First full run, four passes: all 10,426 parsing gems ranked; of the top 500, 122 grade "runs as is" at the syntax level, among them coffee-script-source, babel-source, and capistrano-bundler.
- **Correction: level 0 had counted every failing one-file gem as parsing.** Given one file, `pdx --parse` took a path that printed only the panic, so `pdx-parse` found no `does not parse:` line and recorded a pass. portland 3a4c2e3 gives one file the many-files output, and the analysis now records a failure whenever pdx exits nonzero without naming a file. Rerun against it: **10,426 of 188,444 gems (5.5%)** parse unedited, not the 17.6% and 17.8% reported below, and 14.9% of files. The refusal counts below were lower bounds for the same reason; the rankings held. `first-gem-candidates` narrows to 9 (fizzbuzzard, which reopens `Fixnum`, had been listed).
- `first-gem-candidates` report (#12): a funnel over what the other reports know per gem — every `lib/` file parses under pdx (33,589), no runtime dependencies (20,394), pure Ruby (19,399), no open question (5,701), ships its own tests in the `.gem` (28) — ranked by downloads, with the decided thesis and taste differences each candidate still touches. The last stage is the steep one because most gems leave their tests out of the published `.gem`; the test story for the rest needs their source repositories.
- `pdx-parse` rerun against portland 4e6a118, after `;`, line continuation, CRLF, multi-line literals, `yield` with values, type constants, `class A::B`, and `::Name` landed (portland #136–#147): files that parse rose from 14.6% to 16.0% (332,554 to 364,510), gems from 17.6% to 17.8% — most newly parsing files now reach instance variables or inheritance, whose counts rose accordingly (105,282 to 110,692 gems; 52,336 to 67,165).
- `pdx-parse` report, readiness level 0 (#9): every gem's `lib/` files, as published, through portland's own `pdx --parse`, resumable like `portland-compatibility`. Refusals are folded into shapes (quoted source becomes `…`, numbers `N`, a possessive's apostrophe set aside; a quoted character or two stays, since which character a lexer refused is the finding) and ranked by the gems they appear in and by the gems for which each is the only refusal. First full run, about 17 minutes over two budgeted passes: 33,158 of 188,444 gems with `lib/` files (17.6%) parse unedited, and 14.6% of 2.28 million files. The top refusals are instance variables (105,282 gems), inheritance (52,336), and three characters Portland never lexed: `;` (38,455), `&` (38,310), and a backslash line continuation (30,058).
- Full-corpus `portland-compatibility` on the refreshed corpus, all 196,982 gems in about 7 minutes across 8 workers. 11,767 gems (6.0%) touch no listed difference; 1,331 only taste differences; 1,549 a thesis difference but nothing open; 182,335 (92.6%) an open question. A new section ranks the open questions by the gems they hold back: `require` by name (portland#116) is the only open question for 23,476 gems and the only difference of any kind for 7,782, far ahead of instance-variable writes (portland#103: 716 and 76), regex (portland#74: 673 and 135), and visibility (portland#133: 360 and 64). Visibility and `attr_reader` now name their portland issues as owners.
- `portland-compatibility` resumes across runs (#15): each gem's answer is kept as a JSON line under `data/results/`, keyed by a digest of the report's source and the removals list, so changing either starts afresh, and by the gem's version, so a refreshed gem is redone. `--workers N` forks N analyzers and `--minutes M` stops taking gems after M minutes; the run that completes the set writes the report. A full-corpus run had been about 130 minutes in one process with nothing kept if it stopped; 8 workers take 2,000 gems in about 12 seconds.
- The removals list is current and tagged (#7). Every entry carries portland's principle-2 `difference` — thesis (the language's price), taste (a removed spelling, which must name what it buys), or gap (nothing decided; Portland lacks it for now) — plus `status` (decided or undecided) and the `owner` holding the ruling or question. New entries: inheritance (detected as `class A < B`, which the report now tells apart from a plain class, plus `super`), `class << self`, instance-variable reads and writes separately, class variables, `attr_reader`, `attr_writer`/`attr_accessor`, `raise`/`rescue`/`ensure`/`retry`, visibility, `require` by name, and regex. `class` itself is not a removal (portland ADR 0056). Splats move from a tentative removal to a gap: ADR 0014 deferred them. `portland-compatibility` grades each gem by the hardest difference it touches — runs as is, taste only, thesis, or gap or undecided — and a Just Work™ candidate is now a gem touching none, not one touching no decided removal, which had counted gems full of undecided gaps as working. A 300-gem smoke run, not committed: 4.3% run as is, and `require` by name alone blocks 91%.
- `script/fetch refresh` catches the cache up with rubygems.org (#5): it reads the fresh `/names` and `/versions`, whose last line per gem carries the MD5 of that gem's current `/info` file, and deletes only the cached version lists whose digest no longer matches, so `script/fetch index` refetches those alone. It prints what was added, removed, and changed, and replaces the cached names. First run against the 2026-07-22 snapshot: 2,057 gems added, 474 removed, 5,531 changed; a second run straight after finds nothing. `all` doesn't include it.
- `script/fetch prune [--dry-run]` keeps the corpus at one version per gem (#6): it deletes every cached `.gem`, gemspec, and version list that isn't a listed gem's latest version, by the same selector the reports use, now one method (`CompactIndexClient#latest_version_of`) where there were thirteen copies. It refuses while any listed gem's version list is uncached, since right after a refresh a changed gem's latest is unknown and its files would look stale. First run: 12,446 files and 4.72 GB, among them old versions of refreshed gems and pre-case-safe-key duplicates the repair stage had left behind.

## 2026-09-25 (ordering census)

- `ordering` report, answering portland#76: which gems define `<=>`, whether they also `include Comparable`, what a `<=>` body does (delegates to one part, compares parts as an array, or computes), how ordering is asked for at call sites (`sort` bare or with a block, `sort_by`, `min`/`max`, `min_by`/`max_by`, `<=>` in an expression, `between?`, `clamp`), and whether a `<=>` result is ever read as an integer. Gems and sites counted separately; era cohort shares included.

## 2026-09-24 (percent literal census)

- `percent-literals` report, answering portland#29's per-member questions: which of `%w %W %i %I %q %Q % %s %r %x` gems write and how often, which delimiters they use per member, how often a body escapes or nests its own delimiter, and whether `%q`/`%Q`/`%` bodies actually contain a quote character. Gems and sites counted separately; era cohort shares included.

## 2026-07-26 (construction census)

- `construction` report, answering the impl repo's object-model questions: what `initialize` bodies contain (pure ivar assignment vs derivation vs validation-that-raises vs side effects), initialize signature shapes (positional/keyword/mixed), `Const.new` vs named class-method constructors at call sites, and `def self.new` overrides with/without `super`. Gems and occurrences counted separately throughout; era cohort shares included.

## 2026-07-26 (later)

- Two defects the full-corpus site-normalized runs exposed, both fixed:
  - `feature-usage` now reports per-100k density instead of composition percent — at percent scale, one decimal place rounded 144 of 148 node types to 0.0%, destroying the signal the table existed to carry.
  - `nil-idioms` excludes `nil_literal` from the site views (it stays in site counts and gem coverage): it is a literal, not a handling idiom, and generated SDK gems carry enough `x = nil` defaults that it was 86% of all 2020+ sites, diluting every real idiom.

## 2026-07-26 (site normalization)

- Full-corpus `portland-compatibility` with the corrected removal list: Just Work™ is **24.8%** (48,460 of 195,390 gems), confirming the 2,000-gem sample's 24.6%.
- `CohortTally` gained `site_composition` (share of a cohort's sites — scale-free, columns sum to 100%) and `site_density` (sites per 100k AST nodes), alongside the existing gem shares. `CohortTable` renders all three, each stating its own denominator so they cannot be misread.
- All five site-counting reports now emit composition and density: `mutation-shapes` (by era *and* dependents), `error-handling`, `nil-idioms`, `heredocs`, `feature-usage`. Node counting is free — every report already walked the full AST.
- Resolves the confound flagged in the previous mutation-shapes run: gem share rose monotonically with dependent count only because widely-depended-on gems contain more code. Composition does not, and the by-dependents table now says so in the report itself.

## 2026-07-26

- Reconciled `config/portland_removals.yml` against impl-repo ADRs 0012–0024. Corrected a material error: ADR 0015 makes `<<` a *rebinding append operator*, not a removal, so counting it as removed overstated the affected population by 45.2% of gems. Added the ADR 0015 mutation removals, the ADR 0017 numbered-parameter removal, and the ADR 0014 splat deferral.
- Rewrote `PORTLAND_DECISION_CANDIDATES.md`: full-corpus prevalence (n=195,390) with era trends against the 29.2% baseline, re-ranked priorities, a "graduated since last pass" table for the six items ADRs have since decided, corpus evidence offered back on landed ADRs, and three open questions where a decision's scope affects measurement. Cross-linked to the impl repo's `open-decisions.md`.

## 2026-07-25 (cohort slicing)

- `RubyResearch::Cohorts`: per-gem cohort keys (era, last-release year, minimum Ruby, dependents bucket) derived from the cached compact index, so reports can break findings down instead of only reporting corpus-wide totals.
- `feature-usage` now slices by cohort: usage-by-era per node type, the newest gem using each type, node types last used before 2020, and node types used only by gems nobody depends on. Answers README's "are there parts of the language only used by very old/unmaintained gems?" — the answer is one: `interpolated_match_last_line_node`, newest user shipped 2014.
- Fixture corpus made self-consistent: `spec/fixtures/compact_index/names.txt` listed a gem with no info file, so a spec silently fetched it from the network and wrote 184KB into the fixtures directory.

## 2026-07-25 (dependency graph)

- `CompactIndexClient` now parses each version's runtime dependencies, which were previously discarded. Verified against gemspecs that the compact index carries runtime dependencies only.
- `dependencies` report: the graph in both directions — most depended-on gems, dependent-count and dependency-count distributions, and a cross-join with `c-extensions` answering README's "which C extensions are effectively required in the community?". Full corpus in ~30s, offline. nokogiri has 6,900 dependents; json 7,518.

## 2026-07-25 (later)

- `case-collisions` report: every set of gems whose names differ only in letter case (178 pairs, 356 gems), with version counts, release dates, and the date each collision came into existence. All 178 were created 2009–2013 — none since — so the registry appears to validate this now and the remaining pairs are legacy index data.

## 2026-07-25

- Case-safe cache keys (`RubyResearch::CacheKey`): macOS folds filename case, so the 178 pairs of gems whose names differ only in case (`Abundance`/`abundance`) shared one cache file and one silently served the other's data. Lowercase names keep their plain filename; names carrying uppercase get a digest suffix.
- `script/fetch repair`: migrates pre-existing cache entries to the case-safe key by renaming on disk (9,402 entries, no refetch) and refills the poisoned collision groups. Idempotent.
- Regenerated the full-corpus reports with corrected data (intel-only gems 152 → 153).

## 2026-07-23 (later)

- Load gemspecs with RubyGems' safe loader and normalize `require_paths` ourselves, so the ~0.03% of gems whose ancient gemspecs store `require_paths` as `[["lib"]]` no longer warn to stderr and smear the fetch progress ticker. These were always warnings, not failures — the gems fetched and parsed fine.

## 2026-07-23

- Full-corpus runs of `ruby-requirements`, `platforms`, and `gem-ages` (all 195,399 gems) from the cached compact index.
- `heredocs` report: indentation flavor (`<<` / `<<-` / `<<~`), quoting (bare / single / double / backtick), interpolation, terminator names and casing, body size, call-argument position, and same-line stacking. Reports per-gem coverage alongside raw site counts because heredoc counts are heavily concentrated in a few generated-SDK gems.

## 2026-07-22 (bandwidth + resilience)

- Shared `HttpClient` for all fetchers: 10s/30s timeouts, 4 attempts with exponential backoff on transient failures (timeouts, resets, 5xx, 429), bounded redirect following.
- Metadata probe for the C-extension census shrunk from 256KB to 16KB per gem (exact-range fallback when metadata.gz is bigger) — cuts the full-corpus stage-2 transfer by roughly an order of magnitude.

## 2026-07-22 (design-decision censuses)

- `mutation-shapes` report: classifies receiver-mutation sites as accumulator / escaped / aliased / shared, feeding the `<<`-as-rebinding decision.
- `error-handling` report: rescue shapes (specific vs bare, re-raise vs swallow), `foo rescue nil`, ensure, retry, custom error classes.
- `nil-idioms` report: nil checks, `&.`, `||` defaults, `||=`, truthiness-on-variable sites, and the fetch arity breakdown.
- Split `<<`/`>>` out of the bitwise-operators feature in `config/portland_removals.yml` — true bitwise usage is 6% of gems, shift/append 54%.

## 2026-07-22 (Portland)

- `config/portland_removals.yml`: Ruby features Portland removes/changes, derived from the Portland docs, with static-detection metadata (Prism node types, method names, constants).
- `portland-compatibility` report: scans sampled gem sources for those features, reports gems-affected-per-feature and Just Work™ candidates.

## 2026-07-22 (later)

- `ruby-deprecations` report: deprecation/removal bullets extracted from ruby/ruby NEWS files, Ruby 2.0 through head.
- `c-extensions` report: native-gem census with extension-kind and last-release-year histograms. Full gemspecs read from each `.gem`'s metadata.gz via ranged HTTP (the quick-index marshaled specs strip `extensions`).
- `feature-usage` report: Prism AST node tally across sampled gem sources — occurrences, per-gem coverage, unused node types, and files that no longer parse under current Ruby.
- `GemSourceClient`: cached `.gem` downloads, in-memory Ruby source extraction, ranged metadata reads.

## 2026-07-22

- Project scaffold: `script/setup`, `script/test`, `script/report`, RSpec, RuboCop.
- Report framework: every report writes Markdown + JSON, versioned per run under `reports/<timestamp>/` and mirrored to `reports/latest/`.
- Compact index client with on-disk cache (names, versions, platforms, ruby requirements, release dates).
- RubyGems API client with on-disk cache and rate-limit throttle.
- Working reports: `rubocop` (discouraged language, via RuboCop defaults), `ruby-requirements` (minimum Ruby histogram), `platforms` (platform histogram + Intel-only gems), `gem-ages` (last-release-year histogram).
- METHODOLOGY.md mapping every research question to a report and status.
