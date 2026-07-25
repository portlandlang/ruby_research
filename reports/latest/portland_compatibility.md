# Portland compatibility across RubyGems.org

Sampled 100 gems (seeded, reproducible) out of 195399 on RubyGems.org, scanned for the Ruby features Portland removes or changes (config/portland_removals.yml).

Just Work™ candidates (no decided removal detected): **38** (38.0%).

## Gems affected, by removed/changed feature

| Feature | Gems | % of gems |
|---|---|---|
| shift-operators | 46 | 46.0% |
| eval-family | 40 | 40.0% |
| global-variables | 37 | 37.0% |
| runtime-define-method | 21 | 21.0% |
| fetch-retired | 16 | 16.0% |
| thread-model | 13 | 13.0% |
| bitwise-operators | 6 | 6.0% |
| method-missing | 4 | 4.0% |
| for-in-loop | 4 | 4.0% |

## Semantic changes with no static detection

These affect nearly all code via the type checker rather than any syntax form:

- ambient-nil
- truthiness
- mutable-by-default
- monkeypatching-open-classes
- dynamic-typing

## Just Work™ candidates

- ai_stream
- archive-pecan
- automation-shared-support
- capistrano3-drupal
- captive-sdk
- cucumber-js_console_errors
- datatablesassets-rails
- devise-pbkdf2-encryptable
- enerbot-slack
- fanforce-internal-validations
- fleece
- formadmin
- github-pulse
- google-apis-cloudsupport_v2
- google-apis-vmmigration_v1alpha1
- goosi
- jektop
- job_hunter_cli
- justpics
- n_able_rails
- organize_files
- ota
- pathspec
- pg-enum
- psq-dm-xapian
- puppet-lint-classes_and_types_beginning_with_digits--check
- queue_sync
- rack_session_mongo
- ruby-psd
- seedream_4
- semgit
- sgfa
- test_changes
- tiny_xpath_helper
- valuevaluevalue
- wirecard-rails
- yo-api
- zillow_ruby

Errors: 0
