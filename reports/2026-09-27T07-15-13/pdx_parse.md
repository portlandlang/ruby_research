# Readiness level 0: gems that parse under pdx, unedited

Based on all 188444 gems with Ruby files under lib/, out of 196982 on RubyGems.org (8538 more have none). Each gem's lib/ files, as published, through portland's `pdx --parse`.

- Gems whose every lib/ file parses: **33589** (17.8%)
- Files that parse: 364510 of 2284239 (16.0%)

## Refusals, by the gems they appear in

A refusal with its particulars folded out (quoted source becomes `…`, numbers `N`). "Only refusal" counts the gems for which it is the only kind that stops them: fix what it names and they parse.

| Refusal | Gems | Files | Only refusal |
|---|---:|---:|---:|
| '…' is an instance variable, which Portland does not have — a field is read by its bare name, '…' | 110692 | 819162 | 19716 |
| '…' inherits, and Portland has no inheritance — move X's shared methods into a trait and '…' it | 67165 | 422606 | 8880 |
| unexpected character '&' at byte N | 40869 | 113496 | 2928 |
| a backslash outside a string continues a line, so a newline must follow it | 29092 | 68146 | 2618 |
| struct X needs at least one field | 25835 | 47862 | 1661 |
| unexpected character '$' at byte N | 21817 | 37505 | 1311 |
| '…' is a class variable, which Portland does not have — a value lives in a local, a field, or a constant | 14510 | 25547 | 889 |
| only one level of index assignment is supported — assign to name[index] | 11853 | 18738 | 335 |
| '…' has no Portland meaning — write each method as '…' in the X's body | 11475 | 18633 | 470 |
| `include` belongs inside a struct body — a trait is carried by a struct (ADR N) | 8537 | 19854 | 279 |
| expected a newline after statement, got Some(Symbol) | 7891 | 50783 | 178 |
| expected method name after dot, got Keyword | 6182 | 8142 | 211 |
| expected a newline after statement, got Some(Identifier) | 5710 | 11745 | 204 |
| unexpected character '`' at byte N | 5488 | 8093 | 627 |
| expected closing paren after parameters, got Some(Star) | 5089 | 9394 | 276 |
| '…' is not a Portland literal — there is no regex yet | 4604 | 8593 | 222 |
| expected a newline after statement, got Some(Keyword) | 4602 | 13269 | 193 |
| modules don't nest inside structs — a module groups things, a struct is a thing | 4384 | 18662 | 60 |
| expected a newline after statement, got Some(FatArrow) | 4288 | 6712 | 146 |
| unexpected keyword "…" | 3657 | 5763 | 131 |
| expected closing paren after arguments, got Some(FatArrow) | 3440 | 21586 | 187 |
| expected a newline after statement, got Some(Comma) | 3358 | 4476 | 107 |
| '…' has no Portland meaning yet — visibility is undecided (#N); remove it to run | 3023 | 4204 | 168 |
| expected a newline after statement, got Some(Equal) | 2833 | 5532 | 106 |
| unexpected token Newline | 2559 | 4569 | 49 |
| unexpected token Slash | 2217 | 2532 | 255 |
| '…' is not a Portland literal — write a quoted string or a heredoc | 1815 | 2868 | 101 |
| expected parameter name, got Star | 1715 | 2107 | 69 |
| '%(' is not a Portland literal — write a quoted string or a heredoc | 1704 | 13002 | 81 |
| expected a newline after statement, got Some(String) | 1650 | 11422 | 71 |
| unexpected character '@' at byte N | 1649 | 2328 | 59 |
| expected a newline after statement, got Some(LessLess) | 1641 | 2062 | 66 |
| unexpected token Star | 1603 | 1886 | 45 |
| '%{' is not a Portland literal — write a quoted string or a heredoc | 1466 | 2215 | 88 |
| expected a newline after statement, got Some(Dot) | 1452 | 2799 | 62 |
| expected closing paren, got Some(Equal) | 1379 | 1548 | 25 |
| unterminated string starting at byte N | 1342 | 1741 | 40 |
| unexpected token Equal | 1231 | 4356 | 57 |
| expected parameter name, got StarStar | 1152 | 1807 | 16 |
| unexpected token Greater | 1124 | 1972 | 52 |
| '…' is not a Portland literal — write %w[] when no word interpolates, or ["…", "…"] when one does | 1056 | 1246 | 73 |
| expected block parameter, got LeftParen | 957 | 1026 | 30 |
| fields come before methods in struct X | 902 | 1326 | 21 |
| expected a trait name after include, got ColonColon | 851 | 3089 | 14 |
| expected closing bracket, got Some(Comma) | 803 | 1097 | 34 |
| unexpected token LessLess | 794 | 1170 | 29 |
| expected a newline after statement, got Some(ColonColon) | 744 | 1207 | 27 |
| expected a field name in struct X, got Keyword | 711 | 1089 | 11 |
| unknown escape sequence \x | 665 | 6335 | 16 |
| an underscore in a number sits between digits — 9_ has one loose | 663 | 730 | 20 |
| expected a newline after statement, got Some(PipePipeEqual) | 610 | 674 | 15 |
| expected a newline after statement, got Some(Star) | 604 | 749 | 27 |
| unexpected token Colon | 602 | 792 | 32 |
| expected struct name after class, got Less | 597 | 1309 | 0 |
| alias takes two method names — alias new_name old_name | 587 | 843 | 27 |
| unknown escape sequence \e | 545 | 591 | 16 |
| expected closing paren after parameters, got Some(StarStar) | 543 | 802 | 5 |
| '…' is not a Portland literal — there is no shell execution | 533 | 698 | 51 |
| expected block parameter, got Star | 525 | 622 | 36 |
| expected a newline after statement, got Some(PlusEqual) | 501 | 516 | 11 |

5233 refusal shapes in all; the JSON has every one.

## Gems that parse

33589 gems. First 100, alphabetically:

- -
- -A
- .cat
- 023_solver_ed4d08b963-direct-output-gem
- 023_solver_ed4d08b963-env-correct-gem
- 023_solver_ed4d08b963-error-rce-gem
- 023_solver_ed4d08b963-exfiltrate-gem
- 023_solver_ed4d08b963-final-attempt-gem
- 023_solver_ed4d08b963-final-flag-attempt-gem
- 023_solver_ed4d08b963-final-gem
- 023_solver_ed4d08b963-final-v2-gem
- 023_solver_ed4d08b963-final-v3-gem
- 023_solver_ed4d08b963-fresh-gem
- 023_solver_ed4d08b963-gem
- 023_solver_ed4d08b963-id-correct-gem
- 023_solver_ed4d08b963-id-final-gem
- 023_solver_ed4d08b963-interactsh-gem
- 023_solver_ed4d08b963-simple-exfil-gem
- 023_solver_ed4d08b963-uname-gem
- 023_solver_ed4d08b963-whoami-gem
- 0xfacet
- 0xfacet-rubidity
- 0xffffff
- 1234567890_
- 196demo
- 19cah
- 1_as_identity_function
- 21-day-challenge-countdown
- 228_solver_62d87e0b22_xss
- 233_solver_3cf48ff7a5-rce-test-gem
- 2DArray
- 2gis
- 37-pieces-of-flair
- 3d-ribbon
- 3dmf
- 3months_staff_schedule
- 3scale_toolbox_supercool_plugin
- 420-time
- 42858gemtest
- 42_gem
- 52inc-danger
- 6_mail_regex_andeshmukh
- A-
- ABO
- ACORD
- API2Cart
- A_123
- Acai
- AccountGem
- ActionMailer-Base-to-use-an-absolute-path-template
- ActiveCohort
- ActiveExcel
- ActsAsEscaped
- AddressBookImporter
- AiitA1336mnHola
- Akeel
- AlertMe
- Alexonozor
- Alexsecdemo
- Alkzz
- AllSportDB
- AmberRack
- Amortize
- AnVH
- AndyFirstGem
- Anti-gravity-qy
- Anyhub
- ApEye
- AppFormBuilder
- AptDownloader
- Aravind
- ArgvParser
- AsciiGenerator
- AuraPrint
- AutoAssignment
- AutoNic
- Avatax_AddressService
- Avatax_TaxService
- BF2LF
- BFD
- BJClark-sinatra-content-for
- BMI_ReynaCarrillo
- BMI_calc
- BMRcal
- BRIMIL01-meetup_api
- BRLL
- B_123
- Bacon_Colored
- Bacon_FS_Matchers
- Baidu_cloudpush
- Banana
- BankValInt
- BankValUK
- BarcodeLookup
- Basaah-pony-gae
- Base62
- Base64_coder
- Bauble
- Bian001
- BidManagerLoggerGem

Errors: 0
