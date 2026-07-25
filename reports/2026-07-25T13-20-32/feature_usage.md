# Ruby language feature usage across RubyGems.org

Prism AST node tally for the latest release of a random sample of 300 gems (seeded, reproducible), out of 195399 gems on RubyGems.org.

Prism defines 151 node types; 120 appear in the sample.
Files that no longer parse under current Ruby: 30.

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
- imaginary_node
- instance_variable_and_write_node
- interpolated_match_last_line_node
- interpolated_xstring_node
- it_local_variable_read_node
- it_parameters_node
- match_last_line_node
- match_predicate_node
- match_write_node
- missing_node
- no_keywords_parameter_node
- pinned_expression_node
- pinned_variable_node
- post_execution_node
- pre_execution_node
- rational_node
- redo_node
- source_encoding_node
- xstring_node

## Gem coverage (how many gems use each node type)

| Node type | Gems | % of gems | Total occurrences |
|---|---|---|---|
| program_node | 289 | 96.3% | 6104 |
| statements_node | 289 | 96.3% | 147571 |
| constant_read_node | 287 | 95.7% | 63009 |
| call_node | 285 | 95.0% | 348311 |
| arguments_node | 283 | 94.3% | 223160 |
| string_node | 282 | 94.0% | 111217 |
| def_node | 265 | 88.3% | 31569 |
| module_node | 258 | 86.0% | 6097 |
| local_variable_read_node | 258 | 86.0% | 167829 |
| class_node | 256 | 85.3% | 6327 |
| parameters_node | 255 | 85.0% | 31597 |
| required_parameter_node | 250 | 83.3% | 39623 |
| symbol_node | 241 | 80.3% | 107160 |
| local_variable_write_node | 240 | 80.0% | 27201 |
| if_node | 236 | 78.7% | 27909 |
| block_node | 234 | 78.0% | 31492 |
| constant_write_node | 234 | 78.0% | 3393 |
| constant_path_node | 233 | 77.7% | 28532 |
| block_parameters_node | 222 | 74.0% | 16732 |
| self_node | 211 | 70.3% | 18874 |
| embedded_statements_node | 209 | 69.7% | 13875 |
| interpolated_string_node | 207 | 69.0% | 9346 |
| array_node | 202 | 67.3% | 9806 |
| integer_node | 202 | 67.3% | 22504 |
| assoc_node | 201 | 67.0% | 34751 |
| else_node | 194 | 64.7% | 6595 |
| instance_variable_write_node | 192 | 64.0% | 7432 |
| hash_node | 188 | 62.7% | 16572 |
| instance_variable_read_node | 183 | 61.0% | 25456 |
| nil_node | 175 | 58.3% | 5896 |
| true_node | 175 | 58.3% | 5229 |
| keyword_hash_node | 174 | 58.0% | 9120 |
| unless_node | 164 | 54.7% | 4037 |
| optional_parameter_node | 158 | 52.7% | 3628 |
| false_node | 153 | 51.0% | 3665 |
| or_node | 148 | 49.3% | 3776 |
| return_node | 146 | 48.7% | 5502 |
| and_node | 143 | 47.7% | 7283 |
| parentheses_node | 139 | 46.3% | 3770 |
| regular_expression_node | 125 | 41.7% | 5949 |
| begin_node | 121 | 40.3% | 1117 |
| source_file_node | 119 | 39.7% | 595 |
| local_variable_target_node | 113 | 37.7% | 2977 |
| global_variable_read_node | 110 | 36.7% | 1295 |
| rescue_node | 103 | 34.3% | 948 |
| block_argument_node | 102 | 34.0% | 1457 |
| instance_variable_or_write_node | 93 | 31.0% | 556 |
| splat_node | 93 | 31.0% | 687 |
| case_node | 91 | 30.3% | 1362 |
| when_node | 91 | 30.3% | 9193 |
| rest_parameter_node | 88 | 29.3% | 714 |
| local_variable_operator_write_node | 81 | 27.0% | 587 |
| yield_node | 81 | 27.0% | 566 |
| multi_write_node | 79 | 26.3% | 946 |
| range_node | 78 | 26.0% | 435 |
| singleton_class_node | 75 | 25.0% | 317 |
| block_parameter_node | 69 | 23.0% | 581 |
| next_node | 62 | 20.7% | 1117 |
| super_node | 61 | 20.3% | 263 |
| forwarding_super_node | 53 | 17.7% | 236 |
| defined_node | 52 | 17.3% | 218 |
| index_or_write_node | 52 | 17.3% | 446 |
| optional_keyword_parameter_node | 51 | 17.0% | 1114 |
| while_node | 47 | 15.7% | 195 |
| float_node | 46 | 15.3% | 1016 |
| break_node | 45 | 15.0% | 159 |
| local_variable_or_write_node | 35 | 11.7% | 115 |
| class_variable_write_node | 35 | 11.7% | 220 |
| ensure_node | 33 | 11.0% | 199 |
| interpolated_regular_expression_node | 33 | 11.0% | 189 |
| alias_method_node | 32 | 10.7% | 271 |
| class_variable_read_node | 32 | 10.7% | 226 |
| rescue_modifier_node | 31 | 10.3% | 92 |
| required_keyword_parameter_node | 30 | 10.0% | 310 |
| multi_target_node | 29 | 9.7% | 931 |
| numbered_reference_read_node | 27 | 9.0% | 989 |
| instance_variable_operator_write_node | 25 | 8.3% | 126 |
| instance_variable_target_node | 24 | 8.0% | 187 |
| keyword_rest_parameter_node | 22 | 7.3% | 500 |
| until_node | 22 | 7.3% | 37 |
| index_operator_write_node | 20 | 6.7% | 83 |
| interpolated_x_string_node | 19 | 6.3% | 46 |
| global_variable_write_node | 19 | 6.3% | 168 |
| assoc_splat_node | 19 | 6.3% | 411 |
| interpolated_symbol_node | 18 | 6.0% | 657 |
| call_or_write_node | 16 | 5.3% | 42 |
| lambda_node | 15 | 5.0% | 911 |
| call_operator_write_node | 14 | 4.7% | 39 |
| x_string_node | 14 | 4.7% | 47 |
| class_variable_or_write_node | 12 | 4.0% | 20 |
| retry_node | 11 | 3.7% | 17 |
| source_line_node | 10 | 3.3% | 19 |
| for_node | 9 | 3.0% | 45 |
| constant_path_write_node | 5 | 1.7% | 61 |
| index_target_node | 5 | 1.7% | 23 |
| undef_node | 4 | 1.3% | 5 |
| implicit_rest_node | 3 | 1.0% | 11 |
| global_variable_target_node | 3 | 1.0% | 4 |
| global_variable_or_write_node | 3 | 1.0% | 12 |
| call_target_node | 3 | 1.0% | 17 |
| back_reference_read_node | 3 | 1.0% | 14 |
| numbered_parameters_node | 3 | 1.0% | 8 |
| class_variable_operator_write_node | 3 | 1.0% | 3 |
| embedded_variable_node | 3 | 1.0% | 7 |
| global_variable_operator_write_node | 2 | 0.7% | 4 |
| in_node | 2 | 0.7% | 18 |
| case_match_node | 2 | 0.7% | 5 |
| constant_target_node | 2 | 0.7% | 4 |
| array_pattern_node | 2 | 0.7% | 17 |
| match_required_node | 2 | 0.7% | 5 |
| local_variable_and_write_node | 2 | 0.7% | 6 |
| implicit_node | 2 | 0.7% | 81 |
| forwarding_parameter_node | 1 | 0.3% | 1 |
| forwarding_arguments_node | 1 | 0.3% | 1 |
| index_and_write_node | 1 | 0.3% | 1 |
| constant_path_target_node | 1 | 0.3% | 2 |
| shareable_constant_node | 1 | 0.3% | 6 |
| capture_pattern_node | 1 | 0.3% | 1 |
| alternation_pattern_node | 1 | 0.3% | 7 |
| constant_or_write_node | 1 | 0.3% | 1 |

Errors: 0
