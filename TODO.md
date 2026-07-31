# TODO

Planned work for this harness. See METHODOLOGY.md for how existing reports
answer the questions in README.md, and CHANGELOG.md for what has landed.

Nothing here requires new network fetches unless it says so. The corpus
snapshot in `data/` (195,399 gems, fetched 2026-07-22) is complete, so every
active item runs offline from cache.

## Active

- **Update PORTLAND_DECISION_CANDIDATES.md** — its prevalence figures all cite
  the old 50-gem sample; replace with full-corpus numbers (n=195,390) and
  re-rank the priorities, which were chosen from that small sample. Also
  reconcile against the impl repo (ADRs, CHANGELOG, commits, issues): anything
  since decided leaves the candidates list and enters
  `config/portland_removals.yml` with detection metadata instead.
- **Run the site-normalized reports at full corpus.** The composition and
  density code is built, verified at `--sample 300–400`, and committed, but
  the committed `reports/` still hold gem-share-only runs. Five serial
  full-corpus runs (~70 min total) will populate the new tables. Watch for
  whether density contradicts gem share for `class << self`, `defined?`,
  zsuper, or `alias` — the candidates file's priority ranking assumes those
  are growing, and density is the better evidence.

## Deferred

### Needs fetching from rubygems.org

- **Download counts / usage weighting.** The most valuable missing dimension:
  today every report weights a 2009 abandoned gem equally with rails, which
  answers "what is in the corpus" but not "what does the code people actually
  run look like" — the question implementers, linter authors, and editor
  authors care about. Not derivable from the compact index. Investigate bulk
  sources (RubyGems.org database dumps, if published) before considering
  ~195k throttled API calls (~5.4 hours). Would also carry ownership data,
  which closes the open question on the case-collisions report: whether those
  178 colliding pairs are one author's rename or genuinely different projects.
- **Incremental index refresh.** `names.txt` and the per-gem info files are
  cached indefinitely, so new gems and new versions of known gems never
  appear. A full refresh is ~290MB. The compact index protocol supports
  conditional/ranged updates, so a `script/fetch refresh` could update only
  what changed. Note that refreshing changes seeded sample membership, so the
  current snapshot should stay frozen for the duration of an analysis cycle.
- **Intel-only verification.** `platforms` flags 153 gems by platform tag
  alone. Source-only C extensions that fail to build on arm64 need actual
  build testing to catch.

### Unbuilt censuses

Each answers a design question the way the existing censuses do, and each
runs offline from the cached corpus.

- **`case` anatomy** — `case/when` vs `case/in` counts; what sits in `when`
  slots (classes, regexes, ranges, procs, plain values), which decides how
  much `===` behavior `when` must keep; which `in` pattern forms occur.
  Caveat: pattern matching skews new, so corpus prevalence under-reports it.
- **Args census** — `*args` / `**kwargs` / `&block` prevalence and shapes.
- **Class-shape census** — share of classes that are pure data carriers
  (initialize + attr_*) vs behavior-rich; inheritance depth; include/extend
  frequency; `class << self` idioms. The construction half is built
  (`script/report construction`); this item now covers the rest.
- **Concurrency-shape census** — `Thread.new` / `Mutex` / `Queue` / `Ractor`
  sites, and how many are fork-join-shaped vs long-lived workers.

### Open investigations

Questions surfaced by a report, with data gathered but not yet resolved.
Written up under `investigations/`.

- **[Dependencies pointing at gems not on RubyGems.org](investigations/missing-dependencies.md)**
  — 132 dependency edges name gems absent from the index (`active_support`
  alone has 118 dependents). Hypotheses to test: pre-1.0 Rails naming,
  gems hosted off RubyGems.org (rails-assets.org), version strings leaking
  into the name field, github-gems era names, yanked gems, typos. Needs a
  policy decision for dangling edges before deeper dependency work.

### Analysis joins

- **feature-usage × gem-ages** — which language constructs are used only by
  old or unmaintained gems. Answers README's "are there parts of the language
  only used by very old/unmaintained gems?".
- **C extensions replaceable by pure Ruby** — needs a curated mapping layer
  on top of `c_extensions`; partly a judgment call, not fully derivable.
- **macOS availability** — which gems depend on system libraries absent on
  macOS, and which of those have no effective equivalent. Needs extconf and
  linked-library analysis.

### Harness quality

- **Single-pass architecture.** The six source-based reports each
  independently decompress and Prism-parse all 195k gems, which is why each
  takes ~20 minutes. One pass emitting per-gem records would make every
  aggregation cheap post-processing, make arbitrary slicing free, and let new
  questions be answered without touching the corpus again.
- **Structured deprecations.** `ruby-deprecations` is v1: keyword-matched
  NEWS bullets. Could become feature-level structured data.

### Direction, not yet actionable

- **Decouple from Portland.** The harness is intended to be useful to the
  wider Ruby community — implementations (MRI, JRuby, MagLev), gem hosts
  (RubyGems.org, gem.coop), linters (RuboCop, Standard), and editors. Most
  reports are already general; the Portland-specific surface is just
  `portland_compatibility` and `config/portland_removals.yml`.
- **Move PORTLAND_DECISION_CANDIDATES.md to the impl repo**, leaving this
  repo as data, research, scripts, and reports only.
