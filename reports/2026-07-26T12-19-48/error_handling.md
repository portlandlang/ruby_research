# Error-handling census across RubyGems.org

Based on all 195390 gems, out of 195399 on RubyGems.org.

| Shape | Sites | Gems using it | % of gems |
|---|---|---|---|
| raise_site | 2332536 | 95005 | 48.6% |
| rescue_clause | 703746 | 75238 | 38.5% |
| rescue_specific_class | 579536 | 64425 | 33.0% |
| rescue_bare | 124210 | 29158 | 14.9% |
| rescue_reraises | 249779 | 33704 | 17.2% |
| rescue_swallows | 453967 | 64748 | 33.1% |
| rescue_modifier | 68545 | 15935 | 8.2% |
| ensure_block | 123460 | 23425 | 12.0% |
| retry_site | 15786 | 6679 | 3.4% |
| custom_error_class | 225954 | 50540 | 25.9% |

## By era

Share of gems in each cohort using each shape, so legacy practice can be told apart from
current practice.

### Share of gems

| Shape | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| custom_error_class | 19.4% | 40.2% | 20.5% |
| ensure_block | 8.4% | 14.9% | 12.8% |
| raise_site | 42.7% | 56.9% | 47.3% |
| rescue_bare | 13.7% | 14.1% | 16.5% |
| rescue_clause | 32.5% | 45.4% | 38.3% |
| rescue_modifier | 5.9% | 6.7% | 11.1% |
| rescue_reraises | 13.2% | 24.4% | 15.2% |
| rescue_specific_class | 26.3% | 41.3% | 32.3% |
| rescue_swallows | 27.6% | 38.1% | 34.0% |
| retry_site | 2.7% | 4.3% | 3.4% |

Cohort sizes: 2015-2019 63172, 2020+ 57101, pre-2015 75117 (195390 gems). Cells are the share of gems in that cohort exhibiting the row, so columns are comparable to each other and to how large the cohort is overall.

### Composition of error-handling sites

Gem share says how many gems do something somewhere, which a single sloppy rescue in a large
gem triggers. Composition says how the average site is actually written.

| Shape | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| custom_error_class | 6.3% | 3.7% | 6.0% |
| ensure_block | 3.5% | 1.8% | 3.8% |
| raise_site | 39.7% | 54.0% | 36.0% |
| rescue_bare | 3.9% | 1.7% | 4.0% |
| rescue_clause | 16.0% | 13.2% | 16.8% |
| rescue_modifier | 1.9% | 0.7% | 3.1% |
| rescue_reraises | 4.3% | 5.8% | 3.9% |
| rescue_specific_class | 12.1% | 11.5% | 12.9% |
| rescue_swallows | 11.7% | 7.4% | 12.9% |
| retry_site | 0.5% | 0.2% | 0.5% |

Sites per cohort: 2015-2019 771185, 2020+ 3035283, pre-2015 1071051 (4877519 sites). Cells are the share of that cohort's sites, so each column sums to 100%. This is scale-free: it says what the code is made of, not how much code there is.

### Density

| Shape | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| custom_error_class | 25.1 | 17.0 | 24.0 |
| ensure_block | 14.1 | 8.4 | 15.1 |
| raise_site | 158.8 | 246.4 | 143.4 |
| rescue_bare | 15.7 | 7.7 | 15.8 |
| rescue_clause | 64.0 | 60.1 | 67.0 |
| rescue_modifier | 7.5 | 3.1 | 12.4 |
| rescue_reraises | 17.1 | 26.3 | 15.5 |
| rescue_specific_class | 48.3 | 52.3 | 51.2 |
| rescue_swallows | 46.9 | 33.8 | 51.5 |
| retry_site | 2.0 | 1.0 | 2.1 |

AST nodes per cohort: 2015-2019 192950808, 2020+ 665506121, pre-2015 269169327 (1127626256 nodes). Cells are sites per 100,000 AST nodes — how much of this construct per unit of code, independent of gem size.

Notes: rescue_reraises means the rescue body contains a raise/fail call; rescue_swallows is the complement.
custom_error_class counts classes whose superclass name ends in Error/Exception.

Errors: 9
