# Mutation-site shapes across RubyGems.org

Based on all 195390 gems, out of 195399 on RubyGems.org; 8714762 receiver-mutation sites classified inside method bodies.

| Shape | Sites | % of sites | Gems |
|---|---|---|---|
| accumulator | 1422662 | 16.3% | 63212 |
| escaped_local | 496995 | 5.7% | 34088 |
| aliased_local | 2479396 | 28.5% | 85973 |
| shared_receiver | 4256234 | 48.8% | 97579 |
| implicit_self | 59475 | 0.7% | 11362 |

accumulator sites (fresh local container, never escapes its method mid-build) migrate to
rebinding `<<` verbatim. escaped_local and shared_receiver sites are the aliasing population
that a behavior change would need loud lints for. Static heuristic — escape detection is
conservative and mutator matching is receiver-blind; treat accumulator as a lower bound.

Errors: 9
