# Heredoc census across RubyGems.org

Based on all 195390 gems, out of 195399 on RubyGems.org.

**446142** heredocs across **31482** gems (16.1% of gems use at least one).

Heredoc counts are concentrated: the top 5 gems hold 16.6% of all sites
(generated SDKs and DSL-heavy gems dominate), so prefer the per-gem columns over raw site counts.

## Indentation syntax

| Syntax | Heredocs | % of sites | Gems | % of heredoc-using gems |
|---|---|---|---|---|
| `<<- (dash)` | 264090 | 59.2% | 21304 | 67.7% |
| `<<~ (squiggly)` | 95659 | 21.4% | 7816 | 24.8% |
| `<< (plain)` | 86393 | 19.4% | 5782 | 18.4% |

## Quoting

| Quoting | Heredocs | % of sites | Gems | % of heredoc-using gems |
|---|---|---|---|---|
| bare | 409472 | 91.8% | 30620 | 97.3% |
| single-quoted (no interpolation) | 32677 | 7.3% | 1484 | 4.7% |
| double-quoted | 3978 | 0.9% | 901 | 2.9% |
| backtick (shell execution) | 15 | 0.0% | 7 | 0.0% |

## By era

Share of *heredoc-using* gems in each cohort. `<<~` only exists since Ruby 2.3, so its
standing among maintained gems matters more than its corpus-wide share.

### Share of heredoc-using gems

| Form | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| << (plain) | 19.7% | 10.1% | 24.7% |
| <<- (dash) | 78.9% | 41.0% | 84.1% |
| <<~ (squiggly) | 9.3% | 64.2% | 0.0% |
| backtick (shell execution) | 0.1% | 0.0% | 0.0% |
| bare | 97.0% | 98.2% | 96.6% |
| double-quoted | 2.6% | 1.8% | 4.0% |
| single-quoted (no interpolation) | 4.9% | 5.2% | 4.2% |

Cohort sizes: 2015-2019 7306, 2020+ 11118, pre-2015 13058 (31482 gems). Cells are the share of gems in that cohort exhibiting the row, so columns are comparable to each other and to how large the cohort is overall.

### Composition of heredoc sites

Indentation flavor only — counting quoting too would tally each heredoc twice. The gem-share
table above counts a gem once per form it uses anywhere, so a gem writing one `<<~` and forty
`<<-` appears in both rows; this table says which form the corpus actually writes.

| Form | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| << (plain) | 36.5% | 8.4% | 22.2% |
| <<- (dash) | 59.6% | 40.5% | 77.8% |
| <<~ (squiggly) | 3.9% | 51.1% | 0.0% |

Sites per cohort: 2015-2019 85546, 2020+ 180552, pre-2015 180044 (446142 sites). Cells are the share of that cohort's sites, so each column sums to 100%. This is scale-free: it says what the code is made of, not how much code there is.

### Density

| Form | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| << (plain) | 33.9 | 4.6 | 27.0 |
| <<- (dash) | 55.3 | 22.1 | 94.4 |
| <<~ (squiggly) | 3.6 | 27.9 | 0.0 |

AST nodes per cohort: 2015-2019 92187896, 2020+ 330712998, pre-2015 148234785 (571135679 nodes). Cells are sites per 100,000 AST nodes — how much of this construct per unit of code, independent of gem size.

## Terminator casing

UPPERCASE is convention, not grammar — any identifier is legal.

| Casing | Heredocs | % of sites | Gems | % of heredoc-using gems |
|---|---|---|---|---|
| UPPERCASE | 400989 | 89.9% | 29808 | 94.7% |
| MixedCase | 26512 | 5.9% | 971 | 3.1% |
| lowercase | 18641 | 4.2% | 2167 | 6.9% |

Non-uppercase terminators seen: ``, `      EOF`, `    END_OF_TEMPLATE`, `  END_OF_TEMPLATE`, `  EOF`, `# # #`, `---`, `.,.,`, `...`, `...END EXPRESSION_PARSER.Y/MODULE_EVAL...`, `...end C_parser.y.rb/module_eval...`, `...end C_parser.y/module_eval...`, `...end adsl_parser.racc/module_eval...`, `...end bibtex.y/module_eval...`, `...end bnf.y/module_eval...`, `...end bracecomp.y/module_eval...`, `...end bracket-parser.y/module_eval...`, `...end c.y/module_eval...`, `...end cadenza.y/module_eval...`, `...end calc.y/module_eval...`, `...end cddal.y/module_eval...`, `...end cell_value.y/module_eval...`, `...end code_section.y/module_eval...`, `...end config.y/module_eval...`, `...end constexpr.y/module_eval...`, `...end ddb-parser.y/module_eval...`, `...end demotape.y/module_eval...`, `...end ec2-parser.y/module_eval...`, `...end ecma.y/module_eval...`, `...end ecma_fuku.y/module_eval...`, `...end egrammar.ra/module_eval...`, `...end expression.y/module_eval...`, `...end fortran_namelist.y/module_eval...`, `...end gameParser.racc/module_eval...`, `...end gherkin.y/module_eval...`, `...end grammar.ra/module_eval...`, `...end grammar.racc/module_eval...`, `...end grammar.ry/module_eval...`, `...end grammar.y/module_eval...`, `...end grammer.y/module_eval...`, `...end handlebars_parser.y/module_eval...`, `...end interpreter.y/module_eval...`, `...end javascriptre.ry/module_eval...`, `...end kdl.yy/module_eval...`, `...end line_parser.y/module_eval...`, `...end lucid-tdl.y/module_eval...`, `...end mdstat_parser.y/module_eval...`, `...end mediawikiparser.y/module_eval...`, `...end mml.grammar/module_eval...`, `...end modifier.y/module_eval...`, `...end mokblockparser.ry/module_eval...`, `...end mokinlineparser.ry/module_eval...`, `...end mork.y/module_eval...`, `...end mvinl.y/module_eval...`, `...end mysql.y.rb/module_eval...`, `...end names.y/module_eval...`, `...end ofx_102.racc/module_eval...`, `...end parse.y/module_eval...`, `...end parser.ra/module_eval...`, `...end parser.racc/module_eval...`, `...end parser.rb/module_eval...`, `...end parser.ry/module_eval...`, `...end parser.y/module_eval...`, `...end po_parser.ry/module_eval...`, `...end poparser.ry/module_eval...`, `...end proto.y/module_eval...`, `...end query_parser.racc/module_eval...`, `...end racc/parser.rb/module_eval...`, `...end rafblockparser.ry/module_eval...`, `...end rafinlineparser.ry/module_eval...`, `...end rdblockparser.ry/module_eval...`, `...end rdinlineparser.ry/module_eval...`, `...end robotstxt.ry/module_eval...`, `...end rules.racc/module_eval...`, `...end sasm.y/module_eval...`, `...end sdb-parser.y/module_eval...`, `...end shell.y/module_eval...`, `...end sqlparser.y/module_eval...`, `...end sts_parse.ry/module_eval...`, `...end text_parser.ry/module_eval...`, `...end tokens.racc/module_eval...`, `...end units.racc/module_eval...`, `...end unserializer.y/module_eval...`, `...end uptime_parser.y/module_eval...`, `...end xsm_expression_parser.racc/module_eval...`, `...end yacc_shave.y/module_eval...`, `..end /home/aamine/lib/ruby/racc/parser.rb modeval..id32ad1a7c1e`, `..end /home/aamine/lib/ruby/racc/parser.rb modeval..idb76f2e220d`, `..end /home/katsu/local/lib/site_ruby/racc/parser.rb modeval..id92db944ac5`, `..end /usr/local/lib/ruby/site_ruby/1.8/racc/parser.rb modeval..id4449eb2054`, `..end grammar.ry modeval..idcb2ea30b34`, `..end iuparser.ry modeval..id57c30dc50e`, `..end json.y modeval..idf8edf52a5d`, `..end json_parser.y modeval..id3d5fb611e2`, `..end lib/cast/c.y modeval..idba17d34edf`, `..end lib/doily/parser.y modeval..id32b1a5e4ef`, `..end lib/mm/transition_execution.grammar modeval..id395e8e8615`, `..end lib/rd/rdblockparser.ry modeval..idc4b57748f0`, `..end lib/rd/rdinlineparser.ry modeval..id193b0f608d`, `..end lib/sql/parser.racc modeval..id637f2c9ecb`, `..end lib/tmail/parser.y modeval..id2dd1c7d21d`, `..end lib/yacc.y modeval..id83b5753790`, `..end linucs.ry modeval..idcf977ebdbe`, `..end mediawikiparser.y modeval..idbd32b73581`, `..end ofx_102.y modeval..ida980a4d65b`, `..end parse.y modeval..id3b357f8af2`, `..end parse.y modeval..ida1760a43d7`, `..end parser.ry modeval..id173dda2250`, `..end parser.ry modeval..id43bff5dec9`, `..end parser.y modeval..id0b372b56e6`, `..end parser.y modeval..id43721faf1c`, `..end parser.y modeval..id7b0b3dccb7`, `..end racc/parser.rb modeval..id5256434e8a`, `..end racc/parser.rb modeval..id72f10a7251`, `..end racc/parser.rb modeval..id8076474214`, `..end smiles.ry modeval..idae4de8f30f`, `..end sqlparser.y modeval..idb280b00f18`, `..end src/ctype.y modeval..id10edfde54d`, `..end src/define.y modeval..id81df9ac3e8`, `..end src/emitter.rb modeval..iddd2784be19`, `..end src/ocl.y modeval..id7feff4ef7b`, `..end src/parameters.y modeval..id8a761dbfd1`, `..end src/poparser.ry modeval..id7a99570e05`, `..end src/preprocessor.y modeval..idc10037fa39`, `..end src/yaml.y.rb modeval..idae682a68eb`, `..end xpath.ry modeval..idcc62899492`, `/EOH`, `5032c8a5-9c5e-ba7a-3804-832a03e16381`, `;`, `;;;`, `AppplicaitonJS`, `Banner`, `BlockOfJavaScript`, `BloodlineKeeper`, `C++`, `CMap`, `ChangeLog`, `CivilizedScholar`, `Code`, `CodeR`, `Coffee`, `Controlfile`, `Data`, `Data1`, `Define`, `Desc`, `Detail`, `Doc`, `END HTML`, `END;`, `ENDCODEend`, `ENDControllerCode`, `ENDFormCode`, `ENDListAllCode`, `ENDModelCode`, `ENDNewCode`, `ENDRoutesCode`, `ENDSampleData`, `ENDShowCode`, `END_OF_body`, `END_OF_first`, `END_OF_html`, `END_OF_input`, `END_OF_json`, `END_OF_last`, `END_OF_lhs`, `END_OF_lhs_doc`, `END_OF_rhs`, `END_OF_rhs_doc`, `END_OF_tr`, `END_OF_xml`, `END_OF_yaml_string`, `END_databaseConfig`, `ENDinit`, `ENDofIMG`, `ENDofPUPPETcode`, `ENDvmLISTING`, `EOAlreadyExists`, `EOBucketNoexists`, `EOBucketexists`, `EOBuckets`, `EOEmpty`, `EOEmptyBuckets`, `EOF;`, `EOF_main`, `EOF_output`, `EOFakeBody`, `EOFormat`, `EOLocation`, `EOObjects`, `EOObjectsPrefix`, `EOOwnedByYou`, `EO_Artifact`, `EO_Ask`, `EO_Comment`, `EO_Commit`, `EO_Constraints`, `EO_Context`, `EO_Description`, `EO_Diffs`, `EO_Instructions`, `EO_Markdown`, `EO_Objective`, `EO_Prompt`, `EO_Section`, `EO_Step`, `EO_Untracked_File`, `End`, `EndAccessors`, `EndBanner`, `EndCode`, `EndEditCode`, `EndEval`, `EndForm`, `EndHTML`, `EndMeth`, `EndMethods`, `EndOfHTML`, `EndOfMail`, `EndOfTests`, `EndOfText`, `EndOverload`, `EndSQL`, `EndTemplate`, `EndUsage`, `End_of_preamble`, `EoHTM`, `EoS`, `EoY`, `Eof`, `Error`, `File`, `Gemfile`, `GraphQL`, `HandlebarsTemplate`, `HanweirWatchkeep`, `History_txt`, `Info`, `JSCode`, `Job`, `Klass`, `Kotlin`, `LectureString`, `Logo`, `Markdown`, `Md`, `Message`, `Msg`, `Must_be_one_of_them_newfangled_ones`, `MustacheTemplate`, `NodeMakeNormal`, `NodeMakePie`, `NodeNormal`, `NodePIe`, `NodePic`, `ONECOlWEBDASH`, `OOTPÜT`, `Pattern`, `Perl`, `Pipeline`, `PipelineGroup`, `RCode`, `RFC8174ise`, `Ruby`, `SingleSide`, `Summary`, `Swift`, `Syntax`, `Template`, `TestXml`, `Text`, `]`, `^D`, `_`, `_0_`, `_1_`, `_2_`, `_3_`, `_4_`, `_5_`, `_6_`, `_7_`, `_8_`, `_9_`, `_BAT_TXT`, `_BUNDLE_INSTALL_`, `_CSS`, `_CSV_`, `_DEF`, `_END`, `_END_`, `_END_EXPECTED_`, `_END_OF_EXPECTED_`, `_EOC`, `_EOD_`, `_EOE`, `_EOE_`, `_EOF_`, `_EOL_`, `_EOM`, `_EOS_`, `_EOT`, `_EXAMPLES_`, `_FILE_PAGE_`, `_HTML`, `_HTML_`, `_HTML_BODY_TAIL`, `_HTML_HEAD`, `_HTML_STRING_`, `_INCLUDES`, `_INIT`, `_INSTALL_ASYNC_GEMS`, `_IT_SHOULD_BE_DONE_`, `_JS`, `_LAYOUTS`, `_MIGRATE_TO_NEW_RHOCONNECT`, `_NGINX_CONF_`, `_NGINX_INIT_SCRIPT_`, `_NGINX_LOGRORATE_CONF_`, `_NGINX_README_`, `_NGINX_TO_DO_`, `_NPM_INSTALL_`, `_README2_`, `_README_`, `_REDIS_INIT_SCRIPT_`, `_REDIS_LOGRORATE_CONF_`, `_RPM_LIB_`, `_RUBY`, `_RUN_BUNDLER`, `_SCREEN`, `_SH_TXT`, `_SLIM_`, `_SQL`, `_TEXT_`, `_THIN_INIT_`, `_THIN_LOGRORATE_CONF_`, `_VHOST_CONF_`, `__`, `__AMRITA2__`, `__ANTEX_TEXT__`, `__BASH`, `__CODE`, `__CODE__`, `__DATA_END__`, `__DEF__`, `__DESC`, `__DESC__`, `__DIST_CERT__`, `__E`, `__END`, `__END_EXAMPLE_RESPONSE__`, `__END_OF_AASEQS__`, `__END_OF_CLASS_DEFINITION__`, `__END_OF_DATA__`, `__END_OF_DEF__`, `__END_OF_EVAL__`, `__END_OF_MFST__`, `__END_OF_NASEQS__`, `__END_OF_REFERENCE__`, `__END_OF_SEQ__`, `__END_OF_STR__`, `__END_OF_TEMPLATE__`, `__END_OF_TESTDATA__`, `__END_OF_TEXT__`, `__END__`, `__EOC__`, `__EOD__`, `__EOF__`, `__EOI`, `__EOM__`, `__EOP__`, `__EOR__`, `__EOS`, `__EOS__`, `__EOT`, `__EOU__`, `__EOX__`, `__ERROR`, `__ERROR_TXT`, `__E__`, `__HEAD__`, `__HELP__`, `__HERDOC`, `__HEREDOC`, `__HEREDOC__`, `__HERE__`, `__HTML`, `__HTML__`, `__INFO`, `__INFO_TXT`, `__MARKDOWN__`, `__METHOD__`, `__Makefile_END__`, `__NOTE`, `__OBJ`, `__OUTPUT__`, `__PATCH__`, `__Q_TEXT`, `__Q__`, `__RB__`, `__REDCLOTH__`, `__REGEXP__`, `__RESULT__`, `__RINEX_CLK_TEXT__`, `__RINEX_NAV_TEXT__`, `__RINEX_OBS_TEXT__`, `__RUBY`, `__RUBY_CODE__`, `__RUBY_RESULT__`, `__SCRIPT`, `__SCSS__`, `__SP3_TEXT__`, `__SQL__`, `__SRC__`, `__STR`, `__SWIG`, `__TABLE_END__`, `__TASK`, `__TASK__`, `__TENJIN__`, `__TEXT__`, `__TOPLEVEL_MAKEFILE__`, `__TXT`, `__USAGE`, `__USAGE__`, `__WARN`, `__WHALE__`, `__XML__`, `__YOU_ARE_SPECIAL__`, `___`, `____`, `_____`, `__________`, `__dfa_description__`, `__end_of_file__`, `__sh__`, `_certificate_`, `_end`, `_end_of_cnf_`, `_end_of_html_`, `_end_of_message_`, `_end_of_pem_`, `_eob_`, `_eom`, `_eos`, `_html`, `_tmpl`, `_v_`, `_xml`, `_yml_`, `a`, `aa`, `account`, `adios`, `adsl`, `ajax_error`, `annfooter`, `annheader`, `art`, `attr`, `attribute_method`, `b`, `b_b`, `baggage`, `banner`, `bar`, `base64`, `bash`, `baz`, `bazquux`, `begin`, `begin;`, `beispiel`, `bower`, `build_options`, `c`, `cbnotify`, `chain`, `class_body`, `class_eval`, `class_string`, `clean`, `clean_with_4`, `cmap_problem`, `cmd`, `code`, `command`, `comment`, `comment2`, `comment3`, `comment4`, `comment5`, `compile`, `compiled`, `conf`, `config`, `config_string`, `content`, `contents`, `controller`, `creole`, `cs`, `css`, `csv`, `current_user`, `dashboard_controller`, `dashboard_page`, `data`, `date`, `datos`, `def`, `default`, `definition`, `desc`, `describe_block`, `dirty`, `dirty_tracker`, `dmap_problem`, `do_eval`, `doc`, `docblock`, `doco`, `document`, `documentxml`, `dot_spec`, `dsl`, `dummytext`, `dump_cmd`, `e`, `ecode`, `edoc`, `element`, `elixir`, `end`, `end;`, `endUsage`, `end_banner`, `end_blurb`, `end_body`, `end_c_code`, `end_callbacks`, `end_class_def`, `end_class_eval`, `end_code`, `end_command`, `end_commands`, `end_comment`, `end_complex`, `end_content`, `end_css`, `end_custom_definition`, `end_def`, `end_define`, `end_error`, `end_eval`, `end_event_definition`, `end_file`, `end_footer`, `end_fragment`, `end_gemfile`, `end_haml`, `end_help`, `end_info`, `end_java_script`, `end_liberal`, `end_lockfile`, `end_log`, `end_message`, `end_method_definitions`, `end_module_eval`, `end_msg`, `end_of_answer`, `end_of_config`, `end_of_def`, `end_of_duplicate_options_example`, `end_of_duplicate_section_example`, `end_of_dynamic_method`, `end_of_expected`, `end_of_lorem`, `end_of_message`, `end_of_modifier`, `end_of_python_example`, `end_of_result`, `end_of_script`, `end_of_secrets`, `end_of_simple`, `end_of_string`, `end_of_template`, `end_of_xml`, `end_of_yaml`, `end_output`, `end_partial`, `end_passenger`, `end_preamble`, `end_render`, `end_result`, `end_section`, `end_simple`, `end_source`, `end_sql`, `end_src`, `end_step`, `end_str`, `end_summary`, `end_task`, `end_template`, `end_text`, `end_title_bar`, `end_tml`, `end_txt`, `end_warning`, `end_xml`, `endblock`, `endcode`, `endeval`, `endg`, `endjs`, `endl`, `endofeval`, `ends`, `endsql`, `endstr`, `eo_cmake`, `eo_table`, `eo_xml`, `eoawesomehack`, `eoc`, `eocode`, `eocss`, `eoctxml`, `eod`, `eodef`, `eodoc`, `eodot`, `eoedge`, `eoerb`, `eof`, `eofwopxml`, `eofwpxml`, `eograph`, `eoh`, `eoht`, `eohtml`, `eoidl`, `eoidxml`, `eoinspect`, `eoj`, `eojs`, `eojson`, `eol`, `eom`, `eomail`, `eometh`, `eomethod`, `eomsg`, `eonc`, `eonode`, `eop`, `eoprobe`, `eor`, `eorb`, `eoruby`, `eos`, `eoscss`, `eosql`, `eostmt`, `eostr`, `eostring`, `eostruct`, `eot`, `eotest`, `eow`, `eowarn`, `eoxhtml`, `eoxml`, `eoxslt`, `eoyaml`, `eoyml`, `erb`, `erb_snippet`, `error`, `error_message`, `esql`, `eval`, `eval_end`, `evl`, `example`, `examples`, `exception`, `existing`, `exml`, `expect`, `expected`, `f`, `fenced`, `file`, `filename_in_envvar`, `filters`, `fixed_key`, `foo`, `foobar1`, `foobar2`, `frag`, `gems`, `gems_deps_rb`, `geometry`, `ggg`, `gql`, `h`, `hah`, `haml`, `haml_end`, `hash`, `haskell`, `hbs`, `hd`, `header`, `header_partial`, `headings`, `help`, `helper`, `helptext`, `here`, `heredoc`, `hhh`, `hooks`, `howto_make_searchable`, `html`, `html_code`, `ics`, `idx`, `img`, `impedimentia`, `indented`, `init`, `input`, `insert`, `instance_eval`, `instructions`, `interpret`, `intro`, `invariants`, `jade`, `jam`, `java`, `javascript`, `js`, `json`, `json;`, `json_body`, `keystr`, `leaks`, `links`, `lisp`, `load_css`, `log`, `log;`, `login`, `logo`, `many`, `markdown`, `matrix`, `md`, `message`, `messages`, `meth`, `meth_call`, `method`, `method_to_eval`, `methods`, `missingtests`, `mkd`, `model`, `motd`, `msg`, `multiline_script`, `multiline_string`, `name`, `new_cron`, `nxo`, `oes`, `one`, `oof`, `org`, `original`, `osascript`, `out`, `output`, `oview`, `p`, `page_CONTENT`, `paramsXML`, `parse_md`, `partial`, `payload`, `person`, `philos`, `php`, `pids`, `plist`, `pond`, `postinstall`, `pre_style`, `preamble`, `private_method`, `products`, `program`, `prolog`, `prompt`, `properties`, `proto`, `ps_exitcheck`, `python`, `qsim`, `quux`, `r`, `rails`, `raw_git_commit`, `rb`, `rdf`, `rdoc`, `reader`, `redefintion`, `rem`, `remote_access`, `remote_attribute`, `rendered`, `report`, `resp`, `result`, `review`, `rhtml`, `route`, `routes`, `ruby`, `ruby_eval`, `ruby_src`, `sample`, `scenario`, `schema_migration`, `scope`, `script`, `script_body`, `security`, `sessions_controller`, `set_report`, `settings`, `sf`, `sh`, `shared_examples`, `sidebar_partial`, `simple1`, `simple2`, `site`, `slim`, `snowytimes`, `solo`, `source`, `sparql`, `spec`, `sql`, `src`, `ssl_conf`, `start`, `start_message`, `stats`, `stdout`, `stmt`, `stop`, `str`, `stringend`, `strs`, `stub_method`, `stubs`, `stuff`, `stylesheet`, `switch`, `sys_certs_error`, `sys_output`, `table`, `tabular`, `tag`, `target`, `template`, `testhead`, `testscript`, `teststring`, `tex`, `text`, `textwithfrontmatter`, `the_end_of_the_text`, `toc`, `trasnf`, `tree`, `txt`, `uniforms`, `usage`, `usage_banner`, `usage_information`, `verb`, `version 2`, `vert`, `vertex`, `vf`, `vite`, `warning`, `whatnot`, `wiki`, `wiki_content`, `wollok`, `xml`, `xml_str`, `xml_string`, `xx`, `xxx`, `yaml`, `yml`, `yow`, `|`, `ｶﾞｯ`

## Interpolation, position, stacking

| Property | Heredocs | % |
|---|---|---|
| body interpolates | 153521 | 34.4% |
| body is literal | 292621 | 65.6% |
| passed as a call argument | 286865 | 64.3% |
| lines opening 2+ heredocs | 12578 | — |

## Body size

| Size | Heredocs | % |
|---|---|---|
| 1 line | 55082 | 12.3% |
| 2-5 lines | 191165 | 42.8% |
| 6-20 lines | 131875 | 29.6% |
| 21+ lines | 68020 | 15.2% |

## Terminator names (top 40)

What heredocs are used for — SQL, HTML, RUBY, and friends name their content.

| Terminator | Heredocs |
|---|---|
| `EOF` | 66143 |
| `PATTERN` | 31670 |
| `EOS` | 29763 |
| `HTML` | 21473 |
| `RUBY` | 20497 |
| `.,.,` | 19020 |
| `SQL` | 11898 |
| `END` | 11595 |
| `SCSS` | 11571 |
| `EOD` | 9931 |
| `CSS` | 9077 |
| `DESC` | 8097 |
| `XML` | 7740 |
| `SRC` | 7296 |
| `EOT` | 7198 |
| `MSG` | 6463 |
| `EOM` | 6259 |
| `SASS` | 4924 |
| `DOT` | 4920 |
| `MESSAGE` | 4065 |
| `CODE` | 4013 |
| `BANNER` | 3902 |
| `eof` | 3769 |
| `DESCRIPTION` | 3360 |
| `G` | 3254 |
| `TEXT` | 3066 |
| `eoxml` | 2801 |
| `JS` | 2709 |
| `STR` | 2546 |
| `EOH` | 2269 |
| `CONFIG` | 2084 |
| `HAML` | 2017 |
| `YAML` | 2006 |
| `DOC` | 1986 |
| `WARNING` | 1974 |
| `EXPECTED` | 1886 |
| `eos` | 1879 |
| `HELP` | 1847 |
| `OUTPUT` | 1786 |
| `EOL` | 1650 |

## Gems with the most heredocs

| Gem | Heredocs |
|---|---|
| oddb.org | 42662 |
| candlepin-api | 10188 |
| classiccms | 9243 |
| mdi | 7447 |
| sc_core | 4592 |
| challah-rolls | 3787 |
| pages_core | 3704 |
| encrypted_jsonb | 3565 |
| opengl-bindings | 3168 |
| opengl-bindings2 | 3164 |

Errors: 9
