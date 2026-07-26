# nil-idiom census across RubyGems.org

Based on all 195390 gems, out of 195399 on RubyGems.org.

| Idiom | Sites | Gems using it | % of gems |
|---|---|---|---|
| nil_predicate | 2642995 | 74076 | 37.9% |
| nil_equality | 161922 | 13746 | 7.0% |
| safe_navigation | 282899 | 16570 | 8.5% |
| or_default | 2131977 | 102659 | 52.5% |
| or_assign | 866873 | 84213 | 43.1% |
| rescue_nil | 41455 | 9828 | 5.0% |
| truthiness_on_variable | 1528554 | 89621 | 45.9% |
| nil_literal | 36327790 | 113473 | 58.1% |
| fetch_bare | 132235 | 13192 | 6.8% |
| fetch_with_default | 117487 | 17087 | 8.7% |
| fetch_with_block | 29553 | 6669 | 3.4% |

## By era

Share of gems in each cohort using each idiom — whether `&.` is displacing `.nil?` in
maintained code, and whether truthiness testing is on the way out.

| Idiom | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| fetch_bare | 6.2% | 11.1% | 3.9% |
| fetch_with_block | 3.0% | 6.2% | 1.7% |
| fetch_with_default | 7.0% | 16.9% | 4.0% |
| nil_equality | 6.1% | 5.3% | 9.1% |
| nil_literal | 52.2% | 64.9% | 57.8% |
| nil_predicate | 32.6% | 47.9% | 34.8% |
| or_assign | 38.4% | 48.1% | 43.2% |
| or_default | 46.0% | 60.4% | 52.1% |
| rescue_nil | 3.4% | 4.3% | 6.9% |
| safe_navigation | 2.4% | 26.4% | 0.0% |
| truthiness_on_variable | 39.5% | 54.4% | 44.7% |

Cohort sizes: 2015-2019 63172, 2020+ 57101, pre-2015 75117 (195390 gems). Percentages are of the gems within each cohort, so rows are comparable across columns; compare a column against how large that cohort is overall.

Notes: truthiness_on_variable counts `if x` / `unless x` where the condition is a bare local or
instance variable — the sites the booleans-only rule turns into compile errors. or_default counts
all `a || b` sites (some are boolean logic, not defaulting); fetch rows are receiver-blind.

Errors: 9
