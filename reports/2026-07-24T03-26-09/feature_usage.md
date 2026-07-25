# Ruby language feature usage across RubyGems.org

Prism AST node tally for the latest release of a random sample of 500 gems (seeded, reproducible), out of 195399 gems on RubyGems.org.

Prism defines 151 node types; 125 appear in the sample.
Files that no longer parse under current Ruby: 33.

## Node types unused by any sampled gem

- alias_global_variable_node
- block_local_variable_node
- call_and_write_node
- class_variable_and_write_node
- class_variable_target_node
- constant_and_write_node
- constant_operator_write_node
- constant_path_and_write_node
- constant_path_operator_write_node
- constant_path_or_write_node
- find_pattern_node
- flip_flop_node
- global_variable_and_write_node
- hash_pattern_node
- interpolated_match_last_line_node
- interpolated_xstring_node
- it_local_variable_read_node
- it_parameters_node
- match_last_line_node
- match_predicate_node
- missing_node
- no_keywords_parameter_node
- pinned_expression_node
- pinned_variable_node
- post_execution_node
- pre_execution_node
- source_encoding_node
- xstring_node

## Gem coverage (how many gems use each node type)

| Node type | Gems | % of gems | Total occurrences |
|---|---|---|---|
| program_node | 482 | 96.4% | 11729 |
| statements_node | 482 | 96.4% | 310972 |
| constant_read_node | 479 | 95.8% | 137395 |
| string_node | 473 | 94.6% | 264973 |
| call_node | 473 | 94.6% | 701203 |
| arguments_node | 471 | 94.2% | 451127 |
| def_node | 445 | 89.0% | 78109 |
| module_node | 437 | 87.4% | 13214 |
| local_variable_read_node | 437 | 87.4% | 367572 |
| parameters_node | 435 | 87.0% | 71964 |
| required_parameter_node | 429 | 85.8% | 102657 |
| class_node | 424 | 84.8% | 12603 |
| local_variable_write_node | 406 | 81.2% | 70331 |
| symbol_node | 403 | 80.6% | 208911 |
| constant_write_node | 398 | 79.6% | 10539 |
| block_node | 397 | 79.4% | 50785 |
| if_node | 394 | 78.8% | 52686 |
| constant_path_node | 390 | 78.0% | 44284 |
| block_parameters_node | 376 | 75.2% | 28496 |
| self_node | 351 | 70.2% | 35051 |
| embedded_statements_node | 348 | 69.6% | 31936 |
| assoc_node | 345 | 69.0% | 91725 |
| interpolated_string_node | 344 | 68.8% | 20924 |
| integer_node | 342 | 68.4% | 838284 |
| array_node | 338 | 67.6% | 29873 |
| else_node | 325 | 65.0% | 15594 |
| instance_variable_write_node | 324 | 64.8% | 20743 |
| hash_node | 317 | 63.4% | 34414 |
| instance_variable_read_node | 306 | 61.2% | 60547 |
| keyword_hash_node | 292 | 58.4% | 16408 |
| nil_node | 277 | 55.4% | 520538 |
| true_node | 274 | 54.8% | 10540 |
| optional_parameter_node | 268 | 53.6% | 9047 |
| unless_node | 268 | 53.6% | 10752 |
| false_node | 252 | 50.4% | 8277 |
| return_node | 249 | 49.8% | 12241 |
| or_node | 245 | 49.0% | 7736 |
| parentheses_node | 234 | 46.8% | 9875 |
| and_node | 223 | 44.6% | 13866 |
| regular_expression_node | 199 | 39.8% | 10427 |
| begin_node | 195 | 39.0% | 4646 |
| source_file_node | 194 | 38.8% | 1176 |
| local_variable_target_node | 183 | 36.6% | 7423 |
| global_variable_read_node | 169 | 33.8% | 2131 |
| block_argument_node | 168 | 33.6% | 2955 |
| rescue_node | 168 | 33.6% | 1728 |
| instance_variable_or_write_node | 160 | 32.0% | 1377 |
| splat_node | 149 | 29.8% | 2387 |
| when_node | 146 | 29.2% | 18147 |
| case_node | 146 | 29.2% | 2604 |
| rest_parameter_node | 141 | 28.2% | 1392 |
| yield_node | 130 | 26.0% | 1248 |
| multi_write_node | 128 | 25.6% | 2581 |
| local_variable_operator_write_node | 124 | 24.8% | 1901 |
| range_node | 123 | 24.6% | 1144 |
| singleton_class_node | 118 | 23.6% | 624 |
| block_parameter_node | 114 | 22.8% | 1314 |
| super_node | 96 | 19.2% | 728 |
| next_node | 91 | 18.2% | 2268 |
| defined_node | 86 | 17.2% | 510 |
| forwarding_super_node | 83 | 16.6% | 979 |
| optional_keyword_parameter_node | 83 | 16.6% | 4223 |
| index_or_write_node | 83 | 16.6% | 650 |
| while_node | 82 | 16.4% | 500 |
| float_node | 77 | 15.4% | 5176 |
| break_node | 67 | 13.4% | 646 |
| local_variable_or_write_node | 56 | 11.2% | 241 |
| ensure_node | 53 | 10.6% | 365 |
| class_variable_write_node | 50 | 10.0% | 307 |
| interpolated_regular_expression_node | 49 | 9.8% | 742 |
| alias_method_node | 48 | 9.6% | 1006 |
| instance_variable_operator_write_node | 48 | 9.6% | 395 |
| required_keyword_parameter_node | 47 | 9.4% | 718 |
| class_variable_read_node | 46 | 9.2% | 635 |
| multi_target_node | 44 | 8.8% | 1364 |
| numbered_reference_read_node | 44 | 8.8% | 1406 |
| instance_variable_target_node | 42 | 8.4% | 399 |
| call_operator_write_node | 41 | 8.2% | 160 |
| keyword_rest_parameter_node | 40 | 8.0% | 712 |
| rescue_modifier_node | 39 | 7.8% | 136 |
| assoc_splat_node | 36 | 7.2% | 593 |
| until_node | 31 | 6.2% | 112 |
| index_operator_write_node | 30 | 6.0% | 297 |
| lambda_node | 27 | 5.4% | 2157 |
| interpolated_x_string_node | 27 | 5.4% | 71 |
| interpolated_symbol_node | 26 | 5.2% | 970 |
| global_variable_write_node | 26 | 5.2% | 268 |
| call_or_write_node | 23 | 4.6% | 64 |
| x_string_node | 21 | 4.2% | 61 |
| class_variable_or_write_node | 17 | 3.4% | 28 |
| retry_node | 16 | 3.2% | 36 |
| for_node | 16 | 3.2% | 69 |
| source_line_node | 13 | 2.6% | 60 |
| embedded_variable_node | 7 | 1.4% | 43 |
| implicit_node | 7 | 1.4% | 140 |
| constant_path_write_node | 7 | 1.4% | 66 |
| index_target_node | 7 | 1.4% | 31 |
| back_reference_read_node | 7 | 1.4% | 64 |
| numbered_parameters_node | 6 | 1.2% | 12 |
| undef_node | 6 | 1.2% | 45 |
| call_target_node | 5 | 1.0% | 27 |
| forwarding_parameter_node | 4 | 0.8% | 13 |
| implicit_rest_node | 4 | 0.8% | 88 |
| global_variable_or_write_node | 4 | 0.8% | 13 |
| global_variable_operator_write_node | 4 | 0.8% | 7 |
| forwarding_arguments_node | 4 | 0.8% | 10 |
| global_variable_target_node | 4 | 0.8% | 11 |
| class_variable_operator_write_node | 4 | 0.8% | 4 |
| constant_target_node | 3 | 0.6% | 8 |
| local_variable_and_write_node | 3 | 0.6% | 10 |
| in_node | 3 | 0.6% | 57 |
| case_match_node | 3 | 0.6% | 11 |
| array_pattern_node | 2 | 0.4% | 17 |
| match_required_node | 2 | 0.4% | 5 |
| index_and_write_node | 2 | 0.4% | 2 |
| constant_path_target_node | 1 | 0.2% | 2 |
| shareable_constant_node | 1 | 0.2% | 6 |
| capture_pattern_node | 1 | 0.2% | 1 |
| alternation_pattern_node | 1 | 0.2% | 7 |
| constant_or_write_node | 1 | 0.2% | 1 |
| redo_node | 1 | 0.2% | 2 |
| match_write_node | 1 | 0.2% | 1 |
| rational_node | 1 | 0.2% | 1 |
| imaginary_node | 1 | 0.2% | 1 |
| instance_variable_and_write_node | 1 | 0.2% | 1 |

Errors: 0
