# Ruby language feature usage across RubyGems.org

Prism AST node tally for the latest release of all 195390 gems, out of 195399 gems on RubyGems.org.

Prism defines 151 node types; 148 appear in the sample.
Files that no longer parse under current Ruby: 16461.

## Node types unused by any sampled gem

- constant_and_write_node
- constant_path_and_write_node
- missing_node

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
