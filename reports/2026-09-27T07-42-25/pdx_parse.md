# Readiness level 0: gems that parse under pdx, unedited

Based on all 188444 gems with Ruby files under lib/, out of 196982 on RubyGems.org (8538 more have none). Each gem's lib/ files, as published, through portland's `pdx --parse`.

- Gems whose every lib/ file parses: **10426** (5.5%)
- Files that parse: 341346 of 2284239 (14.9%)

## Refusals, by the gems they appear in

A refusal with its particulars folded out (quoted source becomes `…`, numbers `N`). "Only refusal" counts the gems for which it is the only kind that stops them: fix what it names and they parse.

| Refusal | Gems | Files | Only refusal |
|---|---:|---:|---:|
| '…' is an instance variable, which Portland does not have — a field is read by its bare name, '…' | 120535 | 829005 | 29559 |
| '…' inherits, and Portland has no inheritance — move X's shared methods into a trait and '…' it | 67988 | 423429 | 9703 |
| unexpected character '&' at byte N | 42857 | 115484 | 4916 |
| a backslash outside a string continues a line, so a newline must follow it | 30552 | 69606 | 4078 |
| struct X needs at least one field | 28732 | 50759 | 4558 |
| unexpected character '$' at byte N | 23021 | 38709 | 2515 |
| '…' is a class variable, which Portland does not have — a value lives in a local, a field, or a constant | 15414 | 26451 | 1793 |
| only one level of index assignment is supported — assign to name[index] | 12057 | 18942 | 539 |
| '…' has no Portland meaning — write each method as '…' in the X's body | 11665 | 18823 | 660 |
| `include` belongs inside a struct body — a trait is carried by a struct (ADR N) | 8616 | 19933 | 358 |
| expected a newline after statement, got Some(Symbol) | 8011 | 50903 | 298 |
| expected method name after dot, got Keyword | 6288 | 8248 | 317 |
| expected a newline after statement, got Some(Identifier) | 5816 | 11851 | 310 |
| unexpected character '`' at byte N | 5798 | 8403 | 937 |
| expected closing paren after parameters, got Some(Star) | 5271 | 9576 | 458 |
| '…' is not a Portland literal — there is no regex yet | 4735 | 8724 | 353 |
| expected a newline after statement, got Some(Keyword) | 4689 | 13356 | 280 |
| modules don't nest inside structs — a module groups things, a struct is a thing | 4436 | 18714 | 112 |
| expected a newline after statement, got Some(FatArrow) | 4369 | 6793 | 227 |
| expected closing paren after arguments, got Some(FatArrow) | 3757 | 21903 | 503 |
| unexpected keyword "…" | 3730 | 5836 | 204 |
| expected a newline after statement, got Some(Comma) | 3465 | 4583 | 214 |
| '…' has no Portland meaning yet — visibility is undecided (#N); remove it to run | 3077 | 4258 | 222 |
| expected a newline after statement, got Some(Equal) | 2918 | 5617 | 191 |
| unexpected token Newline | 2592 | 4602 | 82 |
| unexpected token Slash | 2307 | 2622 | 345 |
| '…' is not a Portland literal — write a quoted string or a heredoc | 1917 | 2970 | 203 |
| expected parameter name, got Star | 1749 | 2141 | 103 |
| expected a newline after statement, got Some(String) | 1745 | 11517 | 166 |
| '%(' is not a Portland literal — write a quoted string or a heredoc | 1739 | 13037 | 116 |
| unexpected character '@' at byte N | 1695 | 2374 | 105 |
| expected a newline after statement, got Some(LessLess) | 1678 | 2099 | 103 |
| unexpected token Star | 1629 | 1912 | 71 |
| '%{' is not a Portland literal — write a quoted string or a heredoc | 1525 | 2274 | 147 |
| expected a newline after statement, got Some(Dot) | 1516 | 2863 | 126 |
| expected closing paren, got Some(Equal) | 1396 | 1565 | 42 |
| unterminated string starting at byte N | 1379 | 1778 | 77 |
| unexpected token Equal | 1287 | 4412 | 113 |
| expected parameter name, got StarStar | 1157 | 1812 | 21 |
| unexpected token Greater | 1133 | 1981 | 61 |
| '…' is not a Portland literal — write %w[] when no word interpolates, or ["…", "…"] when one does | 1082 | 1272 | 99 |
| expected block parameter, got LeftParen | 967 | 1036 | 40 |
| fields come before methods in struct X | 917 | 1341 | 36 |
| expected a trait name after include, got ColonColon | 856 | 3094 | 19 |
| expected closing bracket, got Some(Comma) | 834 | 1128 | 65 |
| unexpected token LessLess | 808 | 1184 | 43 |
| expected a newline after statement, got Some(ColonColon) | 757 | 1220 | 40 |
| expected a field name in struct X, got Keyword | 724 | 1102 | 24 |
| an underscore in a number sits between digits — 9_ has one loose | 677 | 744 | 34 |
| unknown escape sequence \x | 671 | 6341 | 22 |
| expected a newline after statement, got Some(Star) | 625 | 770 | 48 |
| expected a newline after statement, got Some(PipePipeEqual) | 615 | 679 | 20 |
| unexpected token Colon | 613 | 803 | 43 |
| alias takes two method names — alias new_name old_name | 604 | 860 | 44 |
| expected struct name after class, got Less | 597 | 1309 | 0 |
| '…' is not a Portland literal — there is no shell execution | 561 | 726 | 79 |
| unknown escape sequence \e | 560 | 606 | 31 |
| expected closing paren after parameters, got Some(StarStar) | 545 | 804 | 7 |
| expected block parameter, got Star | 540 | 637 | 51 |
| expected a newline after statement, got Some(PlusEqual) | 512 | 527 | 22 |

5348 refusal shapes in all; the JSON has every one.

## Gems that parse

10426 gems. First 100, alphabetically:

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
- 19cah
- 228_solver_62d87e0b22_xss
- 233_solver_3cf48ff7a5-rce-test-gem
- 37-pieces-of-flair
- 3dmf
- 3months_staff_schedule
- 52inc-danger
- A_123
- Acai
- Alexonozor
- AmberRack
- Amortize
- AnVH
- AndyFirstGem
- BF2LF
- BMRcal
- B_123
- Baidu_cloudpush
- Banana
- Basaah-pony-gae
- Base64_coder
- Bian001
- CASProjectServer
- CUTM
- C_123
- CapicuaGenEssential
- Cartesian
- CemFirstGem
- Chouhyou
- Chrononaut-treetop-dcf
- CocoaKucha
- CurlingIron
- Currentize
- D_123
- DanaDanger-trigraph_password
- Data_Delete
- DictFlutterCommand
- DilumTest
- ECToken
- ED_GRID
- ESet
- EmailList
- EmmanuelOga-sets_uuid
- Eric
- EsignRuby
- F2C
- FatIntakeSP
- FirstGemTest1212
- FizzBuzzAlgorithm
- Formulan
- GemTobeAdded
- GetToken4Twitter
- Github_Api_Ruby
- GuyNorkunas
- GuysFitnessApp
- GyyTest1
- HTMLSaver
- HTStyle
- HarryGuerilla-damn-layout-generators
- HelloWorldInC
- HelloWorld_bensarz
- Hello_RubyMin
- Heyamate_Voteable_Gem
- Hola-extended
- Hola_ML
- I18nFloat
- ImageClip
- J-_-L
- JSONPlaceholder
- KA-CHING
- KinopoiskAPI
- LOLsp
- LVS-JSONService
- Labrador
- Lazurite-ruby
- LazuriteGem
- Letter
- Logic_test
- MattsFace
- Maxxxxx

Errors: 0
