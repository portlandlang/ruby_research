# First-gem candidates

The gems most likely to be the first to run on Portland with their own tests passing, out of 196982 gems with a pdx-parse result. Each stage keeps the gems passing it and every stage before.

| Stage | Gems |
|---|---:|
| every lib/ file parses under pdx | 33589 |
| no runtime dependencies | 20394 |
| pure Ruby, no C extension | 19399 |
| no open question (gap or undecided) | 5701 |
| ships its own tests | 28 |

## The candidates, by downloads (first 28)

Thesis and taste differences are the decided ones the gem still touches — the edits it needs, or a linter could make — as `portland-compatibility` lists them.

| Gem | Version | Downloads | Test files | Thesis differences | Taste differences |
|---|---|---:|---:|---|---|
| nido | 1.0.0 | 549422 | 1 |  | inheritance |
| BigCat | 1.0.2 | 58160 | 1 | raise-rescue | global-variables |
| aa | 1.1 | 35437 | 1 | method-missing, runtime-define-method, class-variables | inheritance |
| regex_replace | 1.0.4 | 15853 | 1 |  |  |
| bigcat | 1.0.3 | 12630 | 1 | raise-rescue | global-variables |
| whinytasks | 0.0.2 | 12158 | 1 | eval-family, raise-rescue |  |
| crash | 1.0.22 | 11617 | 1 |  |  |
| freeman | 0.0.4 | 10340 | 1 |  |  |
| configur | 1.1.0 | 9801 | 1 | method-missing, class-variables | inheritance |
| hash-polyfill | 0.1.20180120 | 7107 | 1 | in-place-mutators |  |
| mono | 0.0.1 | 7084 | 1 |  |  |
| JosephPecoraro-rr | 1.0.3 | 6426 | 1 |  |  |
| switchout | 0.0.2 | 5966 | 1 | raise-rescue | global-variables, singleton-class-block |
| draft | 0.0.0 | 5890 | 1 |  |  |
| htmldog | 1.0.0 | 5750 | 1 |  |  |
| machospec | 0.0.0.1 | 4932 | 1 | raise-rescue |  |
| scream | 0.0.1 | 4897 | 1 |  |  |
| opal-json | 0.0.1 | 4886 | 2 |  |  |
| matic_timestamp | 0.0.1 | 4731 | 1 | eval-family | inheritance |
| meth | 0.1.0 | 4630 | 1 |  |  |
| reraise | 0.0.1 | 4483 | 1 | method-missing, in-place-mutators, raise-rescue | inheritance |
| cols | 0.0.1 | 4480 | 1 |  |  |
| fizzbuzzard | 0.0.1 | 4472 | 1 |  |  |
| haml-partial | 0.1.0 | 4044 | 1 |  |  |
| kic | 0.0.1 | 3937 | 1 |  |  |
| stop-words | 0.0.1 | 3770 | 1 |  |  |
| veganstraightedge-htmldog | 1.0.0.200903121450 | 3752 | 1 |  |  |
| hola_world | 0.0.0 | 2989 | 1 |  |  |
