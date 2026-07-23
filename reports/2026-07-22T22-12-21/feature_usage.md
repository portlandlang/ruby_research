# Ruby language feature usage across RubyGems.org

Prism AST node tally for the latest release of a random sample of 55 gems (seeded, reproducible), out of 195399 gems on RubyGems.org.

Prism defines 151 node types; 99 appear in the sample.
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
| program_node | 54 | 98.2% | 925 |
| statements_node | 54 | 98.2% | 19068 |
| constant_read_node | 54 | 98.2% | 10792 |
| string_node | 54 | 98.2% | 15462 |
| arguments_node | 54 | 98.2% | 32631 |
| call_node | 54 | 98.2% | 48374 |
| parameters_node | 52 | 94.5% | 4161 |
| def_node | 52 | 94.5% | 4026 |
| local_variable_read_node | 52 | 94.5% | 22097 |
| required_parameter_node | 52 | 94.5% | 4901 |
| local_variable_write_node | 51 | 92.7% | 4008 |
| symbol_node | 50 | 90.9% | 17848 |
| class_node | 50 | 90.9% | 1571 |
| module_node | 49 | 89.1% | 1118 |
| if_node | 49 | 89.1% | 3133 |
| constant_path_node | 47 | 85.5% | 10147 |
| block_node | 47 | 85.5% | 3962 |
| assoc_node | 47 | 85.5% | 7701 |
| block_parameters_node | 47 | 85.5% | 1770 |
| integer_node | 44 | 80.0% | 3274 |
| hash_node | 44 | 80.0% | 1388 |
| else_node | 43 | 78.2% | 849 |
| instance_variable_write_node | 43 | 78.2% | 2544 |
| array_node | 43 | 78.2% | 1850 |
| embedded_statements_node | 42 | 76.4% | 1718 |
| constant_write_node | 42 | 76.4% | 732 |
| keyword_hash_node | 42 | 76.4% | 3093 |
| instance_variable_read_node | 41 | 74.5% | 5657 |
| unless_node | 41 | 74.5% | 808 |
| interpolated_string_node | 41 | 74.5% | 1075 |
| self_node | 40 | 72.7% | 955 |
| nil_node | 38 | 69.1% | 1184 |
| or_node | 37 | 67.3% | 459 |
| optional_parameter_node | 36 | 65.5% | 418 |
| true_node | 36 | 65.5% | 676 |
| false_node | 34 | 61.8% | 527 |
| and_node | 33 | 60.0% | 318 |
| return_node | 32 | 58.2% | 615 |
| parentheses_node | 29 | 52.7% | 415 |
| block_argument_node | 27 | 49.1% | 366 |
| instance_variable_or_write_node | 26 | 47.3% | 122 |
| regular_expression_node | 26 | 47.3% | 388 |
| begin_node | 24 | 43.6% | 263 |
| local_variable_target_node | 24 | 43.6% | 416 |
| rescue_node | 23 | 41.8% | 244 |
| source_file_node | 22 | 40.0% | 134 |
| global_variable_read_node | 21 | 38.2% | 67 |
| local_variable_operator_write_node | 20 | 36.4% | 184 |
| singleton_class_node | 19 | 34.5% | 54 |
| block_parameter_node | 19 | 34.5% | 193 |
| range_node | 19 | 34.5% | 101 |
| rest_parameter_node | 18 | 32.7% | 157 |
| case_node | 17 | 30.9% | 121 |
| optional_keyword_parameter_node | 17 | 30.9% | 667 |
| when_node | 17 | 30.9% | 373 |
| splat_node | 17 | 30.9% | 110 |
| super_node | 16 | 29.1% | 55 |
| yield_node | 16 | 29.1% | 118 |
| forwarding_super_node | 15 | 27.3% | 61 |
| multi_write_node | 15 | 27.3% | 129 |
| index_or_write_node | 15 | 27.3% | 112 |
| defined_node | 14 | 25.5% | 91 |
| float_node | 13 | 23.6% | 520 |
| break_node | 12 | 21.8% | 28 |
| next_node | 12 | 21.8% | 74 |
| local_variable_or_write_node | 9 | 16.4% | 17 |
| class_variable_write_node | 9 | 16.4% | 61 |
| while_node | 8 | 14.5% | 33 |
| interpolated_regular_expression_node | 8 | 14.5% | 41 |
| class_variable_read_node | 8 | 14.5% | 95 |
| rescue_modifier_node | 8 | 14.5% | 27 |
| assoc_splat_node | 7 | 12.7% | 258 |
| required_keyword_parameter_node | 7 | 12.7% | 144 |
| instance_variable_target_node | 7 | 12.7% | 45 |
| instance_variable_operator_write_node | 6 | 10.9% | 16 |
| multi_target_node | 6 | 10.9% | 18 |
| interpolated_x_string_node | 6 | 10.9% | 13 |
| ensure_node | 5 | 9.1% | 29 |
| alias_method_node | 5 | 9.1% | 145 |
| call_or_write_node | 5 | 9.1% | 8 |
| keyword_rest_parameter_node | 5 | 9.1% | 382 |
| x_string_node | 4 | 7.3% | 9 |
| lambda_node | 3 | 5.5% | 55 |
| class_variable_or_write_node | 3 | 5.5% | 6 |
| until_node | 3 | 5.5% | 4 |
| constant_path_write_node | 3 | 5.5% | 15 |
| call_operator_write_node | 3 | 5.5% | 4 |
| index_operator_write_node | 3 | 5.5% | 30 |
| embedded_variable_node | 2 | 3.6% | 3 |
| numbered_reference_read_node | 2 | 3.6% | 4 |
| interpolated_symbol_node | 2 | 3.6% | 3 |
| global_variable_write_node | 2 | 3.6% | 17 |
| source_line_node | 1 | 1.8% | 1 |
| implicit_node | 1 | 1.8% | 77 |
| local_variable_and_write_node | 1 | 1.8% | 4 |
| retry_node | 1 | 1.8% | 2 |
| class_variable_operator_write_node | 1 | 1.8% | 1 |
| index_target_node | 1 | 1.8% | 2 |
| for_node | 1 | 1.8% | 1 |

Errors: 0
