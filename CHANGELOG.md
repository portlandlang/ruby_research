# Changelog

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
