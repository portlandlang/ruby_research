# Mutation-site shapes across RubyGems.org

Sampled 50 gems (seeded, reproducible) out of 195399 on RubyGems.org; 1713 receiver-mutation sites classified inside method bodies.

| Shape | Sites | % of sites | Gems |
|---|---|---|---|
| accumulator | 280 | 16.3% | 24 |
| escaped_local | 83 | 4.8% | 12 |
| aliased_local | 536 | 31.3% | 26 |
| shared_receiver | 788 | 46.0% | 32 |
| implicit_self | 26 | 1.5% | 4 |

accumulator sites (fresh local container, never escapes its method mid-build) migrate to
rebinding `<<` verbatim. escaped_local and shared_receiver sites are the aliasing population
that a behavior change would need loud lints for. Static heuristic — escape detection is
conservative and mutator matching is receiver-blind; treat accumulator as a lower bound.

Errors: 0
