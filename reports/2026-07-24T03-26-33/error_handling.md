# Error-handling census across RubyGems.org

Sampled 500 gems (seeded, reproducible) out of 195399 on RubyGems.org.

| Shape | Sites | Gems using it | % of gems |
|---|---|---|---|
| raise_site | 7953 | 229 | 45.8% |
| rescue_clause | 1728 | 168 | 33.6% |
| rescue_specific_class | 1330 | 145 | 29.0% |
| rescue_bare | 398 | 69 | 13.8% |
| rescue_reraises | 556 | 81 | 16.2% |
| rescue_swallows | 1172 | 144 | 28.8% |
| rescue_modifier | 136 | 39 | 7.8% |
| ensure_block | 365 | 53 | 10.6% |
| retry_site | 36 | 16 | 3.2% |
| custom_error_class | 470 | 117 | 23.4% |

Notes: rescue_reraises means the rescue body contains a raise/fail call; rescue_swallows is the complement.
custom_error_class counts classes whose superclass name ends in Error/Exception.

Errors: 0
