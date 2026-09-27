# Readiness level 0: gems that parse under pdx, unedited

Based on all 188444 gems with Ruby files under lib/, out of 196982 on RubyGems.org (8538 more have none). Each gem's lib/ files, as published, through portland's `pdx --parse`.

- Gems whose every lib/ file parses: **33158** (17.6%)
- Files that parse: 332554 of 2284239 (14.6%)

## Refusals, by the gems they appear in

A refusal with its particulars folded out (quoted source becomes `…`, numbers `N`). "Only refusal" counts the gems for which it is the only kind that stops them: fix what it names and they parse.

| Refusal | Gems | Files | Only refusal |
|---|---:|---:|---:|
| '…' is an instance variable, which Portland does not have — a field is read by its bare name, '…' | 105282 | 744759 | 16332 |
| '…' inherits, and Portland has no inheritance — move X's shared methods into a trait and '…' it | 52336 | 370941 | 5526 |
| unexpected character ';' at byte N | 38455 | 92179 | 4379 |
| unexpected character '&' at byte N | 38310 | 104896 | 2449 |
| unexpected character '\\' at byte N | 30058 | 77462 | 1982 |
| unexpected character '$' at byte N | 20458 | 34199 | 1085 |
| unexpected token Newline | 15880 | 48845 | 565 |
| struct X needs at least one field | 14086 | 24435 | 1281 |
| expected a newline after statement, got Some(Equal) | 13403 | 23298 | 286 |
| '…' is a class variable, which Portland does not have — a value lives in a local, a field, or a constant | 13338 | 23246 | 730 |
| expected a newline after statement, got Some(ColonColon) | 10319 | 39135 | 329 |
| only one level of index assignment is supported — assign to name[index] | 9877 | 14843 | 250 |
| '…' has no Portland meaning — write each method as '…' in the X's body | 9828 | 15414 | 381 |
| `include` belongs inside a struct body — a trait is carried by a struct (ADR N) | 7827 | 17371 | 224 |
| expected a newline after statement, got Some(Symbol) | 5719 | 44284 | 117 |
| unexpected character '…' at byte N | 5412 | 75978 | 3118 |
| unexpected token ColonColon | 5397 | 11096 | 170 |
| expected a newline after statement, got Some(Identifier) | 5281 | 9723 | 163 |
| unexpected character '`' at byte N | 5072 | 7389 | 555 |
| expected method name after dot, got Keyword | 5021 | 6397 | 167 |
| expected closing paren after parameters, got Some(Star) | 4361 | 8366 | 235 |
| '…' is not a Portland literal — there is no regex yet | 4220 | 7830 | 168 |
| expected a newline after statement, got Some(Keyword) | 4070 | 11611 | 162 |
| modules don't nest inside structs — a module groups things, a struct is a thing | 3982 | 16799 | 52 |
| expected a newline after statement, got Some(FatArrow) | 3489 | 5417 | 115 |
| unexpected keyword "…" | 2775 | 3996 | 91 |
| expected a newline after statement, got Some(Comma) | 2644 | 3445 | 87 |
| expected closing paren after arguments, got Some(FatArrow) | 2182 | 4293 | 129 |
| '…' has no Portland meaning yet — visibility is undecided (#N); remove it to run | 1933 | 2492 | 130 |
| unexpected token Slash | 1681 | 1915 | 224 |
| '…' is not a Portland literal — write a quoted string or a heredoc | 1601 | 2553 | 83 |
| '%(' is not a Portland literal — write a quoted string or a heredoc | 1592 | 12726 | 66 |
| expected parameter name, got Star | 1501 | 1843 | 66 |
| unexpected character '@' at byte N | 1490 | 2127 | 49 |
| '%{' is not a Portland literal — write a quoted string or a heredoc | 1312 | 1997 | 75 |
| expected a newline after statement, got Some(LessLess) | 1305 | 1609 | 54 |
| unterminated string starting at byte N | 1215 | 1574 | 31 |
| expected closing paren, got Some(Equal) | 1150 | 1244 | 14 |
| unexpected token Star | 1107 | 1240 | 33 |
| expected a newline after statement, got Some(Dot) | 1057 | 2094 | 48 |
| '…' is not a Portland literal — write %w[] when no word interpolates, or ["…", "…"] when one does | 1009 | 1172 | 63 |
| expected parameter name, got StarStar | 976 | 1458 | 12 |
| unexpected token Equal | 962 | 2867 | 36 |
| expected a newline after statement, got Some(String) | 946 | 8160 | 51 |
| expected a trait name after include, got ColonColon | 766 | 2961 | 10 |
| unexpected token Greater | 721 | 1403 | 40 |
| expected block parameter, got LeftParen | 669 | 704 | 16 |
| expected a newline after statement, got Some(LeftParen) | 602 | 845 | 23 |
| an underscore in a number sits between digits — 9_ has one loose | 600 | 656 | 17 |
| unknown escape sequence \x | 586 | 6247 | 13 |
| expected closing bracket, got Some(Comma) | 586 | 786 | 28 |
| expected struct name after class, got Less | 583 | 1274 | 0 |
| fields come before methods in struct X | 578 | 745 | 17 |
| unexpected token LessLess | 540 | 812 | 17 |
| positional arguments cannot follow keyword arguments | 510 | 721 | 9 |
| expected a newline after statement, got Some(PipePipeEqual) | 504 | 554 | 13 |
| alias takes two method names — alias new_name old_name | 502 | 660 | 23 |
| '…' is not a Portland literal — there is no shell execution | 488 | 603 | 41 |
| expected a field name in struct X, got Keyword | 470 | 637 | 5 |
| expected closing paren after parameters, got Some(StarStar) | 445 | 655 | 4 |

3707 refusal shapes in all; the JSON has every one.

## Gems that parse

33158 gems. First 100, alphabetically:

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
