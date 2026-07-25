# Heredoc census across RubyGems.org

Sampled 500 gems (seeded, reproducible) out of 195399 on RubyGems.org.

**1112** heredocs across **70** gems (14.0% of gems use at least one).

Heredoc counts are concentrated: the top 5 gems hold 76.5% of all sites
(generated SDKs and DSL-heavy gems dominate), so prefer the per-gem columns over raw site counts.

## Indentation syntax

| Syntax | Heredocs | % of sites | Gems | % of heredoc-using gems |
|---|---|---|---|---|
| `<<~ (squiggly)` | 569 | 51.2% | 14 | 20.0% |
| `<<- (dash)` | 434 | 39.0% | 50 | 71.4% |
| `<< (plain)` | 109 | 9.8% | 16 | 22.9% |

## Quoting

| Quoting | Heredocs | % of sites | Gems | % of heredoc-using gems |
|---|---|---|---|---|
| bare | 1066 | 95.9% | 68 | 97.1% |
| single-quoted (no interpolation) | 43 | 3.9% | 3 | 4.3% |
| double-quoted | 3 | 0.3% | 3 | 4.3% |

## Terminator casing

UPPERCASE is convention, not grammar — any identifier is legal.

| Casing | Heredocs | % of sites | Gems | % of heredoc-using gems |
|---|---|---|---|---|
| UPPERCASE | 1062 | 95.5% | 67 | 95.7% |
| lowercase | 39 | 3.5% | 7 | 10.0% |
| MixedCase | 11 | 1.0% | 1 | 1.4% |

Non-uppercase terminators seen: `;;;`, `End`, `__end_of_file__`, `code`, `end;`, `end_body`, `end_eval`, `end_src`, `eos`, `json`

## Interpolation, position, stacking

| Property | Heredocs | % |
|---|---|---|
| body interpolates | 620 | 55.8% |
| body is literal | 492 | 44.2% |
| passed as a call argument | 705 | 63.4% |
| lines opening 2+ heredocs | 0 | — |

## Body size

| Size | Heredocs | % |
|---|---|---|
| 1 line | 216 | 19.4% |
| 2-5 lines | 539 | 48.5% |
| 6-20 lines | 271 | 24.4% |
| 21+ lines | 86 | 7.7% |

## Terminator names (top 40)

What heredocs are used for — SQL, HTML, RUBY, and friends name their content.

| Terminator | Heredocs |
|---|---|
| `PATTERN` | 254 |
| `DOT` | 153 |
| `RUBY` | 94 |
| `EOS` | 68 |
| `DESCRIPTION` | 61 |
| `SQL` | 57 |
| `EOF` | 56 |
| `BANNER` | 51 |
| `DESC` | 43 |
| `HTML` | 27 |
| `eos` | 18 |
| `HEADER` | 15 |
| `MARKDOWN` | 14 |
| `EOT` | 11 |
| `MESSAGE` | 10 |
| `END` | 10 |
| `JS` | 9 |
| `End` | 8 |
| `json` | 8 |
| `WARNING` | 7 |
| `EXPECTED` | 7 |
| `METHOD` | 6 |
| `OUTPUT` | 6 |
| `code` | 5 |
| `MSG` | 5 |
| `end_eval` | 5 |
| `XML` | 4 |
| `STR` | 4 |
| `CSS` | 4 |
| `EOR` | 4 |
| `SAMPLE` | 3 |
| `TEXT` | 3 |
| `TXT` | 3 |
| `EO_OUTPUT` | 2 |
| `CMD` | 2 |
| `CONTENT` | 2 |
| `END_SRC` | 2 |
| `LAMBDA` | 2 |
| `EOM` | 2 |
| `end_src` | 2 |

## Gems with the most heredocs

| Gem | Heredocs |
|---|---|
| fattureincloud_ruby_sdk | 671 |
| wrappix | 54 |
| viewy | 48 |
| actionpack-2.3.17-rack-upgrade | 47 |
| capistrano-edge | 31 |
| pgtools | 22 |
| github-pulse | 21 |
| ulla | 17 |
| usman | 16 |
| new_cfoundry | 16 |

Errors: 0
