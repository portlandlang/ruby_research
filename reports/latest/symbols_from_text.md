# Symbols built from text across RubyGems.org

Based on a random sample of 5000 gems (seeded, reproducible), out of 196982 on RubyGems.org.

**15004** sites across **1377** gems (27.5% of analyzed gems build a symbol from text somewhere).

For portland ADR 0023 §3, re-opened: Portland has no `String#to_sym`, so every symbol is literal and a declared vocabulary can be checked. The proposal is to allow a symbol from text wherever a symbol is a plain value and refuse it only where a declared vocabulary is expected. The consumer column is the question: how much of this feeds hash keys and comparisons (open positions, allowed under the proposal), how much feeds metaprogramming (gone regardless), and how much would meet a checked position.

## Constructs

| Construct | Sites | % of sites | Gems | % of analyzed gems |
|---|---:|---:|---:|---:|
| `to_sym` | 10460 | 69.7% | 1156 | 23.1% |
| `interpolated symbol` | 2389 | 15.9% | 299 | 6.0% |
| `transform_keys(&:to_sym)` | 981 | 6.5% | 57 | 1.1% |
| `intern` | 392 | 2.6% | 54 | 1.1% |
| `symbolize_keys` | 284 | 1.9% | 129 | 2.6% |
| `symbolize_names:` | 203 | 1.4% | 97 | 1.9% |
| `with_indifferent_access` | 160 | 1.1% | 73 | 1.5% |
| `deep_symbolize_keys` | 69 | 0.5% | 24 | 0.5% |
| `symbolize_keys!` | 52 | 0.3% | 32 | 0.6% |
| `deep_symbolize_keys!` | 14 | 0.1% | 8 | 0.2% |

## What `to_sym` and `intern` are called on

A string literal receiver could have been a symbol literal; an interpolated string is a name assembled from parts; a variable or call is text the program did not write.

| Receiver | Sites | % of to_sym/intern sites |
|---|---:|---:|
| a variable or call | 10317 | 95.1% |
| an interpolated string | 436 | 4.0% |
| a string literal | 56 | 0.5% |
| no receiver | 43 | 0.4% |

## What the runtime symbol feeds

For `to_sym`, `intern`, and interpolated-symbol sites: the nearest ancestor that says what the symbol is for.

| Consumer | Sites | % of sites | Gems |
|---|---:|---:|---:|
| a hash key | 3339 | 25.2% | 579 |
| a metaprogramming call | 2109 | 15.9% | 338 |
| a membership test | 1719 | 13.0% | 269 |
| other | 1668 | 12.6% | 487 |
| a binding | 1598 | 12.1% | 485 |
| a case subject | 1493 | 11.3% | 83 |
| an argument to another method | 917 | 6.9% | 310 |
| a comparison with a non-literal | 146 | 1.1% | 48 |
| a receiver of another method | 132 | 1.0% | 44 |
| a comparison with a literal symbol | 119 | 0.9% | 59 |
| a receiver of to_s or to_proc | 1 | 0.0% | 1 |

### Consumer by construct

| Construct | Consumers (sites) |
|---|---|
| `interpolated symbol` | a metaprogramming call 1689, a hash key 182, an argument to another method 177, a binding 168, other 157, a membership test 13, a comparison with a non-literal 2, a receiver of another method 1 |
| `to_sym` | a hash key 3104, a membership test 1700, a case subject 1492, other 1425, a binding 1314, an argument to another method 682, a metaprogramming call 404, a comparison with a non-literal 144, a comparison with a literal symbol 119, a receiver of another method 75, a receiver of to_s or to_proc 1 |
| `intern` | a binding 116, other 86, an argument to another method 58, a receiver of another method 56, a hash key 53, a metaprogramming call 16, a membership test 6, a case subject 1 |

## By era

Share of gems in each cohort that use each construct at least once.

| Construct | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| deep_symbolize_keys | 0.5% | 0.9% | 0.2% |
| deep_symbolize_keys! | 0.2% | 0.2% | 0.1% |
| intern | 0.5% | 0.5% | 2.1% |
| interpolated symbol | 3.6% | 9.6% | 5.1% |
| symbolize_keys | 1.9% | 3.5% | 2.4% |
| symbolize_keys! | 0.1% | 0.5% | 1.2% |
| symbolize_names: | 1.6% | 4.0% | 0.6% |
| to_sym | 18.4% | 28.0% | 23.2% |
| transform_keys(&:to_sym) | 0.1% | 3.7% | 0.0% |
| with_indifferent_access | 0.7% | 2.7% | 1.1% |

Cohort sizes: 2015-2019 1604, 2020+ 1510, pre-2015 1886 (5000 gems). Cells are the share of gems in that cohort exhibiting the row, so columns are comparable to each other and to how large the cohort is overall.

### Composition of sites

| Construct | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| deep_symbolize_keys | 1.8% | 0.3% | 0.2% |
| deep_symbolize_keys! | 0.3% | 0.1% | 0.1% |
| intern | 2.7% | 1.1% | 7.3% |
| interpolated symbol | 9.6% | 18.3% | 12.7% |
| symbolize_keys | 2.9% | 1.3% | 3.2% |
| symbolize_keys! | 0.1% | 0.2% | 1.1% |
| symbolize_names: | 1.9% | 1.4% | 0.7% |
| to_sym | 79.6% | 66.6% | 73.0% |
| transform_keys(&:to_sym) | 0.1% | 10.0% | 0.0% |
| with_indifferent_access | 0.8% | 0.9% | 1.8% |

Sites per cohort: 2015-2019 2052, 2020+ 9828, pre-2015 3124 (15004 sites). Cells are the share of that cohort's sites, so each column sums to 100%. This is scale-free: it says what the code is made of, not how much code there is.

### Density

| Construct | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| deep_symbolize_keys | 1.0 | 0.2 | 0.0 |
| deep_symbolize_keys! | 0.2 | 0.0 | 0.0 |
| intern | 1.5 | 0.7 | 2.0 |
| interpolated symbol | 5.2 | 11.4 | 3.5 |
| symbolize_keys | 1.6 | 0.8 | 0.9 |
| symbolize_keys! | 0.1 | 0.1 | 0.3 |
| symbolize_names: | 1.1 | 0.9 | 0.2 |
| to_sym | 43.3 | 41.6 | 20.2 |
| transform_keys(&:to_sym) | 0.1 | 6.2 | 0.0 |
| with_indifferent_access | 0.5 | 0.5 | 0.5 |

AST nodes per cohort: 2015-2019 3771948, 2020+ 15737283, pre-2015 11299942 (30809173 nodes). Cells are sites per 100,000 AST nodes — how much of this construct per unit of code, independent of gem size.

## Gems with the most sites

| Gem | Sites |
|---|---:|
| ory-client | 1745 |
| onfido | 1459 |
| shortcut_client_ruby | 708 |
| candlepin-api | 520 |
| bag_kadaster_client | 502 |
| integration_api | 366 |
| kabustation_client | 337 |
| mlh-rubocop-config | 336 |
| commonlit-clever-ruby | 336 |
| anthropic | 243 |

Errors: 0
