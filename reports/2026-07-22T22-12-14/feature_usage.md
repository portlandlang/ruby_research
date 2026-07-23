# Ruby language feature usage across RubyGems.org

Prism AST node tally for the latest release of a random sample of 5 gems (seeded, reproducible), out of 195399 gems on RubyGems.org.

Prism defines 151 node types; 76 appear in the sample.
Files that no longer parse under current Ruby: 0.

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
- class_variable_operator_write_node
- class_variable_read_node
- class_variable_target_node
- class_variable_write_node
- constant_and_write_node
- constant_operator_write_node
- constant_or_write_node
- constant_path_and_write_node
- constant_path_operator_write_node
- constant_path_or_write_node
- constant_path_target_node
- constant_path_write_node
- constant_target_node
- embedded_variable_node
- ensure_node
- find_pattern_node
- flip_flop_node
- for_node
- forwarding_arguments_node
- forwarding_parameter_node
- global_variable_and_write_node
- global_variable_operator_write_node
- global_variable_or_write_node
- global_variable_target_node
- global_variable_write_node
- hash_pattern_node
- imaginary_node
- implicit_node
- implicit_rest_node
- in_node
- index_and_write_node
- index_operator_write_node
- index_or_write_node
- index_target_node
- instance_variable_and_write_node
- instance_variable_operator_write_node
- instance_variable_target_node
- interpolated_match_last_line_node
- interpolated_regular_expression_node
- interpolated_xstring_node
- it_local_variable_read_node
- it_parameters_node
- local_variable_and_write_node
- local_variable_operator_write_node
- match_last_line_node
- match_predicate_node
- match_required_node
- match_write_node
- missing_node
- multi_target_node
- no_keywords_parameter_node
- numbered_parameters_node
- numbered_reference_read_node
- pinned_expression_node
- pinned_variable_node
- post_execution_node
- pre_execution_node
- rational_node
- redo_node
- retry_node
- shareable_constant_node
- source_encoding_node
- source_line_node
- undef_node
- while_node
- xstring_node

## Gem coverage (how many gems use each node type)

| Node type | Gems | % of gems | Total occurrences |
|---|---|---|---|
| local_variable_read_node | 5 | 100.0% | 1867 |
| local_variable_write_node | 5 | 100.0% | 403 |
| parameters_node | 5 | 100.0% | 376 |
| if_node | 5 | 100.0% | 377 |
| required_parameter_node | 5 | 100.0% | 392 |
| string_node | 5 | 100.0% | 784 |
| block_node | 5 | 100.0% | 227 |
| symbol_node | 5 | 100.0% | 2001 |
| arguments_node | 5 | 100.0% | 2199 |
| call_node | 5 | 100.0% | 4249 |
| class_node | 5 | 100.0% | 93 |
| constant_read_node | 5 | 100.0% | 1199 |
| constant_path_node | 5 | 100.0% | 430 |
| def_node | 5 | 100.0% | 557 |
| module_node | 5 | 100.0% | 131 |
| statements_node | 5 | 100.0% | 2029 |
| program_node | 5 | 100.0% | 82 |
| instance_variable_read_node | 4 | 80.0% | 144 |
| assoc_node | 4 | 80.0% | 1002 |
| constant_write_node | 4 | 80.0% | 41 |
| hash_node | 4 | 80.0% | 118 |
| block_parameters_node | 4 | 80.0% | 94 |
| unless_node | 4 | 80.0% | 158 |
| and_node | 4 | 80.0% | 130 |
| keyword_hash_node | 4 | 80.0% | 431 |
| integer_node | 4 | 80.0% | 75 |
| self_node | 4 | 80.0% | 149 |
| begin_node | 3 | 60.0% | 56 |
| rescue_node | 3 | 60.0% | 69 |
| singleton_class_node | 3 | 60.0% | 9 |
| optional_keyword_parameter_node | 3 | 60.0% | 104 |
| array_node | 3 | 60.0% | 64 |
| instance_variable_write_node | 3 | 60.0% | 166 |
| local_variable_target_node | 3 | 60.0% | 56 |
| else_node | 3 | 60.0% | 116 |
| interpolated_string_node | 3 | 60.0% | 87 |
| embedded_statements_node | 3 | 60.0% | 144 |
| false_node | 3 | 60.0% | 99 |
| true_node | 3 | 60.0% | 100 |
| optional_parameter_node | 3 | 60.0% | 11 |
| block_argument_node | 3 | 60.0% | 24 |
| return_node | 3 | 60.0% | 205 |
| regular_expression_node | 3 | 60.0% | 7 |
| instance_variable_or_write_node | 2 | 40.0% | 9 |
| or_node | 2 | 40.0% | 89 |
| parentheses_node | 2 | 40.0% | 21 |
| call_or_write_node | 2 | 40.0% | 3 |
| global_variable_read_node | 2 | 40.0% | 3 |
| forwarding_super_node | 2 | 40.0% | 4 |
| rest_parameter_node | 2 | 40.0% | 5 |
| assoc_splat_node | 2 | 40.0% | 10 |
| keyword_rest_parameter_node | 2 | 40.0% | 7 |
| required_keyword_parameter_node | 2 | 40.0% | 35 |
| range_node | 2 | 40.0% | 3 |
| yield_node | 2 | 40.0% | 2 |
| when_node | 2 | 40.0% | 32 |
| case_node | 2 | 40.0% | 13 |
| nil_node | 2 | 40.0% | 197 |
| next_node | 2 | 40.0% | 3 |
| defined_node | 2 | 40.0% | 51 |
| rescue_modifier_node | 2 | 40.0% | 3 |
| break_node | 2 | 40.0% | 7 |
| local_variable_or_write_node | 1 | 20.0% | 2 |
| interpolated_symbol_node | 1 | 20.0% | 4 |
| splat_node | 1 | 20.0% | 2 |
| block_parameter_node | 1 | 20.0% | 18 |
| super_node | 1 | 20.0% | 3 |
| call_operator_write_node | 1 | 20.0% | 1 |
| alias_method_node | 1 | 20.0% | 2 |
| float_node | 1 | 20.0% | 1 |
| multi_write_node | 1 | 20.0% | 3 |
| lambda_node | 1 | 20.0% | 42 |
| interpolated_x_string_node | 1 | 20.0% | 3 |
| class_variable_or_write_node | 1 | 20.0% | 5 |
| until_node | 1 | 20.0% | 1 |
| source_file_node | 1 | 20.0% | 3 |

Errors: 0
