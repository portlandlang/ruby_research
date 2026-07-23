# Changelog

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
