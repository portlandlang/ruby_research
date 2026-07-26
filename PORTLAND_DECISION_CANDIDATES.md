# Undocumented removal candidates for Portland

Ruby features the Portland docs don't yet rule on, but that collide with a
stated Portland principle. Each needs an explicit keep/change/remove decision
(and ideally an ADR) in [portlandlang/portland](https://github.com/portlandlang/portland).

**Companion document:** the impl repo's
[`docs/history/2026-07-22-open-decisions.md`](https://github.com/portlandlang/portland/blob/main/docs/history/2026-07-22-open-decisions.md)
tracks the *named* open decisions and their recommended order. This file
tracks the *unnamed* ones — features nothing has ruled on yet — and feeds
measured prevalence into them. Items here graduate into
`config/portland_removals.yml` once an ADR lands, which is what makes them
show up in the `portland-compatibility` report.

**Reconciled against the impl repo as of 2026-07-26** (ADRs 0001–0024).

## How to read the numbers

Full corpus: **195,390 gems**, latest release of each
(`reports/latest/feature_usage.json`). Two figures per entry:

- **Gems** — share of all gems using the construct at least once.
- **2020+** — share of the gems *using it* whose newest release shipped in
  2020 or later. **The corpus baseline is 29.2%**, so above that means the
  construct is growing, below means declining. This is the figure that
  matters: a construct can be everywhere in the corpus and still be dying,
  or rare and rising.

Prevalence is a lower bound on migration cost, not an argument by itself —
`for` is only 2.7% of gems and still worth removing.

## Graduated since the last pass

Decided by ADR, moved into `config/portland_removals.yml`, no longer
candidates:

| Was a candidate | Decided by | Outcome |
|---|---|---|
| In-place mutation methods | [0015](https://github.com/portlandlang/portland/blob/main/docs/adr/0015-2026-07-23-values-never-mutate.md) | Removed. `<<` and `[]=` return as *rebinding* operators |
| `freeze` / `frozen?` / `dup` / `clone` | 0015 | Meaningless; ledger entries |
| `# frozen_string_literal:` magic comment | 0015 | Meaningless |
| Block-parameter spellings | [0017](https://github.com/portlandlang/portland/blob/main/docs/adr/0017-2026-07-23-it-under-no-shadow.md) | `_1`–`_9` out, `it` in |
| Heredoc flavors | [0020](https://github.com/portlandlang/portland/blob/main/docs/adr/0020-2026-07-23-heredocs-squiggly-only.md) | Only `<<~`; SCREAMING_CAPS terminators |
| `*args` / `**kwargs` splats | [0014](https://github.com/portlandlang/portland/blob/main/docs/adr/0014-2026-07-22-keyword-arguments.md) | Out for now (tentative) |

Corpus evidence bearing on those decisions is in
[Evidence for decisions already made](#evidence-for-decisions-already-made)
below — including one number that ADR 0020 explicitly asked for.

## Priority

Re-ranked on full-corpus data. The old ranking came from a 50-gem sample and
was wrong about which constructs are legacy.

1. **The exception model** — the largest unnamed decision, and the impl repo
   agrees (`open-decisions.md` §6, "no recommendation yet"). `begin` blocks
   are in 42.3% of gems and *growing* (33.9% shipped 2020+). See the
   error-handling group below for the shape of real recovery code.
2. **Singleton classes / `class << self`** — 24.9% of gems, growing (36.3%).
   Feeds the object-model session. Not removable without a blessed
   replacement for class methods.
3. **Destructuring** — 27.1% of gems, steady in every era (~30% of each
   cohort uses it). Already flagged as an ADR 0011 leftover; the numbers say
   it is mainstream, not legacy.
4. **`defined?` and the reflection family** — 17.7%, growing (36.3%). Routes
   to the inference session (#9).
5. **Class variables** — 9.3% of gems and clearly declining (20.2% vs the
   29.2% baseline). Pure shared mutable state, small blast radius, dying on
   its own: the easiest defensible removal on this list.

## Collides with "no shared mutable runtime state"

- **Class variables (`@@foo`)** — shared hierarchy-wide mutable state.
  **9.3% of gems, 20.2% 2020+ (declining).**
  Detect: `class_variable_*` node types.
- **`ObjectSpace`** — enumerate every live object at runtime. Also breaks the
  refcount-exactness argument ADR 0015 leans on. Detect: constant.
- **`at_exit`** — runtime-registered exit hooks; sibling of the already-removed
  `BEGIN`/`END` blocks. Detect: method name.
- **`Marshal`** — runtime serialization of arbitrary object graphs. Detect:
  constant.

## Collides with "no runtime metaprogramming"

- **`alias` / `alias_method`** — runtime method-table mutation.
  **10.0% of gems; flat across eras** (12.1% of pre-2015 gems, 11.2% of
  2020+ gems). Worth noting the docs use `alias` in their own prose but
  never rule on it. Detect: `alias_method_node`.
- **`undef` / `undef_method` / `remove_method`** — **1.1% of gems, 18.0% 2020+
  (declining).** Detect: `undef_node`, method names.
- **Refinements (`refine` / `using`)** — scoped monkeypatching. Detect: method
  names.
- **Singleton classes (`class << self`, `def obj.foo`,
  `define_singleton_method`)** — **24.9% of gems, 36.3% 2020+ (growing).**
  Also the idiomatic spelling for class methods, so removal needs a
  replacement, not just a deletion. Detect: `singleton_class_node`.
- **Module lifecycle hooks (`inherited`, `included`, `extended`, `prepended`,
  `method_added`)** — the engine of most Ruby DSLs. Detect: def names.
- **`Module#prepend`** — runtime method interception. Detect: method name.
- **`binding` / `Binding`** — reify a scope as an object. Detect: method name,
  constant.
- **`defined?`** — runtime existence reflection. **17.7% of gems, 36.3% 2020+
  (growing).** Detect: `defined_node`.
- **Reflection queries (`respond_to?`, `is_a?`, `kind_of?`, `instance_of?`,
  `.class`, `.methods`)** — runtime type interrogation vs compile-time
  structural typing. Detect: method names.
- **`OpenStruct`** — built on `method_missing`, already removed; needs an
  explicit "gone, use X". Detect: constant.
- **`autoload`** — runtime lazy constant loading. Detect: method name.

## Collides with "never panics implicitly / loud errors"

The impl repo has opened no issue for this yet and explicitly declines to
recommend (`open-decisions.md` §6). Full-corpus shapes, from
`reports/latest/error_handling.json`:

- **The exception model as a whole** — `begin` blocks in **42.3% of gems,
  33.9% 2020+ (growing)**. `raise` sites in 48.6% of gems. Sub-shapes, as a
  share of gems by era (pre-2015 → 2020+):
  - rescue with a specific class: 32.3% → **41.3%** (growing)
  - rescue that swallows: 34.0% → 38.1% (flat — *current* practice, not a
    legacy artifact, and it outnumbers re-raising roughly 2:1)
  - rescue that re-raises: 15.2% → **24.4%** (growing)
  - custom error classes: 20.5% → **40.2%** (doubling — 2 in 5 modern gems
    define an error hierarchy, which is a lot of API surface for a
    Result-shaped migration to absorb)
- **`rescue` modifier (`foo rescue nil`)** — the anti-loud spelling.
  **8.2% of gems, and the one clear decline in the group** (11.1% → 6.7% by
  era). The ecosystem is already moving Portland's way here.
- **`catch` / `throw`** — non-local control flow that isn't an error. Detect:
  method names.
- **Bare `super` (zsuper)** — implicitly forwards the caller's arguments.
  **21.3% of gems, 36.5% 2020+ (growing).** Detect: `forwarding_super_node`.
- **`retry`** — **3.4% of gems, 36.4% 2020+.** Marginal but not dead.
- **`ensure`** — **12.0% of gems, 36.4% 2020+ (growing).** Whatever replaces
  exceptions still needs a cleanup story.

## Collides with "one way to do it"

- **`proc` vs `lambda`** — two callables with different return/arity
  semantics. `->` lambdas are in **7.0% of gems and strongly growing (56.6%
  2020+)**. The `and`/`or` precedent suggests collapsing to one. Detect:
  `lambda_node`, method names `proc`/`lambda`.
- **`%` literal family (`%w` `%i` `%q` `%r` `%s` `%x`)** — `open-decisions.md`
  lists `%()` literals under "build-when-pulled", i.e. Ruby-match by default,
  but which survive is unstated. `%x` in particular is shell execution — see
  below.
- **Multiple assignment / destructuring (`a, b = b, a`)** — **27.1% of gems;
  steady across eras** (29.5% of pre-2015 gems, 30.5% of 2020+ gems).
  Flagged as undecided in the docs; the data says it is mainstream in every
  era, not a legacy form.
- **`=begin`/`=end` blocks and `__END__`/`DATA`** — perlish file furniture the
  removed-syntax doc doesn't mention.

## Platform / process surface

- **Shell execution (backticks, `%x{}`, `system`, `exec`, `spawn`)** —
  string-to-shell is a major injection surface for a compiled, macOS-native
  language. **Backtick/`%x` literals in 4.9% of gems (plus 6.3% interpolated),
  26.8% 2020+.** Notably ADR 0020 already removed backtick *heredocs*
  (`<<~\`CMD\``), which the corpus confirms are vanishingly rare — 15 sites
  in 7 gems — so the appetite for narrowing this exists. Detect:
  `x_string_node`, `interpolated_x_string_node`, method names.
- **`fork` / `trap` / signals** — POSIX process model vs the `together`
  runtime. Detect: method names.
- **The standard streams** — globals are removed, but the docs never name the
  blessed spelling for stdout/stderr. Every CLI gem needs the answer.

## Numeric / literal odds and ends

- **`Rational` / `Complex` literals (`1r`, `1i`)** — **0.1% and 0.0% of gems.**
  ADR 0018 settled division and floats but not these. Effectively free to
  remove; listed only so the decision is explicit. Detect: `rational_node`,
  `imaginary_node`.
- **`__FILE__` / `__LINE__` / `__method__`** — compile-time-resolvable
  introspection. **`__FILE__` is in 38.2% of gems**, which is higher than most
  things on this list, though sharply declining (16.1% 2020+) as
  `require_relative` and gemspec conventions replaced the
  `File.dirname(__FILE__)` idiom. Detect: `source_file_node`,
  `source_line_node`.

## Evidence for decisions already made

Corpus data bearing on landed ADRs, offered back as validation or challenge.

- **ADR 0020 asked for this one.** It requires SCREAMING_CAPS terminators on
  the grounds that "the convention is already universal", adding: "Corpus
  evidence may revisit this; it is a prior, not a closed book." Measured:
  **94.7% of heredoc-using gems use uppercase terminators, but 6.9% use
  lowercase and 3.1% MixedCase** — so roughly 1 in 14 has a non-conforming
  terminator somewhere. Universal as a convention, not as a fact. The ADR's
  claim that upcasing is a free-tier autocorrect holds, so this is a
  migration-volume note rather than a challenge.
- **ADR 0020's `<<~`-only decision is strongly validated by the era data.**
  Among heredoc-using gems: `<<~` goes **0.0% → 9.3% → 64.2%** across
  pre-2015 / 2015–2019 / 2020+, while `<<-` falls **84.1% → 41.0%** and plain
  `<<` **24.7% → 10.1%**. Corpus-wide totals hide this completely (`<<-` looks
  dominant at 67.7% of heredoc gems); among gems still shipping, `<<~` is
  already the majority form. The unsafe-autocorrect population the ADR worries
  about is real but shrinking.
- **ADR 0020 shows multiple heredocs per line as supported** (`[<<~A, <<~B]`),
  and the corpus confirms it is used: **12,578 lines open two or more.**
  `spec/heredoc_spec.pdx` does not currently cover that case.
- **ADR 0003 (bitwise out, tentative) is safe** on the "rare in application
  code" claim, once `<<`-append is separated out: true bitwise `& | ^ ~` is
  **10.2% of gems**, not the 56% a combined counter suggested. `>>` alone is
  2.0%.
- **ADR 0015 is the single largest migration cost in the language.** With its
  removals encoded, gems that would compile verbatim drop from 39.8% to
  **24.8%** of the full corpus — in-place mutators alone touch 47.8% of gems
  (93,434), the `<<` rebinding change another 45.0% (87,944), and the freeze
  family 29.3%.
  For the accumulator question specifically: of 8.7M receiver-mutation sites,
  only **16.3% are accumulator-shaped** (fresh local, never escapes its
  method) and migrate to rebinding `<<` verbatim; **48.8% mutate a shared
  receiver** (ivar, constant, call result), which cannot become a rebinding
  because the target isn't a local. That second population is the real
  migration work, and the `mutable` gate does not help it.
- **ADR 0017's `it` and the numbered parameters both barely exist yet** —
  `it` in 0.1% of gems, `_1`–`_9` in 0.6% — but both are almost entirely
  modern (90.4% and 99.8% shipped 2020+), so prevalence understates where
  they are heading.

## Open questions for the impl repo

Places where a decision's *scope* is unclear enough to affect measurement:

1. **Do `freeze`/`dup`/`clone` fail to compile, or are they accepted no-ops?**
   ADR 0015 calls them "meaningless — ledger entries, not features", which
   doesn't say. It changes 30.2% of gems' migration status.
   `portland_removals.yml` currently assumes compile error.
2. **Does `!` survive, and meaning what?** ADR 0015 explicitly defers it:
   rebinding sugar (`word.upcase!` ≡ `word = word.upcase`) versus "may
   panic". The corpus can size either reading once decided.
3. **Which `%` literals survive?** Affects whether `%x` shell execution is a
   separate decision or falls out of the literal cleanup.
