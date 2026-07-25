# Error-handling census across RubyGems.org

Based on a random sample of 40 gems (seeded, reproducible), out of 195399 on RubyGems.org.

| Shape | Sites | Gems using it | % of gems |
|---|---|---|---|
| raise_site | 489 | 27 | 67.5% |
| rescue_clause | 193 | 19 | 47.5% |
| rescue_specific_class | 149 | 18 | 45.0% |
| rescue_bare | 44 | 8 | 20.0% |
| rescue_reraises | 51 | 10 | 25.0% |
| rescue_swallows | 142 | 17 | 42.5% |
| rescue_modifier | 27 | 8 | 20.0% |
| ensure_block | 29 | 5 | 12.5% |
| retry_site | 2 | 1 | 2.5% |
| custom_error_class | 40 | 16 | 40.0% |

Notes: rescue_reraises means the rescue body contains a raise/fail call; rescue_swallows is the complement.
custom_error_class counts classes whose superclass name ends in Error/Exception.

Errors: 0
