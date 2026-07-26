# Dependencies that point at gems not on RubyGems.org

**Status:** open question, data gathered 2026-07-25. Not yet a report.

## What was found

Building the dependency graph (`script/report dependencies`) surfaced an
inconsistency: the latest releases of the 195,399 gems in the corpus
reference **25,692 distinct gem names as runtime dependencies, but only
25,560 of those exist in `names.txt`**. So **132 dependency edges point at
gems that RubyGems.org does not have.**

Confirmed not a case-collision artifact: **zero** of the 132 differ only by
letter case from a real gem, so this is unrelated to the cache-key bug
documented in METHODOLOGY.md.

## Why it might matter

- **Methodological.** Several reports assume the corpus is closed — that a
  dependency name resolves to a gem we can analyze. It mostly does (99.5% of
  referenced names), but not entirely. Any future dependency-graph work
  (transitive closure, depth, reverse-dependency weighting for cohort
  slicing) needs a defined policy for dangling edges.
- **Ecosystem health.** 132 unresolvable dependencies means some published
  gems cannot be installed from RubyGems.org alone. `active_support` alone
  is referenced by 118 gems.
- **Possibly upstream-reportable**, like the case-collisions finding — but
  only after the hypotheses below are tested. Several categories look like
  legitimate behavior rather than bugs.

## Hypotheses to test

Ranked by how much of the list each would explain. These are patterns
visible in the names; none are verified.

1. **Pre-1.0 Rails naming.** `active_support` (118 dependents),
   `active_record` (10), `active_resource`, `active_merchant`,
   `action_mailer`. Underscored names from the era before the gems were
   published as `activesupport` etc. Were these ever real published gems
   that got renamed and removed, or did authors simply write the wrong name
   in their gemspec? This one category is ~140 of the 310,838 edges and
   dominates the list.
2. **Gems hosted somewhere other than RubyGems.org.** `rails-assets-angular`,
   `rails-assets-jquery-ui`, `rails-assets-underscore` come from
   rails-assets.org, a separate gem host. Bundler supports multiple sources,
   so these are *correct* gemspecs whose dependencies simply are not on
   RubyGems.org. If confirmed, this category is expected behavior and should
   be excluded rather than reported. Relevant to the gem.coop question of
   multi-host ecosystems.
3. **Version strings leaking into the name field.** `log4r-1.0.5`,
   `stream-0.5`, and especially `camping>=1.5.180` — that last one is an
   entire requirement string sitting in a dependency name. Suggests
   malformed gemspecs that RubyGems accepted. Worth checking whether current
   RubyGems still permits this.
4. **github-gems era names.** `jakewendt-*` (3 names), `senotrusov-*`,
   `halorgium-activesupport`, `yabawock-Saikuro`, `djberg96-krb5-auth`,
   `tiegz-*`. The `user-gem` convention from gems.github.com (2008–2009),
   which shut down; these likely never migrated.
5. **Yanked gems.** `scrapi`, `pcap`, `vrlib`, `mongomapper`, `logstash`.
   A gem whose every version is yanked leaves `names.txt` while dependents
   keep referencing it. Check the RubyGems API for tombstones.
6. **Typos.** `activesuport` (missing p), `active-support` (hyphen).
   Small but confirmable.
7. **Never published.** `fuck_you_bundler`, referenced by a gem called
   `fuck_you_rubygems`. Presumably deliberate.

## How to reproduce

Needs no network; reads only the cached compact index.

```sh
bundle exec ruby -r./lib/ruby_research -rjson -e '
client = RubyResearch::CompactIndexClient.new
names  = client.names
known  = names.to_set

referenced = Hash.new { |h, k| h[k] = [] }
names.each do |name|
  versions = client.versions_of(name)
  latest = versions.rfind { it[:platform] == "ruby" } || versions.last
  next unless latest
  latest[:dependencies].each { referenced[it[:name]] << name }
rescue StandardError
  next
end

missing = referenced.reject { |dep, _| known.include?(dep) }
puts "missing: #{missing.size}"
missing.sort_by { |dep, users| -users.size }.each { puts "#{it[0]} (#{it[1].size})" }
'
```

To test hypotheses 1, 5, and 6, the RubyGems API will say whether a name
ever existed (`/api/v1/gems/<name>.json` → 404 vs a tombstone). That is
network access, currently deferred — see TODO.md.

## Next steps

1. Classify all 132 against the hypotheses above; most can be settled by
   inspecting names and dependents without network.
2. Decide the policy for dangling edges in dependency work — exclude, or
   count and disclose. Whichever, say so in the report.
3. If a category turns out to be a genuine RubyGems.org data-integrity
   problem (hypothesis 3 is the strongest candidate), write it up the way
   `case_collisions` was.
4. Consider promoting this to `script/report missing-dependencies` so the
   number is tracked over time rather than being a one-off note.

## The full list

132 names, by number of gems depending on them.

| Missing gem | Dependents | Depended on by |
|---|---|---|
| `active_support` | 118 | `SimControl`, `active_datastore`, `admincredible`, `allen` +114 more |
| `vrlib` | 15 | `ClockOFF`, `cb_all_widgets`, `ebaytool`, `findcontrol` +11 more |
| `active_record` | 10 | `ar_lightning`, `db_version_manager`, `guidebook`, `guillaumegentil-import_fu` +6 more |
| `logstash` | 9 | `logstash-filter-crowd`, `logstash-filter-units`, `logstash-input-log4j`, `logstash-input-log4j2` +5 more |
| `scrapi` | 7 | `google_font_extractor`, `quick_scrapper`, `rbook`, `rcrawl` +3 more |
| `cascading-configuration` | 6 | `cascading-configuration-array`, `cascading-configuration-array-sorted`, `cascading-configuration-array-sorted-unique`, `cascading-configuration-array-unique` +2 more |
| `backbone-on-rails` | 5 | `backbone-jasmine`, `chiropractor`, `compartment`, `nulogyrefineryfrontendeditor` +1 more |
| `mongomapper` | 5 | `mongolytics`, `shingara-merb_mongomapper`, `tpitale-mongolytics`, `yeastymobs-machinist_mongomapper` +1 more |
| `jakewendt-rails_helpers` | 4 | `jakewendt-authorized`, `jakewendt-documents`, `jakewendt-pages`, `jakewendt-photos` |
| `pcap` | 4 | `arbdrone`, `mysql_warmer`, `nmunch`, `thm` |
| `ruby-git` | 4 | `autovrsion`, `tempest-time`, `tempest_time`, `yard-nowpunk` |
| `aws_credentials` | 3 | `ebs_snapshot_cleanup`, `manipulator`, `s3-backup` |
| `jakewendt-assert_this_and_that` | 3 | `jakewendt-authorized`, `jakewendt-documents`, `jakewendt-pages` |
| `keychain_services` | 3 | `omudid`, `publicity`, `xcode` |
| `log4r-1.0.5` | 3 | `genie`, `trimurti`, `yax` |
| `pow` | 3 | `local_unfuddle_notebook`, `ngpod_scraper`, `switch_file` |
| `senotrusov-ruby-toolkit` | 3 | `senotrusov-ruby-daemonic-threads`, `senotrusov-ruby-process-controller`, `senotrusov-ruby-threading-toolkit` |
| `stream-0.5` | 3 | `genie`, `trimurti`, `yax` |
| `Rubilicious` | 2 | `De.linque.nt`, `Graphiclious` |
| `asperalm` | 2 | `cantemo-portal-agent`, `envoi-mam-agent` |
| `collections` | 2 | `fizx-ordered_json`, `loganb-scribble-client` |
| `daemons-mikehale` | 2 | `job_boss`, `redis_ring` |
| `distributed_tracing` | 2 | `cross_spec`, `cross_spec_rails` |
| `dm-more` | 2 | `dm-groonga-adapter`, `kematzy-dm-is-select` |
| `go_puff-http-client` | 2 | `go_puff-prodcat_api`, `go_puff-tax_service` |
| `gotta-common` | 2 | `gotta-run`, `gotta-run-ruby` |
| `halorgium-activesupport` | 2 | `halorgium-actionpack`, `sleuth` |
| `jdbc-teradata` | 2 | `activerecord-jdbcteradata-adapter`, `teradata-extractor` |
| `libxml` | 2 | `sprsquish-blather`, `themactep-fliewr` |
| `myerror` | 2 | `epimath100`, `ogem` |
| `optparse-command` | 2 | `dircat`, `sem4r` |
| `phantom_open_emoji` | 2 | `poe_rails`, `poe_static` |
| `rails-assets-angular` | 2 | `evvnt-submission-form-angular-rails`, `sprangular` |
| `rails-assets-jquery-ui` | 2 | `devoops-rails`, `rails-assets-lygneo_jsxc` |
| `rails-assets-underscore` | 2 | `rails-assets-backbone`, `sprangular` |
| `strava-api-v3` | 2 | `middleman-strava`, `strava-cli` |
| `thor_plus` | 2 | `clone.io`, `daygram` |
| `tree_visitor` | 2 | `gf-dircat`, `gf-ralbum` |
| `vk-ruby` | 2 | `social-bee`, `social_poster` |
| `wxruby2-preview` | 2 | `lustr-wx`, `nobbie-wx-preview` |
| `3scale-client` | 1 | `soos_sample_project` |
| `Choco_Library` | 1 | `Chouhyou` |
| `Ruby-yUML` | 1 | `traffic_patterns` |
| `VRTools` | 1 | `vrvirtualdesktop` |
| `aanmapxml` | 1 | `nmap_http_title_dumper` |
| `action_mailer` | 1 | `mtodd-silverpop_mailer` |
| `active-support` | 1 | `tiegz-ruby-mtv` |
| `active_merchant` | 1 | `ship_me` |
| `active_patterns` | 1 | `active_merge` |
| `active_resource` | 1 | `joshuabates-rightscaler` |
| `activesuport` | 1 | `lifespan` |
| `advisable` | 1 | `trellis` |
| `attr_lazy` | 1 | `solr_makr` |
| `bankster-bank_credentials` | 1 | `bankster-client` |
| `baseballdb-commander` | 1 | `aws-cli` |
| `bd_pod_extentions` | 1 | `cocoapods-BDTransform` |
| `biopieces` | 1 | `demultiplexer` |
| `buweb_content_models` | 1 | `biola_wcms_components` |
| `camping>=1.5.180` | 1 | `pasaporte` |
| `cleverbot2` | 1 | `cogibara` |
| `cloud66-backup` | 1 | `cloudblocks` |
| `colours` | 1 | `glimmer-dsl-specification` |
| `commonlit-caracal` | 1 | `decidim-enhanced_textwork` |
| `corsets` | 1 | `microfiche` |
| `couch_foo` | 1 | `capcode-base-couch_foo` |
| `deep_merger` | 1 | `celsius` |
| `default_form` | 1 | `rails_auth` |
| `djberg96-krb5-auth` | 1 | `rack-auth-kerberos` |
| `do_rails` | 1 | `print_preview-rails` |
| `drylib` | 1 | `conreality` |
| `easy_rails_authentication` | 1 | `summer_residents` |
| `emojidex-toolkit` | 1 | `emojidex-desktop` |
| `erubis-auto` | 1 | `flutterby` |
| `ext_rails` | 1 | `flammarion_rails` |
| `ext_ruby` | 1 | `flammarion_rails` |
| `factory_bot_namespaced_factories` | 1 | `munificent` |
| `faster_csv` | 1 | `guillaumegentil-import_fu` |
| `filesaver_rails` | 1 | `flammarion_rails` |
| `freckles` | 1 | `star_track` |
| `fuck_you_bundler` | 1 | `fuck_you_rubygems` |
| `g5_heroku_app_name_formatter` | 1 | `g5_client_notifications_url` |
| `gaku_forms` | 1 | `gaku_nested_forms` |
| `gengin` | 1 | `rmap` |
| `hexx-active_record` | 1 | `uuids` |
| `hooked-hash` | 1 | `compositing-hash` |
| `itunes-library` | 1 | `stratify-itunes` |
| `james_bond-release_mission` | 1 | `james_bond` |
| `jekyll-planet` | 1 | `officetxt` |
| `jlo` | 1 | `wicoris-postman` |
| `jquery-mousewheel_rails` | 1 | `antiscroll_rails` |
| `lettercase` | 1 | `pione` |
| `lightcloud` | 1 | `activeobject` |
| `loaded` | 1 | `courtier` |
| `match_files` | 1 | `insup` |
| `matchy` | 1 | `libc-tidy_ffi` |
| `merb-datamapper` | 1 | `merb-words` |
| `metacrunch-ubpb` | 1 | `mabmapper` |
| `more-ruby` | 1 | `terse_ruby` |
| `msplat` | 1 | `ms-sequest` |
| `net-ldap2` | 1 | `cmu` |
| `net-loc` | 1 | `Sac` |
| `nhibernate3` | 1 | `conform` |
| `novas` | 1 | `gnib-ads-api` |
| `oga-without-the-wimpiness` | 1 | `texttube_baby` |
| `osmlib-export` | 1 | `geodublincreate` |
| `phantom_open_emoji_static` | 1 | `poe_rails` |
| `phr_logging` | 1 | `faraday-client_error_handling` |
| `poker_ranking` | 1 | `poker_croupier_core` |
| `powerline` | 1 | `rmap` |
| `proudhon` | 1 | `social_stream-ostatus` |
| `purecss_rails` | 1 | `articulate_rails` |
| `quecto_parser` | 1 | `quecto_calc` |
| `rails_structured_logging` | 1 | `fizzy-saas` |
| `ruby_matter` | 1 | `kuromd` |
| `sinatra-group-items` | 1 | `dircat` |
| `smtp-tls` | 1 | `vtext` |
| `sorted-array` | 1 | `compositing-array` |
| `standalone-migrations` | 1 | `guidebook` |
| `sunshowers` | 1 | `universe-webserver` |
| `syslog_logger` | 1 | `couchrest_changes` |
| `termbox-ffi` | 1 | `cura-termbox` |
| `terminal_table` | 1 | `todd` |
| `themis-checker-result` | 1 | `themis-checker-server` |
| `time-ago-in-words` | 1 | `interstate` |
| `uakari` | 1 | `chimpster-rails` |
| `unique-array` | 1 | `parallel-ancestry` |
| `unweary` | 1 | `mailer` |
| `userstream` | 1 | `tomodachi` |
| `vlad-extras` | 1 | `traktor` |
| `wind_up_queue` | 1 | `wind_up` |
| `xni` | 1 | `walters` |
| `yabawock-Saikuro` | 1 | `cdd-metric_fu` |

Only 40 of the 132 have more than one dependent; the tail is mostly
single-referrer names, consistent with author error or unpublished
companion gems rather than a systemic problem.
