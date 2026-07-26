# Portland compatibility across RubyGems.org

Based on all 195390 gems, out of 195399 on RubyGems.org, scanned for the Ruby features Portland removes or changes (config/portland_removals.yml).

Just Work™ candidates (no decided removal detected): **48460** (24.8%).

## Gems affected, by removed/changed feature

| Feature | Gems | % of gems |
|---|---|---|
| in-place-mutators | 93434 | 47.8% |
| shift-append-operator | 87944 | 45.0% |
| eval-family | 80285 | 41.1% |
| global-variables | 65349 | 33.4% |
| splat-arguments | 63221 | 32.4% |
| freeze-family | 57198 | 29.3% |
| runtime-define-method | 32919 | 16.8% |
| fetch-retired | 27630 | 14.1% |
| method-missing | 18688 | 9.6% |
| thread-model | 17317 | 8.9% |
| bitwise-operators | 17167 | 8.8% |
| for-in-loop | 5284 | 2.7% |
| right-shift-operator | 3600 | 1.8% |
| numbered-block-parameters | 1239 | 0.6% |
| begin-end-execution-blocks | 186 | 0.1% |
| flip-flops | 47 | 0.0% |

## By era

Share of gems in each cohort touching each removal. A feature well below its cohort share
is already fading on its own; one above it is still being written today.

| Feature | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| begin-end-execution-blocks | 0.1% | 0.1% | 0.1% |
| bitwise-operators | 6.4% | 11.3% | 8.8% |
| eval-family | 35.3% | 39.0% | 47.6% |
| fetch-retired | 12.6% | 24.1% | 7.9% |
| flip-flops | 0.0% | 0.0% | 0.0% |
| for-in-loop | 2.2% | 1.9% | 3.8% |
| freeze-family | 25.6% | 43.6% | 21.5% |
| global-variables | 24.9% | 25.3% | 46.8% |
| in-place-mutators | 40.9% | 44.8% | 55.9% |
| method-missing | 7.4% | 8.3% | 12.3% |
| numbered-block-parameters | 0.0% | 2.2% | 0.0% |
| right-shift-operator | 1.4% | 2.4% | 1.8% |
| runtime-define-method | 14.0% | 19.5% | 17.2% |
| shift-append-operator | 39.1% | 46.8% | 48.6% |
| splat-arguments | 25.7% | 40.2% | 32.1% |
| thread-model | 7.0% | 11.7% | 8.3% |

Cohort sizes: 2015-2019 63172, 2020+ 57101, pre-2015 75117 (195390 gems). Percentages are of the gems within each cohort, so rows are comparable across columns; compare a column against how large that cohort is overall.

## Semantic changes with no static detection

These affect nearly all code via the type checker rather than any syntax form:

- heredoc-plain-and-dash
- ambient-nil
- truthiness
- mutable-by-default
- monkeypatching-open-classes
- dynamic-typing

## Just Work™ candidates

48460 gems touch no decided removal. First 100, alphabetically:

- -A
- .cat
- .omghi
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
- 0xdm5
- 0xfacet
- 0xfacet-rubidity
- 0xn3va-hola
- 149_solver_e529153442_gem
- 189seg
- 196demo
- 19cah
- 1OS
- 1_as_identity_function
- 21-day-challenge-countdown
- 228_solver_62d87e0b22_xss
- 233_solver_3cf48ff7a5-rce-test-gem
- 234ewd
- 2gis
- 2n-patterns
- 37-pieces-of-flair
- 3d-ribbon
- 3dmf
- 3months_staff_schedule
- 3scale_toolbox_supercool_plugin
- 420-time
- 42858gemtest
- 42_gem
- 6_mail_regex_andeshmukh
- 80ae2fe5c929b7d0a00bdee2d710fa9e
- 80legs
- A-
- AABeginnerTestGem
- ABCEvaluateMath
- AMS
- A_123
- AbsoluteRenamer-system
- Acai
- AccountGem
- ActiveMerchant-FatZebra
- AdelX
- AdministratedScaffold
- AiitA1336mnHola
- Akeel
- Alexonozor
- Alexsecdemo
- Alimento_a123
- Alkzz
- AllAboutFiles
- AllSportDB
- Alonso_gem
- AmazonEchoJS
- AmberRack
- Amortize
- AnVH
- AndrewO-prawn_grid
- Andrey-hello_world
- AndyFirstGem
- AnnieNumbers
- App_View_Tool
- ArduinoStringToNum
- Artforge-rvideo
- AsciiGenerator
- AsciiPNG
- AuraPrint
- Austins_Top_Yoga_Studios
- AutoAssignment
- AvrijAnalyticsUtility
- AwesomeDadBlog
- Aython-Houttekier-thermostat-exercise
- BAT_Notifications
- BDParseLock
- BMI_ReynaCarrillo
- BMRcal
- BVDryer
- B_123
- BackAtCha
- Badger_Mushroom_Snake_View_Tool
- Baidu_cloudpush
- Banana
- BanglaToEnglish
- BannerGrab
- BarcodeLookup
- Base62

Errors: 9
