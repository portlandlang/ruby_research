# Symbols built from text across RubyGems.org

Based on a random sample of 100 gems (seeded, reproducible), out of 196982 on RubyGems.org.

**620** sites across **26** gems (26.0% of analyzed gems build a symbol from text somewhere).

For portland ADR 0023 §3, re-opened: Portland has no `String#to_sym`, so every symbol is literal and a declared vocabulary can be checked. The proposal is to allow a symbol from text wherever a symbol is a plain value and refuse it only where a declared vocabulary is expected. The consumer column is the question: how much of this feeds hash keys and comparisons (open positions, allowed under the proposal), how much feeds metaprogramming (gone regardless), and how much would meet a checked position.

## Constructs

| Construct | Sites | % of sites | Gems | % of analyzed gems |
|---|---:|---:|---:|---:|
| `to_sym` | 491 | 79.2% | 23 | 23.0% |
| `intern` | 90 | 14.5% | 1 | 1.0% |
| `interpolated symbol` | 15 | 2.4% | 6 | 6.0% |
| `symbolize_keys` | 6 | 1.0% | 2 | 2.0% |
| `symbolize_names:` | 5 | 0.8% | 3 | 3.0% |
| `with_indifferent_access` | 5 | 0.8% | 3 | 3.0% |
| `deep_symbolize_keys!` | 3 | 0.5% | 1 | 1.0% |
| `deep_symbolize_keys` | 2 | 0.3% | 1 | 1.0% |
| `transform_keys(&:to_sym)` | 2 | 0.3% | 1 | 1.0% |
| `symbolize_keys!` | 1 | 0.2% | 1 | 1.0% |

## What `to_sym` and `intern` are called on

A string literal receiver could have been a symbol literal; an interpolated string is a name assembled from parts; a variable or call is text the program did not write.

| Receiver | Sites | % of to_sym/intern sites |
|---|---:|---:|
| a variable or call | 523 | 90.0% |
| an interpolated string | 28 | 4.8% |
| a string literal | 21 | 3.6% |
| no receiver | 9 | 1.5% |

## What the runtime symbol feeds

For `to_sym`, `intern`, and interpolated-symbol sites: the nearest ancestor that says what the symbol is for.

| Consumer | Sites | % of sites | Gems |
|---|---:|---:|---:|
| a binding | 139 | 23.3% | 9 |
| other | 133 | 22.3% | 5 |
| a hash key | 133 | 22.3% | 8 |
| an argument to another method | 83 | 13.9% | 8 |
| a receiver of another method | 38 | 6.4% | 2 |
| a metaprogramming call | 26 | 4.4% | 6 |
| a membership test | 22 | 3.7% | 7 |
| a comparison with a non-literal | 18 | 3.0% | 2 |
| a comparison with a literal symbol | 3 | 0.5% | 1 |
| a case subject | 1 | 0.2% | 1 |

### Consumer by construct

| Construct | Consumers (sites) |
|---|---|
| `interpolated symbol` | an argument to another method 11, a binding 2, a metaprogramming call 1, other 1 |
| `to_sym` | other 123, a hash key 123, a binding 112, an argument to another method 56, a metaprogramming call 25, a membership test 22, a comparison with a non-literal 18, a receiver of another method 8, a comparison with a literal symbol 3, a case subject 1 |
| `intern` | a receiver of another method 30, a binding 25, an argument to another method 16, a hash key 10, other 9 |

## By era

Share of gems in each cohort that use each construct at least once.

| Construct | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| deep_symbolize_keys | 2.4% | 0.0% | 0.0% |
| deep_symbolize_keys! | 2.4% | 0.0% | 0.0% |
| intern | 0.0% | 0.0% | 2.9% |
| interpolated symbol | 2.4% | 8.0% | 8.8% |
| symbolize_keys | 2.4% | 0.0% | 2.9% |
| symbolize_keys! | 2.4% | 0.0% | 0.0% |
| symbolize_names: | 2.4% | 0.0% | 5.9% |
| to_sym | 22.0% | 28.0% | 20.6% |
| transform_keys(&:to_sym) | 0.0% | 4.0% | 0.0% |
| with_indifferent_access | 4.9% | 4.0% | 0.0% |

Cohort sizes: 2015-2019 41, 2020+ 25, pre-2015 34 (100 gems). Cells are the share of gems in that cohort exhibiting the row, so columns are comparable to each other and to how large the cohort is overall.

### Composition of sites

| Construct | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| deep_symbolize_keys | 3.3% | 0.0% | 0.0% |
| deep_symbolize_keys! | 5.0% | 0.0% | 0.0% |
| intern | 0.0% | 0.0% | 16.8% |
| interpolated symbol | 1.7% | 21.7% | 1.7% |
| symbolize_keys | 3.3% | 0.0% | 0.7% |
| symbolize_keys! | 1.7% | 0.0% | 0.0% |
| symbolize_names: | 1.7% | 0.0% | 0.7% |
| to_sym | 76.7% | 65.2% | 80.1% |
| transform_keys(&:to_sym) | 0.0% | 8.7% | 0.0% |
| with_indifferent_access | 6.7% | 4.3% | 0.0% |

Sites per cohort: 2015-2019 60, 2020+ 23, pre-2015 537 (620 sites). Cells are the share of that cohort's sites, so each column sums to 100%. This is scale-free: it says what the code is made of, not how much code there is.

### Density

| Construct | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| deep_symbolize_keys | 1.9 | 0.0 | 0.0 |
| deep_symbolize_keys! | 2.9 | 0.0 | 0.0 |
| intern | 0.0 | 0.0 | 2.6 |
| interpolated symbol | 1.0 | 3.9 | 0.3 |
| symbolize_keys | 1.9 | 0.0 | 0.1 |
| symbolize_keys! | 1.0 | 0.0 | 0.0 |
| symbolize_names: | 1.0 | 0.0 | 0.1 |
| to_sym | 44.2 | 11.7 | 12.4 |
| transform_keys(&:to_sym) | 0.0 | 1.6 | 0.0 |
| with_indifferent_access | 3.8 | 0.8 | 0.0 |

AST nodes per cohort: 2015-2019 104130, 2020+ 128006, pre-2015 3479068 (3711204 nodes). Cells are sites per 100,000 AST nodes — how much of this construct per unit of code, independent of gem size.

## Gems with the most sites

| Gem | Sites |
|---|---:|
| candlepin-api | 520 |
| appfuel | 31 |
| jamnagar | 6 |
| reline | 6 |
| paperclip-neo4j | 6 |
| jsonapi-validations | 5 |
| madscience | 4 |
| fit_parser | 4 |
| meteoroid | 4 |
| json_mapper | 4 |

Errors: 0
