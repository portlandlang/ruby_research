# Undocumented removal candidates for Portland

Ruby features the Portland docs don't yet rule on, but that collide with a
stated Portland principle. Each needs an explicit keep/change/remove decision
(and ideally an ADR) in portlandlang/portland. "Sample prevalence" is how many
gems out of the 50-gem feature-usage sample use the feature at least once
(reports/latest/feature_usage.json); syntax-level detection is noted so
`config/portland_removals.yml` can pick each one up the moment it's decided.

## Collides with "no shared mutable runtime state"

- **Class variables (`@@foo`)** — shared, hierarchy-wide mutable state; widely
  considered a Ruby design mistake. Sample prevalence: 7/50 gems.
  Detect: `class_variable_*` node types.
- **`ObjectSpace`** — enumerate/introspect every live object at runtime.
  Detect: constant `ObjectSpace`.
- **`at_exit`** — runtime-registered exit hooks; END-block sibling (BEGIN/END
  are already removed). Detect: method name `at_exit`.
- **`Marshal`** — runtime serialization of arbitrary object graphs; unsafe
  loads, depends on the mutable object model. Detect: constant `Marshal`.

## Collides with "no runtime metaprogramming / what you read is what runs"

- **`alias` keyword and `alias_method`** — runtime method-table mutation. The
  perlism doc removes `alias $new $old` for globals implicitly (globals are
  gone) but never rules on method aliasing. Sample prevalence: 5/50 gems.
  Detect: `alias_method_node`, method name `alias_method`.
- **`undef` / `undef_method` / `remove_method`** — runtime method deletion.
  Sample prevalence: 0/50. Detect: `undef_node`, method names.
- **Refinements (`refine` / `using`)** — scoped monkeypatching; open-classes
  ADR territory but never named. Detect: method names `refine`, `using`.
- **Singleton classes and per-object methods (`class << self`, `def obj.foo`,
  `define_singleton_method`)** — per-object method tables. `class << self` is
  also the idiomatic class-method spelling, so removal needs a blessed
  replacement. Sample prevalence: 17/50 gems. Detect: `singleton_class_node`.
- **Module lifecycle hooks (`inherited`, `included`, `extended`, `prepended`,
  `method_added`)** — runtime callbacks that rewrite classes as they load;
  the engine of most Ruby DSL magic. Detect: def names.
- **`Module#prepend`** — runtime method interception (AOP). `include`/`extend`
  presumably survive as compile-time composition, but that line is undrawn.
  Detect: method name `prepend`.
- **`binding` / `Binding`** — reify a scope as a runtime object. Detect:
  method name `binding`, constant `Binding`.
- **`defined?`** — runtime existence reflection; under static typing it's
  either always answerable at compile time or meaningless. Sample prevalence:
  14/50 gems. Detect: `defined_node`.
- **Reflection query family (`respond_to?`, `is_a?`, `kind_of?`,
  `instance_of?`, `.class`, `.methods`)** — runtime type interrogation vs
  compile-time structural typing; `case/in` narrowing presumably replaces
  some of it. Detect: method names.
- **`OpenStruct`** — built on method_missing, which is already removed;
  needs an explicit "gone, use X" note. Detect: constant `OpenStruct`.
- **`autoload`** — runtime lazy constant loading. Detect: method name.

## Collides with "never panics implicitly / loud errors"

- **Exceptions as a whole (`raise` / `rescue` / `ensure` / `retry`)** — the
  docs establish maybes + `or panic` for partial operations but never say
  whether raise/rescue survives for genuinely exceptional errors, becomes a
  Result type, or disappears. Biggest undocumented decision on this list.
  Sample prevalence: begin 23/50, ensure 5/50, retry 1/50.
- **`rescue` modifier (`foo rescue nil`)** — silently swallows StandardError;
  the anti-loud spelling. Sample prevalence: 8/50 gems.
  Detect: `rescue_modifier_node`.
- **`catch` / `throw`** — non-local control flow that isn't an error.
  Detect: method names `catch`, `throw`.
- **Bare `super` (zsuper)** — implicitly forwards the caller's arguments;
  quiet action at a distance. Sample prevalence: 15/50 gems.
  Detect: `forwarding_super_node`.

## Collides with "one way to do it" (the and/or/not precedent)

- **`proc` vs `lambda`** — two callables with different return/arity
  semantics; the and/or precedent suggests collapsing to one. Sample
  prevalence: `->` lambdas 3/50 (blocks are separate). Detect:
  `lambda_node`, method names `proc`, `lambda`.
- **Block-parameter spellings (`|x|` vs `_1` vs `it`)** — three ways to name
  the same thing. Sample prevalence: numbered params 0/50, `it` 0/50 (corpus
  still pre-3.4). Detect: `numbered_parameters_node`, `it_parameters_node`.
- **`%` literal zoo (`%w` `%i` `%q` `%r` `%s` `%x`)** — which survive?
  `%x{}` backtick-alias belongs with shell execution below. Detect: opening
  location on string/array literal nodes.
- **Multiple assignment / destructuring (`a, b = b, a`)** — docs already mark
  destructuring undecided; listed here so it gets an ADR. Sample prevalence:
  14/50 gems. Detect: `multi_write_node`.
- **`=begin`/`=end` comment blocks and `__END__`/`DATA`** — perlish file
  furniture the removed-syntax doc doesn't mention. Detect: comments/DATA
  constant.

## Collides with immutability / typed-values direction

- **In-place mutation methods** — bang mutators (`map!`, `sort!`, `gsub!`,
  `merge!`, …) and the non-bang mutators that change receivers just as much
  (`push`, `pop`, `clear`, `delete`, `concat`, `replace`, `[]=`, `<<`).
  Receiver mutation is a separate decision from `mutable`-marked rebinding,
  and the docs' undecided "mutable values" question covers it only
  implicitly. Also needs a ruling on the `!` convention itself: if nothing
  mutates, does `!` retire, or get redefined (e.g. "may panic")? Sample
  prevalence: bang mutators 24/50 gems, non-bang mutators 39/50, either
  42/50 — the widest-reaching item on this list. Detect: `call_node` names
  ending in `!` (minus non-mutating bangs like `exit!`) plus a curated
  mutator list.
- **`freeze` / `frozen?` / `dup` / `clone`** — under immutable-by-default
  these are redundant, meaningless, or need redefined semantics (travels
  with the undecided mutable-values question). Detect: method names.
- **Magic comments (`# frozen_string_literal: true`)** — obsolete if strings
  are immutable values; needs an explicit "not needed, not an error" ruling
  for migration.

## Platform / process surface (macOS-only, compiled binary)

- **Shell execution (backticks, `%x{}`, `system`, `exec`, `spawn`,
  `` Kernel#` ``)** — string-to-shell is a major injection surface; a
  compiled macOS-native language could require a structured process API.
  Sample prevalence: x-string nodes 7/50 gems. Detect: `x_string_node`,
  `interpolated_x_string_node`, method names.
- **`fork` / `trap` / signals** — POSIX process model vs the together/
  meanwhile runtime; undocumented. Detect: method names.
- **`$stdin`/`$stdout`/`$stderr` replacements** — globals are removed, but
  the docs don't name the blessed spelling for the standard streams
  (`STDOUT` constants? a named API?). Every CLI gem needs the answer.

## Numeric / literal odds and ends

- **`Rational` / `Complex` literals (`1r`, `1i`)** — niche literal syntax;
  keep, or make them library types? Sample prevalence: 0/50 each.
  Detect: `rational_node`, `imaginary_node`.
- **`__FILE__` / `__LINE__` / `__method__`** — compile-time-resolvable
  introspection; presumably fine as macro-style constants, but unstated.
  Sample prevalence: `__FILE__` 20/50 gems. Detect: `source_file_node`,
  `source_line_node`.
