
# Changelog

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
