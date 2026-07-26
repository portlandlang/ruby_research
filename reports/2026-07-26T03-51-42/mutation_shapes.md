# Mutation-site shapes across RubyGems.org

Based on all 195390 gems, out of 195399 on RubyGems.org; 8714762 receiver-mutation sites classified inside method bodies.

| Shape | Sites | % of sites | Gems |
|---|---|---|---|
| accumulator | 1422662 | 16.3% | 63212 |
| escaped_local | 496995 | 5.7% | 34088 |
| aliased_local | 2479396 | 28.5% | 85973 |
| shared_receiver | 4256234 | 48.8% | 97579 |
| implicit_self | 59475 | 0.7% | 11362 |

## By era

| Shape | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| accumulator | 27.6% | 37.0% | 32.9% |
| aliased_local | 39.0% | 48.3% | 44.9% |
| escaped_local | 14.8% | 20.7% | 17.2% |
| implicit_self | 4.5% | 6.5% | 6.4% |
| shared_receiver | 44.1% | 54.1% | 51.7% |

Cohort sizes: 2015-2019 63172, 2020+ 57101, pre-2015 75117 (195390 gems). Percentages are of the gems within each cohort, so rows are comparable across columns; compare a column against how large that cohort is overall.

## By how many gems depend on the gem

Whether widely-depended-on gems mutate differently from leaf gems.

| Shape | 0 | 1-3 | 100+ | 11-100 | 4-10 |
|---|---|---|---|---|---|
| accumulator | 30.2% | 43.4% | 77.2% | 62.0% | 52.6% |
| aliased_local | 41.3% | 58.5% | 88.7% | 77.2% | 69.5% |
| escaped_local | 16.2% | 22.5% | 57.3% | 38.8% | 31.7% |
| implicit_self | 5.1% | 8.8% | 31.7% | 18.9% | 14.1% |
| shared_receiver | 47.6% | 62.8% | 90.3% | 79.2% | 73.2% |

Cohort sizes: 0 169830, 1-3 19932, 100+ 382, 11-100 1923, 4-10 3323 (195390 gems). Percentages are of the gems within each cohort, so rows are comparable across columns; compare a column against how large that cohort is overall.

accumulator sites (fresh local container, never escapes its method mid-build) migrate to
rebinding `<<` verbatim. escaped_local and shared_receiver sites are the aliasing population
that a behavior change would need loud lints for. Static heuristic — escape detection is
conservative and mutator matching is receiver-blind; treat accumulator as a lower bound.

Errors: 9
