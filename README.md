# Ruby language research

Systematic, re-runnable answers to the questions below, generated against the
live RubyGems.org corpus. See METHODOLOGY.md for how each question maps to a
report and its current status.

## Usage

```sh
script/setup                                # install dependencies
script/test                                 # run specs
script/report rubocop                       # RuboCop-discouraged language
script/report ruby-requirements --sample 500
script/report platforms --sample 500
script/report gem-ages --sample 500
script/report c-extensions --sample 500
script/report feature-usage --sample 100     # downloads gems; heavier
script/report ruby-deprecations
script/report portland-compatibility --sample 100
script/report error-handling --sample 100
script/report nil-idioms --sample 100
script/report mutation-shapes --sample 100
script/report all --sample 500
```

Reports land in `reports/<timestamp>/` (one folder per run, so answers are
comparable over time) as both `.md` (human) and `.json` (machine), with the
newest run mirrored to `reports/latest/`. Omit `--sample` for a full-corpus
run; all fetches are cached under `data/` and resumable.

## Language

- What parts of Ruby language are discouraged by the language itself?
- What parts of Ruby language are discouraged by Rubocop and other linters?
- What parts of Ruby language are disallowed on which versions of Ruby? (Deprecations, warnings, errors)

## Gems

- What parts of Ruby language are use in gems published to RubyGems.org?
- Are there any parts of the language that are fully not used by any gems anywhere on RubyGems.org?
- Are there any parts of the language that are only used by gems that are very old/unmaintained?
- What is the histogram threshhold of "very old/unmaintained"?
  - By year?
  - By supported/minimum Ruby version?
  - By Ruby versions still supported by Ruby core?
- Which gems on RubyGems.org work on which versions of Ruby?

## C extensions

- How many C extensions gems are on RubyGems.org?
- How many C extensions gems on RubyGems.org are actively maintained/used/supported?
  - By year?
  - By supported/minimum Ruby version?
  - By Ruby versions still supported by Ruby core?
- Which C extensions gems on RubyGems.org are reasonably replaced by pure Ruby gems?
- Which C extensions gems on RubyGems.org are effectively required in the Ruby community?
  - Because of broad usage?
  - Because of no pure Ruby option?
  - Because no pure Ruby option is performant enough?

## Portland

- Which gems on RubyGems.org use parts of Ruby that Portland is removing or changing?
- Which gems on RubyGems.org which use parts of Ruby could be migrated to Just Work™ in Portland too?
- Which gems on RubyGems.org which use parts of Ruby could NOT be easily migrated to work in Portland too?
- Which gems on RubyGems.org use something that isn't available in macOS?
- Which gems on RubyGems.org use something that isn't available in macOS and doesn't have an effective equivalent in macOS?
- Which gems on RubyGems.org only work on Intel architecture?
