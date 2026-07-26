# Ruby language feature usage across RubyGems.org

Prism AST node tally for the latest release of all 195390 gems, out of 195399 gems on RubyGems.org.

Prism defines 151 node types; 148 appear in the sample.
Files that no longer parse under current Ruby: 16461.

## Node types unused by any sampled gem

- constant_and_write_node
- constant_path_and_write_node
- missing_node

## Node types last used before 2020

Alive in the corpus but not in maintained code: no gem using these has shipped a release
since 2020. Listed with the year of the newest gem that uses them.

| Node type | Newest using gem |
|---|---|
| interpolated_match_last_line_node | 2014 |

## Node types used only by gems nobody depends on

- class_variable_and_write_node
- constant_path_operator_write_node
- interpolated_match_last_line_node

## By era

Share of gems in each cohort using the node type, then what share of that cohort's AST
the type accounts for. The second is scale-free; the first is not.

| Node type | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| alias_global_variable_node | 0.0% | 0.0% | 0.0% |
| alias_method_node | 6.4% | 11.2% | 12.1% |
| alternation_pattern_node | 0.0% | 0.4% | 0.0% |
| and_node | 41.4% | 54.8% | 46.0% |
| arguments_node | 96.4% | 94.4% | 96.5% |
| array_node | 65.2% | 72.3% | 71.3% |
| array_pattern_node | 0.0% | 0.8% | 0.0% |
| assoc_node | 66.3% | 74.9% | 70.0% |
| assoc_splat_node | 2.0% | 19.4% | 0.1% |
| back_reference_read_node | 0.7% | 1.1% | 1.7% |
| begin_node | 36.2% | 49.1% | 42.3% |
| block_argument_node | 29.2% | 45.1% | 30.7% |
| block_local_variable_node | 0.0% | 0.0% | 0.0% |
| block_node | 78.1% | 80.8% | 85.6% |
| block_parameter_node | 21.7% | 30.3% | 30.7% |
| block_parameters_node | 73.1% | 77.4% | 79.9% |
| break_node | 10.1% | 16.8% | 12.5% |
| call_and_write_node | 0.0% | 0.1% | 0.1% |
| call_node | 96.4% | 94.6% | 96.8% |
| call_operator_write_node | 6.6% | 7.2% | 8.1% |
| call_or_write_node | 3.7% | 5.8% | 4.5% |
| call_target_node | 1.0% | 1.3% | 3.1% |
| capture_pattern_node | 0.0% | 0.4% | 0.0% |
| case_match_node | 0.0% | 1.1% | 0.0% |
| case_node | 25.1% | 37.9% | 29.7% |
| class_node | 84.6% | 86.9% | 86.0% |
| class_variable_and_write_node | 0.0% | 0.0% | 0.0% |
| class_variable_operator_write_node | 0.5% | 0.6% | 1.1% |
| class_variable_or_write_node | 2.7% | 3.2% | 4.3% |
| class_variable_read_node | 7.5% | 6.2% | 12.0% |
| class_variable_target_node | 0.1% | 0.1% | 0.1% |
| class_variable_write_node | 7.8% | 6.4% | 12.6% |
| constant_operator_write_node | 0.0% | 0.0% | 0.0% |
| constant_or_write_node | 0.3% | 0.4% | 0.2% |
| constant_path_node | 76.4% | 80.1% | 83.4% |
| constant_path_operator_write_node | 0.0% | 0.0% | 0.0% |
| constant_path_or_write_node | 0.0% | 0.1% | 0.0% |
| constant_path_target_node | 0.0% | 0.0% | 0.0% |
| constant_path_write_node | 1.1% | 2.3% | 1.7% |
| constant_read_node | 96.5% | 94.8% | 97.0% |
| constant_target_node | 0.4% | 0.6% | 0.7% |
| constant_write_node | 81.9% | 85.4% | 73.8% |
| def_node | 89.1% | 89.6% | 90.3% |
| defined_node | 12.8% | 22.0% | 18.6% |
| else_node | 63.4% | 70.7% | 68.5% |
| embedded_statements_node | 69.4% | 75.2% | 74.9% |
| embedded_variable_node | 0.7% | 0.7% | 1.5% |
| ensure_node | 8.4% | 14.9% | 12.8% |
| false_node | 45.7% | 57.6% | 50.9% |
| find_pattern_node | 0.0% | 0.0% | 0.0% |
| flip_flop_node | 0.0% | 0.0% | 0.0% |
| float_node | 13.9% | 21.4% | 17.6% |
| for_node | 2.2% | 1.9% | 3.8% |
| forwarding_arguments_node | 0.0% | 2.7% | 0.0% |
| forwarding_parameter_node | 0.0% | 3.2% | 0.0% |
| forwarding_super_node | 17.3% | 26.6% | 20.7% |
| global_variable_and_write_node | 0.0% | 0.0% | 0.0% |
| global_variable_operator_write_node | 0.4% | 0.7% | 0.9% |
| global_variable_or_write_node | 0.3% | 0.5% | 0.8% |
| global_variable_read_node | 21.9% | 22.2% | 42.8% |
| global_variable_target_node | 0.5% | 0.7% | 1.2% |
| global_variable_write_node | 4.7% | 4.7% | 9.3% |
| hash_node | 61.9% | 68.7% | 67.4% |
| hash_pattern_node | 0.0% | 0.6% | 0.0% |
| if_node | 75.9% | 81.2% | 80.2% |
| imaginary_node | 0.0% | 0.1% | 0.0% |
| implicit_node | 0.0% | 5.2% | 0.0% |
| implicit_rest_node | 0.6% | 2.7% | 1.1% |
| in_node | 0.0% | 1.1% | 0.0% |
| index_and_write_node | 0.1% | 0.3% | 0.2% |
| index_operator_write_node | 4.4% | 7.7% | 6.0% |
| index_or_write_node | 14.1% | 19.5% | 18.1% |
| index_target_node | 0.9% | 1.2% | 1.7% |
| instance_variable_and_write_node | 0.1% | 0.3% | 0.1% |
| instance_variable_operator_write_node | 6.9% | 10.3% | 9.1% |
| instance_variable_or_write_node | 28.8% | 38.6% | 31.9% |
| instance_variable_read_node | 58.3% | 64.2% | 66.1% |
| instance_variable_target_node | 6.0% | 7.1% | 11.3% |
| instance_variable_write_node | 62.6% | 69.4% | 67.6% |
| integer_node | 67.0% | 71.0% | 73.4% |
| interpolated_match_last_line_node | 0.0% | 0.0% | 0.0% |
| interpolated_regular_expression_node | 8.4% | 11.3% | 13.5% |
| interpolated_string_node | 68.8% | 75.0% | 74.0% |
| interpolated_symbol_node | 3.6% | 8.2% | 4.2% |
| interpolated_x_string_node | 5.7% | 5.0% | 7.8% |
| it_local_variable_read_node | 0.0% | 0.5% | 0.0% |
| it_parameters_node | 0.0% | 0.5% | 0.0% |
| keyword_hash_node | 55.4% | 68.5% | 57.1% |
| keyword_rest_parameter_node | 3.3% | 18.7% | 0.2% |
| lambda_node | 6.6% | 13.6% | 2.4% |
| local_variable_and_write_node | 0.5% | 1.0% | 0.6% |
| local_variable_operator_write_node | 19.2% | 27.7% | 22.9% |
| local_variable_or_write_node | 8.6% | 16.0% | 11.4% |
| local_variable_read_node | 86.6% | 87.2% | 89.4% |
| local_variable_target_node | 32.4% | 45.2% | 38.7% |
| local_variable_write_node | 79.1% | 83.0% | 83.8% |
| match_last_line_node | 0.0% | 0.0% | 0.0% |
| match_predicate_node | 0.0% | 0.2% | 0.0% |
| match_required_node | 0.0% | 0.3% | 0.0% |
| match_write_node | 0.2% | 0.4% | 0.1% |
| module_node | 85.8% | 87.6% | 83.7% |
| multi_target_node | 6.2% | 12.0% | 6.2% |
| multi_write_node | 21.2% | 30.5% | 29.5% |
| next_node | 14.2% | 28.1% | 15.1% |
| nil_node | 52.2% | 64.9% | 57.8% |
| no_keywords_parameter_node | 0.0% | 0.0% | 0.0% |
| numbered_parameters_node | 0.0% | 2.2% | 0.0% |
| numbered_reference_read_node | 5.4% | 6.3% | 13.5% |
| optional_keyword_parameter_node | 12.0% | 39.2% | 1.1% |
| optional_parameter_node | 51.3% | 56.6% | 61.5% |
| or_node | 46.0% | 60.4% | 52.1% |
| parameters_node | 85.7% | 86.5% | 88.3% |
| parentheses_node | 43.2% | 52.8% | 51.1% |
| pinned_expression_node | 0.0% | 0.0% | 0.0% |
| pinned_variable_node | 0.0% | 0.2% | 0.0% |
| post_execution_node | 0.0% | 0.0% | 0.1% |
| pre_execution_node | 0.0% | 0.1% | 0.1% |
| program_node | 97.0% | 96.0% | 97.6% |
| range_node | 22.0% | 29.7% | 26.1% |
| rational_node | 0.0% | 0.2% | 0.0% |
| redo_node | 0.2% | 0.3% | 0.2% |
| regular_expression_node | 37.6% | 44.9% | 48.5% |
| required_keyword_parameter_node | 6.0% | 24.9% | 0.1% |
| required_parameter_node | 84.7% | 85.7% | 87.5% |
| rescue_modifier_node | 5.9% | 6.7% | 11.1% |
| rescue_node | 32.5% | 45.4% | 38.3% |
| rest_parameter_node | 25.0% | 31.3% | 35.8% |
| retry_node | 2.7% | 4.3% | 3.4% |
| return_node | 47.2% | 60.7% | 49.0% |
| self_node | 69.4% | 74.0% | 73.6% |
| shareable_constant_node | 0.0% | 0.0% | 0.0% |
| singleton_class_node | 20.7% | 30.9% | 23.8% |
| source_encoding_node | 0.0% | 0.0% | 0.0% |
| source_file_node | 31.5% | 21.0% | 56.8% |
| source_line_node | 1.5% | 2.5% | 3.2% |
| splat_node | 25.0% | 32.9% | 32.0% |
| statements_node | 97.0% | 96.0% | 97.6% |
| string_node | 96.1% | 95.1% | 96.6% |
| super_node | 15.5% | 28.4% | 18.0% |
| symbol_node | 79.5% | 83.6% | 84.4% |
| true_node | 51.9% | 62.0% | 58.8% |
| undef_node | 0.4% | 0.7% | 2.0% |
| unless_node | 49.6% | 65.5% | 55.5% |
| until_node | 4.6% | 6.6% | 5.3% |
| when_node | 25.1% | 37.9% | 29.7% |
| while_node | 12.1% | 16.6% | 16.3% |
| x_string_node | 4.5% | 4.5% | 5.5% |
| yield_node | 22.5% | 32.0% | 26.9% |

Cohort sizes: 2015-2019 63172, 2020+ 57101, pre-2015 75117 (195390 gems). Cells are the share of gems in that cohort exhibiting the row, so columns are comparable to each other and to how large the cohort is overall.

### Composition of the AST

| Node type | 2015-2019 | 2020+ | pre-2015 |
|---|---|---|---|
| alias_global_variable_node | 0.0% | 0.0% | 0.0% |
| alias_method_node | 0.0% | 0.0% | 0.0% |
| alternation_pattern_node | 0.0% | 0.0% | 0.0% |
| and_node | 0.2% | 0.3% | 0.1% |
| arguments_node | 12.3% | 9.5% | 13.6% |
| array_node | 1.2% | 0.7% | 1.1% |
| array_pattern_node | 0.0% | 0.0% | 0.0% |
| assoc_node | 3.0% | 2.9% | 2.7% |
| assoc_splat_node | 0.0% | 0.0% | 0.0% |
| back_reference_read_node | 0.0% | 0.0% | 0.0% |
| begin_node | 0.1% | 0.1% | 0.1% |
| block_argument_node | 0.1% | 0.1% | 0.1% |
| block_local_variable_node | 0.0% | 0.0% | 0.0% |
| block_node | 2.1% | 1.0% | 2.0% |
| block_parameter_node | 0.1% | 0.0% | 0.1% |
| block_parameters_node | 0.6% | 0.5% | 0.6% |
| break_node | 0.0% | 0.0% | 0.0% |
| call_and_write_node | 0.0% | 0.0% | 0.0% |
| call_node | 19.0% | 14.6% | 19.9% |
| call_operator_write_node | 0.0% | 0.0% | 0.0% |
| call_or_write_node | 0.0% | 0.0% | 0.0% |
| call_target_node | 0.0% | 0.0% | 0.0% |
| capture_pattern_node | 0.0% | 0.0% | 0.0% |
| case_match_node | 0.0% | 0.0% | 0.0% |
| case_node | 0.0% | 0.0% | 0.0% |
| class_node | 0.4% | 0.4% | 0.4% |
| class_variable_and_write_node | 0.0% | 0.0% | 0.0% |
| class_variable_operator_write_node | 0.0% | 0.0% | 0.0% |
| class_variable_or_write_node | 0.0% | 0.0% | 0.0% |
| class_variable_read_node | 0.0% | 0.0% | 0.0% |
| class_variable_target_node | 0.0% | 0.0% | 0.0% |
| class_variable_write_node | 0.0% | 0.0% | 0.0% |
| constant_operator_write_node | 0.0% | 0.0% | 0.0% |
| constant_or_write_node | 0.0% | 0.0% | 0.0% |
| constant_path_node | 1.6% | 1.9% | 1.7% |
| constant_path_operator_write_node | 0.0% | 0.0% | 0.0% |
| constant_path_or_write_node | 0.0% | 0.0% | 0.0% |
| constant_path_target_node | 0.0% | 0.0% | 0.0% |
| constant_path_write_node | 0.0% | 0.0% | 0.0% |
| constant_read_node | 3.9% | 3.4% | 4.3% |
| constant_target_node | 0.0% | 0.0% | 0.0% |
| constant_write_node | 0.2% | 0.3% | 0.2% |
| def_node | 1.7% | 8.8% | 1.7% |
| defined_node | 0.0% | 0.0% | 0.0% |
| else_node | 0.3% | 0.3% | 0.3% |
| embedded_statements_node | 0.8% | 0.6% | 0.8% |
| embedded_variable_node | 0.0% | 0.0% | 0.0% |
| ensure_node | 0.0% | 0.0% | 0.0% |
| false_node | 0.5% | 0.3% | 0.2% |
| find_pattern_node | 0.0% | 0.0% | 0.0% |
| flip_flop_node | 0.0% | 0.0% | 0.0% |
| float_node | 0.1% | 0.1% | 0.3% |
| for_node | 0.0% | 0.0% | 0.0% |
| forwarding_arguments_node | 0.0% | 0.0% | 0.0% |
| forwarding_parameter_node | 0.0% | 0.0% | 0.0% |
| forwarding_super_node | 0.0% | 0.0% | 0.0% |
| global_variable_and_write_node | 0.0% | 0.0% | 0.0% |
| global_variable_operator_write_node | 0.0% | 0.0% | 0.0% |
| global_variable_or_write_node | 0.0% | 0.0% | 0.0% |
| global_variable_read_node | 0.1% | 0.0% | 0.1% |
| global_variable_target_node | 0.0% | 0.0% | 0.0% |
| global_variable_write_node | 0.0% | 0.0% | 0.0% |
| hash_node | 0.7% | 0.7% | 0.7% |
| hash_pattern_node | 0.0% | 0.0% | 0.0% |
| if_node | 0.9% | 1.2% | 0.8% |
| imaginary_node | 0.0% | 0.0% | 0.0% |
| implicit_node | 0.0% | 0.0% | 0.0% |
| implicit_rest_node | 0.0% | 0.0% | 0.0% |
| in_node | 0.0% | 0.0% | 0.0% |
| index_and_write_node | 0.0% | 0.0% | 0.0% |
| index_operator_write_node | 0.0% | 0.0% | 0.0% |
| index_or_write_node | 0.0% | 0.0% | 0.0% |
| index_target_node | 0.0% | 0.0% | 0.0% |
| instance_variable_and_write_node | 0.0% | 0.0% | 0.0% |
| instance_variable_operator_write_node | 0.0% | 0.0% | 0.0% |
| instance_variable_or_write_node | 0.1% | 0.0% | 0.0% |
| instance_variable_read_node | 1.3% | 1.1% | 2.6% |
| instance_variable_target_node | 0.0% | 0.0% | 0.0% |
| instance_variable_write_node | 0.6% | 0.5% | 0.6% |
| integer_node | 4.4% | 9.7% | 4.5% |
| interpolated_match_last_line_node | 0.0% | 0.0% | 0.0% |
| interpolated_regular_expression_node | 0.0% | 0.0% | 0.0% |
| interpolated_string_node | 0.5% | 0.4% | 0.5% |
| interpolated_symbol_node | 0.0% | 0.0% | 0.0% |
| interpolated_x_string_node | 0.0% | 0.0% | 0.0% |
| it_local_variable_read_node | 0.0% | 0.0% | 0.0% |
| it_parameters_node | 0.0% | 0.0% | 0.0% |
| keyword_hash_node | 0.6% | 0.7% | 0.6% |
| keyword_rest_parameter_node | 0.0% | 0.0% | 0.0% |
| lambda_node | 0.0% | 0.0% | 0.0% |
| local_variable_and_write_node | 0.0% | 0.0% | 0.0% |
| local_variable_operator_write_node | 0.0% | 0.0% | 0.0% |
| local_variable_or_write_node | 0.0% | 0.0% | 0.0% |
| local_variable_read_node | 7.3% | 7.8% | 7.1% |
| local_variable_target_node | 0.2% | 0.2% | 0.1% |
| local_variable_write_node | 1.6% | 1.5% | 1.6% |
| match_last_line_node | 0.0% | 0.0% | 0.0% |
| match_predicate_node | 0.0% | 0.0% | 0.0% |
| match_required_node | 0.0% | 0.0% | 0.0% |
| match_write_node | 0.0% | 0.0% | 0.0% |
| module_node | 0.5% | 0.4% | 0.4% |
| multi_target_node | 0.0% | 0.0% | 0.0% |
| multi_write_node | 0.1% | 0.1% | 0.1% |
| next_node | 0.0% | 0.0% | 0.0% |
| nil_node | 0.4% | 5.2% | 0.5% |
| no_keywords_parameter_node | 0.0% | 0.0% | 0.0% |
| numbered_parameters_node | 0.0% | 0.0% | 0.0% |
| numbered_reference_read_node | 0.0% | 0.0% | 0.0% |
| optional_keyword_parameter_node | 0.1% | 0.2% | 0.0% |
| optional_parameter_node | 0.2% | 0.2% | 0.3% |
| or_node | 0.2% | 0.2% | 0.2% |
| parameters_node | 1.5% | 1.4% | 1.4% |
| parentheses_node | 0.2% | 0.2% | 0.2% |
| pinned_expression_node | 0.0% | 0.0% | 0.0% |
| pinned_variable_node | 0.0% | 0.0% | 0.0% |
| post_execution_node | 0.0% | 0.0% | 0.0% |
| pre_execution_node | 0.0% | 0.0% | 0.0% |
| program_node | 0.4% | 0.3% | 0.4% |
| range_node | 0.1% | 0.0% | 0.1% |
| rational_node | 0.0% | 0.0% | 0.0% |
| redo_node | 0.0% | 0.0% | 0.0% |
| regular_expression_node | 0.2% | 0.2% | 0.2% |
| required_keyword_parameter_node | 0.0% | 0.1% | 0.0% |
| required_parameter_node | 1.8% | 1.8% | 1.7% |
| rescue_modifier_node | 0.0% | 0.0% | 0.0% |
| rescue_node | 0.1% | 0.1% | 0.1% |
| rest_parameter_node | 0.1% | 0.0% | 0.1% |
| retry_node | 0.0% | 0.0% | 0.0% |
| return_node | 0.3% | 0.3% | 0.2% |
| self_node | 0.6% | 0.7% | 0.5% |
| shareable_constant_node | 0.0% | 0.0% | 0.0% |
| singleton_class_node | 0.0% | 0.0% | 0.0% |
| source_encoding_node | 0.0% | 0.0% | 0.0% |
| source_file_node | 0.1% | 0.0% | 0.1% |
| source_line_node | 0.0% | 0.0% | 0.0% |
| splat_node | 0.1% | 0.0% | 0.1% |
| statements_node | 7.8% | 6.6% | 7.5% |
| string_node | 12.5% | 5.7% | 10.0% |
| super_node | 0.0% | 0.0% | 0.0% |
| symbol_node | 5.2% | 5.4% | 5.5% |
| true_node | 0.4% | 0.3% | 0.3% |
| undef_node | 0.0% | 0.0% | 0.0% |
| unless_node | 0.2% | 0.3% | 0.2% |
| until_node | 0.0% | 0.0% | 0.0% |
| when_node | 0.2% | 0.2% | 0.2% |
| while_node | 0.0% | 0.0% | 0.0% |
| x_string_node | 0.0% | 0.0% | 0.0% |
| yield_node | 0.0% | 0.0% | 0.0% |

Sites per cohort: 2015-2019 192950808, 2020+ 665506121, pre-2015 269169327 (1127626256 sites). Cells are the share of that cohort's sites, so each column sums to 100%. This is scale-free: it says what the code is made of, not how much code there is.

## Gem coverage (how many gems use each node type)

| Node type | Gems | % of gems | Total occurrences |
|---|---|---|---|
| program_node | 189410 | 96.9% | 3710135 |
| statements_node | 189410 | 96.9% | 78776461 |
| constant_read_node | 188025 | 96.2% | 41901495 |
| call_node | 187606 | 96.0% | 187704022 |
| string_node | 187531 | 96.0% | 89085925 |
| arguments_node | 187284 | 95.9% | 123576056 |
| def_node | 175308 | 89.7% | 66591023 |
| local_variable_read_node | 171720 | 87.9% | 85367243 |
| parameters_node | 169825 | 86.9% | 16325999 |
| required_parameter_node | 168196 | 86.1% | 20198435 |
| class_node | 167715 | 85.8% | 4067544 |
| module_node | 167065 | 85.5% | 4760777 |
| symbol_node | 161398 | 82.6% | 60659310 |
| local_variable_write_node | 160315 | 82.0% | 17070531 |
| block_node | 159747 | 81.8% | 16313348 |
| constant_path_node | 156635 | 80.2% | 20135807 |
| constant_write_node | 155948 | 79.8% | 2730396 |
| if_node | 154580 | 79.1% | 11834956 |
| block_parameters_node | 150352 | 76.9% | 6187764 |
| embedded_statements_node | 143061 | 73.2% | 7623522 |
| interpolated_string_node | 141848 | 72.6% | 5076846 |
| self_node | 141430 | 72.4% | 6970411 |
| integer_node | 138028 | 70.6% | 85412866 |
| assoc_node | 137249 | 70.2% | 32475122 |
| array_node | 136048 | 69.6% | 9770115 |
| else_node | 131873 | 67.5% | 3534060 |
| instance_variable_write_node | 129917 | 66.5% | 6094511 |
| hash_node | 128958 | 66.0% | 7947920 |
| instance_variable_read_node | 123124 | 63.0% | 16703208 |
| keyword_hash_node | 116959 | 59.9% | 6971620 |
| nil_node | 113473 | 58.1% | 36327790 |
| true_node | 112386 | 57.5% | 3559141 |
| optional_parameter_node | 110918 | 56.8% | 2512455 |
| unless_node | 110464 | 56.5% | 3018457 |
| or_node | 102659 | 52.5% | 2131977 |
| return_node | 101254 | 51.8% | 2977739 |
| false_node | 99945 | 51.2% | 3102013 |
| parentheses_node | 95865 | 49.1% | 2268789 |
| and_node | 91963 | 47.1% | 2685606 |
| regular_expression_node | 85845 | 43.9% | 1952333 |
| begin_node | 82734 | 42.3% | 1006825 |
| local_variable_target_node | 75386 | 38.6% | 1985379 |
| rescue_node | 75238 | 38.5% | 703746 |
| source_file_node | 74589 | 38.2% | 462416 |
| block_argument_node | 67234 | 34.4% | 775673 |
| instance_variable_or_write_node | 64158 | 32.8% | 476906 |
| rest_parameter_node | 60541 | 31.0% | 538660 |
| when_node | 59868 | 30.6% | 2287518 |
| case_node | 59868 | 30.6% | 537892 |
| global_variable_read_node | 58695 | 30.0% | 528962 |
| splat_node | 58622 | 30.0% | 581313 |
| block_parameter_node | 54080 | 27.7% | 480438 |
| multi_write_node | 52905 | 27.1% | 674870 |
| yield_node | 52694 | 27.0% | 342387 |
| range_node | 50434 | 25.8% | 534631 |
| singleton_class_node | 48639 | 24.9% | 198190 |
| local_variable_operator_write_node | 45151 | 23.1% | 455834 |
| forwarding_super_node | 41664 | 21.3% | 379237 |
| super_node | 39503 | 20.2% | 385649 |
| next_node | 36380 | 18.6% | 410855 |
| defined_node | 34643 | 17.7% | 203654 |
| float_node | 34211 | 17.5% | 1627906 |
| index_or_write_node | 33694 | 17.2% | 217577 |
| optional_keyword_parameter_node | 30788 | 15.8% | 1361020 |
| while_node | 29399 | 15.0% | 176161 |
| break_node | 25393 | 13.0% | 221218 |
| ensure_node | 23425 | 12.0% | 123460 |
| local_variable_or_write_node | 23192 | 11.9% | 109646 |
| interpolated_regular_expression_node | 21878 | 11.2% | 144072 |
| alias_method_node | 19536 | 10.0% | 290727 |
| required_keyword_parameter_node | 18133 | 9.3% | 439096 |
| class_variable_write_node | 18112 | 9.3% | 121238 |
| class_variable_read_node | 17265 | 8.8% | 194392 |
| numbered_reference_read_node | 17155 | 8.8% | 254300 |
| instance_variable_operator_write_node | 17046 | 8.7% | 111403 |
| instance_variable_target_node | 16301 | 8.3% | 147316 |
| rescue_modifier_node | 15935 | 8.2% | 68545 |
| multi_target_node | 15459 | 7.9% | 188136 |
| call_operator_write_node | 14350 | 7.3% | 46289 |
| lambda_node | 13684 | 7.0% | 234912 |
| keyword_rest_parameter_node | 12919 | 6.6% | 291260 |
| global_variable_write_node | 12602 | 6.4% | 79275 |
| assoc_splat_node | 12445 | 6.4% | 342109 |
| interpolated_x_string_node | 12287 | 6.3% | 48361 |
| index_operator_write_node | 11695 | 6.0% | 45939 |
| until_node | 10651 | 5.5% | 34771 |
| interpolated_symbol_node | 10047 | 5.1% | 125816 |
| x_string_node | 9584 | 4.9% | 38357 |
| call_or_write_node | 9017 | 4.6% | 30108 |
| class_variable_or_write_node | 6726 | 3.4% | 20171 |
| retry_node | 6679 | 3.4% | 15786 |
| for_node | 5284 | 2.7% | 32498 |
| source_line_node | 4736 | 2.4% | 28544 |
| call_target_node | 3658 | 1.9% | 16036 |
| constant_path_write_node | 3344 | 1.7% | 27537 |
| implicit_node | 2996 | 1.5% | 84885 |
| implicit_rest_node | 2759 | 1.4% | 25781 |
| index_target_node | 2544 | 1.3% | 13617 |
| back_reference_read_node | 2326 | 1.2% | 20090 |
| undef_node | 2208 | 1.1% | 10663 |
| embedded_variable_node | 2026 | 1.0% | 18915 |
| forwarding_parameter_node | 1829 | 0.9% | 10459 |
| global_variable_target_node | 1631 | 0.8% | 6368 |
| forwarding_arguments_node | 1557 | 0.8% | 8422 |
| class_variable_operator_write_node | 1448 | 0.7% | 2768 |
| global_variable_operator_write_node | 1356 | 0.7% | 4151 |
| local_variable_and_write_node | 1297 | 0.7% | 3621 |
| numbered_parameters_node | 1239 | 0.6% | 13602 |
| global_variable_or_write_node | 1039 | 0.5% | 2602 |
| constant_target_node | 1035 | 0.5% | 6741 |
| case_match_node | 633 | 0.3% | 7617 |
| in_node | 633 | 0.3% | 19692 |
| constant_or_write_node | 608 | 0.3% | 9863 |
| array_pattern_node | 450 | 0.2% | 6962 |
| redo_node | 440 | 0.2% | 1342 |
| index_and_write_node | 429 | 0.2% | 1345 |
| match_write_node | 422 | 0.2% | 1003 |
| hash_pattern_node | 349 | 0.2% | 3216 |
| it_parameters_node | 291 | 0.1% | 3787 |
| it_local_variable_read_node | 291 | 0.1% | 4371 |
| instance_variable_and_write_node | 270 | 0.1% | 600 |
| alternation_pattern_node | 253 | 0.1% | 6185 |
| capture_pattern_node | 251 | 0.1% | 1709 |
| class_variable_target_node | 203 | 0.1% | 888 |
| match_required_node | 157 | 0.1% | 1390 |
| rational_node | 137 | 0.1% | 2296 |
| pinned_variable_node | 114 | 0.1% | 188 |
| pre_execution_node | 108 | 0.1% | 237 |
| match_predicate_node | 104 | 0.1% | 594 |
| call_and_write_node | 99 | 0.1% | 174 |
| post_execution_node | 87 | 0.0% | 121 |
| constant_path_or_write_node | 71 | 0.0% | 103 |
| source_encoding_node | 56 | 0.0% | 100 |
| imaginary_node | 50 | 0.0% | 288 |
| flip_flop_node | 47 | 0.0% | 68 |
| block_local_variable_node | 34 | 0.0% | 87 |
| alias_global_variable_node | 27 | 0.0% | 319 |
| no_keywords_parameter_node | 15 | 0.0% | 45 |
| find_pattern_node | 14 | 0.0% | 46 |
| constant_operator_write_node | 13 | 0.0% | 23 |
| match_last_line_node | 11 | 0.0% | 42 |
| constant_path_target_node | 10 | 0.0% | 19 |
| shareable_constant_node | 9 | 0.0% | 74 |
| pinned_expression_node | 6 | 0.0% | 14 |
| class_variable_and_write_node | 4 | 0.0% | 6 |
| global_variable_and_write_node | 4 | 0.0% | 7 |
| constant_path_operator_write_node | 4 | 0.0% | 4 |
| interpolated_match_last_line_node | 1 | 0.0% | 1 |

Errors: 9
