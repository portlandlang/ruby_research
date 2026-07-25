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

Notes: truthiness_on_variable counts `if x` / `unless x` where the condition is a bare local or
instance variable — the sites the booleans-only rule turns into compile errors. or_default counts
all `a || b` sites (some are boolean logic, not defaulting); fetch rows are receiver-blind.

Errors: 9
