# Heredoc census across RubyGems.org

Sampled 100 gems (seeded, reproducible) out of 195399 on RubyGems.org.

**199** heredocs across **24** gems (24.0% of gems use at least one).

Heredoc counts are concentrated: the top 5 gems hold 76.4% of all sites
(generated SDKs and DSL-heavy gems dominate), so prefer the per-gem columns over raw site counts.

## Indentation syntax

| Syntax | Heredocs | % of sites | Gems | % of heredoc-using gems |
|---|---|---|---|---|
| `<<- (dash)` | 94 | 47.2% | 17 | 70.8% |
| `<<~ (squiggly)` | 83 | 41.7% | 6 | 25.0% |
| `<< (plain)` | 22 | 11.1% | 5 | 20.8% |

## Quoting

| Quoting | Heredocs | % of sites | Gems | % of heredoc-using gems |
|---|---|---|---|---|
| bare | 195 | 98.0% | 24 | 100.0% |
| single-quoted (no interpolation) | 4 | 2.0% | 2 | 8.3% |

## Terminator casing

UPPERCASE is convention, not grammar — any identifier is legal.

| Casing | Heredocs | % of sites | Gems | % of heredoc-using gems |
|---|---|---|---|---|
| UPPERCASE | 191 | 96.0% | 24 | 100.0% |
| lowercase | 8 | 4.0% | 2 | 8.3% |

Non-uppercase terminators seen: `end_body`, `end_eval`, `end_src`

## Interpolation, position, stacking

| Property | Heredocs | % |
|---|---|---|
| body interpolates | 118 | 59.3% |
| body is literal | 81 | 40.7% |
| passed as a call argument | 77 | 38.7% |
| lines opening 2+ heredocs | 0 | — |

## Body size

| Size | Heredocs | % |
|---|---|---|
| 1 line | 20 | 10.1% |
| 2-5 lines | 88 | 44.2% |
| 6-20 lines | 70 | 35.2% |
| 21+ lines | 21 | 10.6% |

## Terminator names (top 40)

What heredocs are used for — SQL, HTML, RUBY, and friends name their content.

| Terminator | Heredocs |
|---|---|
| `EOS` | 46 |
| `RUBY` | 45 |
| `HTML` | 19 |
| `MARKDOWN` | 14 |
| `DESC` | 13 |
| `EOT` | 10 |
| `JS` | 8 |
| `EOF` | 6 |
| `end_eval` | 5 |
| `PATTERN` | 3 |
| `SQL` | 3 |
| `XML` | 3 |
| `STR` | 3 |
| `end_src` | 2 |
| `CONTENT` | 2 |
| `LAMBDA` | 2 |
| `END_SRC` | 2 |
| `EO_OUTPUT` | 2 |
| `CONFIG_JS` | 1 |
| `TYPES_JS` | 1 |
| `CMD` | 1 |
| `ROW` | 1 |
| `EOM` | 1 |
| `EO_ERROR` | 1 |
| `CACHED` | 1 |
| `EVAL` | 1 |
| `end_body` | 1 |
| `YAML` | 1 |
| `MSG` | 1 |

## Gems with the most heredocs

| Gem | Heredocs |
|---|---|
| wrappix | 54 |
| actionpack-2.3.17-rack-upgrade | 47 |
| github-pulse | 21 |
| gli | 16 |
| bio-gadget | 14 |
| middleman-presentation-core | 12 |
| puppet-lint-classes_and_types_beginning_with_digits--check | 5 |
| moneypools-capistrano-ext | 4 |
| paraxial | 3 |
| nexus_mods | 3 |

Errors: 0
