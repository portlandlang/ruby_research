# Error-handling census across RubyGems.org

Sampled 100 gems (seeded, reproducible) out of 195399 on RubyGems.org.

| Shape | Sites | Gems using it | % of gems |
|---|---|---|---|
| raise_site | 3609 | 59 | 59.0% |
| rescue_clause | 484 | 37 | 37.0% |
| rescue_specific_class | 300 | 33 | 33.0% |
| rescue_bare | 184 | 16 | 16.0% |
| rescue_reraises | 187 | 21 | 21.0% |
| rescue_swallows | 297 | 29 | 29.0% |
| rescue_modifier | 61 | 13 | 13.0% |
| ensure_block | 134 | 9 | 9.0% |
| retry_site | 7 | 4 | 4.0% |
| custom_error_class | 120 | 29 | 29.0% |

Notes: rescue_reraises means the rescue body contains a raise/fail call; rescue_swallows is the complement.
custom_error_class counts classes whose superclass name ends in Error/Exception.

Errors: 0
