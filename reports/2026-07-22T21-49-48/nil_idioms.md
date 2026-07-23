# nil-idiom census across RubyGems.org

Sampled 50 gems (seeded, reproducible) out of 195399 on RubyGems.org.

| Idiom | Sites | Gems using it | % of gems |
|---|---|---|---|
| nil_predicate | 680 | 28 | 56.0% |
| nil_equality | 20 | 3 | 6.0% |
| safe_navigation | 32 | 9 | 18.0% |
| or_default | 453 | 34 | 68.0% |
| or_assign | 255 | 27 | 54.0% |
| rescue_nil | 11 | 8 | 16.0% |
| truthiness_on_variable | 338 | 27 | 54.0% |
| nil_literal | 1156 | 36 | 72.0% |
| fetch_bare | 48 | 6 | 12.0% |
| fetch_with_default | 15 | 5 | 10.0% |
| fetch_with_block | 3 | 2 | 4.0% |

Notes: truthiness_on_variable counts `if x` / `unless x` where the condition is a bare local or
instance variable — the sites the booleans-only rule turns into compile errors. or_default counts
all `a || b` sites (some are boolean logic, not defaulting); fetch rows are receiver-blind.

Errors: 0
