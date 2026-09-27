# Readiness level 2: a gem is only as ready as its dependencies

Of the 10426 gems whose every lib/ file parses under pdx, following each one's runtime dependencies all the way down through their latest versions:

- No runtime dependencies: **7254**
- Every dependency parses too: **41**
- Held back by a dependency that doesn't: 3131

## The dependencies holding back the most parsing gems

| Dependency | Parsing gems it holds back |
|---|---:|
| logger | 1574 |
| base64 | 1373 |
| concurrent-ruby | 1165 |
| i18n | 1093 |
| bigdecimal | 1043 |
| rake | 857 |
| json | 839 |
| prism | 812 |
| connection_pool | 752 |
| benchmark | 705 |
| drb | 699 |
| minitest | 697 |
| tzinfo | 696 |
| securerandom | 689 |
| activesupport | 685 |
| racc | 632 |
| rack | 592 |
| thor | 497 |
| mini_portile2 | 470 |
| ostruct | 460 |
| nokogiri | 454 |
| openssl | 423 |
| io-console | 423 |
| reline | 423 |
| net-ssh | 401 |
| activemodel | 395 |
| net-scp | 379 |
| timeout | 365 |
| rack-session | 358 |
| builder | 355 |
| net-sftp | 354 |
| sshkit | 336 |
| mini_mime | 336 |
| airbrussh | 334 |
| capistrano | 334 |
| erubi | 327 |
| activerecord | 327 |
| zeitwerk | 321 |
| public_suffix | 316 |
| addressable | 314 |
| tsort | 304 |
| rbs | 300 |
| erb | 298 |
| rack-test | 298 |
| rdoc | 297 |
| bundler | 296 |
| rackup | 295 |
| cgi | 291 |
| crass | 291 |
| loofah | 288 |
