# Portland compatibility across RubyGems.org

Based on a random sample of 40 gems (seeded, reproducible), out of 195399 on RubyGems.org, scanned for the Ruby features Portland removes or changes (config/portland_removals.yml).

Just Work™ candidates (no decided removal detected): **15** (37.5%).

## Gems affected, by removed/changed feature

| Feature | Gems | % of gems |
|---|---|---|
| shift-operators | 23 | 57.5% |
| eval-family | 18 | 45.0% |
| global-variables | 13 | 32.5% |
| runtime-define-method | 9 | 22.5% |
| fetch-retired | 8 | 20.0% |
| thread-model | 4 | 10.0% |
| bitwise-operators | 3 | 7.5% |
| method-missing | 1 | 2.5% |

## Semantic changes with no static detection

These affect nearly all code via the type checker rather than any syntax form:

- ambient-nil
- truthiness
- mutable-by-default
- monkeypatching-open-classes
- dynamic-typing

## Just Work™ candidates

- ai_stream
- formadmin
- github-pulse
- google-apis-vmmigration_v1alpha1
- job_hunter_cli
- justpics
- organize_files
- pathspec
- psq-dm-xapian
- puppet-lint-classes_and_types_beginning_with_digits--check
- queue_sync
- ruby-psd
- sgfa
- valuevaluevalue
- wirecard-rails

Errors: 0
