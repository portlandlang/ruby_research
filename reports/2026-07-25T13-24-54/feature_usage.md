# Ruby language feature usage across RubyGems.org

Prism AST node tally for the latest release of a random sample of 40 gems (seeded, reproducible), out of 195399 gems on RubyGems.org.

Prism defines 151 node types; 97 appear in the sample.
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
- index_target_node
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
| string_node | 39 | 97.5% | 13308 |
| arguments_node | 39 | 97.5% | 27947 |
| call_node | 39 | 97.5% | 40939 |
| constant_read_node | 39 | 97.5% | 9103 |
| program_node | 39 | 97.5% | 781 |
| statements_node | 39 | 97.5% | 16116 |
| local_variable_read_node | 38 | 95.0% | 18712 |
| parameters_node | 38 | 95.0% | 3615 |
| required_parameter_node | 38 | 95.0% | 4323 |
| symbol_node | 38 | 95.0% | 14369 |
| def_node | 38 | 95.0% | 3525 |
| class_node | 37 | 92.5% | 1257 |
| local_variable_write_node | 37 | 92.5% | 3363 |
| module_node | 36 | 90.0% | 842 |
| block_parameters_node | 36 | 90.0% | 1534 |
| block_node | 36 | 90.0% | 3513 |
| constant_path_node | 35 | 87.5% | 6368 |
| if_node | 35 | 87.5% | 2433 |
| assoc_node | 34 | 85.0% | 5763 |
| hash_node | 33 | 82.5% | 910 |
| integer_node | 33 | 82.5% | 2784 |
| array_node | 32 | 80.0% | 1538 |
| instance_variable_read_node | 31 | 77.5% | 4673 |
| constant_write_node | 31 | 77.5% | 568 |
| instance_variable_write_node | 31 | 77.5% | 2232 |
| keyword_hash_node | 31 | 77.5% | 2542 |
| unless_node | 30 | 75.0% | 637 |
| embedded_statements_node | 30 | 75.0% | 1519 |
| else_node | 30 | 75.0% | 730 |
| self_node | 29 | 72.5% | 781 |
| interpolated_string_node | 29 | 72.5% | 951 |
| nil_node | 28 | 70.0% | 863 |
| or_node | 27 | 67.5% | 413 |
| false_node | 27 | 67.5% | 485 |
| true_node | 26 | 65.0% | 573 |
| optional_parameter_node | 26 | 65.0% | 303 |
| and_node | 25 | 62.5% | 287 |
| return_node | 24 | 60.0% | 593 |
| parentheses_node | 22 | 55.0% | 392 |
| instance_variable_or_write_node | 21 | 52.5% | 86 |
| block_argument_node | 20 | 50.0% | 320 |
| begin_node | 20 | 50.0% | 204 |
| rescue_node | 19 | 47.5% | 193 |
| local_variable_target_node | 19 | 47.5% | 255 |
| regular_expression_node | 19 | 47.5% | 358 |
| singleton_class_node | 16 | 40.0% | 50 |
| local_variable_operator_write_node | 16 | 40.0% | 171 |
| when_node | 15 | 37.5% | 339 |
| case_node | 15 | 37.5% | 106 |
| rest_parameter_node | 15 | 37.5% | 152 |
| block_parameter_node | 14 | 35.0% | 163 |
| optional_keyword_parameter_node | 14 | 35.0% | 572 |
| range_node | 14 | 35.0% | 90 |
| source_file_node | 14 | 35.0% | 102 |
| forwarding_super_node | 14 | 35.0% | 59 |
| splat_node | 13 | 32.5% | 105 |
| super_node | 13 | 32.5% | 52 |
| yield_node | 13 | 32.5% | 31 |
| index_or_write_node | 12 | 30.0% | 41 |
| global_variable_read_node | 12 | 30.0% | 49 |
| defined_node | 11 | 27.5% | 81 |
| next_node | 11 | 27.5% | 73 |
| float_node | 10 | 25.0% | 510 |
| multi_write_node | 10 | 25.0% | 91 |
| break_node | 9 | 22.5% | 20 |
| rescue_modifier_node | 8 | 20.0% | 27 |
| local_variable_or_write_node | 8 | 20.0% | 13 |
| class_variable_write_node | 7 | 17.5% | 58 |
| multi_target_node | 6 | 15.0% | 18 |
| class_variable_read_node | 6 | 15.0% | 82 |
| interpolated_regular_expression_node | 6 | 15.0% | 39 |
| required_keyword_parameter_node | 6 | 15.0% | 121 |
| call_or_write_node | 5 | 12.5% | 8 |
| alias_method_node | 5 | 12.5% | 145 |
| instance_variable_operator_write_node | 5 | 12.5% | 12 |
| ensure_node | 5 | 12.5% | 29 |
| assoc_splat_node | 5 | 12.5% | 183 |
| while_node | 4 | 10.0% | 24 |
| instance_variable_target_node | 4 | 10.0% | 38 |
| keyword_rest_parameter_node | 4 | 10.0% | 322 |
| interpolated_x_string_node | 4 | 10.0% | 6 |
| call_operator_write_node | 3 | 7.5% | 4 |
| x_string_node | 3 | 7.5% | 6 |
| class_variable_or_write_node | 3 | 7.5% | 6 |
| until_node | 3 | 7.5% | 4 |
| lambda_node | 2 | 5.0% | 54 |
| global_variable_write_node | 2 | 5.0% | 17 |
| embedded_variable_node | 2 | 5.0% | 3 |
| interpolated_symbol_node | 2 | 5.0% | 3 |
| constant_path_write_node | 2 | 5.0% | 3 |
| index_operator_write_node | 2 | 5.0% | 29 |
| local_variable_and_write_node | 1 | 2.5% | 4 |
| retry_node | 1 | 2.5% | 2 |
| class_variable_operator_write_node | 1 | 2.5% | 1 |
| source_line_node | 1 | 2.5% | 1 |
| numbered_reference_read_node | 1 | 2.5% | 1 |
| implicit_node | 1 | 2.5% | 77 |

Errors: 0
