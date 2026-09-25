# `%` literal census across RubyGems.org

Based on a random sample of 500 gems (seeded, reproducible), out of 195399 on RubyGems.org.

**4007** `%` literals across **150** gems (30.0% of gems use at least one member).

The top 5 gems hold 73.9% of all sites, so prefer the per-gem columns over raw site counts.

## Members

| Member | Sites | % of sites | Gems | % of analyzed gems |
|---|---:|---:|---:|---:|
| `%` | 1504 | 37.5% | 34 | 6.8% |
| `%w` | 1442 | 36.0% | 98 | 19.6% |
| `%i` | 536 | 13.4% | 32 | 6.4% |
| `%r` | 373 | 9.3% | 42 | 8.4% |
| `%Q` | 97 | 2.4% | 11 | 2.2% |
| `%q` | 29 | 0.7% | 10 | 2.0% |
| `%W` | 21 | 0.5% | 6 | 1.2% |
| `%x` | 5 | 0.1% | 3 | 0.6% |

## Delimiters

| Delimiter | Sites | % of sites | Gems |
|---|---:|---:|---:|
| `()` | 1648 | 41.1% | 70 |
| `[]` | 1334 | 33.3% | 57 |
| `{}` | 935 | 23.3% | 60 |
| `<>` | 35 | 0.9% | 3 |
| `!!` | 21 | 0.5% | 5 |
| `//` | 13 | 0.3% | 6 |
| `||` | 10 | 0.2% | 6 |
| `''` | 6 | 0.1% | 1 |
| `^^` | 3 | 0.1% | 2 |
| `$$` | 1 | 0.0% | 1 |
| `""` | 1 | 0.0% | 1 |

### Delimiters by member

| Member | Delimiters (sites) |
|---|---|
| `%i` | `[]` 486, `()` 46, `{}` 4 |
| `%w` | `[]` 803, `()` 473, `{}` 157, `''` 6, `//` 1, `$$` 1, `""` 1 |
| `%r` | `{}` 320, `!!` 15, `()` 11, `//` 11, `[]` 8, `<>` 4, `||` 4 |
| `%` | `()` 1086, `{}` 370, `<>` 31, `[]` 11, `!!` 5, `||` 1 |
| `%Q` | `{}` 69, `()` 17, `||` 5, `[]` 3, `//` 1, `^^` 1, `!!` 1 |
| `%q` | `()` 13, `{}` 10, `[]` 4, `^^` 2 |
| `%W` | `[]` 19, `()` 2 |
| `%x` | `{}` 5 |

## Content that escapes or nests its own delimiter

Sizes whether delimiter escapes and balanced nesting matter to real code.

| Member | Escaped delimiter | Nested delimiter |
|---|---:|---:|
| `%` | 0 | 370 |
| `%w` | 0 | 4 |
| `%i` | 0 | 12 |
| `%r` | 5 | 63 |
| `%Q` | 0 | 17 |
| `%q` | 0 | 3 |
| `%W` | 0 | 0 |
| `%x` | 0 | 1 |

## Why `%q`, `%Q`, and bare `%` are reached for

The one thing they buy over `'...'` and `"..."` is a body with quotes in it.

| Body contains | Sites | % of string-member sites |
|---|---:|---:|
| a double quote | 1077 | 66.1% |
| no quote character | 280 | 17.2% |
| both quote characters | 208 | 12.8% |
| a single quote | 65 | 4.0% |

## By era

Share of `%`-using gems in each cohort that write each member.

| Member | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| % | 15.2% | 15.4% | 36.5% |
| %Q | 8.7% | 3.8% | 9.6% |
| %W | 4.3% | 5.8% | 1.9% |
| %i | 23.9% | 40.4% | 0.0% |
| %q | 8.7% | 3.8% | 7.7% |
| %r | 15.2% | 28.8% | 38.5% |
| %w | 71.7% | 65.4% | 59.6% |
| %x | 2.2% | 1.9% | 1.9% |

Cohort sizes: 2015-2019 46, 2020+ 52, pre-2015 52 (150 gems). Cells are the share of gems in that cohort exhibiting the row, so columns are comparable to each other and to how large the cohort is overall.

### Composition of sites

| Member | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| % | 4.8% | 4.8% | 69.7% |
| %Q | 7.6% | 1.0% | 3.0% |
| %W | 4.4% | 0.5% | 0.0% |
| %i | 13.3% | 28.9% | 0.0% |
| %q | 3.2% | 0.5% | 0.6% |
| %r | 22.5% | 12.3% | 5.1% |
| %w | 43.8% | 51.8% | 21.4% |
| %x | 0.4% | 0.1% | 0.1% |

Sites per cohort: 2015-2019 249, 2020+ 1739, pre-2015 2019 (4007 sites). Cells are the share of that cohort's sites, so each column sums to 100%. This is scale-free: it says what the code is made of, not how much code there is.

### Density

| Member | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| % | 3.4 | 2.4 | 358.2 |
| %Q | 5.4 | 0.5 | 15.3 |
| %W | 3.1 | 0.3 | 0.3 |
| %i | 9.4 | 14.2 | 0.0 |
| %q | 2.3 | 0.3 | 3.1 |
| %r | 16.0 | 6.1 | 26.2 |
| %w | 31.2 | 25.5 | 110.1 |
| %x | 0.3 | 0.1 | 0.5 |

AST nodes per cohort: 2015-2019 349683, 2020+ 3533014, pre-2015 393120 (4275817 nodes). Cells are sites per 100,000 AST nodes — how much of this construct per unit of code, independent of gem size.

## Gems with the most `%` literals

| Gem | Sites |
|---|---:|
| actionpack-2.3.17-rack-upgrade | 1534 |
| fattureincloud_ruby_sdk | 776 |
| newstore-apimatic-sdk | 448 |
| capistrano-edge | 137 |
| facebookbusiness | 68 |
| new_cfoundry | 67 |
| 24games | 53 |
| gli | 52 |
| google-cloud-backupdr-v1 | 47 |
| kreator | 44 |

Errors: 0
