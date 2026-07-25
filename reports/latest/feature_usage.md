# Ruby language feature usage across RubyGems.org

Prism AST node tally for the latest release of a random sample of 100 gems (seeded, reproducible), out of 195399 gems on RubyGems.org.

Prism defines 151 node types; 104 appear in the sample.
Files that no longer parse under current Ruby: 21.

## Node types unused by any sampled gem

- alias_global_variable_node
- alternation_pattern_node
- array_pattern_node
- block_local_variable_node
- call_and_write_node
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
- forwarding_arguments_node
- forwarding_parameter_node
- global_variable_and_write_node
- global_variable_operator_write_node
- global_variable_or_write_node
- hash_pattern_node
- imaginary_node
- implicit_rest_node
- in_node
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
| string_node | 98 | 98.0% | 48519 |
| arguments_node | 98 | 98.0% | 120874 |
| call_node | 98 | 98.0% | 194146 |
| constant_read_node | 98 | 98.0% | 34180 |
| program_node | 98 | 98.0% | 2308 |
| statements_node | 98 | 98.0% | 85396 |
| local_variable_read_node | 89 | 89.0% | 102700 |
| def_node | 89 | 89.0% | 20171 |
| parameters_node | 88 | 88.0% | 18257 |
| module_node | 88 | 88.0% | 2540 |
| required_parameter_node | 87 | 87.0% | 23530 |
| class_node | 86 | 86.0% | 3137 |
| symbol_node | 85 | 85.0% | 54842 |
| local_variable_write_node | 85 | 85.0% | 16288 |
| block_node | 82 | 82.0% | 14314 |
| constant_write_node | 82 | 82.0% | 1309 |
| constant_path_node | 82 | 82.0% | 13467 |
| if_node | 82 | 82.0% | 18655 |
| block_parameters_node | 80 | 80.0% | 9583 |
| assoc_node | 76 | 76.0% | 18879 |
| embedded_statements_node | 73 | 73.0% | 8436 |
| interpolated_string_node | 72 | 72.0% | 5824 |
| integer_node | 71 | 71.0% | 8139 |
| array_node | 71 | 71.0% | 4936 |
| instance_variable_write_node | 70 | 70.0% | 4220 |
| hash_node | 70 | 70.0% | 8722 |
| else_node | 69 | 69.0% | 4302 |
| self_node | 69 | 69.0% | 11557 |
| keyword_hash_node | 69 | 69.0% | 6036 |
| instance_variable_read_node | 67 | 67.0% | 13650 |
| unless_node | 65 | 65.0% | 2028 |
| nil_node | 64 | 64.0% | 3356 |
| true_node | 61 | 61.0% | 3223 |
| optional_parameter_node | 60 | 60.0% | 1964 |
| false_node | 56 | 56.0% | 2149 |
| or_node | 56 | 56.0% | 2940 |
| return_node | 55 | 55.0% | 3510 |
| and_node | 54 | 54.0% | 5043 |
| block_argument_node | 43 | 43.0% | 1151 |
| parentheses_node | 42 | 42.0% | 2668 |
| source_file_node | 41 | 41.0% | 278 |
| begin_node | 41 | 41.0% | 609 |
| regular_expression_node | 40 | 40.0% | 4040 |
| instance_variable_or_write_node | 40 | 40.0% | 261 |
| local_variable_target_node | 39 | 39.0% | 1555 |
| rescue_node | 37 | 37.0% | 484 |
| rest_parameter_node | 35 | 35.0% | 399 |
| global_variable_read_node | 34 | 34.0% | 181 |
| splat_node | 32 | 32.0% | 356 |
| singleton_class_node | 31 | 31.0% | 166 |
| case_node | 31 | 31.0% | 883 |
| block_parameter_node | 31 | 31.0% | 386 |
| when_node | 31 | 31.0% | 6424 |
| yield_node | 29 | 29.0% | 231 |
| local_variable_operator_write_node | 27 | 27.0% | 231 |
| range_node | 26 | 26.0% | 169 |
| multi_write_node | 24 | 24.0% | 538 |
| super_node | 23 | 23.0% | 123 |
| index_or_write_node | 23 | 23.0% | 213 |
| forwarding_super_node | 22 | 22.0% | 147 |
| optional_keyword_parameter_node | 22 | 22.0% | 704 |
| next_node | 22 | 22.0% | 751 |
| defined_node | 21 | 21.0% | 153 |
| float_node | 19 | 19.0% | 577 |
| break_node | 17 | 17.0% | 66 |
| alias_method_node | 13 | 13.0% | 186 |
| rescue_modifier_node | 13 | 13.0% | 61 |
| class_variable_write_node | 13 | 13.0% | 101 |
| while_node | 13 | 13.0% | 69 |
| local_variable_or_write_node | 12 | 12.0% | 62 |
| multi_target_node | 12 | 12.0% | 670 |
| interpolated_regular_expression_node | 11 | 11.0% | 80 |
| class_variable_read_node | 11 | 11.0% | 134 |
| instance_variable_operator_write_node | 11 | 11.0% | 27 |
| required_keyword_parameter_node | 10 | 10.0% | 160 |
| instance_variable_target_node | 9 | 9.0% | 105 |
| ensure_node | 9 | 9.0% | 134 |
| keyword_rest_parameter_node | 8 | 8.0% | 392 |
| numbered_reference_read_node | 7 | 7.0% | 643 |
| interpolated_symbol_node | 7 | 7.0% | 593 |
| call_operator_write_node | 7 | 7.0% | 11 |
| assoc_splat_node | 7 | 7.0% | 258 |
| call_or_write_node | 7 | 7.0% | 28 |
| index_operator_write_node | 6 | 6.0% | 47 |
| interpolated_x_string_node | 6 | 6.0% | 13 |
| class_variable_or_write_node | 5 | 5.0% | 9 |
| until_node | 5 | 5.0% | 8 |
| x_string_node | 5 | 5.0% | 17 |
| global_variable_write_node | 5 | 5.0% | 34 |
| retry_node | 4 | 4.0% | 7 |
| lambda_node | 4 | 4.0% | 56 |
| for_node | 4 | 4.0% | 15 |
| constant_path_write_node | 4 | 4.0% | 16 |
| source_line_node | 3 | 3.0% | 10 |
| index_target_node | 3 | 3.0% | 15 |
| back_reference_read_node | 2 | 2.0% | 13 |
| class_variable_operator_write_node | 2 | 2.0% | 2 |
| local_variable_and_write_node | 2 | 2.0% | 6 |
| embedded_variable_node | 2 | 2.0% | 3 |
| numbered_parameters_node | 1 | 1.0% | 3 |
| implicit_node | 1 | 1.0% | 77 |
| call_target_node | 1 | 1.0% | 14 |
| index_and_write_node | 1 | 1.0% | 1 |
| global_variable_target_node | 1 | 1.0% | 1 |

Errors: 0
