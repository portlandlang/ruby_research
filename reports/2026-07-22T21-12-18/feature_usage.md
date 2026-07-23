# Ruby language feature usage across RubyGems.org

Prism AST node tally for the latest release of a random sample of 50 gems (seeded, reproducible), out of 195399 gems on RubyGems.org.

Prism defines 151 node types; 98 appear in the sample.
Files that no longer parse under current Ruby: 20.

## Node types unused by any sampled gem

- alias_global_variable_node
- alternation_pattern_node
- array_pattern_node
- back_reference_read_node
- block_local_variable_node
- call_and_write_node
- call_target_node
- capture_pattern_node
- case_match_node
- class_variable_and_write_node
- class_variable_target_node
- constant_and_write_node
- constant_operator_write_node
- constant_or_write_node
- constant_path_and_write_node
- constant_path_operator_write_node
- constant_path_or_write_node
- constant_path_target_node
- constant_target_node
- find_pattern_node
- flip_flop_node
- for_node
- forwarding_arguments_node
- forwarding_parameter_node
- global_variable_and_write_node
- global_variable_operator_write_node
- global_variable_or_write_node
- global_variable_target_node
- hash_pattern_node
- imaginary_node
- implicit_rest_node
- in_node
- index_and_write_node
- instance_variable_and_write_node
- interpolated_match_last_line_node
- interpolated_xstring_node
- it_local_variable_read_node
- it_parameters_node
- match_last_line_node
- match_predicate_node
- match_required_node
- match_write_node
- missing_node
- no_keywords_parameter_node
- numbered_parameters_node
- pinned_expression_node
- pinned_variable_node
- post_execution_node
- pre_execution_node
- rational_node
- redo_node
- shareable_constant_node
- source_encoding_node
- undef_node
- xstring_node

## Gem coverage (how many gems use each node type)

| Node type | Gems | % of gems | Total occurrences |
|---|---|---|---|
| string_node | 49 | 98.0% | 15035 |
| arguments_node | 49 | 98.0% | 31905 |
| call_node | 49 | 98.0% | 47306 |
| constant_read_node | 49 | 98.0% | 10478 |
| program_node | 49 | 98.0% | 889 |
| statements_node | 49 | 98.0% | 18717 |
| local_variable_read_node | 48 | 96.0% | 21932 |
| parameters_node | 48 | 96.0% | 4118 |
| def_node | 48 | 96.0% | 3952 |
| required_parameter_node | 48 | 96.0% | 4853 |
| local_variable_write_node | 47 | 94.0% | 3967 |
| symbol_node | 47 | 94.0% | 17659 |
| class_node | 46 | 92.0% | 1553 |
| if_node | 45 | 90.0% | 3105 |
| assoc_node | 44 | 88.0% | 7545 |
| module_node | 44 | 88.0% | 1091 |
| constant_path_node | 44 | 88.0% | 10072 |
| block_parameters_node | 43 | 86.0% | 1751 |
| block_node | 43 | 86.0% | 3865 |
| hash_node | 41 | 82.0% | 1330 |
| instance_variable_write_node | 41 | 82.0% | 2481 |
| array_node | 41 | 82.0% | 1840 |
| integer_node | 41 | 82.0% | 3148 |
| else_node | 40 | 80.0% | 841 |
| instance_variable_read_node | 39 | 78.0% | 5510 |
| keyword_hash_node | 39 | 78.0% | 3072 |
| unless_node | 38 | 76.0% | 802 |
| embedded_statements_node | 38 | 76.0% | 1675 |
| constant_write_node | 37 | 74.0% | 713 |
| interpolated_string_node | 37 | 74.0% | 1049 |
| self_node | 36 | 72.0% | 938 |
| nil_node | 36 | 72.0% | 1156 |
| true_node | 35 | 70.0% | 670 |
| or_node | 34 | 68.0% | 453 |
| optional_parameter_node | 34 | 68.0% | 415 |
| false_node | 32 | 64.0% | 522 |
| and_node | 32 | 64.0% | 317 |
| return_node | 29 | 58.0% | 603 |
| parentheses_node | 26 | 52.0% | 410 |
| block_argument_node | 26 | 52.0% | 364 |
| regular_expression_node | 25 | 50.0% | 387 |
| instance_variable_or_write_node | 24 | 48.0% | 115 |
| begin_node | 23 | 46.0% | 260 |
| rescue_node | 22 | 44.0% | 241 |
| local_variable_target_node | 22 | 44.0% | 412 |
| source_file_node | 20 | 40.0% | 121 |
| local_variable_operator_write_node | 20 | 40.0% | 184 |
| global_variable_read_node | 19 | 38.0% | 61 |
| block_parameter_node | 19 | 38.0% | 193 |
| rest_parameter_node | 18 | 36.0% | 157 |
| range_node | 18 | 36.0% | 99 |
| when_node | 17 | 34.0% | 373 |
| case_node | 17 | 34.0% | 121 |
| singleton_class_node | 17 | 34.0% | 52 |
| splat_node | 16 | 32.0% | 109 |
| yield_node | 16 | 32.0% | 118 |
| optional_keyword_parameter_node | 16 | 32.0% | 661 |
| forwarding_super_node | 15 | 30.0% | 61 |
| super_node | 15 | 30.0% | 54 |
| defined_node | 14 | 28.0% | 91 |
| multi_write_node | 14 | 28.0% | 128 |
| index_or_write_node | 14 | 28.0% | 109 |
| float_node | 12 | 24.0% | 519 |
| break_node | 12 | 24.0% | 28 |
| next_node | 11 | 22.0% | 73 |
| local_variable_or_write_node | 9 | 18.0% | 17 |
| rescue_modifier_node | 8 | 16.0% | 27 |
| while_node | 7 | 14.0% | 30 |
| assoc_splat_node | 7 | 14.0% | 258 |
| required_keyword_parameter_node | 7 | 14.0% | 144 |
| instance_variable_target_node | 7 | 14.0% | 45 |
| class_variable_write_node | 7 | 14.0% | 58 |
| class_variable_read_node | 6 | 12.0% | 82 |
| interpolated_regular_expression_node | 6 | 12.0% | 39 |
| multi_target_node | 6 | 12.0% | 18 |
| instance_variable_operator_write_node | 6 | 12.0% | 16 |
| alias_method_node | 5 | 10.0% | 145 |
| ensure_node | 5 | 10.0% | 29 |
| call_or_write_node | 5 | 10.0% | 8 |
| keyword_rest_parameter_node | 5 | 10.0% | 382 |
| interpolated_x_string_node | 4 | 8.0% | 6 |
| class_variable_or_write_node | 3 | 6.0% | 6 |
| lambda_node | 3 | 6.0% | 55 |
| constant_path_write_node | 3 | 6.0% | 15 |
| call_operator_write_node | 3 | 6.0% | 4 |
| x_string_node | 3 | 6.0% | 6 |
| until_node | 3 | 6.0% | 4 |
| numbered_reference_read_node | 2 | 4.0% | 4 |
| embedded_variable_node | 2 | 4.0% | 3 |
| interpolated_symbol_node | 2 | 4.0% | 3 |
| global_variable_write_node | 2 | 4.0% | 17 |
| index_operator_write_node | 2 | 4.0% | 29 |
| source_line_node | 1 | 2.0% | 1 |
| implicit_node | 1 | 2.0% | 77 |
| local_variable_and_write_node | 1 | 2.0% | 4 |
| retry_node | 1 | 2.0% | 2 |
| class_variable_operator_write_node | 1 | 2.0% | 1 |
| index_target_node | 1 | 2.0% | 2 |

Errors: 0
