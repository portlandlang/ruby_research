# Ordering census across RubyGems.org

Based on all 195390 gems, out of 195399 on RubyGems.org.

## Who defines an ordering

| Fact | Sites | Gems | % of analyzed gems |
|---|---:|---:|---:|
| defines `<=>` | 10734 | 4940 | 2.5% |
| `include Comparable` | 6269 | 2907 | 1.5% |
| reads a `<=>` result as an integer | 1795 | 728 | 0.4% |

## What a `<=>` body does

| Shape | Definitions | % of definitions |
|---|---:|---:|
| computes | 6344 | 59.1% |
| delegates to a part | 4111 | 38.3% |
| compares parts as an array | 279 | 2.6% |

## Ordering at the call site

| Call | Sites | Gems | % of analyzed gems |
|---|---:|---:|---:|
| `sort` | 102493 | 22036 | 11.3% |
| `max` | 50362 | 11920 | 6.1% |
| `min` | 39290 | 9951 | 5.1% |
| `sort_by` | 37822 | 11294 | 5.8% |
| `<=> in an expression` | 32293 | 7551 | 3.9% |
| `between?` | 10242 | 2456 | 1.3% |
| `sort with a block` | 9508 | 4718 | 2.4% |
| `clamp` | 5946 | 1065 | 0.5% |
| `max_by` | 3523 | 1761 | 0.9% |
| `min_by` | 1984 | 1111 | 0.6% |
| `max with a block` | 1114 | 755 | 0.4% |
| `min with a block` | 470 | 285 | 0.1% |

## By era

Share of gems in each cohort exhibiting the row.

| Fact | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| <=> body compares parts as an array | 0.1% | 0.1% | 0.1% |
| <=> body computes | 1.1% | 1.7% | 1.4% |
| <=> body delegates to a part | 1.1% | 1.4% | 1.6% |
| <=> in an expression | 2.8% | 3.4% | 5.1% |
| between? | 1.1% | 2.5% | 0.5% |
| clamp | 0.1% | 1.8% | 0.0% |
| defines <=> | 2.0% | 2.7% | 2.8% |
| includes Comparable | 1.3% | 1.7% | 1.5% |
| max | 4.2% | 9.6% | 5.1% |
| max with a block | 0.2% | 0.4% | 0.5% |
| max_by | 0.7% | 2.0% | 0.3% |
| min | 3.3% | 8.0% | 4.4% |
| min with a block | 0.1% | 0.1% | 0.2% |
| min_by | 0.3% | 1.4% | 0.1% |
| reads <=> result as an integer | 0.2% | 0.5% | 0.4% |
| sort | 7.9% | 13.1% | 12.7% |
| sort with a block | 1.8% | 2.0% | 3.3% |
| sort_by | 4.3% | 8.8% | 4.7% |

Cohort sizes: 2015-2019 63172, 2020+ 57101, pre-2015 75117 (195390 gems). Cells are the share of gems in that cohort exhibiting the row, so columns are comparable to each other and to how large the cohort is overall.

Errors: 9
