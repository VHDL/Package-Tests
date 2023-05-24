-- --------------------------------------------------------------------
-- Last Modified: $Date: 2006-09-21 10:33:43-04 $
-- RCS ID: $Id: float_noround_pkg.vhdl,v 1.3 2006-09-21 10:33:43-04 l435385 Exp $
--  Created for VHDL-200X par, David Bishop (dbishopx@gmail.com)
-- --------------------------------------------------------------------
library ieee;
use ieee.math_utility_pkg.all;

package float_noround_pkg is new ieee.float_generic_pkg
    generic map (
      float_exponent_width => 6,        -- float16'high
      float_fraction_width => 9,        -- -float16'low
      float_round_style    => round_zero,  -- round zero (truncate) algorithm
      float_denormalize    => false,    -- Turn off Denormal numbers
      float_check_error    => false,    -- Turn off NAN and overflow processing
      float_guard_bits     => 0,        -- no guard bits
      no_warning           => true      -- do not show warnings
      );

