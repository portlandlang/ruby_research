# Portland compatibility across RubyGems.org

Sampled 50 gems (seeded, reproducible) out of 195399 on RubyGems.org, scanned for the Ruby features Portland removes or changes (config/portland_removals.yml).

Just Work™ candidates (no decided removal detected): **17** (34.0%).

## Gems affected, by removed/changed feature

| Feature | Gems | % of gems |
|---|---|---|
| shift-operators | 27 | 54.0% |
| eval-family | 21 | 42.0% |
| global-variables | 20 | 40.0% |
| runtime-define-method | 10 | 20.0% |
| fetch-retired | 9 | 18.0% |
| thread-model | 4 | 8.0% |
| bitwise-operators | 3 | 6.0% |
| method-missing | 1 | 2.0% |

## Semantic changes with no static detection

These affect nearly all code via the type checker rather than any syntax form:

- ambient-nil
- truthiness
- mutable-by-default
- monkeypatching-open-classes
- dynamic-typing

## Just Work™ candidates

- ai_stream
- fleece
- formadmin
- github-pulse
- google-apis-cloudsupport_v2
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
