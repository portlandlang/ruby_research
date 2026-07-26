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

Cohort sizes: 2015-2019 63172, 2020+ 57101, pre-2015 75117 (195390 gems). Percentages are of the gems within each cohort, so rows are comparable across columns; compare a column against how large that cohort is overall.

Notes: rescue_reraises means the rescue body contains a raise/fail call; rescue_swallows is the complement.
custom_error_class counts classes whose superclass name ends in Error/Exception.

Errors: 9
