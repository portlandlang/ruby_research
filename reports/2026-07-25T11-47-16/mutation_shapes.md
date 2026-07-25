# Mutation-site shapes across RubyGems.org

Sampled 100 gems (seeded, reproducible) out of 195399 on RubyGems.org; 9334 receiver-mutation sites classified inside method bodies.

| Shape | Sites | % of sites | Gems |
|---|---|---|---|
| accumulator | 1565 | 16.8% | 37 |
| escaped_local | 2859 | 30.6% | 21 |
| aliased_local | 3337 | 35.8% | 43 |
| shared_receiver | 1372 | 14.7% | 54 |
| implicit_self | 201 | 2.2% | 6 |

accumulator sites (fresh local container, never escapes its method mid-build) migrate to
rebinding `<<` verbatim. escaped_local and shared_receiver sites are the aliasing population
that a behavior change would need loud lints for. Static heuristic — escape detection is
conservative and mutator matching is receiver-blind; treat accumulator as a lower bound.

Errors: 0
