# nil-idiom census across RubyGems.org

Based on a random sample of 40 gems (seeded, reproducible), out of 195399 on RubyGems.org.

| Idiom | Sites | Gems using it | % of gems |
|---|---|---|---|
| nil_predicate | 504 | 21 | 52.5% |
| nil_equality | 9 | 2 | 5.0% |
| safe_navigation | 28 | 8 | 20.0% |
| or_default | 413 | 27 | 67.5% |
| or_assign | 154 | 23 | 57.5% |
| rescue_nil | 11 | 8 | 20.0% |
| truthiness_on_variable | 284 | 22 | 55.0% |
| nil_literal | 863 | 28 | 70.0% |
| fetch_bare | 48 | 6 | 15.0% |
| fetch_with_default | 5 | 4 | 10.0% |
| fetch_with_block | 3 | 2 | 5.0% |

Notes: truthiness_on_variable counts `if x` / `unless x` where the condition is a bare local or
instance variable — the sites the booleans-only rule turns into compile errors. or_default counts
all `a || b` sites (some are boolean logic, not defaulting); fetch rows are receiver-blind.

Errors: 0
