s/  generic (/-- generic (/
s/float_exponent_width : NATURAL    := 8;/constant float_exponent_width : NATURAL    := 8;/
s/float_fraction_width : NATURAL    := 23;/constant float_fraction_width : NATURAL    := 23;/
s/float_round_style    : round_type := round_nearest;/constant float_round_style    : round_type := round_nearest;/
s/float_denormalize    : BOOLEAN    := true;/constant float_denormalize    : BOOLEAN    := true;/
s/float_check_error    : BOOLEAN    := true;/constant float_check_error    : BOOLEAN    := true;/
s/float_guard_bits     : NATURAL    := 3;/constant float_guard_bits     : NATURAL    := 3;/
s/no_warning           : BOOLEAN    := false/constant no_warning           : BOOLEAN    := (false/
s/alias U_float is UNRESOLVED_float/subtype U_float is UNRESOLVED_float/
s/subtype float is (resolved) UNRESOLVED_float/subtype float is UNRESOLVED_float/
s/function "?="/function \\?=\\/
s@function "?/="@function \\?/=\\@
s/function "?<"/function \\?<\\/
s/function "?<="/function \\?<=\\/
s/function "?>"/function \\?>\\/
s/function "?>="/function \\?>=\\/
s/function "and"  (l : UNRESOLVED_float)/function and_reduce (l : UNRESOLVED_float)/
s/function "nand" (l : UNRESOLVED_float)/function nand_reduce (l : UNRESOLVED_float)/
s/function "or"   (l : UNRESOLVED_float)/function or_reduce (l : UNRESOLVED_float)/
s/function "nor"  (l : UNRESOLVED_float)/function nor_reduce (l : UNRESOLVED_float)/
s/function "xor"  (l : UNRESOLVED_float)/function xor_reduce (l : UNRESOLVED_float)/
s/function "xnor" (l : UNRESOLVED_float)/function xnor_reduce (l : UNRESOLVED_float)/


