# Error-handling census across RubyGems.org

Sampled 50 gems (seeded, reproducible) out of 195399 on RubyGems.org.

| Shape | Sites | Gems using it | % of gems |
|---|---|---|---|
| raise_site | 628 | 33 | 66.0% |
| rescue_clause | 241 | 22 | 44.0% |
| rescue_specific_class | 197 | 21 | 42.0% |
| rescue_bare | 44 | 8 | 16.0% |
| rescue_reraises | 98 | 12 | 24.0% |
| rescue_swallows | 143 | 18 | 36.0% |
| rescue_modifier | 27 | 8 | 16.0% |
| ensure_block | 29 | 5 | 10.0% |
| retry_site | 2 | 1 | 2.0% |
| custom_error_class | 41 | 17 | 34.0% |

Notes: rescue_reraises means the rescue body contains a raise/fail call; rescue_swallows is the complement.
custom_error_class counts classes whose superclass name ends in Error/Exception.

Errors: 0
