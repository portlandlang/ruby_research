# Portland compatibility across RubyGems.org

Based on all 196982 gems, out of 196982 on RubyGems.org, scanned for the Ruby features Portland removes or changes (config/portland_removals.yml).

## Gems by the hardest difference they touch

Each gem is graded by the hardest listed difference its source touches (principle 2): none; only taste differences, spellings a linter can rewrite; a thesis difference, the language's price; or a gap or undecided question, which no rewrite answers yet. Semantic changes with no static detection (below) apply to every gem and are not graded.

| Grade | Gems | % of gems |
|---|---:|---:|
| runs as is | 11767 | 6.0% |
| taste only | 1331 | 0.7% |
| thesis | 1549 | 0.8% |
| gap or undecided | 182335 | 92.6% |

## Open questions, by the gems they hold back

For each gap or undecided question: the gems for which it is the only open question (answered, they have only decided differences left) and the gems for which it is the only listed difference of any kind (answered favorably, they run as is).

| Question | Owner | Only open question | Only difference |
|---|---|---:|---:|
| require-by-name | https://github.com/portlandlang/portland/issues/116 | 23476 | 7782 |
| instance-variable-writes | https://github.com/portlandlang/portland/issues/103 | 716 | 76 |
| regex | https://github.com/portlandlang/portland/issues/74 | 673 | 135 |
| visibility | https://github.com/portlandlang/portland/issues/133 | 360 | 64 |
| splat-arguments | docs/adr/0014-2026-07-22-keyword-arguments.md | 169 | 23 |
| attr-writers | https://github.com/portlandlang/portland/issues/103 | 51 | 10 |
| bitwise-operators | docs/adr/0003-2026-07-20-bitwise-operators-out.md | 20 | 3 |
| attr-reader | https://github.com/portlandlang/portland/issues/134 | 5 | 1 |
| right-shift-operator | docs/adr/0003-2026-07-20-bitwise-operators-out.md | 3 | 0 |

## Gems affected, by removed/changed feature

| Feature | Difference | Status | Gems | % of gems |
|---|---|---|---:|---:|
| require-by-name | gap | undecided | 176770 | 89.7% |
| instance-variable-writes | thesis | undecided | 137552 | 69.8% |
| inheritance | taste | decided | 128866 | 65.4% |
| instance-variable-reads | taste | decided | 124443 | 63.2% |
| raise-rescue | thesis | decided | 116432 | 59.1% |
| visibility | gap | undecided | 107499 | 54.6% |
| in-place-mutators | thesis | decided | 94357 | 47.9% |
| regex | gap | undecided | 89361 | 45.4% |
| shift-append-operator | thesis | decided | 89049 | 45.2% |
| eval-family | thesis | decided | 81038 | 41.1% |
| attr-reader | taste | undecided | 71048 | 36.1% |
| attr-writers | thesis | undecided | 68224 | 34.6% |
| global-variables | taste | decided | 65793 | 33.4% |
| splat-arguments | gap | undecided | 64402 | 32.7% |
| freeze-family | thesis | decided | 58563 | 29.7% |
| singleton-class-block | taste | decided | 49483 | 25.1% |
| runtime-define-method | thesis | decided | 33290 | 16.9% |
| fetch-retired | taste | decided | 28819 | 14.6% |
| class-variables | thesis | decided | 21453 | 10.9% |
| method-missing | thesis | decided | 18755 | 9.5% |
| thread-model | thesis | decided | 17863 | 9.1% |
| bitwise-operators | taste | undecided | 17663 | 9.0% |
| for-in-loop | taste | decided | 5269 | 2.7% |
| right-shift-operator | taste | undecided | 3682 | 1.9% |
| numbered-block-parameters | taste | decided | 1288 | 0.7% |
| begin-end-execution-blocks | taste | decided | 187 | 0.1% |
| flip-flops | taste | decided | 47 | 0.0% |

## By era

Share of gems in each cohort touching each removal. A feature well below its cohort share
is already fading on its own; one above it is still being written today.

| Feature | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| attr-reader | 31.6% | 45.8% | 32.2% |
| attr-writers | 31.2% | 36.1% | 36.3% |
| begin-end-execution-blocks | 0.1% | 0.1% | 0.1% |
| bitwise-operators | 6.4% | 11.9% | 8.8% |
| class-variables | 9.3% | 8.0% | 14.5% |
| eval-family | 35.3% | 39.2% | 47.6% |
| fetch-retired | 12.6% | 25.5% | 7.9% |
| flip-flops | 0.0% | 0.0% | 0.0% |
| for-in-loop | 2.2% | 1.8% | 3.8% |
| freeze-family | 25.5% | 44.8% | 21.5% |
| global-variables | 24.9% | 25.4% | 46.8% |
| in-place-mutators | 40.9% | 45.1% | 55.9% |
| inheritance | 59.1% | 72.6% | 65.1% |
| instance-variable-reads | 58.3% | 64.7% | 66.1% |
| instance-variable-writes | 66.0% | 72.8% | 70.8% |
| method-missing | 7.4% | 8.2% | 12.3% |
| numbered-block-parameters | 0.0% | 2.2% | 0.0% |
| raise-rescue | 52.7% | 66.1% | 59.0% |
| regex | 38.8% | 46.7% | 49.8% |
| require-by-name | 90.8% | 85.8% | 92.0% |
| right-shift-operator | 1.3% | 2.5% | 1.8% |
| runtime-define-method | 14.0% | 19.6% | 17.2% |
| shift-append-operator | 39.1% | 47.4% | 48.6% |
| singleton-class-block | 20.7% | 31.5% | 23.8% |
| splat-arguments | 25.6% | 41.1% | 32.1% |
| thread-model | 7.0% | 12.3% | 8.3% |
| visibility | 50.4% | 63.5% | 51.1% |

Cohort sizes: 2015-2019 63100, 2020+ 58790, pre-2015 75092 (196982 gems). Cells are the share of gems in that cohort exhibiting the row, so columns are comparable to each other and to how large the cohort is overall.

## Semantic changes with no static detection

These affect nearly all code via the type checker rather than any syntax form:

- heredoc-plain-and-dash
- ambient-nil
- truthiness
- mutable-by-default
- monkeypatching-open-classes
- dynamic-typing

## Just Work™ candidates

11767 gems touch no listed difference. First 100, alphabetically:

- -A
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
- 196demo
- 19cah
- 1OS
- 228_solver_62d87e0b22_xss
- 233_solver_3cf48ff7a5-rce-test-gem
- 234ewd
- 2gis
- 37-pieces-of-flair
- 3dmf
- 42858gemtest
- 42_gem
- 80ae2fe5c929b7d0a00bdee2d710fa9e
- A-
- AMS
- A_123
- AbsoluteRenamer-system
- Acai
- AdministratedScaffold
- AiitA1336mnHola
- Akeel
- Alexsecdemo
- Alimento_a123
- Alkzz
- AnVH
- AndrewO-prawn_grid
- Artforge-rvideo
- AsciiPNG
- AwesomeDadBlog
- BMRcal
- B_123
- Banana
- Blair_first
- BmiCalculator
- Box2d
- BrianTestGem
- BuraksEinstein
- Buranya
- BysxiangLog
- CASProjectServer
- CMS-jekyll
- CV-Portfolio
- C_123
- CamerettaUnity
- Cartesian
- CcHola
- CemFirstGem
- Checkques
- ClickClack
- Cold_Sun
- ColorScience
- CommentsFilter
- CompraFacil
- Crota
- DBR
- DIL
- D_123
- Da
- DanaDanger-plist
- DarkFolio
- Depreciation
- DevSculptor
- Disegni_autocad
- ED-GRID
- ESPGem
- ESet
- ElectricCityPredictor
- EnhanceXCpretty
- EnvJasmine
- Etch
- F2C
- FatIntakeSP
- FiftyTasks
- FilePrepender
- Fingertips-internetkassa
- FireRails
- FirstGem515

Errors: 0
