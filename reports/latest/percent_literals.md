# `%` literal census across RubyGems.org

Based on a random sample of 5000 gems (seeded, reproducible), out of 195399 on RubyGems.org.

**27346** `%` literals across **1616** gems (32.3% of gems use at least one member).

The top 5 gems hold 32.9% of all sites, so prefer the per-gem columns over raw site counts.

## Members

| Member | Sites | % of sites | Gems | % of analyzed gems |
|---|---:|---:|---:|---:|
| `%w` | 12791 | 46.8% | 1096 | 21.9% |
| `%` | 5897 | 21.6% | 329 | 6.6% |
| `%r` | 3335 | 12.2% | 456 | 9.1% |
| `%i` | 3239 | 11.8% | 300 | 6.0% |
| `%Q` | 1169 | 4.3% | 171 | 3.4% |
| `%q` | 537 | 2.0% | 79 | 1.6% |
| `%x` | 226 | 0.8% | 60 | 1.2% |
| `%W` | 146 | 0.5% | 66 | 1.3% |
| `%I` | 6 | 0.0% | 2 | 0.0% |

## Delimiters

| Delimiter | Sites | % of sites | Gems |
|---|---:|---:|---:|
| `()` | 10899 | 39.9% | 755 |
| `[]` | 8105 | 29.6% | 686 |
| `{}` | 7260 | 26.5% | 663 |
| `||` | 272 | 1.0% | 55 |
| `<>` | 207 | 0.8% | 53 |
| `//` | 158 | 0.6% | 32 |
| `!!` | 149 | 0.5% | 36 |
| `%%` | 79 | 0.3% | 11 |
| `''` | 78 | 0.3% | 11 |
| `""` | 56 | 0.2% | 14 |
| `$$` | 50 | 0.2% | 7 |
| `--` | 8 | 0.0% | 3 |
| `@@` | 6 | 0.0% | 2 |
| `##` | 5 | 0.0% | 4 |
| `^^` | 3 | 0.0% | 2 |
| `::` | 3 | 0.0% | 2 |
| ```` | 3 | 0.0% | 1 |
| `??` | 2 | 0.0% | 1 |
| `==` | 1 | 0.0% | 1 |
| `++` | 1 | 0.0% | 1 |
| `..` | 1 | 0.0% | 1 |

### Delimiters by member

| Member | Delimiters (sites) |
|---|---|
| `%i` | `[]` 3084, `()` 139, `{}` 16 |
| `%w` | `()` 6978, `[]` 4413, `{}` 1265, `''` 68, `//` 31, `||` 13, `""` 11, `$$` 5, `--` 3, `!!` 2, `..` 1, `<>` 1 |
| `%r` | `{}` 2426, `()` 238, `<>` 145, `//` 119, `||` 116, `!!` 94, `[]` 93, `%%` 75, `""` 17, `''` 5, `##` 4, `::` 1, `@@` 1, `--` 1 |
| `%` | `()` 3099, `{}` 2412, `[]` 256, `||` 43, `<>` 34, `!!` 33, `@@` 5, `%%` 3, `//` 3, `''` 3, `??` 2, `::` 1, `##` 1, `==` 1, `++` 1 |
| `%Q` | `{}` 641, `()` 254, `[]` 126, `||` 100, `<>` 26, `!!` 8, `//` 5, ```` 3, `''` 2, `""` 2, `^^` 1, `%%` 1 |
| `%q` | `{}` 361, `[]` 46, `()` 45, `$$` 45, `""` 22, `!!` 11, `--` 4, `^^` 2, `::` 1 |
| `%W` | `()` 83, `[]` 48, `{}` 14, `<>` 1 |
| `%x` | `{}` 125, `()` 61, `[]` 35, `""` 4, `!!` 1 |
| `%I` | `[]` 4, `()` 2 |

## Content that escapes or nests its own delimiter

Sizes whether delimiter escapes and balanced nesting matter to real code.

| Member | Escaped delimiter | Nested delimiter |
|---|---:|---:|
| `%w` | 2 | 53 |
| `%` | 7 | 1353 |
| `%r` | 54 | 406 |
| `%i` | 1 | 51 |
| `%Q` | 0 | 331 |
| `%q` | 5 | 66 |
| `%x` | 0 | 69 |
| `%W` | 0 | 14 |
| `%I` | 0 | 0 |

## Why `%q`, `%Q`, and bare `%` are reached for

The one thing they buy over `'...'` and `"..."` is a body with quotes in it.

| Body contains | Sites | % of string-member sites |
|---|---:|---:|
| a double quote | 4194 | 55.2% |
| no quote character | 2173 | 28.6% |
| both quote characters | 730 | 9.6% |
| a single quote | 506 | 6.7% |

## By era

Share of `%`-using gems in each cohort that write each member.

| Member | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| % | 17.9% | 17.0% | 25.2% |
| %I | 0.0% | 0.3% | 0.0% |
| %Q | 10.0% | 5.0% | 16.2% |
| %W | 6.4% | 2.9% | 3.6% |
| %i | 15.5% | 40.0% | 0.6% |
| %q | 5.2% | 3.5% | 6.0% |
| %r | 19.8% | 31.5% | 30.9% |
| %w | 66.2% | 65.9% | 70.7% |
| %x | 4.5% | 1.9% | 4.9% |

Cohort sizes: 2015-2019 420, 2020+ 578, pre-2015 618 (1616 gems). Cells are the share of gems in that cohort exhibiting the row, so columns are comparable to each other and to how large the cohort is overall.

### Composition of sites

| Member | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| % | 24.2% | 7.7% | 37.6% |
| %I | 0.0% | 0.1% | 0.0% |
| %Q | 5.7% | 1.9% | 6.3% |
| %W | 1.1% | 0.3% | 0.5% |
| %i | 2.1% | 26.5% | 0.1% |
| %q | 1.8% | 1.6% | 2.5% |
| %r | 12.9% | 11.2% | 13.0% |
| %w | 51.4% | 50.0% | 39.1% |
| %x | 0.8% | 0.7% | 1.0% |

Sites per cohort: 2015-2019 6693, 2020+ 11687, pre-2015 8966 (27346 sites). Cells are the share of that cohort's sites, so each column sums to 100%. This is scale-free: it says what the code is made of, not how much code there is.

### Density

| Member | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| % | 34.3 | 5.8 | 80.4 |
| %I | 0.0 | 0.0 | 0.0 |
| %Q | 8.1 | 1.4 | 13.4 |
| %W | 1.5 | 0.2 | 1.0 |
| %i | 2.9 | 19.7 | 0.1 |
| %q | 2.6 | 1.2 | 5.4 |
| %r | 18.3 | 8.4 | 27.7 |
| %w | 72.9 | 37.3 | 83.6 |
| %x | 1.2 | 0.5 | 2.0 |

AST nodes per cohort: 2015-2019 4720006, 2020+ 15680145, pre-2015 4195412 (24595563 nodes). Cells are sites per 100,000 AST nodes — how much of this construct per unit of code, independent of gem size.

## Gems with the most `%` literals

| Gem | Sites |
|---|---:|
| lexxy-variables | 3016 |
| sc_core | 2318 |
| actionpack-2.3.17-rack-upgrade | 1534 |
| ghazel-erubis_rails_helper | 1363 |
| fattureincloud_ruby_sdk | 776 |
| activerecord-postgresql-extensions | 582 |
| ory-keto-client | 565 |
| pdf_oxide | 510 |
| newstore-apimatic-sdk | 448 |
| when_exe | 392 |

Errors: 0
