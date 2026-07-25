# Heredoc census across RubyGems.org

Based on a random sample of 40 gems (seeded, reproducible), out of 195399 on RubyGems.org.

**122** heredocs across **12** gems (30.0% of gems use at least one).

Heredoc counts are concentrated: the top 5 gems hold 88.5% of all sites
(generated SDKs and DSL-heavy gems dominate), so prefer the per-gem columns over raw site counts.

## Indentation syntax

| Syntax | Heredocs | % of sites | Gems | % of heredoc-using gems |
|---|---|---|---|---|
| `<<~ (squiggly)` | 82 | 67.2% | 5 | 41.7% |
| `<<- (dash)` | 25 | 20.5% | 7 | 58.3% |
| `<< (plain)` | 15 | 12.3% | 1 | 8.3% |

## Quoting

| Quoting | Heredocs | % of sites | Gems | % of heredoc-using gems |
|---|---|---|---|---|
| bare | 120 | 98.4% | 12 | 100.0% |
| single-quoted (no interpolation) | 2 | 1.6% | 1 | 8.3% |

## Terminator casing

UPPERCASE is convention, not grammar — any identifier is legal.

| Casing | Heredocs | % of sites | Gems | % of heredoc-using gems |
|---|---|---|---|---|
| UPPERCASE | 122 | 100.0% | 12 | 100.0% |

Non-uppercase terminators seen: 

## Interpolation, position, stacking

| Property | Heredocs | % |
|---|---|---|
| body interpolates | 93 | 76.2% |
| body is literal | 29 | 23.8% |
| passed as a call argument | 31 | 25.4% |
| lines opening 2+ heredocs | 0 | — |

## Body size

| Size | Heredocs | % |
|---|---|---|
| 1 line | 7 | 5.7% |
| 2-5 lines | 57 | 46.7% |
| 6-20 lines | 40 | 32.8% |
| 21+ lines | 18 | 14.8% |

## Terminator names (top 40)

What heredocs are used for — SQL, HTML, RUBY, and friends name their content.

| Terminator | Heredocs |
|---|---|
| `RUBY` | 40 |
| `EOS` | 33 |
| `MARKDOWN` | 14 |
| `HTML` | 12 |
| `JS` | 8 |
| `PATTERN` | 3 |
| `EO_OUTPUT` | 2 |
| `LAMBDA` | 2 |
| `CONTENT` | 2 |
| `SQL` | 1 |
| `EO_ERROR` | 1 |
| `END_SRC` | 1 |
| `ROW` | 1 |
| `TYPES_JS` | 1 |
| `CONFIG_JS` | 1 |

## Gems with the most heredocs

| Gem | Heredocs |
|---|---|
| wrappix | 54 |
| github-pulse | 21 |
| gli | 16 |
| middleman-presentation-core | 12 |
| puppet-lint-classes_and_types_beginning_with_digits--check | 5 |
| paraxial | 3 |
| nexus_mods | 3 |
| y_petri | 2 |
| jekyll-webmention_io | 2 |
| wirecard-rails | 2 |

Errors: 0
