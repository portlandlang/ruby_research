# Undocumented removal candidates for Portland

Ruby features the Portland docs do not rule on, but that collide with a stated Portland principle. Each needs an explicit keep/change/remove decision (and ideally an ADR) in [portlandlang/portland](https://github.com/portlandlang/portland).

**Companion documents:** the impl repo's [ROADMAP.md](https://github.com/portlandlang/portland/blob/main/ROADMAP.md) and [issues](https://github.com/portlandlang/portland/issues) track the *named* open decisions. This file tracks the *unnamed* ones — features nothing has ruled on — and feeds measured prevalence into them. Items here graduate into `config/portland_removals.yml` once an ADR lands, which is what makes them show up in the `portland-compatibility` report.

**Reconciled against the impl repo through ADR 0089.**

## How to read the numbers

Full corpus of the 2026-07-22 snapshot, latest release of each gem (`reports/latest/feature_usage.json`). Two figures per entry:

- **Gems** — share of all gems using the construct at least once.
- **2020+** — share of the gems *using it* whose newest release shipped in 2020 or later. **The snapshot's baseline is 29.2%**, so above that means the construct is growing, below means declining. This is the figure that matters: a construct can be everywhere in the corpus and still be dying, or rare and rising.

Prevalence is a lower bound on migration cost, not an argument by itself — `for` is only 2.7% of gems and still worth removing.

## Graduated

Decided in the impl repo — by ADR, by a ledger page in `docs/ruby/`, or by its approved ruby/spec never-port lists — and no longer candidates. Bringing `config/portland_removals.yml` in line with them is [ruby_research#18](https://github.com/portlandlang/ruby_research/issues/18).

| Was a candidate | Decided by | Outcome |
|---|---|---|
| In-place mutation methods | [0015](https://github.com/portlandlang/portland/blob/main/docs/adr/0015-2026-07-23-values-never-mutate.md) | Removed. `<<` and `[]=` return as *rebinding* operators |
| `freeze` / `frozen?` / `dup` / `clone` | 0015; `docs/ruby/mutability.md` | Loud errors |
| `# frozen_string_literal:` magic comment | 0015; `docs/ruby/mutability.md` | Ignored, not an error |
| Block-parameter spellings | [0017](https://github.com/portlandlang/portland/blob/main/docs/adr/0017-2026-07-23-it-under-no-shadow.md) | `_1`–`_9` out, `it` in |
| Heredoc flavors | [0020](https://github.com/portlandlang/portland/blob/main/docs/adr/0020-2026-07-23-heredocs-squiggly-only.md) | Only `<<~`; SCREAMING_CAPS terminators |
| `*args` / `**kwargs` splats | [0014](https://github.com/portlandlang/portland/blob/main/docs/adr/0014-2026-07-22-keyword-arguments.md) | Deferred (ADR 0014); revisitable on demand |
| The exception model (`begin` / `rescue` / `raise`) | 0027, 0044 | Errors are typed results handled by the unwrap toolkit; `begin`, `rescue`, and `raise` refuse |
| `rescue` modifier (`foo rescue nil`) | 0027; `docs/ruby/errors.md` | Refused: there is no laundering form |
| `retry` / `ensure` | 0027 | Refuse with `rescue` |
| `catch` / `throw` | 0044; never-port ([portland#121](https://github.com/portlandlang/portland/issues/121)) | No non-local exit; a failure that crosses a frame is written at each one |
| Bare `super` (zsuper) | 0028 | `super` refuses: no ancestor chain |
| Singleton classes / `class << self` | 0056 (with `def self.` from 0031) | `class << self` refuses; a class method is `def self.name` in the type's body |
| Class variables (`@@foo`) | 0056 | Refuse: a value lives in a local, a field, or a constant |
| Destructuring / multiple assignment (`a, b = pair`) | `docs/ruby/pattern-matching.md`, `docs/ruby/removed-syntax.md` | Refuses; the rewrite matches the value: `pair => [a, b]` |
| `defined?` | `docs/ruby/removed-syntax.md` | Refuses ([portland#9](https://github.com/portlandlang/portland/issues/9), the inference question it was routed to, is closed) |
| `alias` / `alias_method` | 0039; `docs/ruby/aliases.md` | `alias` ships; `alias_method` refuses, naming `alias` |
| `undef` / redefinition | `docs/ruby/removed-syntax.md`; 0052 | `undef` refuses; a name is defined once, so redefinition refuses |
| `Module#prepend` | 0028 | Gone with `extend` and subclassing; `include` takes a trait |
| Module lifecycle hooks (`inherited`, `extended`, `prepended`, `method_added`) | 0028, 0052 | Moot: no subclassing, `extend`, or `prepend`, and no method added after its one definition. `included` on a trait stays a candidate below |
| Reflection queries | 0074; `docs/ruby/removed-syntax.md`, `docs/ruby/symbols.md`, `docs/ruby/metaprogramming.md` | `.class` answers the type; `is_a?`, `kind_of?`, `instance_of?`, and `respond_to?` refuse, as do `ancestors`, `instance_methods`, and kin |
| `autoload` | 0049, 0077 | Moot: `require` takes a string literal at a file's top level, so the build sees every file |
| `%` literal family | 0051 (`%r` by 0086) | `%w[]`, `%i[]`, and `%r{}` survive; the rest refuse by name. The `%x` spawn is [portland#179](https://github.com/portlandlang/portland/issues/179)'s |
| `__method__` | `docs/ruby/removed-syntax.md` | Refuses |
| The standard streams | 0068 | Ruby's `puts`, `print`, `p`, and `warn`, written over the `System` floor module |
| `Rational` / `Complex` literals (`1r`, `1i`) | 0085 | Kept: builtin values in core, with Ruby's spellings and literal suffixes |
| `ObjectSpace` | never-port ([portland#118](https://github.com/portlandlang/portland/issues/118)) | Heap reflection over an open runtime |
| `Marshal` | never-port ([portland#118](https://github.com/portlandlang/portland/issues/118)) | A value crosses a boundary as JSON (ADR 0072) |
| `binding` / `Binding` | never-port ([portland#118](https://github.com/portlandlang/portland/issues/118)) | Scopes are not values |
| Refinements (`refine` / `using`) | never-port ([portland#118](https://github.com/portlandlang/portland/issues/118)) | A definition is written once and never rewired |
| `OpenStruct` | 0064 | Declined by doctrine (`method_missing`) |
| `trap` / signals | never-port ([portland#175](https://github.com/portlandlang/portland/issues/175)) | A process-global mutable handler table, with no reentrancy story under `together` |

Corpus evidence bearing on those decisions is in [Evidence for decisions already made](#evidence-for-decisions-already-made) below — including one number that ADR 0020 explicitly asked for.

## Open, with an issue

- **`proc` vs `lambda`** — whether a block can be held in a value is [portland#77](https://github.com/portlandlang/portland/issues/77); until it rules, `proc`, `lambda`, and `->` refuse. `->` lambdas are in **7.0% of gems and strongly growing (56.6% 2020+)**. Detect: `lambda_node`, method names `proc`/`lambda`.
- **Shell execution and `fork` (backticks, `system`, `exec`, `spawn`, `popen`, `fork`)** — [portland#179](https://github.com/portlandlang/portland/issues/179), the decision ADR 0051 deferred when it took `%x` out of the literal family. **Backtick/`%x` literals in 4.9% of gems (plus 6.3% interpolated), 26.8% 2020+.** ADR 0020 removed backtick *heredocs* (`<<~\`CMD\``), which the corpus confirms are vanishingly rare — 15 sites in 7 gems. Detect: `x_string_node`, `interpolated_x_string_node`, method names.

## Priority

The five priorities the full-corpus ranking chose — the exception model, singleton classes, destructuring, `defined?` and reflection, and class variables — are all decided (see the table above). What remains below is small and mostly file furniture; none of it blocks a large share of the corpus.

## Collides with "no shared mutable runtime state"

- **`at_exit`** — runtime-registered exit hooks; sibling of the removed `BEGIN`/`END` blocks. Detect: method name.

## Collides with "no runtime metaprogramming"

- **The `included` hook on a trait** — the other lifecycle hooks are moot (ADRs 0028, 0052), but `include` survives with a trait, and nothing rules whether a trait may run code when it is included. Detect: def names.

## File furniture

- **`=begin`/`=end` blocks and `__END__`/`DATA`** — perlish file furniture the removed-syntax doc does not mention. Portland's ruby/spec manifest skips `language/predefined/` as removed with the runtime dynamism, citing `docs/ruby/removed-syntax.md`, but that page names neither.
- **`__FILE__` / `__LINE__`** — compile-time-resolvable introspection. **`__FILE__` is in 38.2% of gems**, which is higher than most things on this list, though sharply declining (16.1% 2020+) as `require_relative` and gemspec conventions replaced the `File.dirname(__FILE__)` idiom. Portland's ruby/spec manifest skips their spec files because every row reaches them through `eval`, `require`, or `load`, which is not a ruling on the names themselves. Detect: `source_file_node`, `source_line_node`.

## Evidence for decisions already made

Corpus data bearing on landed ADRs, offered back as validation or challenge.

- **ADR 0020 asked for this one.** It requires SCREAMING_CAPS terminators on the grounds that "the convention is already universal", adding: "Corpus evidence may revisit this; it is a prior, not a closed book." Measured: **94.7% of heredoc-using gems use uppercase terminators, but 6.9% use lowercase and 3.1% MixedCase** — so roughly 1 in 14 has a non-conforming terminator somewhere. Universal as a convention, not as a fact. The ADR's claim that upcasing is a free-tier autocorrect holds, so this is a migration-volume note rather than a challenge.
- **ADR 0020's `<<~`-only decision is strongly validated by the era data.** Among heredoc-using gems: `<<~` goes **0.0% → 9.3% → 64.2%** across pre-2015 / 2015–2019 / 2020+, while `<<-` falls **84.1% → 41.0%** and plain `<<` **24.7% → 10.1%**. Corpus-wide totals hide this completely (`<<-` looks dominant at 67.7% of heredoc gems); among gems still shipping, `<<~` is already the majority form. The unsafe-autocorrect population the ADR worries about is real but shrinking.
- **ADR 0020 shows multiple heredocs per line as supported** (`[<<~A, <<~B]`), and the corpus confirms it is used: **12,578 lines open two or more.** `spec/language/heredoc_spec.pdx` does not cover that case.
- **ADR 0003 (bitwise out, locked by [portland#157](https://github.com/portlandlang/portland/issues/157)) is safe** on the "rare in application code" claim, once `<<`-append is separated out: true bitwise `& | ^ ~` is **10.2% of gems**, not the 56% a combined counter suggested. `>>` alone is 2.0%.
- **ADR 0015 is the single largest migration cost in the language.** With its removals encoded, gems that would compile verbatim drop from 39.8% to **24.8%** of the full corpus — in-place mutators alone touch 47.8% of gems (93,434), the `<<` rebinding change another 45.0% (87,944), and the freeze family 29.3%. For the accumulator question specifically: of 8.7M receiver-mutation sites, only **16.3% are accumulator-shaped** (fresh local, never escapes its method) and migrate to rebinding `<<` verbatim; **48.8% mutate a shared receiver** (ivar, constant, call result), which cannot become a rebinding because the target isn't a local. That second population is the real migration work, and the `mutable` gate does not help it.
- **ADR 0017's `it` and the numbered parameters both barely exist in the corpus** — `it` in 0.1% of gems, `_1`–`_9` in 0.6% — but both are almost entirely modern (90.4% and 99.8% shipped 2020+), so prevalence understates where they are heading.
- **ADR 0027 cites the error-handling census** (`reports/latest/error_handling.json`): `begin` blocks in **42.3% of gems, 33.9% 2020+ (growing)**; `raise` sites in 48.6% of gems. Sub-shapes, as a share of gems by era (pre-2015 → 2020+):
  - rescue with a specific class: 32.3% → **41.3%** (growing)
  - rescue that swallows: 34.0% → 38.1% (flat — practice in maintained code, not a legacy artifact, and it outnumbers re-raising roughly 2:1)
  - rescue that re-raises: 15.2% → **24.4%** (growing)
  - custom error classes: 20.5% → **40.2%** (doubling — 2 in 5 modern gems define an error hierarchy, which is a lot of API surface for a Result-shaped migration to absorb)
  - the `rescue` modifier: **8.2% of gems, and the one clear decline in the group** (11.1% → 6.7% by era); the ecosystem was already moving Portland's way here
  - `ensure` in **12.0% of gems, 36.4% 2020+ (growing)**; `retry` in **3.4%, 36.4% 2020+**
- **The object-model and reflection refusals are migration volume, not fringe.** Bare `super` is in **21.3% of gems, 36.5% 2020+ (growing)**; `class << self` and kin in **24.9%, 36.3% 2020+ (growing)**; destructuring in **27.1%, steady in every era** (29.5% of pre-2015 gems, 30.5% of 2020+); `defined?` in **17.7%, 36.3% 2020+ (growing)**; `alias` in **10.0%, flat across eras**; class variables in **9.3%, 20.2% 2020+ (declining)**; `undef` in **1.1%, 18.0% 2020+ (declining)**. `Rational`/`Complex` literals, kept by ADR 0085, are in 0.1% and 0.0% of gems.

## Answered questions from the impl repo

Places where a decision's *scope* had been unclear enough to affect measurement:

1. **Do `freeze`/`dup`/`clone` fail to compile, or are they accepted no-ops?** Loud errors; the magic comment alone is ignored ([mutability.md](https://github.com/portlandlang/portland/blob/main/docs/ruby/mutability.md)), which is what `portland_removals.yml` assumed.
2. **Does `!` survive, and meaning what?** It survives as part of a method's name (ADR 0044). Bang mutators are unknown-method errors whose rewrite is rebinding, and whether `!` returns as sugar for exactly that rebinding stays deferred (ADR 0015 §5); [ruby_research#3](https://github.com/portlandlang/ruby_research/issues/3) sizes the two readings.
3. **Which `%` literals survive?** `%w[]`, `%i[]`, and `%r{}` (ADR 0051, with `%r` ruled by ADR 0086). `%x` refuses as a literal, and process spawning is its own decision, [portland#179](https://github.com/portlandlang/portland/issues/179).
