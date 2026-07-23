# Ruby language research

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
