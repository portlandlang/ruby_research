# Mutation-site shapes across RubyGems.org

Based on a random sample of 40 gems (seeded, reproducible), out of 195399 on RubyGems.org; 1419 receiver-mutation sites classified inside method bodies.

| Shape | Sites | % of sites | Gems |
|---|---|---|---|
| accumulator | 248 | 17.5% | 20 |
| escaped_local | 80 | 5.6% | 11 |
| aliased_local | 391 | 27.6% | 20 |
| shared_receiver | 674 | 47.5% | 26 |
| implicit_self | 26 | 1.8% | 4 |

accumulator sites (fresh local container, never escapes its method mid-build) migrate to
rebinding `<<` verbatim. escaped_local and shared_receiver sites are the aliasing population
that a behavior change would need loud lints for. Static heuristic — escape detection is
conservative and mutator matching is receiver-blind; treat accumulator as a lower bound.

Errors: 0
