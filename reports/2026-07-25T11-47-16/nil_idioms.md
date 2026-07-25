# nil-idiom census across RubyGems.org

Sampled 100 gems (seeded, reproducible) out of 195399 on RubyGems.org.

| Idiom | Sites | Gems using it | % of gems |
|---|---|---|---|
| nil_predicate | 4460 | 49 | 49.0% |
| nil_equality | 32 | 7 | 7.0% |
| safe_navigation | 33 | 10 | 10.0% |
| or_default | 2940 | 56 | 56.0% |
| or_assign | 573 | 47 | 47.0% |
| rescue_nil | 29 | 11 | 11.0% |
| truthiness_on_variable | 838 | 43 | 43.0% |
| nil_literal | 3356 | 64 | 64.0% |
| fetch_bare | 51 | 7 | 7.0% |
| fetch_with_default | 21 | 9 | 9.0% |
| fetch_with_block | 8 | 5 | 5.0% |

Notes: truthiness_on_variable counts `if x` / `unless x` where the condition is a bare local or
instance variable — the sites the booleans-only rule turns into compile errors. or_default counts
all `a || b` sites (some are boolean logic, not defaulting); fetch rows are receiver-blind.

Errors: 0
