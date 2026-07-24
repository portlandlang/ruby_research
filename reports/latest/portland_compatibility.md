# Portland compatibility across RubyGems.org

Sampled 500 gems (seeded, reproducible) out of 195399 on RubyGems.org, scanned for the Ruby features Portland removes or changes (config/portland_removals.yml).

Just Work™ candidates (no decided removal detected): **212** (42.4%).

## Gems affected, by removed/changed feature

| Feature | Gems | % of gems |
|---|---|---|
| shift-operators | 210 | 42.0% |
| eval-family | 184 | 36.8% |
| global-variables | 181 | 36.2% |
| runtime-define-method | 80 | 16.0% |
| fetch-retired | 70 | 14.0% |
| thread-model | 54 | 10.8% |
| bitwise-operators | 54 | 10.8% |
| method-missing | 39 | 7.8% |
| for-in-loop | 16 | 3.2% |

## Semantic changes with no static detection

These affect nearly all code via the type checker rather than any syntax form:

- ambient-nil
- truthiness
- mutable-by-default
- monkeypatching-open-classes
- dynamic-typing

## Just Work™ candidates

- AutoZest
- LyricFind
- QAXpert
- active_support-lazy_load_patch
- ad_search
- aga_palindrome
- ai_stream
- alexvishalrps
- angellist-style
- anyparser-core
- aozora-ssml
- apiverve_swiftlookup
- aplayer-rails
- archive-pecan
- arroz
- async-service-supervisor
- async_futurize
- atp_scraper
- automation-shared-support
- bitbucket
- blinky-tape-test-status-guard
- bravissimo
- buildium
- cacertreq
- call_rail
- capistrano3-drupal
- captive-sdk
- cardmagic-omniauth-apple
- cf-ruby-libecp
- champions
- cheetah_mail
- chef-bin
- cmonson_2ndwatch_awsecrets
- codebreaker2018
- color_name
- confc
- countdown_timer
- cryptosol
- cucumber-js_console_errors
- cul-preservation_utils
- datatablesassets-rails
- dcam_view_tool
- devise-pbkdf2-encryptable
- dot
- dotloop-ruby
- dotter_dotfiles
- ellen-twitter
- enerbot-slack
- eric-keyword_search
- errbit_lighthouse_plugin
- esplanade
- everypay
- exponential-backoff
- fanforce-internal-validations
- fleece
- foodie_mihkal
- formadmin
- gemlicense
- geo_monitor
- gid
- git-sync
- gitcontacts
- github-pulse
- gmap-fontawesome
- google-apis-cloudsupport_v2
- google-apis-gameservices_v1beta
- google-apis-notebooks_v2
- google-apis-vmmigration_v1alpha1
- goosi
- h2ocube_rails_tasks
- hardbound
- hippo_view_tool
- horset
- href_protocol
- iching
- jast
- jektop
- jekyll-hardlinks
- jekyll-theme-buttery-biscuit
- jekyll_expressive_organics
- job_hunter_cli
- jsgarvin-flibberty
- jsoneur
- justpics
- katte_hive_autodep
- kiran_hola
- konfiguracja-rails
- latinchart
- libvlc
- license-cli
- lightgraf
- linear
- lita-api-ai
- lita-reverse_table_flip
- locastyle-rails
- logstash-output-unomaly
- math_demo
- minimum-omniauth-scaffold
- modulizer
- mohsin_js
- moj_components
- my_http
- my_string_extend_ankit
- n_able_rails
- namespaced
- neonjs
- ngdrive
- nimbler-path
- nkrus_palindrome
- nokogiri-ext
- oakdex-breeding
- omniauth-chatwork
- omniauth-delivery
- omniauth-facebook-access-token
- onify
- opal-all
- open-uploader-client
- openc3-cosmos-bridge-serial
- organize_files
- ota
- paisa
- partly
- pathspec
- pg-enum
- pg_view_tool
- phantom_client
- pigeon_view_tool
- pl-puppetdb-ruby
- pre-commit-closure-linter
- prepcook
- private-bam
- propshaft-compressor
- psq-dm-xapian
- puppet-lint-classes_and_types_beginning_with_digits--check
- qbloom_filter
- queue_sync
- quine_mc
- rabbit-slide-kou-speee-cafe-meetup-02
- rack-chuck
- rack_health
- rack_session_mongo
- rails_admin_rst_theme
- rainerthiel-zbegit_gem
- rambeau
- raster
- ref2bibtex
- reverse_evolution
- rman
- robokassa_api
- ruboty-mocho
- ruby-psd
- ruby_identicon
- ruby_on_asteroids
- rwdziprwdwruby
- scorespro_parser
- seedance-2
- seedream_4
- semgit
- sgfa
- shopify-rails
- simple_form-theme
- sitemap_gen
- soar_customer
- solo
- sourceress
- spaghetti_stack
- spartan
- sprout-yajl-library
- spruce-beta-ring
- syntax_tree-disable_ternary
- syruppay_jose
- tencentcloud-sdk-cdwpg
- test_changes
- test_metrics
- testecarlos
- thread_ancestors
- timestamped_logger
- tiny_xpath_helper
- tippy_jay
- tlalok-adapter-ospi
- to_lua
- token-die
- tony_correia_view_tool
- topojson-rails
- track_try
- trumbowyg_rails
- tumblr-fu
- tunnelmtu
- tyler-binary_search
- uiux
- upandrunning
- userl
- usman
- valr_api
- valuevaluevalue
- vident-better_html
- viewy
- voteable_krisco
- vp_greeting
- vpn-clistart
- watable-rails
- wavefront
- waylon-db2docs
- wci-bash
- wetube
- wirecard-rails
- wormholio
- xf-generators
- ya_gpio
- yaml_converters
- yo-api
- zillow_ruby

Errors: 0
