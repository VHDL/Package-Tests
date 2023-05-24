s/function "?="/function \\?=\\/
s@function "?/="@function \\?/=\\@
s/function "?<"/function \\?<\\/
s/function "?<="/function \\?<=\\/
s/function "?>"/function \\?>\\/
s/function "?>="/function \\?>=\\/
s/lresize(i) ?= rresize(i)/\\?=\\ (lresize(i), rresize(i))/
s@lresize(i) ?/= rresize(i)@\\?/=\\ (lresize(i), rresize(i))@
s/lresize(i) ?< rresize(i)/\\?<\\ (lresize(i), rresize(i))/
s/lresize(i) ?> rresize(i)/\\?>\\ (lresize(i), rresize(i))/
s/lresize(i) ?<= rresize(i)/\\?<=\\ (lresize(i), rresize(i))/
s/lresize(i) ?>= rresize(i)/\\?>=\\ (lresize(i), rresize(i))/
s@l ?= r_float@\\?=\\ (l, r_float)@
s@l ?/= r_float@\\?/=\\ (l, r_float)@
s@l ?< r_float@\\?<\\ (l, r_float)@
s@l ?<= r_float@\\?<=\\ (l, r_float)@
s@l ?> r_float@\\?>\\ (l, r_float)@
s@l ?>= r_float@\\?>=\\ (l, r_float)@
s@l_float ?= r@\\?=\\ (l_float, r)@
s@l_float ?/= r@\\?/=\\ (l_float, r)@
s@l_float ?< r@\\?<\\ (l_float, r)@
s@l_float ?<= r@\\?<=\\ (l_float, r)@
s@l_float ?> r@\\?>\\ (l_float, r)@
s@l_float ?>= r@\\?>=\\ (l_float, r)@
s/arg(i) ?= y/\\?=\\ (arg(i), y) = '1'/
/-- Reduction operators/,/-- Recommended Functions/ s/to_suv(l)/(to_suv(l))/
/-- Reduction operators/,/-- Recommended Functions/ s/"and"/and/
/-- Reduction operators/,/-- Recommended Functions/ s/"nand"/nand/
/-- Reduction operators/,/-- Recommended Functions/ s/"or"/or/
/-- Reduction operators/,/-- Recommended Functions/ s/"nor"/nor/
/-- Reduction operators/,/-- Recommended Functions/ s/"xor"/xor/
/-- Reduction operators/,/-- Recommended Functions/ s/"xnor"/xnor/
/-- Reduction operators/,/-- Recommended Functions/ s/and/and_reduce/
/-- Reduction operators/,/-- Recommended Functions/ s/or/or_reduce/
29 r float_generic_pkg-body_ADD.vhdl
s@or_reduced := or (remainder \& sticky)@or_reduced := or_reduce (remainder \& sticky)@
s@if ((or (remainder(remainder'high-1@if ((or_reduce (remainder(remainder'high-1@
s@if and@if and_reduce@
s@or (or (@or (or_reduce (@
s@if (or@if (or_reduce@
s@if or @if or_reduce @
s@(and (STD_ULOGIC_VECTOR (arg (exponent_width-1 downto 0)))@(and_reduce (STD_ULOGIC_VECTOR (arg (exponent_width-1 downto 0)))@
s@and (STD_ULOGIC_VECTOR (arg (exponent_width-1 downto 0)))@and_reduce (STD_ULOGIC_VECTOR (arg (exponent_width-1 downto 0)))@
s@elsif or (STD_ULOGIC_VECTOR (arg (exponent_width-1 downto 0)))@elsif or_reduce (STD_ULOGIC_VECTOR (arg (exponent_width-1 downto 0)))@
s@sticky    := or@sticky    := or_reduce@
s@sticky  := or@sticky  := or_reduce@
s@sticky := or@sticky := or_reduce@
s@assert (or (urfract (fraction_width-1 downto 0)) = '0')@assert (or_reduce (urfract (fraction_width-1 downto 0)) = '0')@
s@to_suv(lresize) ?= to_suv(rresize)@\\?=\\ (to_suv(lresize), to_suv(rresize))@
s@(or (slv@(or_reduce (slv@

