# Changelog

## 2026-07-22

- Project scaffold: `script/setup`, `script/test`, `script/report`, RSpec, RuboCop.
- Report framework: every report writes Markdown + JSON, versioned per run under `reports/<timestamp>/` and mirrored to `reports/latest/`.
- Compact index client with on-disk cache (names, versions, platforms, ruby requirements, release dates).
- RubyGems API client with on-disk cache and rate-limit throttle.
- Working reports: `rubocop` (discouraged language, via RuboCop defaults), `ruby-requirements` (minimum Ruby histogram), `platforms` (platform histogram + Intel-only gems), `gem-ages` (last-release-year histogram).
- METHODOLOGY.md mapping every research question to a report and status.
