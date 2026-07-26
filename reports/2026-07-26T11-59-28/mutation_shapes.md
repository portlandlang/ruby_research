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

### Share of gems

| Shape | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| accumulator | 27.6% | 37.0% | 32.9% |
| aliased_local | 39.0% | 48.3% | 44.9% |
| escaped_local | 14.8% | 20.7% | 17.2% |
| implicit_self | 4.5% | 6.5% | 6.4% |
| shared_receiver | 44.1% | 54.1% | 51.7% |

Cohort sizes: 2015-2019 63172, 2020+ 57101, pre-2015 75117 (195390 gems). Cells are the share of gems in that cohort exhibiting the row, so columns are comparable to each other and to how large the cohort is overall.

### Composition of mutation sites

| Shape | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| accumulator | 22.5% | 22.0% | 7.1% |
| aliased_local | 31.2% | 39.5% | 13.2% |
| escaped_local | 7.3% | 6.9% | 3.7% |
| implicit_self | 1.3% | 0.6% | 0.6% |
| shared_receiver | 37.7% | 31.0% | 75.4% |

Sites per cohort: 2015-2019 1029150, 2020+ 4347584, pre-2015 3338028 (8714762 sites). Cells are the share of that cohort's sites, so each column sums to 100%. This is scale-free: it says what the code is made of, not how much code there is.

### Density

| Shape | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| accumulator | 120.0 | 143.6 | 87.5 |
| aliased_local | 166.2 | 258.1 | 163.7 |
| escaped_local | 39.0 | 45.0 | 45.4 |
| implicit_self | 6.8 | 3.8 | 7.8 |
| shared_receiver | 201.3 | 202.8 | 935.6 |

AST nodes per cohort: 2015-2019 192950808, 2020+ 665506121, pre-2015 269169327 (1127626256 nodes). Cells are sites per 100,000 AST nodes — how much of this construct per unit of code, independent of gem size.

## By how many gems depend on the gem

Whether widely-depended-on gems mutate differently from leaf gems.

**Read the composition and density tables, not the gem-share one.** Every shape rises
monotonically with dependent count in the gem-share view, but only because widely-used gems
contain more code and so exhibit more of everything. Gem share cannot separate "popular gems
mutate differently" from "popular gems are bigger"; the other two views can.

### Share of gems (confounded by code volume — see above)

| Shape | 0 | 1-3 | 100+ | 11-100 | 4-10 |
|---|---|---|---|---|---|
| accumulator | 30.2% | 43.4% | 77.2% | 62.0% | 52.6% |
| aliased_local | 41.3% | 58.5% | 88.7% | 77.2% | 69.5% |
| escaped_local | 16.2% | 22.5% | 57.3% | 38.8% | 31.7% |
| implicit_self | 5.1% | 8.8% | 31.7% | 18.9% | 14.1% |
| shared_receiver | 47.6% | 62.8% | 90.3% | 79.2% | 73.2% |

Cohort sizes: 0 169830, 1-3 19932, 100+ 382, 11-100 1923, 4-10 3323 (195390 gems). Cells are the share of gems in that cohort exhibiting the row, so columns are comparable to each other and to how large the cohort is overall.

### Composition of mutation sites

| Shape | 0 | 1-3 | 100+ | 11-100 | 4-10 |
|---|---|---|---|---|---|
| accumulator | 13.4% | 29.2% | 8.4% | 45.9% | 20.9% |
| aliased_local | 27.7% | 32.5% | 21.9% | 29.7% | 34.3% |
| escaped_local | 5.6% | 7.4% | 3.9% | 3.7% | 5.8% |
| implicit_self | 0.6% | 1.0% | 1.0% | 0.8% | 0.7% |
| shared_receiver | 52.7% | 30.0% | 64.7% | 19.9% | 38.4% |

Sites per cohort: 0 7070992, 1-3 897243, 100+ 111598, 11-100 299950, 4-10 334979 (8714762 sites). Cells are the share of that cohort's sites, so each column sums to 100%. This is scale-free: it says what the code is made of, not how much code there is.

### Density

| Shape | 0 | 1-3 | 100+ | 11-100 | 4-10 |
|---|---|---|---|---|---|
| accumulator | 111.5 | 162.4 | 59.4 | 276.1 | 129.4 |
| aliased_local | 231.4 | 180.9 | 154.3 | 178.6 | 212.7 |
| escaped_local | 46.7 | 41.2 | 27.4 | 22.5 | 35.7 |
| implicit_self | 5.3 | 5.4 | 7.3 | 4.6 | 4.6 |
| shared_receiver | 440.1 | 166.8 | 455.3 | 120.1 | 238.0 |

AST nodes per cohort: 0 846794636, 1-3 161157546, 100+ 15858455, 11-100 49831066, 4-10 53984553 (1127626256 nodes). Cells are sites per 100,000 AST nodes — how much of this construct per unit of code, independent of gem size.

accumulator sites (fresh local container, never escapes its method mid-build) migrate to
rebinding `<<` verbatim. escaped_local and shared_receiver sites are the aliasing population
that a behavior change would need loud lints for. Static heuristic — escape detection is
conservative and mutator matching is receiver-blind; treat accumulator as a lower bound.

Errors: 9
