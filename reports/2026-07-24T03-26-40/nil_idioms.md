# nil-idiom census across RubyGems.org

Sampled 500 gems (seeded, reproducible) out of 195399 on RubyGems.org.

| Idiom | Sites | Gems using it | % of gems |
|---|---|---|---|
| nil_predicate | 11066 | 179 | 35.8% |
| nil_equality | 282 | 40 | 8.0% |
| safe_navigation | 1277 | 36 | 7.2% |
| or_default | 7736 | 245 | 49.0% |
| or_assign | 2374 | 214 | 42.8% |
| rescue_nil | 81 | 28 | 5.6% |
| truthiness_on_variable | 4809 | 208 | 41.6% |
| nil_literal | 520538 | 277 | 55.4% |
| fetch_bare | 423 | 32 | 6.4% |
| fetch_with_default | 367 | 42 | 8.4% |
| fetch_with_block | 79 | 18 | 3.6% |

Notes: truthiness_on_variable counts `if x` / `unless x` where the condition is a bare local or
instance variable — the sites the booleans-only rule turns into compile errors. or_default counts
all `a || b` sites (some are boolean logic, not defaulting); fetch rows are receiver-blind.

Errors: 0
