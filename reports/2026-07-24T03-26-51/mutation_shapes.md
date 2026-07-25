# Mutation-site shapes across RubyGems.org

Sampled 500 gems (seeded, reproducible) out of 195399 on RubyGems.org; 29035 receiver-mutation sites classified inside method bodies.

| Shape | Sites | % of sites | Gems |
|---|---|---|---|
| accumulator | 4421 | 15.2% | 144 |
| escaped_local | 4479 | 15.4% | 85 |
| aliased_local | 8353 | 28.8% | 201 |
| shared_receiver | 11503 | 39.6% | 250 |
| implicit_self | 279 | 1.0% | 24 |

accumulator sites (fresh local container, never escapes its method mid-build) migrate to
rebinding `<<` verbatim. escaped_local and shared_receiver sites are the aliasing population
that a behavior change would need loud lints for. Static heuristic — escape detection is
conservative and mutator matching is receiver-blind; treat accumulator as a lower bound.

Errors: 0
