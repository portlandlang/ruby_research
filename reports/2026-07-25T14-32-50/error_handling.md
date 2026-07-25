# Error-handling census across RubyGems.org

Based on all 195390 gems, out of 195399 on RubyGems.org.

| Shape | Sites | Gems using it | % of gems |
|---|---|---|---|
| raise_site | 2332536 | 95005 | 48.6% |
| rescue_clause | 703746 | 75238 | 38.5% |
| rescue_specific_class | 579536 | 64425 | 33.0% |
| rescue_bare | 124210 | 29158 | 14.9% |
| rescue_reraises | 249779 | 33704 | 17.2% |
| rescue_swallows | 453967 | 64748 | 33.1% |
| rescue_modifier | 68545 | 15935 | 8.2% |
| ensure_block | 123460 | 23425 | 12.0% |
| retry_site | 15786 | 6679 | 3.4% |
| custom_error_class | 225954 | 50540 | 25.9% |

Notes: rescue_reraises means the rescue body contains a raise/fail call; rescue_swallows is the complement.
custom_error_class counts classes whose superclass name ends in Error/Exception.

Errors: 9
