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

### Share of gems

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

Cohort sizes: 2015-2019 63172, 2020+ 57101, pre-2015 75117 (195390 gems). Cells are the share of gems in that cohort exhibiting the row, so columns are comparable to each other and to how large the cohort is overall.

### Composition of nil-handling sites

Whether `&.` is a maintainer's default reach or an occasional flourish — gem share cannot
tell those apart, and the answer decides how central safe navigation is to the idiom set.

| Idiom | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| fetch_bare | 1.2% | 0.2% | 0.7% |
| fetch_with_block | 0.4% | 0.0% | 0.1% |
| fetch_with_default | 1.3% | 0.2% | 0.5% |
| nil_equality | 1.1% | 0.2% | 1.7% |
| nil_literal | 41.0% | 86.3% | 48.1% |
| nil_predicate | 14.4% | 5.4% | 8.1% |
| or_assign | 9.6% | 1.1% | 9.2% |
| or_default | 15.6% | 3.5% | 16.3% |
| rescue_nil | 0.5% | 0.0% | 0.8% |
| safe_navigation | 0.4% | 0.7% | 0.0% |
| truthiness_on_variable | 14.5% | 2.2% | 14.6% |

Sites per cohort: 2015-2019 1885458, 2020+ 39762862, pre-2015 2615420 (44263740 sites). Cells are the share of that cohort's sites, so each column sums to 100%. This is scale-free: it says what the code is made of, not how much code there is.

### Density

If total nil handling falls while `&.` share rises, the ecosystem is consolidating on one
spelling rather than simply adding another.

| Idiom | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| fetch_bare | 11.7 | 13.9 | 6.5 |
| fetch_with_block | 4.1 | 2.7 | 1.4 |
| fetch_with_default | 13.0 | 12.1 | 4.4 |
| nil_equality | 11.0 | 14.6 | 16.2 |
| nil_literal | 400.7 | 5153.7 | 466.9 |
| nil_predicate | 141.0 | 324.4 | 78.8 |
| or_assign | 93.6 | 67.0 | 89.3 |
| or_default | 152.7 | 212.1 | 158.2 |
| rescue_nil | 4.4 | 1.8 | 7.7 |
| safe_navigation | 3.6 | 41.5 | 0.0 |
| truthiness_on_variable | 141.3 | 131.2 | 142.3 |

AST nodes per cohort: 2015-2019 192950808, 2020+ 665506121, pre-2015 269169327 (1127626256 nodes). Cells are sites per 100,000 AST nodes — how much of this construct per unit of code, independent of gem size.

Notes: truthiness_on_variable counts `if x` / `unless x` where the condition is a bare local or
instance variable — the sites the booleans-only rule turns into compile errors. or_default counts
all `a || b` sites (some are boolean logic, not defaulting); fetch rows are receiver-blind.

Errors: 9
