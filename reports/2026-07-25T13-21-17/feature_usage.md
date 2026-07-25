# Ruby language feature usage across RubyGems.org

Prism AST node tally for the latest release of a random sample of 5000 gems (seeded, reproducible), out of 195399 gems on RubyGems.org.

Prism defines 151 node types; 136 appear in the sample.
Files that no longer parse under current Ruby: 505.

## Node types unused by any sampled gem

- alias_global_variable_node
- block_local_variable_node
- class_variable_and_write_node
- constant_and_write_node
- constant_operator_write_node
- constant_path_and_write_node
- constant_path_operator_write_node
- find_pattern_node
- flip_flop_node
- global_variable_and_write_node
- interpolated_match_last_line_node
- interpolated_xstring_node
- match_last_line_node
- missing_node
- no_keywords_parameter_node
- source_encoding_node
- xstring_node

## Gem coverage (how many gems use each node type)

| Node type | Gems | % of gems | Total occurrences |
|---|---|---|---|
| program_node | 4843 | 96.9% | 94427 |
| statements_node | 4843 | 96.9% | 2213699 |
| constant_read_node | 4797 | 95.9% | 1103208 |
| call_node | 4790 | 95.8% | 5020307 |
| string_node | 4786 | 95.7% | 1949731 |
| arguments_node | 4782 | 95.6% | 3268761 |
| def_node | 4477 | 89.5% | 547560 |
| local_variable_read_node | 4405 | 88.1% | 2393707 |
| parameters_node | 4351 | 87.0% | 486852 |
| required_parameter_node | 4303 | 86.1% | 624252 |
| class_node | 4290 | 85.8% | 100611 |
| module_node | 4275 | 85.5% | 116783 |
| symbol_node | 4141 | 82.8% | 1465367 |
| local_variable_write_node | 4122 | 82.4% | 488140 |
| block_node | 4097 | 81.9% | 452221 |
| constant_path_node | 3998 | 80.0% | 504003 |
| if_node | 3985 | 79.7% | 325811 |
| constant_write_node | 3984 | 79.7% | 71023 |
| block_parameters_node | 3860 | 77.2% | 181790 |
| embedded_statements_node | 3687 | 73.7% | 222307 |
| interpolated_string_node | 3662 | 73.2% | 146903 |
| self_node | 3632 | 72.6% | 194438 |
| integer_node | 3563 | 71.3% | 3438525 |
| assoc_node | 3520 | 70.4% | 690170 |
| array_node | 3484 | 69.7% | 279361 |
| else_node | 3426 | 68.5% | 102411 |
| hash_node | 3328 | 66.6% | 198888 |
| instance_variable_write_node | 3323 | 66.5% | 163607 |
| instance_variable_read_node | 3118 | 62.4% | 425364 |
| keyword_hash_node | 3002 | 60.0% | 169835 |
| nil_node | 2951 | 59.0% | 1649853 |
| true_node | 2935 | 58.7% | 79827 |
| optional_parameter_node | 2863 | 57.3% | 66359 |
| unless_node | 2844 | 56.9% | 75799 |
| or_node | 2672 | 53.4% | 60113 |
| return_node | 2605 | 52.1% | 90692 |
| false_node | 2588 | 51.8% | 66824 |
| parentheses_node | 2510 | 50.2% | 64511 |
| and_node | 2386 | 47.7% | 74812 |
| regular_expression_node | 2220 | 44.4% | 57157 |
| begin_node | 2130 | 42.6% | 30023 |
| local_variable_target_node | 1983 | 39.7% | 58140 |
| source_file_node | 1962 | 39.2% | 11979 |
| rescue_node | 1944 | 38.9% | 17591 |
| block_argument_node | 1789 | 35.8% | 22879 |
| instance_variable_or_write_node | 1694 | 33.9% | 13515 |
| rest_parameter_node | 1610 | 32.2% | 15817 |
| case_node | 1579 | 31.6% | 16563 |
| when_node | 1579 | 31.6% | 78808 |
| global_variable_read_node | 1560 | 31.2% | 15402 |
| splat_node | 1535 | 30.7% | 18758 |
| yield_node | 1405 | 28.1% | 9971 |
| multi_write_node | 1404 | 28.1% | 20247 |
| block_parameter_node | 1403 | 28.1% | 13158 |
| singleton_class_node | 1313 | 26.3% | 6003 |
| range_node | 1288 | 25.8% | 11706 |
| local_variable_operator_write_node | 1224 | 24.5% | 12107 |
| forwarding_super_node | 1069 | 21.4% | 10789 |
| super_node | 1002 | 20.0% | 9685 |
| next_node | 976 | 19.5% | 12762 |
| defined_node | 931 | 18.6% | 5149 |
| index_or_write_node | 888 | 17.8% | 6446 |
| float_node | 883 | 17.7% | 27613 |
| optional_keyword_parameter_node | 809 | 16.2% | 41709 |
| while_node | 785 | 15.7% | 4865 |
| break_node | 679 | 13.6% | 6579 |
| ensure_node | 661 | 13.2% | 3659 |
| local_variable_or_write_node | 630 | 12.6% | 3469 |
| interpolated_regular_expression_node | 591 | 11.8% | 4475 |
| alias_method_node | 522 | 10.4% | 8589 |
| required_keyword_parameter_node | 507 | 10.1% | 11806 |
| numbered_reference_read_node | 491 | 9.8% | 8062 |
| class_variable_write_node | 467 | 9.3% | 3489 |
| instance_variable_operator_write_node | 463 | 9.3% | 3061 |
| multi_target_node | 442 | 8.8% | 5586 |
| class_variable_read_node | 431 | 8.6% | 4740 |
| rescue_modifier_node | 422 | 8.4% | 1890 |
| instance_variable_target_node | 418 | 8.4% | 4054 |
| call_operator_write_node | 381 | 7.6% | 1429 |
| keyword_rest_parameter_node | 359 | 7.2% | 6493 |
| global_variable_write_node | 350 | 7.0% | 2085 |
| lambda_node | 350 | 7.0% | 6790 |
| assoc_splat_node | 350 | 7.0% | 5123 |
| index_operator_write_node | 318 | 6.4% | 1465 |
| interpolated_x_string_node | 315 | 6.3% | 1797 |
| until_node | 294 | 5.9% | 944 |
| interpolated_symbol_node | 261 | 5.2% | 4239 |
| call_or_write_node | 234 | 4.7% | 806 |
| x_string_node | 230 | 4.6% | 926 |
| retry_node | 187 | 3.7% | 395 |
| class_variable_or_write_node | 173 | 3.5% | 401 |
| source_line_node | 140 | 2.8% | 710 |
| for_node | 125 | 2.5% | 535 |
| call_target_node | 110 | 2.2% | 418 |
| constant_path_write_node | 99 | 2.0% | 436 |
| implicit_node | 89 | 1.8% | 3389 |
| implicit_rest_node | 74 | 1.5% | 617 |
| index_target_node | 72 | 1.4% | 424 |
| undef_node | 63 | 1.3% | 279 |
| back_reference_read_node | 60 | 1.2% | 501 |
| embedded_variable_node | 52 | 1.0% | 949 |
| forwarding_parameter_node | 48 | 1.0% | 413 |
| forwarding_arguments_node | 43 | 0.9% | 327 |
| class_variable_operator_write_node | 38 | 0.8% | 71 |
| global_variable_target_node | 38 | 0.8% | 206 |
| numbered_parameters_node | 36 | 0.7% | 565 |
| constant_target_node | 36 | 0.7% | 200 |
| global_variable_or_write_node | 33 | 0.7% | 57 |
| global_variable_operator_write_node | 31 | 0.6% | 80 |
| local_variable_and_write_node | 29 | 0.6% | 87 |
| case_match_node | 24 | 0.5% | 546 |
| in_node | 24 | 0.5% | 1632 |
| array_pattern_node | 18 | 0.4% | 484 |
| match_write_node | 17 | 0.3% | 46 |
| hash_pattern_node | 13 | 0.3% | 576 |
| alternation_pattern_node | 13 | 0.3% | 393 |
| constant_or_write_node | 13 | 0.3% | 207 |
| match_required_node | 12 | 0.2% | 202 |
| index_and_write_node | 12 | 0.2% | 31 |
| capture_pattern_node | 12 | 0.2% | 85 |
| it_parameters_node | 10 | 0.2% | 1037 |
| redo_node | 10 | 0.2% | 27 |
| it_local_variable_read_node | 10 | 0.2% | 1162 |
| instance_variable_and_write_node | 7 | 0.1% | 16 |
| rational_node | 6 | 0.1% | 63 |
| pinned_variable_node | 6 | 0.1% | 14 |
| class_variable_target_node | 4 | 0.1% | 9 |
| post_execution_node | 4 | 0.1% | 4 |
| imaginary_node | 3 | 0.1% | 4 |
| match_predicate_node | 3 | 0.1% | 42 |
| call_and_write_node | 2 | 0.0% | 2 |
| constant_path_or_write_node | 2 | 0.0% | 2 |
| shareable_constant_node | 1 | 0.0% | 6 |
| constant_path_target_node | 1 | 0.0% | 2 |
| pre_execution_node | 1 | 0.0% | 19 |
| pinned_expression_node | 1 | 0.0% | 1 |

Errors: 0
