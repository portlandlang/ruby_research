# How gems test themselves

The test framework each gem's gemspec names among its development dependencies, for all gems, the gems that parse under pdx, and those of them with no open question left (portland#117).

## all gems (196964 gems, 57876 ship tests in the .gem)

| Framework | Gems |
|---|---:|
| none named | 120687 |
| rspec | 58936 |
| minitest | 12704 |
| test-unit | 5362 |
| bacon | 267 |
| cutest | 169 |

## parse under pdx (10426 gems, 915 ship tests in the .gem)

| Framework | Gems |
|---|---:|
| none named | 7677 |
| rspec | 2107 |
| minitest | 486 |
| test-unit | 159 |
| bacon | 4 |
| cutest | 3 |

## no open question (3124 gems, 8 ship tests in the .gem)

| Framework | Gems |
|---|---:|
| none named | 2935 |
| rspec | 138 |
| minitest | 38 |
| test-unit | 13 |
| cutest | 1 |

## What their shipped tests call

Method names called across the shipped test files of the gems that parse under pdx, most first (the no-open-question group ships too few tests to say much).

| Call | Times |
|---|---:|
| `it` | 5474 |
| `should` | 4837 |
| `expect` | 2895 |
| `to` | 2827 |
| `==` | 2790 |
| `describe` | 2664 |
| `new` | 2379 |
| `[]` | 1896 |
| `eq` | 1808 |
| `require` | 1781 |
| `assert_equal` | 1746 |
| `subject` | 1104 |
| `context` | 847 |
| `include` | 638 |
| `let` | 623 |
| `+` | 585 |
| `be` | 554 |
| `before` | 473 |
| `each` | 421 |
| `raise_error` | 421 |
| `assert` | 398 |
| `dirname` | 369 |
| `<<` | 314 |
| `expand_path` | 304 |
| `[]=` | 290 |
| `get` | 283 |
| `lambda` | 276 |
| `should_not` | 274 |
| `utc` | 264 |
| `Then` | 263 |
| `size` | 259 |
| `*` | 248 |
| `name` | 232 |
| `first` | 228 |
| `test` | 227 |
| `be_nil` | 215 |
| `date_or_time` | 213 |
| `join` | 210 |
| `receive` | 201 |
| `create` | 197 |
| `and_return` | 196 |
| `with` | 188 |
| `match` | 183 |
| `not_to` | 183 |
| `to_s` | 177 |
| `count` | 175 |
| `described_class` | 169 |
| `page` | 166 |
| `length` | 165 |
| `equal` | 161 |
| `valid?` | 156 |
| `class` | 154 |
| `to_a` | 150 |
| `local` | 144 |
| `read` | 143 |
| `predictor` | 140 |
| `body` | 139 |
| `raise` | 135 |
| `fail` | 134 |
| `parse` | 132 |
