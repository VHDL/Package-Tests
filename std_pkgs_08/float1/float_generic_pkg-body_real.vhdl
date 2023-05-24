-------------------------------------------------------------------------------
-- Proposed package body for the VHDL-200x-FT fphdl_generic_pkg package
-- This version is optomized for Simulation, and not for synthesis.
-- Note that there are functional differences between the synthesis and
-- simulation packages bodies.  The Synthesis version is preferred.
-- This package body supplies a recommended implementation of these functions
-- Last Modified: $Date: 2006-06-20 11:12:45-04 $
-- RCS ID: $Id: float_generic_pkg-body_real.vhdl,v 1.1 2006-06-20 11:12:45-04 l435385 Exp $
--
--  Created for VHDL-200X par, David Bishop (dbishopx@gmail.com)
-------------------------------------------------------------------------------
library ieee;
use ieee.math_real.all;

package body float_generic_pkg is
  -- Author David Bishop (dbishopx@gmail.com)
  -----------------------------------------------------------------------------
  -- type declarations
  -----------------------------------------------------------------------------
  -- This differed constant will tell you if the package body is synthesizable
  -- or implemented as real numbers.  Set to "false" if done with real numbers.
  constant fphdlsynth_or_real : BOOLEAN                       := false;  -- differed constant
  -- types of boundary conditions
  type     boundary_type is (normal, infinity, zero, denormal);
  -- null range array constant
  constant NAFP               : UNRESOLVED_float (0 downto 1)            := (others => '0');
  constant NSLV               : STD_LOGIC_VECTOR (0 downto 1) := (others => '0');





  
  -- purpose: Converts an Unsigned into a Real
  function to_real (
    arg : UNSIGNED)                     -- unsigned input
    return REAL is
    variable result : REAL := 0.0;      -- result
  begin  -- function to_real
    floop : for i in arg'range loop
      result := result + result;
      if arg (i) = '1' then
        result := result + 1.0;
      end if;
    end loop floop;
    return result;
  end function to_real;

  -- purpose: Converts an Signed into a Real
  function to_real (
    arg : SIGNED)                             -- unsigned input
    return REAL is
    variable arg_uns : UNSIGNED (arg'range);  -- unsigned version
    variable sign    : BOOLEAN;               -- true if signed
    variable result  : REAL := 0.0;           -- result
  begin  -- function to_real
    if arg (arg'high) = '1' then
      sign    := true;
      arg_uns := UNSIGNED (-arg);
    else
      sign    := false;
      arg_uns := UNSIGNED (arg);
    end if;
    result := to_real (arg_uns);
    if sign then
      return -result;
    else
      return result;
    end if;
  end function to_real;

  -- purpose: converts the negative index to a positive one
  -- negative indices are illegal in 1164 and 1076.3
  function to_slv (
    arg : UNRESOLVED_float)                        -- fp vector
    return STD_LOGIC_VECTOR is
    subtype  t is STD_LOGIC_VECTOR(arg'length - 1 downto 0);
    variable slv : t;
  begin  -- function to_std_logic_vector
    if arg'length < 1 then
      return NSLV;
    end if;
    slv := t(arg);
--    floop : for i in slv'range loop
--      slv(i) := arg(i + arg'low);  -- slv(31) := arg (31-23)
--    end loop floop;
    return slv;
  end function to_slv;

  -- Converts an fp into an SULV
  function to_suv (arg : UNRESOLVED_float) return STD_ULOGIC_VECTOR is
  begin
    return to_stdulogicvector (to_slv(arg));
  end function to_suv;

  -- Special version of "minimum" to do some boundary checking
  function minx (l, r : INTEGER)
    return INTEGER is
  begin  -- function minimum
    if (L = INTEGER'low or R = INTEGER'low) then
      report float_generic_pkg'instance_name
        & " Unbounded number passed, was a literal used?"
        severity error;
      return 0;
    end if;
    if L > R then return R;
    else return L;
    end if;
  end function minx;

  -- purpose: Test the boundary conditions of a Real number
  -- Not Synthisable
  function test_boundary (
    arg                     : REAL;     -- Input, converted to real
    constant fraction_width : NATURAL;  -- length of FP output fraction
    constant exponent_width : NATURAL;  -- length of FP exponent
    constant denormalize    : BOOLEAN := true)  -- Use IEEE extended FP
    return boundary_type is
    constant expon_base : SIGNED (exponent_width-1 downto 0) :=
      to_signed (2**(exponent_width-1) -1, exponent_width);  -- exponent offset
    constant exp_min : SIGNED (12 downto 0) :=
      -(resize(expon_base, 13)) +1;
                                        -- Minimum normal exponent
    constant exp_ext_min : SIGNED (12 downto 0) :=
      exp_min - fraction_width;
                                        -- Minimum for denormal exponent
  begin  -- function test_boundary
    -- Check to see if the exponent is big enough
    -- Note that the argument is always an absolute value at this point.
    if arg = 0.0 then
      return zero;
    elsif exponent_width > 11 then      -- Exponent for Real is 11 (64 bit)
      return normal;
    else
      if arg < 2.0 ** to_integer(exp_min) then
        if denormalize then
          if arg < 2.0 ** to_integer(exp_ext_min) then
            return zero;
          else
            return denormal;
          end if;
        else
          if arg < 2.0 ** to_integer(exp_min-1) then
            return zero;
          else
            return normal;              -- Can still represent this number
          end if;
        end if;
      elsif exponent_width < 11 then
        if arg >= 2.0 ** (to_integer(expon_base)+1) then
          return infinity;
        else
          return normal;
        end if;
      else
        return normal;
      end if;
    end if;
  end function test_boundary;

  -- Returns the class which X falls into
  -- Synthisable
  function Classfp (
    x           : UNRESOLVED_float;                -- floating point input
    check_error : BOOLEAN := float_check_error)   -- check for errors
    return valid_fpstate is
    constant fraction_width : INTEGER := -minx(x'low, x'low);  -- length of FP output fraction
    constant exponent_width : INTEGER := x'high;  -- length of FP output exponent
    variable arg            : UNRESOLVED_float (exponent_width downto -fraction_width);
  begin  -- classfp
    if (arg'length < 1 or fraction_width < 3 or exponent_width < 3
        or x'left < x'right) then
      report FLOAT_GENERIC_PKG'instance_name
        & " CLASSFP: " &
        "Floating point number detected with a bad range"
        severity error;
      return isx;
    end if;
    -- Check for "X".
    arg := to_01 (x, 'X');
    if (arg(0) = 'X') then
      return isx;                       -- If there is an X in the number
      -- Special cases, check for illegal number
    elsif check_error and
      (and (STD_ULOGIC_VECTOR (arg (exponent_width-1 downto 0)))
       = '1') then                      -- Exponent is all "1".
      if or (to_slv (arg (-1 downto -fraction_width)))
         /= '0' then  -- Fraction must be all "0" or this is not a number.
        if (arg(-1) = '1') then         -- From "W. Khan - IEEE standard
          return nan;            -- 754 binary FP Signaling nan (Not a number)
        else
          return quiet_nan;
        end if;
        -- Check for infinity
      elsif arg(exponent_width) = '0' then
        return pos_inf;                 -- Positive infinity
      else
        return neg_inf;                 -- Negative infinity
      end if;
      -- check for "0"
    elsif or (STD_LOGIC_VECTOR (arg (exponent_width-1 downto 0)))
       = '0' then                       -- Exponent is all "0"
      if or (to_slv (arg(-1 downto -fraction_width)))
         = '0' then                     -- Fraction is all "0"
        if arg(exponent_width) = '0' then
          return pos_zero;              -- Zero
        else
          return neg_zero;
        end if;
      else
        if arg(exponent_width) = '0' then
          return pos_denormal;          -- Denormal number (ieee extended fp)
        else
          return neg_denormal;
        end if;
      end if;
    else
      if arg(exponent_width) = '0' then
        return pos_normal;              -- Normal FP number
      else
        return neg_normal;
      end if;
    end if;
  end function Classfp;

  -- Arithmetic functions
  -- Synthisable
  function "abs" (
    arg : UNRESOLVED_float)                        -- floating point input
    return UNRESOLVED_float is
    variable result : UNRESOLVED_float (arg'range);  -- result
  begin
    if (arg'length > 0) then
      result            := to_01 (arg, 'X');
      result (arg'high) := '0';           -- set the sign bit to positive     
      return result;
    else
      return NAFP;
    end if;
  end function "abs";

  -- IEEE 754 "negative" function
  -- Synthisable
  function "-" (
    arg : UNRESOLVED_float)                        -- floating point input
    return UNRESOLVED_float is
    variable result : UNRESOLVED_float (arg'range);           -- result
  begin
    if (arg'length > 0) then
      result            := to_01 (arg, 'X');
      result (arg'high) := not result (arg'high);  -- invert sign bit
      return result;
    else
      return NAFP;
    end if;
  end function "-";
  
  function add (
    l, r                 : UNRESOLVED_float;       -- floating point input
    constant round_style : round_type := float_round_style;  -- rounding option
    constant guard       : NATURAL    := float_guard_bits;  -- number of guard bits
    constant check_error : BOOLEAN    := float_check_error;
    constant denormalize : BOOLEAN    := float_denormalize)
    return UNRESOLVED_float is
    constant fraction_width         : NATURAL := -minx(l'low, r'low);  -- length of FP output fraction
    constant exponent_width         : NATURAL := maximum(l'high, r'high);  -- length of FP output exponent
    variable r_real, l_real, result : REAL;                 -- Real versions
    variable lfptype, rfptype       : valid_fpstate;
    variable fpresult               : UNRESOLVED_float (exponent_width downto -fraction_width);
  begin
    if (fraction_width = 0 or l'length < 7 or r'length < 7) then
      lfptype := isx;
    else
      lfptype := classfp (l, check_error);
      rfptype := classfp (r, check_error);
    end if;
    if (lfptype = isx or rfptype = isx) then
      fpresult := (others => 'X');
    elsif (lfptype = nan or lfptype = quiet_nan or
           rfptype = nan or rfptype = quiet_nan) then
      -- Return quiet NAN, IEEE754-1985-7.1,1
      fpresult := qnanfp (fraction_width    => fraction_width,
                             exponent_width => exponent_width);
    elsif (lfptype = pos_inf and rfptype = neg_inf) or
      (lfptype = neg_inf and rfptype = pos_inf) then        -- +inf + -inf
      -- Return quiet NAN, IEEE754-1985-7.1,2
      fpresult := qnanfp (fraction_width    => fraction_width,
                             exponent_width => exponent_width);
    elsif (lfptype = pos_inf or rfptype = pos_inf) then     -- x + inf = inf
      fpresult := pos_inffp (fraction_width    => fraction_width,
                                exponent_width => exponent_width);
    elsif (lfptype = neg_inf or rfptype = neg_inf) then     -- x - inf = -inf
      fpresult := neg_inffp (fraction_width    => fraction_width,
                                exponent_width => exponent_width);
    else
      l_real := to_real (arg         => l,
                         round_style => round_style,
                         denormalize => denormalize);
      r_real := to_real (arg         => r,
                         round_style => round_style,
                         denormalize => denormalize);
      result := l_real + r_real;
      fpresult := to_float (arg            => result,
                            fraction_width => fraction_width,
                            exponent_width => exponent_width,
                            round_style    => round_style,
                            denormalize    => denormalize);
    end if;
    return fpresult;
  end function add;

  function subtract (
    l, r                 : UNRESOLVED_float;       -- floating point input
    constant round_style : round_type := float_round_style;  -- rounding option
    constant guard       : NATURAL    := float_guard_bits;  -- number of guard bits
    constant check_error : BOOLEAN    := float_check_error;
    constant denormalize : BOOLEAN    := float_denormalize)
    return UNRESOLVED_float is
    constant fraction_width         : NATURAL := -minx(l'low, r'low);  -- length of FP output fraction
    constant exponent_width         : NATURAL := maximum(l'high, r'high);  -- length of FP output exponent
    variable r_real, l_real, result : REAL;                 -- Real versions
    variable lfptype, rfptype       : valid_fpstate;
    variable fpresult               : UNRESOLVED_float (exponent_width downto -fraction_width);
  begin
    if (fraction_width = 0 or l'length < 7 or r'length < 7) then
      lfptype := isx;
    else
      lfptype := classfp (l, check_error);
      rfptype := classfp (r, check_error);
    end if;
    if (lfptype = isx or rfptype = isx) then
      fpresult := (others => 'X');
    elsif (lfptype = nan or lfptype = quiet_nan or
           rfptype = nan or rfptype = quiet_nan) then
      -- Return quiet NAN, IEEE754-1985-7.1,1
      fpresult := qnanfp (fraction_width    => fraction_width,
                             exponent_width => exponent_width);
    elsif (lfptype = pos_inf and rfptype = pos_inf) or
      (lfptype = neg_inf and rfptype = neg_inf) then        -- +inf - +inf
      -- Return quiet NAN, IEEE754-1985-7.1,2
      fpresult := qnanfp (fraction_width    => fraction_width,
                             exponent_width => exponent_width);
    elsif (lfptype = pos_inf or rfptype = neg_inf) then     -- x - inf = inf
      fpresult := pos_inffp (fraction_width    => fraction_width,
                                exponent_width => exponent_width);
    elsif (lfptype = neg_inf or rfptype = pos_inf) then     -- x - inf = -inf
      fpresult := neg_inffp (fraction_width    => fraction_width,
                                exponent_width => exponent_width);
    else
      l_real := to_real (arg         => l,
                         round_style => round_style,
                         denormalize => denormalize);
      r_real := to_real (arg         => r,
                         round_style => round_style,
                         denormalize => denormalize);
      result := l_real - r_real;
      fpresult := to_float (arg            => result,
                            fraction_width => fraction_width,
                            exponent_width => exponent_width,
                            round_style    => round_style,
                            denormalize    => denormalize);
    end if;
    return fpresult;
  end function subtract;

  function multiply (
    l, r                 : UNRESOLVED_float;       -- floating point input
    constant round_style : round_type := float_round_style;  -- rounding option
    constant guard       : NATURAL    := float_guard_bits;  -- number of guard bits
    constant check_error : BOOLEAN    := float_check_error;
    constant denormalize : BOOLEAN    := float_denormalize)
    return UNRESOLVED_float is
    constant fraction_width         : NATURAL := -minx(l'low, r'low);  -- length of FP output fraction
    constant exponent_width         : NATURAL := maximum(l'high, r'high);  -- length of FP output exponent
    variable r_real, l_real, result : REAL;                 -- Real versions
    variable lfptype, rfptype       : valid_fpstate;
    variable fpresult               : UNRESOLVED_float (exponent_width downto -fraction_width);
  begin
    if (fraction_width = 0 or l'length < 7 or r'length < 7) then
      lfptype := isx;
    else
      lfptype := classfp (l, check_error);
      rfptype := classfp (r, check_error);
    end if;
    if (lfptype = isx or rfptype = isx) then
      fpresult := (others => 'X');
    elsif (lfptype = nan or lfptype = quiet_nan or
           rfptype = nan or rfptype = quiet_nan) then
      -- Return quiet NAN, IEEE754-1985-7.1,1
      fpresult := qnanfp (fraction_width    => fraction_width,
                             exponent_width => exponent_width);
    elsif ((lfptype = pos_inf or lfptype = neg_inf) and
           (rfptype = pos_zero or rfptype = neg_zero)) or
      ((rfptype = pos_inf or rfptype = neg_inf) and
       (lfptype = pos_zero or lfptype = neg_zero)) then     -- 0 * inf
      -- Return quiet NAN, IEEE754-1985-7.1,3
      fpresult := qnanfp (fraction_width    => fraction_width,
                             exponent_width => exponent_width);
    elsif (lfptype = pos_inf or rfptype = pos_inf
           or lfptype = neg_inf or rfptype = neg_inf) then  -- x * inf = inf
      fpresult := pos_inffp (fraction_width    => fraction_width,
                                exponent_width => exponent_width);
      -- figure out the sign
      fpresult (exponent_width) := l(exponent_width) xor r(exponent_width);
    else
      l_real := to_real (arg         => l,
                         round_style => round_style,
                         denormalize => denormalize);
      r_real := to_real (arg         => r,
                         round_style => round_style,
                         denormalize => denormalize);
      result := l_real * r_real;
      fpresult := to_float (arg            => result,
                            fraction_width => fraction_width,
                            exponent_width => exponent_width,
                            round_style    => round_style,
                            denormalize    => denormalize);
    end if;
    return fpresult;
  end function multiply;

  function divide (
    l, r                 : UNRESOLVED_float;       -- floating point input
    constant round_style : round_type := float_round_style;  -- rounding option
    constant guard       : NATURAL    := float_guard_bits;
    constant check_error : BOOLEAN    := float_check_error;
    constant denormalize : BOOLEAN    := float_denormalize)
    return UNRESOLVED_float is
    constant fraction_width         : NATURAL := -minx(l'low, r'low);  -- length of FP output fraction
    constant exponent_width         : NATURAL := maximum(l'high, r'high);  -- length of FP output exponent
    variable r_real, l_real, result : REAL;                  -- Real versions
    variable lfptype, rfptype       : valid_fpstate;
    variable fpresult               : UNRESOLVED_float (exponent_width downto -fraction_width);
  begin
    if (fraction_width = 0 or l'length < 7 or r'length < 7) then
      lfptype := isx;
    else
      lfptype := classfp (l, check_error);
      rfptype := classfp (r, check_error);
    end if;
    classcase : case rfptype is
      when isx =>
        fpresult := (others => 'X');
      when nan | quiet_nan =>
        -- Return quiet NAN, IEEE754-1985-7.1,1
        fpresult := qnanfp (fraction_width      => fraction_width,
                                 exponent_width => exponent_width);
      when pos_inf | neg_inf =>
        if lfptype = pos_inf or lfptype = neg_inf            -- inf / inf
          or lfptype = quiet_nan or lfptype = nan then
          -- Return quiet NAN, IEEE754-1985-7.1,4
          fpresult := qnanfp (fraction_width        => fraction_width,
                                     exponent_width => exponent_width);
        else                            -- x / inf = 0
          fpresult := zerofp (fraction_width    => fraction_width,
                                 exponent_width => exponent_width);
        end if;
      when pos_zero | neg_zero =>
        if lfptype = pos_zero or lfptype = neg_zero          -- 0 / 0
          or lfptype = quiet_nan or lfptype = nan then
          -- Return quiet NAN, IEEE754-1985-7.1,4
          fpresult := qnanfp (fraction_width        => fraction_width,
                                     exponent_width => exponent_width);
        else
          report FLOAT_GENERIC_PKG'instance_name
            & " DIVIDE: Floating Point divide by zero"
            severity error;
          -- Infinity, define in 754-1985-7.2
          fpresult := pos_inffp (fraction_width        => fraction_width,
                                        exponent_width => exponent_width);
        end if;
      when others =>
        classcase2 : case lfptype is
          when isx =>
            fpresult := (others => 'X');
          when nan | quiet_nan =>
            -- Return quiet NAN, IEEE754-1985-7.1,1
            fpresult := qnanfp (fraction_width  => fraction_width,
                                 exponent_width => exponent_width);
          when pos_inf | neg_inf =>     -- inf / x = inf
            fpresult := pos_inffp (fraction_width  => fraction_width,
                                    exponent_width => exponent_width);
            fpresult(exponent_width) := l(exponent_width) xor r(exponent_width);
          when pos_zero | neg_zero =>   -- 0 / X = 0
            fpresult := zerofp (fraction_width      => fraction_width,
                                     exponent_width => exponent_width);
          when others =>
            l_real := to_real (arg         => l,
                               round_style => round_style,
                               denormalize => denormalize);
            r_real := to_real (arg         => r,
                               round_style => round_style,
                               denormalize => denormalize);
            result := l_real / r_real;
            fpresult := to_float (arg            => result,
                                  fraction_width => fraction_width,
                                  exponent_width => exponent_width,
                                  round_style    => round_style,
                                  denormalize    => denormalize);
        end case classcase2;
    end case classcase;
    return fpresult;
  end function divide;

  function dividebyp2 (
    l, r                 : UNRESOLVED_float;       -- floating point input
    constant round_style : round_type := float_round_style;  -- rounding option
    constant guard       : NATURAL    := float_guard_bits;  -- number of guard bits
    constant check_error : BOOLEAN    := float_check_error;
    constant denormalize : BOOLEAN    := float_denormalize)
    return UNRESOLVED_float is
    constant fraction_width         : NATURAL := -minx(l'low, r'low);  -- length of FP output fraction
    constant exponent_width         : NATURAL := maximum(l'high, r'high);  -- length of FP output exponent
    variable r_real, l_real, result : REAL;                 -- Real versions
    variable lfptype, rfptype       : valid_fpstate;
    variable urfract                : UNSIGNED (fraction_width-1 downto 0);  -- fract
    variable fpresult               : UNRESOLVED_float (exponent_width downto -fraction_width);
  begin
    if (fraction_width = 0 or l'length < 7 or r'length < 7) then
      lfptype := isx;
    else
      lfptype := classfp (l, check_error);
      rfptype := classfp (r, check_error);
    end if;
    classcase : case rfptype is
      when isx =>
        fpresult := (others => 'X');
      when nan | quiet_nan =>
        -- Return quiet NAN, IEEE754-1985-7.1,1
        fpresult := qnanfp (fraction_width      => fraction_width,
                                 exponent_width => exponent_width);
      when pos_zero | neg_zero =>
        if lfptype = pos_zero or lfptype = neg_zero then    -- 0 / 0
          -- Return quiet NAN, IEEE754-1985-7.1,4
          fpresult := qnanfp (fraction_width        => fraction_width,
                                     exponent_width => exponent_width);
        else
          report FLOAT_GENERIC_PKG'instance_name
            & " DIVIDEBYP2: Floating Point divide by zero"
            severity error;
          -- Infinity, define in 754-1985-7.2
          fpresult := pos_inffp (fraction_width  => fraction_width,
                                  exponent_width => exponent_width);
        end if;
      when pos_inf | neg_inf =>
        if lfptype = pos_inf or lfptype = neg_inf then      -- inf / inf
          -- Return quiet NAN, IEEE754-1985-7.1,4
          fpresult := qnanfp (fraction_width  => fraction_width,
                               exponent_width => exponent_width);
        else                            -- x / inf = 0
          fpresult := zerofp (fraction_width  => fraction_width,
                               exponent_width => exponent_width);
        end if;
      when others =>
        classcase2 : case lfptype is
          when isx =>
            fpresult := (others => 'X');
          when nan | quiet_nan =>
            -- Return quiet NAN, IEEE754-1985-7.1,1
            fpresult := qnanfp (fraction_width  => fraction_width,
                                 exponent_width => exponent_width);
          when pos_inf | neg_inf =>     -- inf / x = inf
            fpresult := pos_inffp (fraction_width  => fraction_width,
                                    exponent_width => exponent_width);
            fpresult(exponent_width) := l(exponent_width) xor r(exponent_width);
          when pos_zero | neg_zero =>   -- 0 / X = 0
            fpresult := zerofp (fraction_width  => fraction_width,
                                 exponent_width => exponent_width);
          when others =>
            l_real := to_real (arg         => l,
                               round_style => round_style,
                               denormalize => denormalize);
            r_real := to_real (arg         => r,
                               round_style => round_style,
                               denormalize => denormalize);
            -- right SIDE
            for i in -1 downto -fraction_width loop
              urfract (i+fraction_width) := r(i);
            end loop;
            assert (or (urfract (fraction_width-1 downto 0)) = '0')
               report FLOAT_GENERIC_PKG'instance_name
              & " DIVIDEBYP2: "
              & "Divideby2 called with a none power of two denominator"
              severity error;
            result := l_real / r_real;
            fpresult := to_float (arg            => result,
                                  fraction_width => fraction_width,
                                  exponent_width => exponent_width,
                                  round_style    => round_style,
                                  denormalize    => denormalize);
        end case classcase2;
    end case classcase;
    return fpresult;
  end function dividebyp2;

  function reciprocal (
    arg                  : UNRESOLVED_float;
    constant round_style : round_type := float_round_style;  -- rounding option
    constant guard       : NATURAL    := float_guard_bits;
    constant check_error : BOOLEAN    := float_check_error;
    constant denormalize : BOOLEAN    := float_denormalize)
    return UNRESOLVED_float is
    constant fraction_width   : NATURAL := -arg'low;  -- length of FP output fraction
    constant exponent_width   : NATURAL := arg'high;  -- length of FP output exponent
    variable result, arg_real : REAL;
    variable fpresult         : UNRESOLVED_float (arg'range);
    variable fptype           : valid_fpstate;
  begin
    fptype := Classfp(arg, check_error);
    classcase : case fptype is
      when isx =>
        fpresult := (others => 'X');
      when nan | quiet_nan =>
        -- Return quiet NAN, IEEE754-1985-7.1,1
        fpresult := qnanfp (fraction_width  => fraction_width,
                             exponent_width => exponent_width);   
      when pos_inf | neg_inf =>         -- 1/inf, return 0
        fpresult := zerofp (fraction_width  => fraction_width,
                             exponent_width => exponent_width);
      when neg_zero | pos_zero =>       -- 1/0
        report FLOAT_GENERIC_PKG'instance_name
          & " RECIPROCAL: Floating Point divide by zero"
          severity error;
        fpresult := pos_inffp (fraction_width  => fraction_width,
                                exponent_width => exponent_width);
      when others =>
        arg_real := to_real (arg         => arg,
                             round_style => round_style,
                             denormalize => denormalize);
        result := 1.0 / arg_real;
        fpresult := to_float (arg            => result,
                              fraction_width => fraction_width,
                              exponent_width => exponent_width,
                              round_style    => round_style,
                              denormalize    => denormalize);
    end case classcase;
    return fpresult;
  end function reciprocal;

  -- Multiply accumumlate  result = l*r + c
  function mac (
    l, r, c              : UNRESOLVED_float;       -- floating point input
    constant round_style : round_type := float_round_style;  -- rounding option
    constant guard       : NATURAL    := float_guard_bits;  -- number of guard bits
    constant check_error : BOOLEAN    := float_check_error;  -- check for errors
    constant denormalize : BOOLEAN    := float_denormalize)  -- Use IEEE extended FP
    return UNRESOLVED_float is
    constant fraction_width : NATURAL :=
      -minx (minx(l'low, r'low), c'low);  -- length of FP output fraction
    constant exponent_width : NATURAL :=
      maximum (maximum(l'high, r'high), c'high);  -- length of FP output exponent
    variable lfptype, rfptype, cfptype : valid_fpstate;
    variable fpresult                  : UNRESOLVED_float (exponent_width downto -fraction_width);
    variable r_real, l_real, c_real, result : REAL;
  begin  -- multiply
    if (fraction_width = 0 or l'length < 7 or r'length < 7 or c'length < 7) then
      lfptype := isx;
    else
      lfptype := classfp (l, check_error);
      rfptype := classfp (r, check_error);
      cfptype := classfp (c, check_error);
    end if;
    if (lfptype = isx or rfptype = isx or cfptype = isx) then
      fpresult := (others => 'X');
    elsif (lfptype = nan or lfptype = quiet_nan or
           rfptype = nan or rfptype = quiet_nan or
           cfptype = nan or cfptype = quiet_nan) then
      -- Return quiet NAN, IEEE754-1985-7.1,1
      fpresult := qnanfp (fraction_width => fraction_width,
                          exponent_width => exponent_width);
    elsif (((lfptype = pos_inf or lfptype = neg_inf) and
            (rfptype = pos_zero or rfptype = neg_zero)) or
           ((rfptype = pos_inf or rfptype = neg_inf) and
            (lfptype = pos_zero or lfptype = neg_zero))) then  -- 0 * inf
      -- Return quiet NAN, IEEE754-1985-7.1,3
      fpresult := qnanfp (fraction_width => fraction_width,
                          exponent_width => exponent_width);
    elsif (lfptype = pos_inf or rfptype = pos_inf
           or lfptype = neg_inf or rfptype = neg_inf  -- x * inf = inf
           or cfptype = neg_inf or cfptype = pos_inf) then  -- x + inf = inf
      fpresult := pos_inffp (fraction_width => fraction_width,
                             exponent_width => exponent_width);
      -- figure out the sign
      fpresult (exponent_width) := l(l'high) xor r(r'high);
    else
      l_real := to_real (l);
      r_real := to_real (r);
      c_real := to_real (c);
      result := (l_real * r_real) + c_real;
      fpresult := to_float (arg            => result,
                            fraction_width => fraction_width,
                            exponent_width => exponent_width,
                            round_style    => round_style,
                            denormalize    => denormalize);
    end if;
    return fpresult;
  end function mac;

  function remainder (
    l, r                 : UNRESOLVED_float;       -- floating point input
    constant round_style : round_type := float_round_style;  -- rounding option
    constant guard       : NATURAL    := float_guard_bits;  -- number of guard bits
    constant check_error : BOOLEAN    := float_check_error;
    constant denormalize : BOOLEAN    := float_denormalize)
    return UNRESOLVED_float is
    constant fraction_width         : NATURAL := -minx(l'low, r'low);  -- length of FP output fraction
    constant exponent_width         : NATURAL := maximum(l'high, r'high);  -- length of FP output exponent
    variable r_real, l_real, result : REAL;                 -- Real versions
    variable lfptype, rfptype       : valid_fpstate;
    variable fpresult               : UNRESOLVED_float (exponent_width downto -fraction_width);
  begin
    if (fraction_width = 0 or l'length < 7 or r'length < 7) then
      lfptype := isx;
    else
      lfptype := classfp (l, check_error);
      rfptype := classfp (r, check_error);
    end if;
    if (lfptype = isx or rfptype = isx) then
      fpresult := (others => 'X');
    elsif (lfptype = nan or lfptype = quiet_nan or
           rfptype = nan or rfptype = quiet_nan) then
      -- Return quiet NAN, IEEE754-1985-7.1,1
      fpresult := qnanfp (fraction_width  => fraction_width,
                           exponent_width => exponent_width);
    elsif (lfptype = pos_inf or lfptype = neg_inf) then     -- inf rem x
      -- Return quiet NAN, IEEE754-1985-7.1,5
      fpresult := qnanfp (fraction_width  => fraction_width,
                           exponent_width => exponent_width);
    elsif (rfptype = pos_zero or rfptype = neg_zero) then   -- x rem 0
      -- Return quiet NAN, IEEE754-1985-7.1,5
      fpresult := qnanfp (fraction_width  => fraction_width,
                           exponent_width => exponent_width);
    elsif (rfptype = pos_inf or rfptype = neg_inf) then     -- x rem inf = 0
      fpresult := zerofp (fraction_width  => fraction_width,
                           exponent_width => exponent_width);
    else
      l_real := to_real (arg          => l,
                          round_style => round_style,
                          denormalize => denormalize);
      r_real := to_real (arg          => r,
                          round_style => round_style,
                          denormalize => denormalize);
--      if (l(l'high) /= r(r'high)) then

--      end if;
      result := l_real - (trunc (l_real/r_real) * r_real);  -- These is no "rem"
                                                            -- in math_real
      fpresult := to_float (arg             => result,
                             fraction_width => fraction_width,
                             exponent_width => exponent_width,
                             round_style    => round_style,
                             denormalize    => denormalize);
    end if;
    return fpresult;
  end function remainder;
  
  function modulo (
    l, r                 : UNRESOLVED_float;       -- floating point input
    constant round_style : round_type := float_round_style;  -- rounding option
    constant guard       : NATURAL    := float_guard_bits;  -- number of guard bits
    constant check_error : BOOLEAN    := float_check_error;
    constant denormalize : BOOLEAN    := float_denormalize)
    return UNRESOLVED_float is
    constant fraction_width         : NATURAL := -minx(l'low, r'low);  -- length of FP output fraction
    constant exponent_width         : NATURAL := maximum(l'high, r'high);  -- length of FP output exponent
    variable r_real, l_real, result : REAL;                 -- Real versions
    variable lfptype, rfptype       : valid_fpstate;
    variable fpresult               : UNRESOLVED_float (exponent_width downto -fraction_width);
  begin
    if (fraction_width = 0 or l'length < 7 or r'length < 7) then
      lfptype := isx;
    else
      lfptype := classfp (l, check_error);
      rfptype := classfp (r, check_error);
    end if;
    if (lfptype = isx or rfptype = isx) then
      fpresult := (others => 'X');
    elsif (lfptype = nan or lfptype = quiet_nan or
           rfptype = nan or rfptype = quiet_nan) then
      -- Return quiet NAN, IEEE754-1985-7.1,1
      fpresult := qnanfp (fraction_width  => fraction_width,
                           exponent_width => exponent_width);
    elsif (lfptype = pos_inf or lfptype = neg_inf) then     -- inf rem x
      -- Return quiet NAN, IEEE754-1985-7.1,5
      fpresult := qnanfp (fraction_width  => fraction_width,
                           exponent_width => exponent_width);
    elsif (rfptype = pos_zero or rfptype = neg_zero) then   -- x rem 0
      -- Return quiet NAN, IEEE754-1985-7.1,5
      fpresult := qnanfp (fraction_width  => fraction_width,
                           exponent_width => exponent_width);
    elsif (rfptype = pos_inf or rfptype = neg_inf) then     -- x rem inf = 0
      fpresult := zerofp (fraction_width  => fraction_width,
                           exponent_width => exponent_width);
    else
      l_real := to_real (arg          => l,
                          round_style => round_style,
                          denormalize => denormalize);
      r_real := to_real (arg          => r,
                          round_style => round_style,
                          denormalize => denormalize);
      result := l_real mod r_real;
      fpresult := to_float (arg             => result,
                             fraction_width => fraction_width,
                             exponent_width => exponent_width,
                             round_style    => round_style,
                             denormalize    => denormalize);
    end if;
    return fpresult;
  end function modulo;

  function sqrt (
    arg                  : UNRESOLVED_float;        -- floating point input
    constant round_style : round_type := float_round_style;
    constant guard       : NATURAL    := float_guard_bits;
    constant check_error : BOOLEAN    := float_check_error;
    constant denormalize : BOOLEAN    := float_denormalize)
    return UNRESOLVED_float is
    constant fraction_width : NATURAL := guard-arg'low;  -- length of FP output fraction
    constant exponent_width : NATURAL := arg'high;  -- length of FP output exponent
    variable sign           : STD_ULOGIC;
    variable fpresult       : float (arg'range);
    variable fptype         : valid_fpstate;
    variable arg_real, result : REAL;                 -- Real versions
  begin  -- square root
    fptype := Classfp (arg, check_error);
    classcase : case fptype is
      when isx =>
        fpresult := (others => 'X');
      when nan | quiet_nan |
        -- Return quiet NAN, IEEE754-1985-7.1,1
        neg_normal | neg_denormal | neg_inf =>      -- sqrt (neg)
        -- Return quiet NAN, IEEE754-1985-7.1.6
        fpresult := qnanfp (fraction_width => fraction_width-guard,
                            exponent_width => exponent_width);
      when pos_inf =>                   -- Sqrt (inf), return infinity
        fpresult := pos_inffp (fraction_width => fraction_width-guard,
                               exponent_width => exponent_width);
      when pos_zero =>                  -- return 0
        fpresult := zerofp (fraction_width => fraction_width-guard,
                            exponent_width => exponent_width);
      when neg_zero =>                  -- IEEE754-1985-6.3 return -0
        fpresult := neg_zerofp (fraction_width => fraction_width-guard,
                                exponent_width => exponent_width);
      when others =>
         arg_real := to_real (arg);
         result := sqrt (arg_real);
      fpresult := to_float (arg             => result,
                             fraction_width => fraction_width,
                             exponent_width => exponent_width,
                             round_style    => round_style,
                             denormalize    => denormalize);
    end case;
    return fpresult;
  end function sqrt;
  
  function Is_Negative (arg : UNRESOLVED_float) return BOOLEAN is
  begin
    return (to_x01(arg(arg'high)) = '1');
  end function Is_Negative;

  -- compare functions
  -- =, /=, >=, <=, <, >
  
  function eq (
    l, r                 : UNRESOLVED_float;       -- floating point input
    constant check_error : BOOLEAN := float_check_error;
    constant denormalize : BOOLEAN := float_denormalize)
    return BOOLEAN is
    constant fraction_width         : NATURAL := -minx(l'low, r'low);  -- length of FP output fraction
    variable lfptype, rfptype       : valid_fpstate;
    variable is_equal, is_unordered : BOOLEAN;
  begin
    if (fraction_width = 0 or l'length < 7 or r'length < 7) then
      return false;
    else
      lfptype := classfp (l, check_error);
      rfptype := classfp (r, check_error);
    end if;
    if (lfptype = neg_zero or lfptype = pos_zero) and
      (rfptype = neg_zero or rfptype = pos_zero) then
      is_equal := true;
    else
      is_equal := to_real(arg         => l,
                          denormalize => denormalize) =
                  to_real(arg         => r,
                          denormalize => denormalize);
    end if;
    if (check_error) then
      is_unordered := Unordered (x => l,
                                 y => r);
    else
      is_unordered := false;
    end if;
    return is_equal and not is_unordered;
  end function eq;

  function lt (
    l, r                 : UNRESOLVED_float;       -- floating point input
    constant check_error : BOOLEAN := float_check_error;
    constant denormalize : BOOLEAN := float_denormalize)
    return BOOLEAN is
    constant fraction_width             : NATURAL := -minx(l'low, r'low);  -- length of FP output fraction
    variable r_real, l_real             : REAL;  -- real versions of inputs
    variable is_less_than, is_unordered : BOOLEAN;
  begin
    if (fraction_width = 0 or l'length < 7 or r'length < 7) then
      is_less_than := false;
    else
      l_real := to_real (arg         => l,
                         round_style => round_type'left,
                         denormalize => denormalize);
      r_real := to_real (arg         => r,
                         round_style => round_type'left,
                         denormalize => denormalize);
      is_less_than := l_real < r_real;
    end if;
    if check_error then
      is_unordered := Unordered (x => l,
                                 y => r);
    else
      is_unordered := false;
    end if;
    return is_less_than and not is_unordered;
  end function lt;

  function gt (
    l, r                 : UNRESOLVED_float;       -- floating point input
    constant check_error : BOOLEAN := float_check_error;
    constant denormalize : BOOLEAN := float_denormalize)
    return BOOLEAN is
    constant fraction_width                : NATURAL := -minx(l'low, r'low);  -- length of FP output fraction
    variable r_real, l_real                : REAL;  -- real versions of inputs
    variable is_greater_than, is_unordered : BOOLEAN;
  begin
    if (fraction_width = 0 or l'length < 7 or r'length < 7) then
      is_greater_than := false;
    else
      l_real := to_real (arg         => l,
                         round_style => round_type'left,
                         denormalize => denormalize);
      r_real := to_real (arg         => r,
                         round_style => round_type'left,
                         denormalize => denormalize);
      is_greater_than := l_real > r_real;
    end if;
    if check_error then
      is_unordered := Unordered (x => l,
                                 y => r);
    else
      is_unordered := false;
    end if;
    return is_greater_than and not is_unordered;
  end function gt;

  -- purpose: /= function
  function ne (                              -- not equal /=
    l, r                 : UNRESOLVED_float;
    constant check_error : BOOLEAN := float_check_error;
    constant denormalize : BOOLEAN := float_denormalize)
    return BOOLEAN is
    variable r_real, l_real         : REAL;  -- real versions of inputs
    variable is_equal, is_unordered : BOOLEAN;
  begin
    l_real := to_real (arg         => l,
                       round_style => round_type'left,
                       denormalize => denormalize);
    r_real := to_real (arg         => r,
                       round_style => round_type'left,
                       denormalize => denormalize);
    is_equal := l_real = r_real;
    if check_error then
      is_unordered := Unordered (x => l,
                                 y => r);
    else
      is_unordered := false;
    end if;
    return not (is_equal and not is_unordered);
  end function ne;

  -- purpose: >= function
  function ge (                                  -- greater than or equal to >=
    l, r                 : UNRESOLVED_float;
    constant check_error : BOOLEAN := float_check_error;
    constant denormalize : BOOLEAN := float_denormalize)
    return BOOLEAN is
    variable r_real, l_real             : REAL;  -- real versions of inputs
    variable is_less_than, is_unordered : BOOLEAN;
  begin
    l_real := to_real (arg         => l,
                       round_style => round_type'left,
                       denormalize => denormalize);
    r_real := to_real (arg         => r,
                       round_style => round_type'left,
                       denormalize => denormalize);
    is_less_than := l_real < r_real;
    if check_error then
      is_unordered := Unordered (x => l,
                                 y => r);
    else
      is_unordered := false;
    end if;
    return not is_less_than and not is_unordered;
  end function ge;

  -- purpose: >= function
  function le (                         -- greater than or equal to >=
    l, r                 : UNRESOLVED_float;
    constant check_error : BOOLEAN := float_check_error;
    constant denormalize : BOOLEAN := float_denormalize)
    return BOOLEAN is
    variable r_real, l_real                : REAL;  -- real versions of inputs
    variable is_greater_than, is_unordered : BOOLEAN;
  begin
    l_real := to_real (arg         => l,
                       round_style => round_type'left,
                       denormalize => denormalize);
    r_real := to_real (arg         => r,
                       round_style => round_type'left,
                       denormalize => denormalize);
    is_greater_than := l_real > r_real;
    if check_error then
      is_unordered := Unordered (x => l,
                                 y => r);
    else
      is_unordered := false;
    end if;
    return not is_greater_than and not is_unordered;
  end function le;

  -- These override the defaults for the compare operators.
  function "=" (l, r : UNRESOLVED_float) return BOOLEAN is
  begin
    return eq(l, r);
  end function "=";
  function "/=" (l, r : UNRESOLVED_float) return BOOLEAN is
  begin
    return ne(l, r);
  end function "/=";
  function ">=" (l, r : UNRESOLVED_float) return BOOLEAN is
  begin
    return ge(l, r);
  end function ">=";
  function "<=" (l, r : UNRESOLVED_float) return BOOLEAN is
  begin
    return le(l, r);
  end function "<=";
  function ">" (l, r : UNRESOLVED_float) return BOOLEAN is
  begin
    return gt(l, r);
  end function ">";
  function "<" (l, r : UNRESOLVED_float) return BOOLEAN is
  begin
    return lt(l, r);
  end function "<";

  function "?=" (L, R: UNRESOLVED_float) return std_ulogic is
    constant fraction_width         : NATURAL := -minx(l'low, r'low);  -- length of FP output fraction
    constant exponent_width         : NATURAL := maximum(l'high, r'high);  -- length of FP output exponent
    variable lfptype, rfptype       : valid_fpstate;
    variable is_equal, is_unordered : STD_ULOGIC;
    variable lresize, rresize       : UNRESOLVED_float (exponent_width downto -fraction_width);
  begin  -- ?=
    if (fraction_width = 0 or l'length < 7 or r'length < 7) then
      return 'X';
    else
      lfptype := classfp (l, float_check_error);
      rfptype := classfp (r, float_check_error);
    end if;
    if (lfptype = neg_zero or lfptype = pos_zero) and
      (rfptype = neg_zero or rfptype = pos_zero) then
      is_equal := '1';
    else
      lresize := resize (arg            => l,
                         exponent_width => exponent_width,
                         fraction_width => fraction_width,
                         denormalize_in => float_denormalize,
                         denormalize    => float_denormalize);
      rresize := resize (arg            => r,
                         exponent_width => exponent_width,
                         fraction_width => fraction_width,
                         denormalize_in => float_denormalize,
                         denormalize    => float_denormalize);
      is_equal := to_suv(lresize) ?= to_suv(rresize);
    end if;
    if (float_check_error) then
      if (lfptype = nan or lfptype = quiet_nan or
          rfptype = nan or rfptype = quiet_nan) then
        is_unordered := '1';
      else
        is_unordered := '0';
      end if;
    else
      is_unordered := '0';
    end if;
    return is_equal and not is_unordered;
  end function "?=";

  function "?/=" (L, R : UNRESOLVED_float) return STD_ULOGIC is
    constant fraction_width         : NATURAL := -minx(l'low, r'low);  -- length of FP output fraction
    constant exponent_width         : NATURAL := maximum(l'high, r'high);  -- length of FP output exponent
    variable lfptype, rfptype       : valid_fpstate;
    variable is_equal, is_unordered : STD_ULOGIC;
    variable lresize, rresize       : UNRESOLVED_float (exponent_width downto -fraction_width);
  begin  -- ?/=
    if (fraction_width = 0 or l'length < 7 or r'length < 7) then
      return 'X';
    else
      lfptype := classfp (l, float_check_error);
      rfptype := classfp (r, float_check_error);
    end if;
    if (lfptype = neg_zero or lfptype = pos_zero) and
      (rfptype = neg_zero or rfptype = pos_zero) then
      is_equal := '1';
    else
      lresize := resize (arg            => l,
                         exponent_width => exponent_width,
                         fraction_width => fraction_width,
                         denormalize_in => float_denormalize,
                         denormalize    => float_denormalize);
      rresize := resize (arg            => r,
                         exponent_width => exponent_width,
                         fraction_width => fraction_width,
                         denormalize_in => float_denormalize,
                         denormalize    => float_denormalize);
      is_equal := to_suv(lresize) ?= to_suv(rresize);
    end if;
    if (float_check_error) then
      if (lfptype = nan or lfptype = quiet_nan or
          rfptype = nan or rfptype = quiet_nan) then
        is_unordered := '1';
      else
        is_unordered := '0';
      end if;
    else
      is_unordered := '0';
    end if;
    return not (is_equal and not is_unordered);
  end function "?/=";

  function "?>" (L, R : UNRESOLVED_float) return std_ulogic is
    constant fraction_width         : NATURAL := -minx(l'low, r'low);
    variable founddash      : BOOLEAN := false;
  begin
    if (fraction_width = 0 or l'length < 7 or r'length < 7) then
      return 'X';
    else
      for i in L'range loop
        if L(i) = '-' then
          founddash := true;
        end if;
      end loop;
      for i in R'range loop
        if R(i) = '-' then
          founddash := true;
        end if;
      end loop;
      if founddash then
        report float_generic_pkg'instance_name
          & " ""?>"": '-' found in compare string"
          severity error;
        return 'X';
      elsif is_x(l) or is_x(r) then
        return 'X';
      elsif l > r then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function "?>";

  function "?>=" (L, R : UNRESOLVED_float) return std_ulogic is
    constant fraction_width : NATURAL := -minx(l'low, r'low);
    variable founddash      : BOOLEAN := false;
  begin
    if (fraction_width = 0 or l'length < 7 or r'length < 7) then
      return 'X';
    else
      for i in L'range loop
        if L(i) = '-' then
          founddash := true;
        end if;
      end loop;
      for i in R'range loop
        if R(i) = '-' then
          founddash := true;
        end if;
      end loop;
      if founddash then
        report float_generic_pkg'instance_name
          & " ""?>="": '-' found in compare string"
          severity error;
        return 'X';
      elsif is_x(l) or is_x(r) then
        return 'X';
      elsif l >= r then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function "?>=";

  function "?<" (L, R : UNRESOLVED_float) return std_ulogic is
    constant fraction_width : NATURAL := -minx(l'low, r'low);
    variable founddash      : BOOLEAN := false;
  begin
    if (fraction_width = 0 or l'length < 7 or r'length < 7) then
      return 'X';
    else
      for i in L'range loop
        if L(i) = '-' then
          founddash := true;
        end if;
      end loop;
      for i in R'range loop
        if R(i) = '-' then
          founddash := true;
        end if;
      end loop;
      if founddash then
        report float_generic_pkg'instance_name
          & " ""?<"": '-' found in compare string"
          severity error;
        return 'X';
      elsif is_x(l) or is_x(r) then
        return 'X';
      elsif l < r then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function "?<";

  function "?<=" (L, R : UNRESOLVED_float) return std_ulogic is
    constant fraction_width : NATURAL := -minx(l'low, r'low);
    variable founddash      : BOOLEAN := false;
  begin
    if (fraction_width = 0 or l'length < 7 or r'length < 7) then
      return 'X';
    else
      for i in L'range loop
        if L(i) = '-' then
          founddash := true;
        end if;
      end loop;
      for i in R'range loop
        if R(i) = '-' then
          founddash := true;
        end if;
      end loop;
      if founddash then
        report float_generic_pkg'instance_name
          & " ""?<="": '-' found in compare string"
          severity error;
        return 'X';
      elsif is_x(l) or is_x(r) then
        return 'X';
      elsif l <= r then
        return '1';
      else
        return '0';
      end if;
    end if;
  end function "?<=";

  function std_match (L, R : UNRESOLVED_float) return BOOLEAN is
  begin
    return std_match(to_slv(L), to_slv(R));
  end function std_match;

  function find_rightmost (arg : UNRESOLVED_float; y : STD_ULOGIC) return INTEGER is
  begin
    for_loop : for i in arg'reverse_range loop
      if arg(i) ?= y then
        return i;
      end if;
    end loop;
    return arg'high+1;                  -- return out of bounds 'high
  end function find_rightmost;

  function find_leftmost (arg : UNRESOLVED_float; y : STD_ULOGIC) return INTEGER is
  begin
    for_loop : for i in arg'range loop
      if arg(i) ?= y then
        return i;
      end if;
    end loop;
    return arg'low-1;                   -- return out of bounds 'low
  end function find_leftmost;

  -- purpose: maximum of two numbers (overrides default)
  function maximum (
    L, R : UNRESOLVED_float)
    return UNRESOLVED_float is
  begin
    if L > R then return L;
    else return R;
    end if;
  end function maximum;

  function minimum (
    L, R : UNRESOLVED_float)
    return UNRESOLVED_float is
  begin
    if L > R then return R;
    else return L;
    end if;
  end function minimum;

  -----------------------------------------------------------------------------
  -- conversion functions
  -----------------------------------------------------------------------------

  -- Convers a floating point number of one format into another format
  -- Synthesizable
  function resize (
    arg                     : UNRESOLVED_float;    -- Floating point input
    constant exponent_width : NATURAL    := float_exponent_width;  -- size of exponent
    constant fraction_width : NATURAL    := float_fraction_width;  -- size of fraction
    constant round_style    : round_type := float_round_style;  -- rounding type
    constant check_error    : BOOLEAN    := float_check_error;
    constant denormalize_in : BOOLEAN    := float_denormalize;
    constant denormalize    : BOOLEAN    := float_denormalize)
    return UNRESOLVED_float is
    variable result_real : REAL;        -- Real version of input
    variable fptype      : valid_fpstate;
    variable result      : UNRESOLVED_float (exponent_width downto -fraction_width);
                                        -- result value
  begin
    if arg'high = exponent_width
      and -arg'low = fraction_width then
      return arg;
    else
      fptype := Classfp(arg, check_error);
      classcase : case fptype is
        when isx =>
          result := (others => 'X');
        when nan =>
          result := nanfp (fraction_width    => fraction_width,
                            exponent_width => exponent_width);
        when quiet_nan =>
          result := qnanfp (fraction_width    => fraction_width,
                            exponent_width => exponent_width);
        when pos_inf =>
          result := pos_inffp (fraction_width    => fraction_width,
                               exponent_width => exponent_width);
        when neg_inf =>
          result := neg_inffp (fraction_width    => fraction_width,
                               exponent_width => exponent_width);
        when pos_zero | neg_zero =>
          result := zerofp (fraction_width  => fraction_width,    -- hate -0
                            exponent_width => exponent_width);
        when others =>
          result_real := to_real (arg         => arg,
                                  round_style => round_style,
                                  denormalize => denormalize);
          result := to_float (arg            => result_real,
                              fraction_width => fraction_width,
                              exponent_width => exponent_width,
                              round_style    => round_style,
                              denormalize    => denormalize);
      end case classcase;
      return result;
    end if;
  end function resize;

  function to_float32 (
    arg                     : UNRESOLVED_float;
    constant round_style    : round_type := float_round_style;  -- rounding option
    constant check_error    : BOOLEAN    := float_check_error;
    constant denormalize_in : BOOLEAN    := float_denormalize;  -- Use IEEE extended FP
    constant denormalize    : BOOLEAN    := float_denormalize)  -- Use IEEE extended FP
    return UNRESOLVED_float32 is
    variable arg_real : REAL;
  begin
    arg_real := to_real (arg);
    return to_float (arg => arg_real,
                     fraction_width => -float32'low,
                     exponent_width => float32'high,
                     round_style    => round_style,
                     denormalize    => denormalize);
  end function to_float32;

  function to_float64 (
    arg                     : UNRESOLVED_float;
    constant round_style    : round_type := float_round_style;  -- rounding option
    constant check_error    : BOOLEAN    := float_check_error;
    constant denormalize_in : BOOLEAN    := float_denormalize;  -- Use IEEE extended FP
    constant denormalize    : BOOLEAN    := float_denormalize)  -- Use IEEE extended FP
    return UNRESOLVED_float64 is
    variable arg_real : REAL;
  begin
    arg_real := to_real (arg);
    return to_float (arg => arg_real,
                     fraction_width => -float64'low,
                     exponent_width => float64'high,
                     round_style    => round_style,
                     denormalize    => denormalize);
  end function to_float64;

  function to_float128 (
    arg                     : UNRESOLVED_float;
    constant round_style    : round_type := float_round_style;  -- rounding option
    constant check_error    : BOOLEAN    := float_check_error;
    constant denormalize_in : BOOLEAN    := float_denormalize;  -- Use IEEE extended FP
    constant denormalize    : BOOLEAN    := float_denormalize)  -- Use IEEE extended FP
    return UNRESOLVED_float128 is
    variable arg_real : REAL;
  begin
    arg_real := to_real (arg);
    return to_float (arg => arg_real,
                     fraction_width => -float128'low,
                     exponent_width => float128'high,
                     round_style    => round_style,
                     denormalize    => denormalize);
  end function to_float128;

  -- to_float - Real number
  -- Not Synthisable (unless the input is a constant)
  function to_float (
    arg                     : REAL;
    constant exponent_width : NATURAL    := float_exponent_width;  -- length of FP output exponent
    constant fraction_width : NATURAL    := float_fraction_width;  -- length of FP output fraction
    constant round_style    : round_type := float_round_style;  -- rounding option
    constant denormalize    : BOOLEAN    := float_denormalize)
    return UNRESOLVED_float is
    variable result     : UNRESOLVED_float (exponent_width downto -fraction_width);
    variable arg_real   : REAL;         -- Real version of argument
    variable validfp    : boundary_type;          -- Check for valid results
    variable exp        : INTEGER;      -- Integer version of exponent
    variable exp_real   : REAL;         -- real version of exponent
    variable expon      : UNSIGNED (exponent_width - 1 downto 0);
                                        -- Unsigned version of exp.
    constant expon_base : INTEGER := 2**(exponent_width-1) -1;  -- exponent offset
    variable fract      : UNSIGNED (fraction_width-1 downto 0);
    variable frac       : REAL;         -- Real version of fraction
    constant roundfrac  : REAL    := 2.0 ** (-2 - fract'high);  -- used for rounding
    variable round      : BOOLEAN;      -- to round or not to round
  begin
    result   := (others => '0');
    arg_real := arg;
    if arg_real < 0.0 then
      result (exponent_width) := '1';
      arg_real                := 0.0 - arg_real;  -- Make it positive.
    else
      result (exponent_width) := '0';
    end if;
    validfp := test_boundary (arg            => arg_real,
                              fraction_width => fraction_width,
                              exponent_width => exponent_width,
                              denormalize    => denormalize);
    if validfp = zero then
      return result;                    -- Result initialized to "0".
    elsif validfp = infinity then
      result (exponent_width - 1 downto 0) := (others => '1');  -- Exponent all "1"
                                        -- return infinity.
      return result;
    else
      if validfp = denormal then        -- Exponent will default to "0".
        expon := (others => '0');
        frac  := arg_real * (2.0 ** (expon_base-1));
      else                              -- Number less than 1. "normal" number
        exp_real                := log2 (arg_real);
        exp                     := INTEGER (floor(exp_real));  -- positive fraction.
        expon                   := UNSIGNED (to_signed (exp-1, exponent_width));
        expon(exponent_width-1) := not expon(exponent_width-1);
        frac                    := (arg_real / 2.0 ** exp) - 1.0;  -- Number less than 1.
      end if;
      for i in 0 to fract'high loop
        if frac >= 2.0 ** (-1 - i) then
          fract (fract'high - i) := '1';
          frac                   := frac - 2.0 ** (-1 - i);
        else
          fract (fract'high - i) := '0';
        end if;
      end loop;
      round := false;
      case round_style is
        when round_nearest =>
          if frac > roundfrac or ((frac = roundfrac) and fract(0) = '1') then
            round := true;
          end if;
        when round_inf =>
          if frac /= 0.0 and result(exponent_width) = '0' then
            round := true;
          end if;
        when round_neginf =>
          if frac /= 0.0 and result(exponent_width) = '1' then
            round := true;
          end if;
        when round_zero =>
          null;                         -- don't round
      end case;
      if (round) then
        if and(fract) = '1' then          -- fraction is all "1"
          expon := expon + 1;
          fract := (others => '0');
        else
          fract := fract + 1;
        end if;
      end if;
      result (exponent_width-1 downto 0) := UNRESOLVED_float(expon);
      result (-1 downto -fraction_width) := UNRESOLVED_float(fract);
      return result;
    end if;
  end function to_float;

  -- to_float - Integer Version
  function to_float (
    arg                     : INTEGER;
    constant exponent_width : NATURAL    := float_exponent_width;  -- length of FP output exponent
    constant fraction_width : NATURAL    := float_fraction_width;  -- length of FP output fraction
    constant round_style    : round_type := float_round_style)  -- rounding option
    return UNRESOLVED_float is
    variable arg_real : REAL;           -- Real version of argument
  begin
    arg_real := REAL (arg);
    return to_float (arg            => arg_real,
                     fraction_width => fraction_width,
                     exponent_width => exponent_width,
                     round_style    => round_style);
  end function to_float;

  -- to_float - unsigned version
  function to_float (
    arg                     : UNRESOLVED_UNSIGNED;
    constant exponent_width : NATURAL    := float_exponent_width;  -- length of FP output exponent
    constant fraction_width : NATURAL    := float_fraction_width;  -- length of FP output fraction
    constant round_style    : round_type := float_round_style)  -- rounding option
    return UNRESOLVED_float is
    variable result   : UNRESOLVED_float (exponent_width downto -fraction_width);
    constant ARG_LEFT : INTEGER := ARG'length-1;
    alias XARG        : UNSIGNED(ARG_LEFT downto 0) is ARG;
    variable arg_real : REAL;           -- Real version of argument
    variable arg_int  : UNSIGNED(xarg'range);  -- Real version of argument
  begin
    arg_int := to_01 (xarg, 'X');
    if (arg_int(0) = 'X') then
      result := (others => 'X');
    else
      arg_real := to_real (arg_int);
      result := to_float (arg            => arg_real,
                          fraction_width => fraction_width,
                          exponent_width => exponent_width,
                          round_style    => round_style);
    end if;
    return result;
  end function to_float;

  -- to_float - signed version
  function to_float (
    arg                     : UNRESOLVED_SIGNED;
    constant exponent_width : NATURAL    := float_exponent_width;  -- length of FP output exponent
    constant fraction_width : NATURAL    := float_fraction_width;  -- length of FP output fraction
    constant round_style    : round_type := float_round_style)  -- rounding option
    return UNRESOLVED_float is
    variable arg_real : REAL;           -- Real version of argument
    constant ARG_LEFT : INTEGER := ARG'length-1;
    alias XARG        : SIGNED(ARG_LEFT downto 0) is ARG;
    variable result   : UNRESOLVED_float (exponent_width downto -fraction_width);
    variable argx     : SIGNED (xarg'range);
  begin
    argx := to_01 (xarg, 'X');
    if (argx(0) = 'X') then
      result := (others => 'X');
    else
      arg_real := to_real (argx);
      result := to_float (arg            => arg_real,
                          fraction_width => fraction_width,
                          exponent_width => exponent_width,
                          round_style    => round_style);
    end if;
    return result;
  end function to_float;

  -- purpose: converts a ufixed to a floating point
  function to_float (
    arg                     : UNRESOLVED_ufixed;   -- unsigned fixed point input
    constant exponent_width : NATURAL    := float_exponent_width;  -- width of exponent
    constant fraction_width : NATURAL    := float_fraction_width;  -- width of fraction
    constant round_style    : round_type := float_round_style;     -- rounding
    constant denormalize    : BOOLEAN    := float_denormalize)
    return UNRESOLVED_float is
    variable result   : UNRESOLVED_float (exponent_width downto -fraction_width);
    variable arg_real : REAL;           -- real version of argument
  begin  -- function to_float
    if (or (to_slv(arg)) = 'X') then
      result := (others => 'X');
    elsif (arg = 0) then
      result := (others => '0');        -- return zero
    else
      arg_real := to_real (arg);
      result := to_float (arg            => arg_real,
                          fraction_width => fraction_width,
                          exponent_width => exponent_width,
                          denormalize    => denormalize,
                          round_style    => round_style);
    end if;
    return result;
  end function to_float;

  function to_float (
    arg                     : UNRESOLVED_sfixed;
    constant exponent_width : NATURAL    := float_exponent_width;  -- length of FP output exponent
    constant fraction_width : NATURAL    := float_fraction_width;  -- length of FP output fraction
    constant round_style    : round_type := float_round_style;  -- rounding option
    constant denormalize    : BOOLEAN    := float_denormalize)
    return UNRESOLVED_float is
    variable result   : UNRESOLVED_float (exponent_width downto -fraction_width);
    variable arg_real : REAL;           -- real version of argument
  begin
    if (or (to_slv(arg)) = 'X') then
      result := (others => 'X');
    elsif (arg = 0) then
      result := (others => '0');
    else
      arg_real := to_real (arg);
      result := to_float (arg            => arg_real,
                          fraction_width => fraction_width,
                          exponent_width => exponent_width,
                          denormalize    => denormalize,
                          round_style    => round_style);      
    end if;
    return result;
  end function to_float;

  -- size_res functions
  -- Convers a floating point number of one format into another format
  -- Synthesizable
  function resize (
    arg                     : UNRESOLVED_float;    -- Floating point input
    size_res                : UNRESOLVED_float;
    constant round_style    : round_type := float_round_style;  -- rounding type
    constant check_error    : BOOLEAN    := float_check_error;
    constant denormalize_in : BOOLEAN    := float_denormalize;
    constant denormalize    : BOOLEAN    := float_denormalize)
    return UNRESOLVED_float is
    variable result_real    : REAL;     -- Real version of input
    variable fptype         : valid_fpstate;
    constant fraction_width : NATURAL := -size_res'low;
    constant exponent_width : NATURAL := size_res'high;
    variable result         : UNRESOLVED_float (exponent_width downto -fraction_width);
                                        -- result value
  begin
    fptype := Classfp(arg, check_error);
    classcase : case fptype is
      when isx =>
        result := (others => 'X');
      when nan | quiet_nan =>
        result := qnanfp (fraction_width    => fraction_width,
                             exponent_width => exponent_width);
      when pos_inf =>
        result := pos_inffp (fraction_width   => fraction_width,
                               exponent_width => exponent_width);
      when neg_inf =>
        result := neg_inffp (fraction_width    => fraction_width,
                                exponent_width => exponent_width);
      when pos_zero | neg_zero =>
        result := zerofp (fraction_width  => fraction_width,    -- hate -0
                           exponent_width => exponent_width);
      when others =>
        result_real := to_real (arg         => arg,
                                round_style => round_style,
                                denormalize => denormalize);
        result := to_float (arg            => result_real,
                            fraction_width => fraction_width,
                            exponent_width => exponent_width,
                            round_style    => round_style,
                            denormalize    => denormalize);
    end case classcase;
    return result;
  end function resize;

  -- to_float - Real number
  -- Not Synthisable (unless the input is a constant)
  function to_float (
    arg                  : REAL;
    size_res             : UNRESOLVED_float;
    constant round_style : round_type := float_round_style;  -- rounding option
    constant denormalize : BOOLEAN    := float_denormalize)
    return UNRESOLVED_float is
    constant fraction_width : NATURAL := -size_res'low;  -- length of FP output fraction
    constant exponent_width : NATURAL := size_res'high;  -- length of FP output exponent
    variable result         : UNRESOLVED_float (exponent_width downto -fraction_width);
                                        -- result value
    variable arg_real       : REAL;     -- Real version of argument
    variable validfp        : boundary_type;  -- Check for valid results
    variable exp            : INTEGER;  -- Integer version of exponent
    variable exp_real       : REAL;     -- real version of exponent
    variable expon          : UNSIGNED (exponent_width - 1 downto 0);
                                        -- Unsigned version of exp.
    constant expon_base     : INTEGER := 2**(exponent_width-1) -1;  -- exponent offset
    variable fract          : UNSIGNED (fraction_width-1 downto 0);
    variable frac           : REAL;     -- Real version of fraction
    constant roundfrac      : REAL    := 2.0 ** (-2 - fract'high);  -- used for rounding
  begin
    result   := (others => '0');
    arg_real := arg;
    if arg_real < 0.0 then
      result (exponent_width) := '1';
      arg_real                := 0.0 - arg_real;         -- Make it positive.
    else
      result (exponent_width) := '0';
    end if;
    validfp := test_boundary (arg            => arg_real,
                              fraction_width => fraction_width,
                              exponent_width => exponent_width,
                              denormalize    => denormalize);
    if validfp = zero then
      return result;                    -- Result initialized to "0".
    elsif validfp = infinity then
      result (exponent_width - 1 downto 0) := (others => '1');  -- Exponent all "1"
                                        -- return infinity.
      return result;
    else
      if validfp = denormal then        -- Exponent will default to "0".
        expon := (others => '0');
        frac  := arg_real * (2.0 ** (expon_base-1));
      else                              -- Number less than 1. "normal" number
        exp_real                := log2 (arg_real);
        exp                     := INTEGER (floor(exp_real));  -- positive fraction.
        expon                   := UNSIGNED (to_signed (exp-1, exponent_width));
        expon(exponent_width-1) := not expon(exponent_width-1);
        frac                    := (arg_real / 2.0 ** exp) - 1.0;  -- Number less than 1.
      end if;
      for i in 0 to fract'high loop
        if frac >= 2.0 ** (-1 - i) then
          fract (fract'high - i) := '1';
          frac                   := frac - 2.0 ** (-1 - i);
        else
          fract (fract'high - i) := '0';
        end if;
      end loop;
      -- Performs a "round Nearest" if selected, otherwise a
      -- round -inifinity.  Round infinity, and 0 are not
      -- implemented in the conversion routines.
      if round_style = round_nearest then
        if frac > roundfrac then
          if and(fract) = '1' then    -- exponent is all "1"
            expon := expon + 1;
            fract := (others => '0');
          else
            fract := fract + 1;
          end if;
        elsif frac = roundfrac then
          -- Round nearest, set bottom bit to "0".  IEEE 754-1985 - 4.1
          if fract (0) = '1' then
            fract := fract + 1;
          end if;
        end if;
      end if;
      result (exponent_width-1 downto 0) := UNRESOLVED_float(expon);
      result (-1 downto -fraction_width) := UNRESOLVED_float(fract);
      return result;
    end if;
  end function to_float;

  -- to_float - Integer Version
  function to_float (
    arg                  : INTEGER;
    size_res             : UNRESOLVED_float;
    constant round_style : round_type := float_round_style)  -- rounding option
    return float is
    constant fraction_width : NATURAL := -size_res'low;  -- length of FP output fraction
    constant exponent_width : NATURAL := size_res'high;  -- length of FP output exponent
    variable arg_real       : REAL;     -- Real version of argument
  begin
    arg_real := REAL (arg);
    return to_float (arg            => arg_real,
                     fraction_width => fraction_width,
                     exponent_width => exponent_width,
                     round_style    => round_style);
  end function to_float;

  -- to_float - unsigned version
  function to_float (
    arg                  : UNRESOLVED_UNSIGNED;
    size_res             : UNRESOLVED_float;
    constant round_style : round_type := float_round_style)  -- rounding option
    return UNRESOLVED_float is
    constant fraction_width : NATURAL := -size_res'low;  -- length of FP output fraction
    constant exponent_width : NATURAL := size_res'high;  -- length of FP output exponent
    variable result         : UNRESOLVED_float (exponent_width downto -fraction_width);
    constant ARG_LEFT       : INTEGER := ARG'length-1;
    alias XARG              : UNSIGNED(ARG_LEFT downto 0) is ARG;
    variable arg_real       : REAL;     -- Real version of argument
    variable arg_int        : UNSIGNED(xarg'range);  -- Real version of argument
  begin
    arg_int := to_01 (xarg, 'X');
    if (arg_int(0) = 'X') then
      result := (others => 'X');
    else
      arg_real := to_real (arg_int);
      result := to_float (arg            => arg_real,
                          fraction_width => fraction_width,
                          exponent_width => exponent_width,
                          round_style    => round_style);
    end if;
    return result;
  end function to_float;

  -- to_float - signed version
  function to_float (
    arg                  : UNRESOLVED_SIGNED;
    size_res             : UNRESOLVED_float;
    constant round_style : round_type := float_round_style)  -- rounding option
    return UNRESOLVED_float is
    variable arg_real       : REAL;     -- Real version of argument
    constant fraction_width : NATURAL := -size_res'low;  -- length of FP output fraction
    constant exponent_width : NATURAL := size_res'high;  -- length of FP output exponent
    constant ARG_LEFT       : INTEGER := ARG'length-1;
    alias XARG              : SIGNED(ARG_LEFT downto 0) is ARG;
    variable result         : UNRESOLVED_float (exponent_width downto -fraction_width);
    variable argx           : SIGNED (xarg'range);
  begin
    argx := to_01 (xarg, 'X');
    if (argx(0) = 'X') then
      result := (others => 'X');
    else
      arg_real := to_real (argx);
      result := to_float (arg            => arg_real,
                          fraction_width => fraction_width,
                          exponent_width => exponent_width,
                          round_style    => round_style);
    end if;
    return result;
  end function to_float;

  -- std_ulogic_vector to float
  function to_float (
    arg                     : STD_ULOGIC_VECTOR;
    constant exponent_width : NATURAL := float_exponent_width;  -- length of FP output exponent
    constant fraction_width : NATURAL := float_fraction_width)  -- length of FP output fraction
    return UNRESOLVED_float is
  begin
    return to_float (arg => to_stdlogicvector(arg),
                     exponent_width => exponent_width,
                     fraction_width => fraction_width);
  end function to_float;

  -- std_ulogic_vector to float
  function to_float (
    arg      : STD_ULOGIC_VECTOR;
    size_res : UNRESOLVED_float)
    return UNRESOLVED_float is
    variable result : UNRESOLVED_float (size_res'left downto size_res'right);
  begin
    if (result'length < 1) then
      return result;
    else
      result := to_float (arg            => to_stdlogicvector(arg),
                          exponent_width => size_res'high,
                          fraction_width => -size_res'low);
      return result;
    end if;
  end function to_float;

  -- purpose: converts a ufixed to a floating point
  function to_float (
    arg                  : UNRESOLVED_ufixed;      -- unsigned fixed point input
    size_res             : UNRESOLVED_float;
    constant round_style : round_type := float_round_style;  -- rounding
    constant denormalize : BOOLEAN    := float_denormalize)  -- use ieee extentions
    return UNRESOLVED_float is
    constant fraction_width : NATURAL := -size_res'low;  -- length of FP output fraction
    constant exponent_width : NATURAL := size_res'high;  -- length of FP output exponent
    variable result         : UNRESOLVED_float (exponent_width downto -fraction_width);
    variable arg_real       : REAL;     -- real version of argument
  begin  -- function to_float
    if (or (to_slv(arg)) = 'X') then
      result := (others => 'X');
    elsif (arg = 0) then
      result := (others => '0');        -- return pos_zero
    else
      arg_real := to_real (arg);
      result := to_float (arg            => arg_real,
                          fraction_width => fraction_width,
                          exponent_width => exponent_width,
                          denormalize    => denormalize,
                          round_style    => round_style);
    end if;
    return result;
  end function to_float;

  function to_float (
    arg                  : UNRESOLVED_sfixed;
    size_res             : UNRESOLVED_float;
    constant round_style : round_type := float_round_style;  -- rounding option
    constant denormalize : BOOLEAN    := float_denormalize)
    return UNRESOLVED_float is
    constant fraction_width : NATURAL := -size_res'low;  -- length of FP output fraction
    constant exponent_width : NATURAL := size_res'high;  -- length of FP output exponent
    variable result         : UNRESOLVED_float (exponent_width downto -fraction_width);
    variable arg_real       : REAL;     -- real version of argument
  begin
    if (or (to_slv(arg)) = 'X') then
      result := (others => 'X');
    elsif (arg = 0) then
      result := (others => '0');
    else                                -- Normal number (can't be denormal)
      arg_real := to_real (arg);
      result := to_float (arg            => arg_real,
                          fraction_width => fraction_width,
                          exponent_width => exponent_width,
                          denormalize    => denormalize,
                          round_style    => round_style);      
    end if;
    return result;
  end function to_float;

  -- fp_to_integer - Floating point to integer
  -- Synthesizable
  function to_integer (
    arg                  : UNRESOLVED_float;       -- floating point input
    constant check_error : BOOLEAN    := float_check_error;
    constant round_style : round_type := float_round_style)  -- rounding option
    return INTEGER is
    variable validfp     : valid_fpstate;        -- Valid FP state
    variable result_real : REAL;        -- real output
  begin
    validfp := Classfp (arg, check_error);
    -- IEEE extended floating point is false because it is not possible
    -- with an integer output.
    classcase : case validfp is
      when isx | pos_zero | neg_zero | nan | quiet_nan | pos_denormal | neg_denormal =>
        return 0;
      when neg_inf =>
        return INTEGER'low;             -- negative infinity
      when pos_inf =>
        return INTEGER'high;            -- Positive infinity
      when others =>
        result_real := to_real (arg);
        case round_style is
          when round_nearest =>
            result_real := round (result_real);  -- problems around 0.5
          when round_inf =>
            result_real := ceil (result_real);
          when round_neginf =>
            result_real := floor (result_real);
          when others =>
            result_real := trunc (result_real);
        end case;
        return INTEGER (result_real);
    end case classcase;
  end function to_integer;

  -- fp_to_unsigned - floating point to unsigned number
  function to_unsigned (
    arg                  : UNRESOLVED_float;       -- floating point input
    constant size        : NATURAL;     -- length of output
    constant check_error : BOOLEAN    := float_check_error;
    constant round_style : round_type := float_round_style)  -- rounding option
    return UNRESOLVED_UNSIGNED is
    variable validfp     : valid_fpstate;        -- Valid FP state
    variable result      : UNSIGNED (size - 1 downto 0) := (others => '0');
    variable result_real : REAL;        -- real output
  begin
    validfp := Classfp (arg, check_error);
    classcase : case validfp is
      when isx | nan | quiet_nan =>
        result := (others => 'X');
      when pos_zero | neg_inf | neg_zero | neg_normal | pos_denormal | neg_denormal =>
        result := (others => '0');      -- return 0
      when pos_inf =>
        result := (others => '1');
      when others =>
        result_real := to_real (arg);
        if result_real >= 2.0**(size) then      -- return infinity
          result := (others => '1');
        else
          if round_style = round_nearest then
            result_real := round (result_real);  -- problems around 0.5
          else
            result_real := floor (result_real);
          end if;
          result := to_unsigned (INTEGER (result_real), size);
        end if;
    end case classcase;
    return (result);
  end function to_unsigned;

  function to_unsigned (
    arg                  : UNRESOLVED_float;       -- floating point input
    size_res             : UNRESOLVED_UNSIGNED;
    constant check_error : BOOLEAN    := float_check_error;
    constant round_style : round_type := float_round_style)  -- rounding option
    return UNRESOLVED_UNSIGNED is
    constant size        : NATURAL                      := size_res'length;
  begin
    return to_unsigned ( arg => arg,
                         size => size,
                         check_error => check_error,
                         round_style => round_style);
  end function to_unsigned;

  -- fp_to_signed - floating point to signed number
  -- Synthesizable
  function to_signed (
    arg                  : UNRESOLVED_float;       -- floating point input
    constant size        : NATURAL;     -- length of output
    constant check_error : BOOLEAN    := float_check_error;
    constant round_style : round_type := float_round_style)  -- rounding option
    return UNRESOLVED_SIGNED is
    variable validfp     : valid_fpstate;        -- Valid FP state
    variable result      : SIGNED (size - 1 downto 0) := (others => '0');
    variable result_real : REAL;        -- real output
  begin
    validfp := Classfp (arg, check_error);
    classcase : case validfp is
      when isx | nan | quiet_nan =>
        result := (others => 'X');
      when pos_zero | neg_zero | pos_denormal | neg_denormal =>
        result := (others => '0');
      when neg_inf =>
        result (size - 1) := '1';       -- return smallest negative number
      when pos_inf =>
        result            := (others => '1');    -- return largest number
        result (size - 1) := '0';
      when others =>
        result_real := to_real (arg);
        if result_real >= 2.0**(size-1) then
          result            := (others => '1');  -- return largest number
          result (size - 1) := '0';
        elsif result_real < -2.0**(size-1) then
          result            := (others => '0');  -- return most negative number
          result (size - 1) := '1';
        else
          if round_style = round_nearest then
            result_real := round (result_real);  -- problems around 0.5
          else
            result_real := floor (result_real);
          end if;
          result := to_signed (INTEGER (result_real), size);
        end if;
    end case classcase;
    return result;
  end function to_signed;

  -- fp_to_signed - floating point to signed number
  -- Synthesizable
  function to_signed (
    arg                  : UNRESOLVED_float;       -- floating point input
    size_res             : UNRESOLVED_SIGNED;
    constant check_error : BOOLEAN    := float_check_error;
    constant round_style : round_type := float_round_style)  -- rounding option
    return UNRESOLVED_SIGNED is
    constant size        : NATURAL                    := size_res'length;
  begin
    return to_signed ( arg => arg,
                       size => size,
                       check_error => check_error,
                       round_style => round_style);
  end function to_signed;

  -- purpose: Converts a float to ufixed
  function to_ufixed (
    arg                     : UNRESOLVED_float;    -- fp input
    constant left_index     : INTEGER;  -- integer part
    constant right_index    : INTEGER;  -- fraction part
    constant round_style    : fixed_round_style_type := fixed_round_style;      -- rounding
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;   -- saturate
    constant check_error    : BOOLEAN := float_check_error;
    constant denormalize    : BOOLEAN := float_denormalize)
    return UNRESOLVED_ufixed is
    variable validfp  : valid_fpstate;  -- Valid FP state
    variable arg_real : REAL;           -- Real version of input
    variable result   : UNRESOLVED_ufixed (left_index downto right_index);  -- result
  begin  -- function to_ufixed
    validfp := Classfp (arg, check_error);
    classcase : case validfp is
      when isx | nan | quiet_nan =>
        result := (others => 'X');
      when pos_zero | neg_inf | neg_zero | neg_normal | neg_denormal =>
        result := (others => '0');      -- return 0
      when pos_inf =>
        result := (others => '1');      -- always saturate
      when others =>
        -- Figure out the fraction
        arg_real := to_real (arg         => arg,
                             denormalize => denormalize);
        result := to_ufixed (arg            => arg_real,
                             left_index     => left_index,
                             right_index    => right_index,
                             round_style    => round_style,
                             overflow_style => overflow_style);
    end case classcase;
    return result;
  end function to_ufixed;

  -- purpose: Converts a float to ufixed
  function to_ufixed (
    arg                     : UNRESOLVED_float;    -- fp input
    size_res                : UNRESOLVED_ufixed;
    constant round_style    : fixed_round_style_type := fixed_round_style;         -- rounding
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;      -- saturate
    constant check_error    : BOOLEAN := float_check_error;
    constant denormalize    : BOOLEAN := float_denormalize)
    return UNRESOLVED_ufixed is
    variable validfp     : valid_fpstate;  -- Valid FP state
    variable arg_real    : REAL;        -- Real version of input
    constant left_index  : INTEGER := size_res'high;
    constant right_index : INTEGER := size_res'low;
    variable result      : UNRESOLVED_ufixed (left_index downto right_index);  -- result
  begin  -- function to_ufixed
    validfp := Classfp (arg, check_error);
    classcase : case validfp is
      when isx | nan | quiet_nan =>
        result := (others => 'X');
      when pos_zero | neg_inf | neg_zero | neg_normal | neg_denormal =>
        result := (others => '0');      -- return 0
      when pos_inf =>
        result := (others => '1');      -- always saturate
      when others =>
        -- Figure out the fraction
        arg_real := to_real (arg         => arg,
                             denormalize => denormalize);
        result := to_ufixed (arg            => arg_real,
                             left_index     => left_index,
                             right_index    => right_index,
                             round_style    => round_style,
                             overflow_style => overflow_style);
    end case classcase;
    return result;
  end function to_ufixed;

  -- purpose: Converts a float to sfixed
  function to_sfixed (
    arg                     : UNRESOLVED_float;    -- fp input
    constant left_index     : INTEGER;  -- integer part
    constant right_index    : INTEGER;  -- fraction part
    constant round_style    : fixed_round_style_type := fixed_round_style;     -- rounding
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;  -- saturate
    constant check_error    : BOOLEAN := float_check_error;
    constant denormalize    : BOOLEAN := float_denormalize)
    return UNRESOLVED_sfixed is
    variable validfp  : valid_fpstate;  -- Valid FP state
    variable arg_real : REAL;           -- Real version of input
    variable result   : UNRESOLVED_sfixed (left_index downto right_index) :=
      (others => '0');                  -- result
  begin  -- function to_sfixed
    validfp := Classfp (arg, check_error);
    classcase : case validfp is
      when isx | nan | quiet_nan =>
        result := (others => 'X');
      when pos_zero | neg_zero =>
        result := (others => '0');      -- return 0
      when neg_inf =>
        result (left_index) := '1';     -- return smallest negative number
      when pos_inf =>
        result              := (others => '1');  -- return largest number
        result (left_index) := '0';
      when others =>
        arg_real := to_real (arg         => arg,
                             denormalize => denormalize);
        result := to_sfixed (arg            => arg_real,
                             left_index     => left_index,
                             right_index    => right_index,
                             round_style    => round_style,
                             overflow_style => overflow_style);        
    end case classcase;

    return result;
  end function to_sfixed;

  -- purpose: Converts a float to sfixed
  function to_sfixed (
    arg                     : UNRESOLVED_float;    -- fp input
    size_res                : UNRESOLVED_sfixed;
    constant round_style    : fixed_round_style_type := fixed_round_style;     -- rounding
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;  -- saturate
    constant check_error    : BOOLEAN := float_check_error;
    constant denormalize    : BOOLEAN := float_denormalize)
    return UNRESOLVED_sfixed is
    variable validfp     : valid_fpstate;        -- Valid FP state
    variable arg_real    : REAL;        -- Real version of input
    constant left_index  : INTEGER                                := size_res'high;
    constant right_index : INTEGER                                := size_res'low;
    variable result      : UNRESOLVED_sfixed (left_index downto right_index) :=
      (others => '0');                  -- result
  begin  -- function to_sfixed
    validfp := Classfp (arg, check_error);
    classcase : case validfp is
      when isx | nan | quiet_nan =>
        result := (others => 'X');
      when pos_zero | neg_zero =>
        result := (others => '0');      -- return 0
      when neg_inf =>
        result (left_index) := '1';     -- return smallest negative number
      when pos_inf =>
        result              := (others => '1');  -- return largest number
        result (left_index) := '0';
      when others =>
        arg_real := to_real (arg         => arg,
                             denormalize => denormalize);
        result := to_sfixed (arg            => arg_real,
                             left_index     => left_index,
                             right_index    => right_index,
                             round_style    => round_style,
                             overflow_style => overflow_style);        
    end case classcase;

    return result;
  end function to_sfixed;

  -- Floating point to Real number conversion
  -- Not Synthesizable
  function to_real (
    arg                  : UNRESOLVED_float;       -- floating point input
    constant round_style : round_type := float_round_style;  -- rounding option
    constant check_error : BOOLEAN    := float_check_error;
    constant denormalize : BOOLEAN    := float_denormalize)
    return REAL is
    constant fraction_width : INTEGER                                := -minx(arg'low, arg'low);  -- length of FP output fraction
    constant exponent_width : INTEGER                                := arg'high;  -- length of FP output exponent
    variable sign           : REAL;     -- Sign, + or - 1
    variable exp            : INTEGER;  -- Exponent
    variable expon_base     : INTEGER;  -- exponent offset
    variable frac           : REAL                                   := 0.0;  -- Fraction
    variable validfp        : valid_fpstate;                 -- Valid FP state
    variable expon          : UNSIGNED (exponent_width - 1 downto 0) :=
      (others => '1');                  -- Vectorized exponent
  begin
    validfp := classfp (arg, check_error);
    classcase : case validfp is
      when isx | pos_zero | neg_zero | nan | quiet_nan =>
        return 0.0;
      when neg_inf =>
        return REAL'low;                -- Negative infinity.
      when pos_inf =>
        return REAL'high;               -- Positive infinity
      when others =>
        expon_base := 2**(exponent_width-1) -1;  -- exponent offset
        if to_x01(arg(exponent_width)) = '0' then
          sign := 1.0;
        else
          sign := -1.0;
        end if;
        -- Figure out the fraction
        for i in 0 to fraction_width-1 loop
          if to_x01(arg (-1 - i)) = '1' then
            frac := frac + (2.0 **(-1 - i));
          end if;
        end loop;  -- i
        if validfp = pos_normal or validfp = neg_normal or not denormalize then
          -- exponent /= '0', normal floating point
          expon                   := UNSIGNED(arg (exponent_width-1 downto 0));
          expon(exponent_width-1) := not expon(exponent_width-1);
          exp                     := to_integer (SIGNED(expon)) +1;
          sign                    := sign * (2.0 ** exp) * (1.0 + frac);
        else  -- exponent = '0', IEEE extended floating point
          exp  := 1 - expon_base;
          sign := sign * (2.0 ** exp) * frac;
        end if;
        return sign;
    end case classcase;
  end function to_real;

  -- purpose: Removes metalogical values from FP string
  function to_01 (
    arg  : UNRESOLVED_float;                       -- floating point input
    XMAP : STD_LOGIC := '0')
    return UNRESOLVED_float is
    variable BAD_ELEMENT : BOOLEAN := false;
    variable RESULT      : UNRESOLVED_float (arg'range);
  begin  -- function to_01
    if (arg'length < 1) then
      assert NO_WARNING
        report FLOAT_GENERIC_PKG'instance_name
        & " TO_01: null detected, returning NAFP"
        severity warning;
      return NAFP;
    end if;
    for I in RESULT'range loop
      case arg(I) is
        when '0' | 'L' => RESULT(I)   := '0';
        when '1' | 'H' => RESULT(I)   := '1';
        when others    => BAD_ELEMENT := true;
      end case;
    end loop;
    if BAD_ELEMENT then
      RESULT := (others => XMAP);
    end if;
    return RESULT;
  end function to_01;

  function Is_X
    (arg : UNRESOLVED_float)
    return BOOLEAN is
  begin
    return Is_X (to_slv(arg));
  end function Is_X;

  function to_X01
    (arg : UNRESOLVED_float)
    return UNRESOLVED_float is
  begin
    if (arg'length < 1) then
      assert NO_WARNING
        report FLOAT_GENERIC_PKG'instance_name
        & " TO_X01: null detected, returning NAFP"
        severity warning;
      return NAFP;
    else
      return to_float (to_X01(to_slv(arg)), arg'high, -arg'low);
    end if;
  end function to_X01;

    function to_X01Z (arg : UNRESOLVED_float) return UNRESOLVED_float is
  begin
    if (arg'length < 1) then
      assert NO_WARNING
        report "FLOAT_GENERIC_PKG.TO_X01Z: null detected, returning NAFP"
        severity warning;
      return NAFP;
    else
      return to_float (to_X01Z(to_slv(arg)), arg'high, -arg'low);
    end if;
  end function to_X01Z;

  function to_UX01 (arg : UNRESOLVED_float) return UNRESOLVED_float is
  begin
    if (arg'length < 1) then
      assert NO_WARNING
        report FLOAT_GENERIC_PKG'instance_name
        & " TO_X01Z: null detected, returning NAFP"
        severity warning;
      return NAFP;
    else
      return to_float (to_UX01(to_slv(arg)), arg'high, -arg'low);
    end if;
  end function to_UX01;

  -- These allows the base math functions to use the default values
  -- of their parameters.  Thus they do full IEEE floating point.
  function "+" (l, r : UNRESOLVED_float) return UNRESOLVED_float is
  begin
    return add (l, r);
  end function "+";
  function "-" (l, r : UNRESOLVED_float) return UNRESOLVED_float is
  begin
    return subtract (l, r);
  end function "-";
  function "*" (l, r : UNRESOLVED_float) return UNRESOLVED_float is
  begin
    return multiply (l, r);
  end function "*";
  function "/" (l, r : UNRESOLVED_float) return UNRESOLVED_float is
  begin
    return divide (l, r);
  end function "/";
  function "rem" (l, r : UNRESOLVED_float) return UNRESOLVED_float is
  begin
    return remainder (l, r);
  end function "rem";
  function "mod" (l, r : UNRESOLVED_float) return UNRESOLVED_float is
  begin
    return modulo (l, r);
  end function "mod";
  -- overloaded versions
  function "+" (l : UNRESOLVED_float; r : REAL) return UNRESOLVED_float is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return add (l, r_float);
  end function "+";

  function "+" (l : REAL; r : UNRESOLVED_float) return UNRESOLVED_float is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return add (l_float, r);
  end function "+";

  function "+" (l : UNRESOLVED_float; r : INTEGER) return UNRESOLVED_float is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return add (l, r_float);
  end function "+";

  function "+" (l : INTEGER; r : UNRESOLVED_float) return UNRESOLVED_float is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return add (l_float, r);
  end function "+";

  function "-" (l : UNRESOLVED_float; r : REAL) return UNRESOLVED_float is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return subtract (l, r_float);
  end function "-";

  function "-" (l : REAL; r : UNRESOLVED_float) return UNRESOLVED_float is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return subtract (l_float, r);
  end function "-";

  function "-" (l : UNRESOLVED_float; r : INTEGER) return UNRESOLVED_float is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return subtract (l, r_float);
  end function "-";

  function "-" (l : INTEGER; r : UNRESOLVED_float) return UNRESOLVED_float is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return subtract (l_float, r);
  end function "-";

  function "*" (l : UNRESOLVED_float; r : REAL) return UNRESOLVED_float is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return multiply (l, r_float);
  end function "*";

  function "*" (l : REAL; r : UNRESOLVED_float) return UNRESOLVED_float is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return multiply (l_float, r);
  end function "*";

  function "*" (l : UNRESOLVED_float; r : INTEGER) return UNRESOLVED_float is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return multiply (l, r_float);
  end function "*";

  function "*" (l : INTEGER; r : UNRESOLVED_float) return UNRESOLVED_float is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return multiply (l_float, r);
  end function "*";

  function "/" (l : UNRESOLVED_float; r : REAL) return UNRESOLVED_float is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return divide (l, r_float);
  end function "/";

  function "/" (l : REAL; r : UNRESOLVED_float) return UNRESOLVED_float is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return divide (l_float, r);
  end function "/";

  function "/" (l : UNRESOLVED_float; r : INTEGER) return UNRESOLVED_float is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return divide (l, r_float);
  end function "/";

  function "/" (l : INTEGER; r : UNRESOLVED_float) return UNRESOLVED_float is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return divide (l_float, r);
  end function "/";

  function "rem" (l : UNRESOLVED_float; r : REAL) return UNRESOLVED_float is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return remainder (l, r_float);
  end function "rem";

  function "rem" (l : REAL; r : UNRESOLVED_float) return UNRESOLVED_float is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return remainder (l_float, r);
  end function "rem";

  function "rem" (l : UNRESOLVED_float; r : INTEGER) return UNRESOLVED_float is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return remainder (l, r_float);
  end function "rem";

  function "rem" (l : INTEGER; r : UNRESOLVED_float) return UNRESOLVED_float is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return remainder (l_float, r);
  end function "rem";

  function "mod" (l : UNRESOLVED_float; r : REAL) return UNRESOLVED_float is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return modulo (l, r_float);
  end function "mod";

  function "mod" (l : REAL; r : UNRESOLVED_float) return UNRESOLVED_float is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return modulo (l_float, r);
  end function "mod";

  function "mod" (l : UNRESOLVED_float; r : INTEGER) return UNRESOLVED_float is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return modulo (l, r_float);
  end function "mod";

  function "mod" (l : INTEGER; r : UNRESOLVED_float) return UNRESOLVED_float is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return modulo (l_float, r);
  end function "mod";

  function "=" (l : UNRESOLVED_float; r : REAL) return BOOLEAN is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return eq (l, r_float);
  end function "=";

  function "/=" (l : UNRESOLVED_float; r : REAL) return BOOLEAN is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return ne (l, r_float);
  end function "/=";

  function ">=" (l : UNRESOLVED_float; r : REAL) return BOOLEAN is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return ge (l, r_float);
  end function ">=";

  function "<=" (l : UNRESOLVED_float; r : REAL) return BOOLEAN is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return le (l, r_float);
  end function "<=";

  function ">" (l : UNRESOLVED_float; r : REAL) return BOOLEAN is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return gt (l, r_float);
  end function ">";

  function "<" (l : UNRESOLVED_float; r : REAL) return BOOLEAN is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return lt (l, r_float);
  end function "<";

  function "=" (l : REAL; r : UNRESOLVED_float) return BOOLEAN is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return eq (l_float, r);
  end function "=";

  function "/=" (l : REAL; r : UNRESOLVED_float) return BOOLEAN is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return ne (l_float, r);
  end function "/=";

  function ">=" (l : REAL; r : UNRESOLVED_float) return BOOLEAN is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return ge (l_float, r);
  end function ">=";

  function "<=" (l : REAL; r : UNRESOLVED_float) return BOOLEAN is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return le (l_float, r);
  end function "<=";

  function ">" (l : REAL; r : UNRESOLVED_float) return BOOLEAN is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return gt (l_float, r);
  end function ">";

  function "<" (l : REAL; r : UNRESOLVED_float) return BOOLEAN is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return lt (l_float, r);
  end function "<";

  function "=" (l : UNRESOLVED_float; r : INTEGER) return BOOLEAN is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return eq (l, r_float);
  end function "=";

  function "/=" (l : UNRESOLVED_float; r : INTEGER) return BOOLEAN is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return ne (l, r_float);
  end function "/=";

  function ">=" (l : UNRESOLVED_float; r : INTEGER) return BOOLEAN is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return ge (l, r_float);
  end function ">=";

  function "<=" (l : UNRESOLVED_float; r : INTEGER) return BOOLEAN is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return le (l, r_float);
  end function "<=";

  function ">" (l : UNRESOLVED_float; r : INTEGER) return BOOLEAN is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return gt (l, r_float);
  end function ">";

  function "<" (l : UNRESOLVED_float; r : INTEGER) return BOOLEAN is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l);         -- use size_res function
    return lt (l, r_float);
  end function "<";

  function "=" (l : INTEGER; r : UNRESOLVED_float) return BOOLEAN is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return eq (l_float, r);
  end function "=";

  function "/=" (l : INTEGER; r : UNRESOLVED_float) return BOOLEAN is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return ne (l_float, r);
  end function "/=";

  function ">=" (l : INTEGER; r : UNRESOLVED_float) return BOOLEAN is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return ge (l_float, r);
  end function ">=";

  function "<=" (l : INTEGER; r : UNRESOLVED_float) return BOOLEAN is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return le (l_float, r);
  end function "<=";

  function ">" (l : INTEGER; r : UNRESOLVED_float) return BOOLEAN is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return gt (l_float, r);
  end function ">";

  function "<" (l : INTEGER; r : UNRESOLVED_float) return BOOLEAN is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float(l, r);
    return lt (l_float, r);
  end function "<";

    -- ?= overloads
  function "?=" (l : UNRESOLVED_float; r : REAL) return STD_ULOGIC is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l'high, -l'low);
    return l ?= r_float;
  end function "?=";

  function "?/=" (l : UNRESOLVED_float; r : REAL) return STD_ULOGIC is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l'high, -l'low);
    return l ?/= r_float;
  end function "?/=";

  function "?>" (l : UNRESOLVED_float; r : REAL) return STD_ULOGIC is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l'high, -l'low);
    return l ?> r_float;
  end function "?>";

  function "?>=" (l : UNRESOLVED_float; r : REAL) return STD_ULOGIC is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l'high, -l'low);
    return l ?>= r_float;
  end function "?>=";

  function "?<" (l : UNRESOLVED_float; r : REAL) return STD_ULOGIC is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l'high, -l'low);
    return l ?< r_float;
  end function "?<";

  function "?<=" (l : UNRESOLVED_float; r : REAL) return STD_ULOGIC is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l'high, -l'low);
    return l ?<= r_float;
  end function "?<=";

  -- real and float
  function "?=" (l : REAL; r : UNRESOLVED_float) return STD_ULOGIC is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float (l, r'high, -r'low);
    return l_float ?= r;
  end function "?=";

  function "?/=" (l : REAL; r : UNRESOLVED_float) return STD_ULOGIC is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float (l, r'high, -r'low);
    return l_float ?/= r;
  end function "?/=";

  function "?>" (l : REAL; r : UNRESOLVED_float) return STD_ULOGIC is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float (l, r'high, -r'low);
    return l_float ?> r;
  end function "?>";

  function "?>=" (l : REAL; r : UNRESOLVED_float) return STD_ULOGIC is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float (l, r'high, -r'low);
    return l_float ?>= r;
  end function "?>=";

  function "?<" (l : REAL; r : UNRESOLVED_float) return STD_ULOGIC is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float (l, r'high, -r'low);
    return l_float ?< r;
  end function "?<";

  function "?<=" (l : REAL; r : UNRESOLVED_float) return STD_ULOGIC is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float (l, r'high, -r'low);
    return l_float ?<= r;
  end function "?<=";

  -- ?= overloads
  function "?=" (l : UNRESOLVED_float; r : INTEGER) return STD_ULOGIC is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l'high, -l'low);
    return l ?= r_float;
  end function "?=";

  function "?/=" (l : UNRESOLVED_float; r : INTEGER) return STD_ULOGIC is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l'high, -l'low);
    return l ?/= r_float;
  end function "?/=";

  function "?>" (l : UNRESOLVED_float; r : INTEGER) return STD_ULOGIC is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l'high, -l'low);
    return l ?> r_float;
  end function "?>";

  function "?>=" (l : UNRESOLVED_float; r : INTEGER) return STD_ULOGIC is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l'high, -l'low);
    return l ?>= r_float;
  end function "?>=";

  function "?<" (l : UNRESOLVED_float; r : INTEGER) return STD_ULOGIC is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l'high, -l'low);
    return l ?< r_float;
  end function "?<";

  function "?<=" (l : UNRESOLVED_float; r : INTEGER) return STD_ULOGIC is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l'high, -l'low);
    return l ?<= r_float;
  end function "?<=";

  -- real and float
  function "?=" (l : INTEGER; r : UNRESOLVED_float) return STD_ULOGIC is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float (l, r'high, -r'low);
    return l_float ?= r;
  end function "?=";

  function "?/=" (l : INTEGER; r : UNRESOLVED_float) return STD_ULOGIC is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float (l, r'high, -r'low);
    return l_float ?/= r;
  end function "?/=";

  function "?>" (l : INTEGER; r : UNRESOLVED_float) return STD_ULOGIC is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float (l, r'high, -r'low);
    return l_float ?> r;
  end function "?>";

  function "?>=" (l : INTEGER; r : UNRESOLVED_float) return STD_ULOGIC is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float (l, r'high, -r'low);
    return l_float ?>= r;
  end function "?>=";

  function "?<" (l : INTEGER; r : UNRESOLVED_float) return STD_ULOGIC is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float (l, r'high, -r'low);
    return l_float ?< r;
  end function "?<";

  function "?<=" (l : INTEGER; r : UNRESOLVED_float) return STD_ULOGIC is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float (l, r'high, -r'low);
    return l_float ?<= r;
  end function "?<=";

  -- minimum and maximum overloads
  function minimum (l : UNRESOLVED_float; r : REAL)
    return UNRESOLVED_float is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l'high, -l'low);
    return minimum (l, r_float);
  end function minimum;

  function maximum (l : UNRESOLVED_float; r : REAL)
    return UNRESOLVED_float is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l'high, -l'low);
    return maximum (l, r_float);
  end function maximum;

  function minimum (l : REAL; r : UNRESOLVED_float)
    return UNRESOLVED_float is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float (l, r'high, -r'low);
    return minimum (l_float, r);
  end function minimum;

  function maximum (l : REAL; r : UNRESOLVED_float)
    return UNRESOLVED_float is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float (l, r'high, -r'low);
    return maximum (l_float, r);
  end function maximum;

  function minimum (l : UNRESOLVED_float; r : INTEGER)
    return UNRESOLVED_float is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l'high, -l'low);
    return minimum (l, r_float);
  end function minimum;

  function maximum (l : UNRESOLVED_float; r : INTEGER)
    return UNRESOLVED_float is
    variable r_float : UNRESOLVED_float (l'range);
  begin
    r_float := to_float (r, l'high, -l'low);
    return maximum (l, r_float);
  end function maximum;

  function minimum (l : INTEGER; r : UNRESOLVED_float)
    return UNRESOLVED_float is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float (l, r'high, -r'low);
    return minimum (l_float, r);
  end function minimum;

  function maximum (l : INTEGER; r : UNRESOLVED_float)
    return UNRESOLVED_float is
    variable l_float : UNRESOLVED_float (r'range);
  begin
    l_float := to_float (l, r'high, -r'low);
    return maximum (l_float, r);
  end function maximum;
  ----------------------------------------------------------------------------
  -- logical functions
  ----------------------------------------------------------------------------
  function "not" (L : UNRESOLVED_float) return UNRESOLVED_float is
    variable RESULT : STD_LOGIC_VECTOR(L'length-1 downto 0);  -- force downto
    variable resfp  : UNRESOLVED_float (L'range);                        -- back to float
  begin
    RESULT := not to_slv(L);
    resfp  := UNRESOLVED_float (RESULT);
    return resfp;
  end function "not";

  function "and" (L, R : UNRESOLVED_float) return UNRESOLVED_float is
    variable RESULT : STD_LOGIC_VECTOR(L'length-1 downto 0);  -- force downto
    variable resfp  : UNRESOLVED_float (L'range);                        -- back to float
  begin
    RESULT := to_slv(L) and to_slv(R);
    resfp  := UNRESOLVED_float (RESULT);
    return resfp;
  end function "and";

  function "or" (L, R : UNRESOLVED_float) return UNRESOLVED_float is
    variable RESULT : STD_LOGIC_VECTOR(L'length-1 downto 0);  -- force downto
    variable resfp  : UNRESOLVED_float (L'range);                        -- back to float
  begin
    RESULT := to_slv(L) or to_slv(R);
    resfp  := UNRESOLVED_float (RESULT);
    return resfp;
  end function "or";

  function "nand" (L, R : UNRESOLVED_float) return UNRESOLVED_float is
    variable RESULT : STD_LOGIC_VECTOR(L'length-1 downto 0);  -- force downto
    variable resfp  : UNRESOLVED_float (L'range);                        -- back to float
  begin
    RESULT := to_slv(L) nand to_slv(R);
    resfp  := UNRESOLVED_float (RESULT);
    return resfp;
  end function "nand";

  function "nor" (L, R : UNRESOLVED_float) return UNRESOLVED_float is
    variable RESULT : STD_LOGIC_VECTOR(L'length-1 downto 0);  -- force downto
    variable resfp  : UNRESOLVED_float (L'range);                        -- back to float
  begin
    RESULT := to_slv(L) nor to_slv(R);
    resfp  := UNRESOLVED_float (RESULT);
    return resfp;
  end function "nor";

  function "xor" (L, R : UNRESOLVED_float) return UNRESOLVED_float is
    variable RESULT : STD_LOGIC_VECTOR(L'length-1 downto 0);  -- force downto
    variable resfp  : UNRESOLVED_float (L'range);                        -- back to float
  begin
    RESULT := to_slv(L) xor to_slv(R);
    resfp  := UNRESOLVED_float (RESULT);
    return resfp;
  end function "xor";

  function "xnor" (L, R : UNRESOLVED_float) return UNRESOLVED_float is
    variable RESULT : STD_LOGIC_VECTOR(L'length-1 downto 0);  -- force downto
    variable resfp  : UNRESOLVED_float (L'range);                        -- back to float
  begin
    RESULT := to_slv(L) xnor to_slv(R);
    resfp  := UNRESOLVED_float (RESULT);
    return resfp;
  end function "xnor";

  -- Vector and std_ulogic functions, same as functions in numeric_std
  function "and" (L : STD_ULOGIC; R : UNRESOLVED_float) return UNRESOLVED_float is
    variable result : UNRESOLVED_float (R'range);
  begin
    for i in result'range loop
      result(i) := L and R(i);
    end loop;
    return result;
  end function "and";

  function "and" (L : UNRESOLVED_float; R : STD_ULOGIC) return UNRESOLVED_float is
    variable result : UNRESOLVED_float (L'range);
  begin
    for i in result'range loop
      result(i) := L(i) and R;
    end loop;
    return result;
  end function "and";

  function "or" (L : STD_ULOGIC; R : UNRESOLVED_float) return UNRESOLVED_float is
    variable result : UNRESOLVED_float (R'range);
  begin
    for i in result'range loop
      result(i) := L or R(i);
    end loop;
    return result;
  end function "or";

  function "or" (L : UNRESOLVED_float; R : STD_ULOGIC) return UNRESOLVED_float is
    variable result : UNRESOLVED_float (L'range);
  begin
    for i in result'range loop
      result(i) := L(i) or R;
    end loop;
    return result;
  end function "or";

  function "nand" (L : STD_ULOGIC; R : UNRESOLVED_float) return UNRESOLVED_float is
    variable result : UNRESOLVED_float (R'range);
  begin
    for i in result'range loop
      result(i) := L nand R(i);
    end loop;
    return result;
  end function "nand";

  function "nand" (L : UNRESOLVED_float; R : STD_ULOGIC) return UNRESOLVED_float is
    variable result : UNRESOLVED_float (L'range);
  begin
    for i in result'range loop
      result(i) := L(i) nand R;
    end loop;
    return result;
  end function "nand";

  function "nor" (L : STD_ULOGIC; R : UNRESOLVED_float) return UNRESOLVED_float is
    variable result : UNRESOLVED_float (R'range);
  begin
    for i in result'range loop
      result(i) := L nor R(i);
    end loop;
    return result;
  end function "nor";

  function "nor" (L : UNRESOLVED_float; R : STD_ULOGIC) return UNRESOLVED_float is
    variable result : UNRESOLVED_float (L'range);
  begin
    for i in result'range loop
      result(i) := L(i) nor R;
    end loop;
    return result;
  end function "nor";

  function "xor" (L : STD_ULOGIC; R : UNRESOLVED_float) return UNRESOLVED_float is
    variable result : UNRESOLVED_float (R'range);
  begin
    for i in result'range loop
      result(i) := L xor R(i);
    end loop;
    return result;
  end function "xor";

  function "xor" (L : UNRESOLVED_float; R : STD_ULOGIC) return UNRESOLVED_float is
    variable result : UNRESOLVED_float (L'range);
  begin
    for i in result'range loop
      result(i) := L(i) xor R;
    end loop;
    return result;
  end function "xor";

  function "xnor" (L : STD_ULOGIC; R : UNRESOLVED_float) return UNRESOLVED_float is
    variable result : UNRESOLVED_float (R'range);
  begin
    for i in result'range loop
      result(i) := L xnor R(i);
    end loop;
    return result;
  end function "xnor";

  function "xnor" (L : UNRESOLVED_float; R : STD_ULOGIC) return UNRESOLVED_float is
    variable result : UNRESOLVED_float (L'range);
  begin
    for i in result'range loop
      result(i) := L(i) xnor R;
    end loop;
    return result;
  end function "xnor";

  -- Reduction operators, same as numeric_std functions

  function "and" (l : UNRESOLVED_float) return STD_ULOGIC is
  begin
    return and to_suv(l);
  end function "and";
  function "nand" (l : UNRESOLVED_float) return STD_ULOGIC is
  begin
    return nand to_suv(l);
  end function "nand";
  function "or" (l : UNRESOLVED_float) return STD_ULOGIC is
  begin
    return or to_suv(l);
  end function "or";
  function "nor" (l : UNRESOLVED_float) return STD_ULOGIC is
  begin
    return nor to_suv(l);
  end function "nor";
  function "xor" (l : UNRESOLVED_float) return STD_ULOGIC is
  begin
    return xor to_suv(l);
  end function "xor";
  function "xnor" (l : UNRESOLVED_float) return STD_ULOGIC is
  begin
    return xnor to_suv(l);
  end function "xnor";
  -----------------------------------------------------------------------------
  -- Recommended Functions from the IEEE 754 Appendix
  -----------------------------------------------------------------------------
  -- returns x with the sign of y.
  function Copysign (
    x, y : UNRESOLVED_float)                       -- floating point input
    return UNRESOLVED_float is
  begin
    return y(y'high) & x (x'high-1 downto x'low);
  end function Copysign;

  -- Returns y * 2**n for intergral values of N without computing 2**n
  function Scalb (
    y                    : UNRESOLVED_float;       -- floating point input
    N                    : INTEGER;     -- exponent to add    
    constant round_style : round_type := float_round_style;  -- rounding option
    constant check_error : BOOLEAN    := float_check_error;
    constant denormalize : BOOLEAN    := float_denormalize)
    return UNRESOLVED_float is
    constant fraction_width : NATURAL := -y'low;  -- length of FP output fraction
    constant exponent_width : NATURAL := y'high;  -- length of FP output exponent
    variable result         : UNRESOLVED_float (y'range);
    variable arg            : UNRESOLVED_float (y'range);    -- internal argument
    variable arg_real       : REAL;     -- real version of argument
    variable result_real    : REAL;     -- real version of result
    variable fptype         : valid_fpstate;
  begin
    -- This can be done by simply adding N to the exponent.
    arg    := to_01 (y, 'X');
    fptype := Classfp(arg, check_error);
    classcase : case fptype is
      when isx =>
        result := (others => 'X');
      when nan | quiet_nan =>
        -- Return quiet NAN, IEEE754-1985-7.1,1
        result := qnanfp (fraction_width    => fraction_width,
                             exponent_width => exponent_width);
      when others =>
        arg_real := to_real (arg         => arg,
                             round_style => round_style,
                             denormalize => denormalize);
        result_real := arg_real * 2.0**N;
        result := to_float (arg            => result_real,
                            fraction_width => fraction_width,
                            exponent_width => exponent_width,
                            round_style    => round_style,
                            denormalize    => denormalize);
    end case classcase;
    return result;
  end function Scalb;

  -- Returns y * 2**n for intergral values of N without computing 2**n
  function Scalb (
    y                    : UNRESOLVED_float;       -- floating point input
    N                    : UNRESOLVED_SIGNED;      -- exponent to add    
    constant round_style : round_type := float_round_style;  -- rounding option
    constant check_error : BOOLEAN    := float_check_error;
    constant denormalize : BOOLEAN    := float_denormalize)
    return UNRESOLVED_float is
    constant fraction_width : NATURAL := -y'low;  -- length of FP output fraction
    constant exponent_width : NATURAL := y'high;  -- length of FP output exponent
    variable result         : UNRESOLVED_float (y'range);
    variable arg            : UNRESOLVED_float (y'range);    -- internal argument
    variable arg_real       : REAL;     -- real version of argument
    variable result_real    : REAL;     -- real version of result
    variable fptype         : valid_fpstate;
  begin
    -- This can be done by simply adding N to the exponent.
    arg    := to_01 (y, 'X');
    fptype := Classfp(arg, check_error);
    classcase : case fptype is
      when isx =>
        result := (others => 'X');
      when nan | quiet_nan =>
        -- Return quiet NAN, IEEE754-1985-7.1,1
        result := qnanfp (fraction_width  => fraction_width,
                           exponent_width => exponent_width);
      when others =>
        arg_real := to_real (arg         => arg,
                             round_style => round_style,
                             denormalize => denormalize);
        result_real := arg_real * 2.0**to_integer(N);
        result := to_float (arg            => result_real,
                            fraction_width => fraction_width,
                            exponent_width => exponent_width,
                            round_style    => round_style,
                            denormalize    => denormalize);
    end case classcase;
    return result;
  end function Scalb;

  -- returns the unbiased exponent of x
  function Logb (
    x : UNRESOLVED_float)                               -- floating point input
    return INTEGER is
    variable arg         : UNRESOLVED_float (x'range);  -- internal argument
    variable arg_real    : REAL;             -- real version of argument
    variable result_real : REAL;             -- real version of result
    variable fptype      : valid_fpstate;
    variable result      : INTEGER;          -- result
  begin
    -- Just return the exponent.
    arg    := to_01 (x, 'X');
    fptype := Classfp(arg);
    classcase : case fptype is
      when isx | nan | quiet_nan =>
        -- Return quiet NAN, IEEE754-1985-7.1,1
        result := 0;
      when others =>
        arg_real := to_real (arg         => arg,
                             round_style => round_neginf,
                             denormalize => true);
        result_real := log2 (abs(arg_real));
        result      := INTEGER (floor (result_real));
    end case classcase;
    return result;
  end function Logb;

  -- returns the unbiased exponent of x
  function Logb (
    x : UNRESOLVED_float)                          -- floating point input
    return UNRESOLVED_SIGNED is
    constant exponent_width : NATURAL := x'high;  -- length of FP output exponent
    variable result         : SIGNED (exponent_width - 1 downto 0);  -- result
  begin
    -- Just return the exponent.
    result := to_signed (Logb (x), exponent_width);
    return result;
  end function Logb;

  -- returns the next represtable neighbor of x in the direction toward y
  function Nextafter (
    x, y                 : UNRESOLVED_float;       -- floating point input
    constant check_error : BOOLEAN := float_check_error;  -- check for errors
    constant denormalize : BOOLEAN := float_denormalize)
    return UNRESOLVED_float is
    constant fraction_width : NATURAL := -x'low;  -- length of FP output fraction
    constant exponent_width : NATURAL := x'high;  -- length of FP output exponent
    function equal (
      l, r : UNRESOLVED_float)                     -- inputs
      return BOOLEAN is
    begin  -- function "="
      return eq (l => l,
                 r => r);
    end function equal;
    function greater_than (
      l, r : UNRESOLVED_float)                     -- inputs
      return BOOLEAN is
    begin  -- function ">"
      return gt (l => l,
                 r => r);
    end function greater_than;
    variable fract              : UNSIGNED (fraction_width-1 downto 0);
    variable expon              : UNSIGNED (exponent_width-1 downto 0);
    variable sign               : STD_ULOGIC;
    variable result             : UNRESOLVED_float (x'range);
    variable validfpx, validfpy : valid_fpstate;  -- Valid FP state
  begin
    -- If Y > X, add one to the fraction, otherwise subtract.
    validfpx := Classfp (x, check_error);
    validfpy := Classfp (y, check_error);
    if validfpx = isx or validfpy = isx then
      result := (others => 'X');
      return result;
    elsif equal (x, y) then             -- Return X
      return x;
    elsif (validfpx = nan or validfpy = nan) then
      return nanfp (fraction_width  => fraction_width,
                     exponent_width => exponent_width);
    elsif (validfpx = quiet_nan or validfpy = quiet_nan) then
      return qnanfp (fraction_width  => fraction_width,
                      exponent_width => exponent_width);
    else
      fract := UNSIGNED (to_slv (x (-1 downto -fraction_width)));  -- Fraction
      expon := UNSIGNED (x (exponent_width - 1 downto 0));         -- exponent
      sign  := x(exponent_width);       -- sign bit
      if greater_than (y, x) then
        -- Increase the number given
        if validfpx = neg_inf then
          -- return most negative number
          expon     := (others => '1');
          expon (0) := '0';
          fract     := (others => '1');
        elsif validfpx = pos_zero or validfpx = neg_zero then
          -- return smallest denormal number
          sign     := '0';
          expon    := (others => '0');
          fract    := (others => '0');
          fract(0) := '1';
        elsif validfpx = pos_normal then
          if and (fract) = '1' then       -- fraction is all "1".
            if and (expon (exponent_width-1 downto 1)) = '1'
              and expon (0) = '0' then
                                        -- Exponent is one away from infinity.
              assert NO_WARNING
                report FLOAT_GENERIC_PKG'instance_name
                & " NEXTAFTER: NextAfter overflow"
                severity warning;
              return pos_inffp (fraction_width  => fraction_width,
                                 exponent_width => exponent_width);
            else
              expon := expon + 1;
              fract := (others => '0');
            end if;
          else
            fract := fract + 1;
          end if;
        elsif validfpx = pos_denormal then
          if and (fract) = '1' then       -- fraction is all "1".
            -- return smallest possible normal number
            expon    := (others => '0');
            expon(0) := '1';
            fract    := (others => '0');
          else
            fract := fract + 1;
          end if;
        elsif validfpx = neg_normal then
          if or (fract) = '0' then        -- fraction is all "0".
            if or (expon (exponent_width-1 downto 1)) = '0' and
              expon (0) = '1' then      -- Smallest exponent
              -- return the largest negative denormal number
              expon := (others => '0');
              fract := (others => '1');
            else
              expon := expon - 1;
              fract := (others => '1');
            end if;
          else
            fract := fract - 1;
          end if;
        elsif validfpx = neg_denormal then
          if or (fract(fract'high downto 1)) = '0'
            and fract (0) = '1' then    -- Smallest possible fraction
            return zerofp (fraction_width  => fraction_width,
                            exponent_width => exponent_width);
          else
            fract := fract - 1;
          end if;
        end if;
      else
        -- Decrease the number
        if validfpx = pos_inf then
          -- return most positive number
          expon     := (others => '1');
          expon (0) := '0';
          fract     := (others => '1');
        elsif validfpx = pos_zero
          or Classfp (x) = neg_zero then
          -- return smallest negative denormal number
          sign     := '1';
          expon    := (others => '0');
          fract    := (others => '0');
          fract(0) := '1';
        elsif validfpx = neg_normal then
          if and (fract) = '1' then       -- fraction is all "1".
            if and (expon (exponent_width-1 downto 1)) = '1'
              and expon (0) = '0' then
                                        -- Exponent is one away from infinity.
              assert NO_WARNING
                report FLOAT_GENERIC_PKG'instance_name
                & " NEXTAFTER: NextAfter overflow"
                severity warning;
              return neg_inffp (fraction_width  => fraction_width,
                                 exponent_width => exponent_width);
            else
              expon := expon + 1;       -- Fraction overflow
              fract := (others => '0');
            end if;
          else
            fract := fract + 1;
          end if;
        elsif validfpx = neg_denormal then
          if and (fract) = '1' then       -- fraction is all "1".
            -- return smallest possible normal number
            expon    := (others => '0');
            expon(0) := '1';
            fract    := (others => '0');
          else
            fract := fract + 1;
          end if;
        elsif validfpx = pos_normal then
          if or (fract) = '0' then        -- fraction is all "0".
            if or (expon (exponent_width-1 downto 1)) = '0' and
              expon (0) = '1' then      -- Smallest exponent
              -- return the largest positive denormal number
              expon := (others => '0');
              fract := (others => '1');
            else
              expon := expon - 1;
              fract := (others => '1');
            end if;
          else
            fract := fract - 1;
          end if;
        elsif validfpx = pos_denormal then
          if or (fract(fract'high downto 1)) = '0'
            and fract (0) = '1' then    -- Smallest possible fraction
            return zerofp (fraction_width  => fraction_width,
                            exponent_width => exponent_width);
          else
            fract := fract - 1;
          end if;
        end if;
      end if;
      result (-1 downto -fraction_width)  := UNRESOLVED_float(fract);
      result (exponent_width -1 downto 0) := UNRESOLVED_float(expon);
      result (exponent_width)             := sign;
      return result;
    end if;
  end function Nextafter;

  -- Returns True if X is unordered with Y.
  function Unordered (
    x, y : UNRESOLVED_float)                       -- floating point input
    return BOOLEAN is
    variable lfptype, rfptype : valid_fpstate;
  begin
    lfptype := Classfp (x);
    rfptype := Classfp (y);
    if (lfptype = nan or lfptype = quiet_nan or
        rfptype = nan or rfptype = quiet_nan) then
      return true;
    else
      return false;
    end if;
  end function Unordered;

  function Finite (
    x : UNRESOLVED_float)
    return BOOLEAN is
    variable fp_state : valid_fpstate;  -- fp state
  begin
    fp_state := Classfp (x);
    if (fp_state = pos_inf) or (fp_state = neg_inf) then
      return true;
    else
      return false;
    end if;
  end function Finite;

  function Isnan (
    x : UNRESOLVED_float)
    return BOOLEAN is
    variable fp_state : valid_fpstate;  -- fp state
  begin
    fp_state := Classfp (x);
    if (fp_state = nan) or (fp_state = quiet_nan) then
      return true;
    else
      return false;
    end if;
  end function Isnan;

  -- purpose: normalizes a floating point number
  -- This version assumes an "unsigned" input with the exponented biased by -1
  function normalize (
    fract                   : UNRESOLVED_UNSIGNED;  -- fraction, unnormalized
    expon                   : UNRESOLVED_SIGNED;   -- exponent, normalized
    sign                    : STD_ULOGIC;                       -- sign bit
    sticky                  : STD_ULOGIC := '0';  -- Sticky bit (rounding)
    constant exponent_width : NATURAL    := float_exponent_width;  -- size of exponent
    constant fraction_width : NATURAL    := float_fraction_width;  -- size of fraction
    constant round_style    : round_type := float_round_style;  -- rounding option
    constant denormalize    : BOOLEAN    := float_denormalize;
    constant nguard         : NATURAL    := float_guard_bits)   -- guard bits
    return UNRESOLVED_float is
    variable result_real : REAL;        -- real version of result
    variable result      : UNRESOLVED_float (exponent_width downto -fraction_width);  -- result
    variable rexp        : SIGNED (exponent_width+1 downto 0);  -- result exponent
  begin  -- function fpnormalize
    rexp        := resize (expon, rexp'length);
    result_real := REAL (to_integer (fract))
                   * (2.0 ** (to_integer (rexp - fraction_width-nguard + 1)));
    if sign = '1' then
      result_real := - result_real;
    end if;
    return to_float (arg            => result_real,
                     fraction_width => fraction_width,
                     exponent_width => exponent_width,
                     round_style    => round_style,
                     denormalize    => denormalize);
  end function normalize;

  -- purpose: normalizes a floating point number
  -- This version assumes a "ufixed" input with
  function normalize (
    fract                   : UNRESOLVED_ufixed;   -- unsigned fixed point
    expon                   : UNRESOLVED_SIGNED;   -- exponent, normalized by -1
    sign                    : STD_ULOGIC;                       -- sign bit
    sticky                  : STD_ULOGIC := '0';  -- Sticky bit (rounding)
    constant exponent_width : NATURAL    := float_exponent_width;  -- size of exponent
    constant fraction_width : NATURAL    := float_fraction_width;  -- size of fraction
    constant round_style    : round_type := float_round_style;  -- rounding option
    constant denormalize    : BOOLEAN    := float_denormalize;
    constant nguard         : NATURAL    := float_guard_bits)   -- guard bits
    return UNRESOLVED_float is
    variable result : UNRESOLVED_float (exponent_width downto -fraction_width);
    variable arguns : UNSIGNED (fract'high + fraction_width + nguard
                                downto 0) := (others => '0');
  begin  -- function fp_normalize
    for i in arguns'high downto maximum (arguns'high-fract'length+1, 0) loop
      arguns (i) := fract (fract'high + (i-arguns'high));
    end loop;
    result := normalize (fract          => arguns,
                         expon          => expon,
                         sign           => sign,
                         fraction_width => fraction_width,
                         exponent_width => exponent_width,
                         round_style    => round_style,
                         denormalize    => denormalize,
                         nguard         => nguard);
    return result;
  end function normalize;

  function normalize (
    fract                : UNRESOLVED_ufixed;      -- unsigned fixed point
    expon                : UNRESOLVED_SIGNED;      -- exponent - 1, normalized
    sign                 : STD_ULOGIC;  -- sign bit
    sticky               : STD_ULOGIC := '0';  -- Sticky bit (rounding)
    size_res             : UNRESOLVED_float;       -- used for sizing only
    constant round_style : round_type := float_round_style;  -- rounding option
    constant denormalize : BOOLEAN    := float_denormalize;
    constant nguard      : NATURAL    := float_guard_bits)   -- guard bits
    return UNRESOLVED_float is
  begin
    return normalize (fract          => fract,
                      expon          => expon,
                      sign           => sign,
                      fraction_width => -size_res'low,
                      exponent_width => size_res'high,
                      round_style    => round_style,
                      denormalize    => denormalize,
                      nguard         => nguard);
  end function normalize;

  function normalize (
    fract                : UNRESOLVED_UNSIGNED;    -- unsigned fixed point
    expon                : UNRESOLVED_SIGNED;      -- exponent - 1, normalized
    sign                 : STD_ULOGIC;  -- sign bit
    sticky               : STD_ULOGIC := '0';  -- Sticky bit (rounding)
    size_res             : UNRESOLVED_float;       -- used for sizing only
    constant round_style : round_type := float_round_style;  -- rounding option
    constant denormalize : BOOLEAN    := float_denormalize;
    constant nguard      : NATURAL    := float_guard_bits)   -- guard bits
    return UNRESOLVED_float is
  begin
    return normalize (fract          => fract,
                      expon          => expon,
                      sign           => sign,
                      fraction_width => -size_res'low,
                      exponent_width => size_res'high,
                      round_style    => round_style,
                      denormalize    => denormalize,
                      nguard         => nguard);
  end function normalize;

  procedure break_number (
    arg         : in  UNRESOLVED_float;
    denormalize : in  BOOLEAN := float_denormalize;
    check_error : in  BOOLEAN := float_check_error;
    fract       : out UNRESOLVED_UNSIGNED;
    expon       : out UNRESOLVED_SIGNED;
    sign        : out STD_ULOGIC) is
    constant fraction_width : NATURAL := -arg'low;  -- length of FP output fraction
    constant exponent_width : NATURAL := arg'high;  -- length of FP output exponent
    constant expon_base     : SIGNED (exponent_width-1 downto 0)
 := to_signed (2**(exponent_width-1) -1, exponent_width);  -- exponent offset
    variable exp   : SIGNED (expon'range);
    variable fptyp : valid_fpstate;
  begin
    sign := to_x01(arg(arg'high));
    fract (fraction_width-1 downto 0)
 := UNSIGNED (to_slv(arg(-1 downto -fraction_width)));
    fptyp := Classfp (arg, check_error);
    breakcase : case fptyp is
      when pos_zero | neg_zero =>
        fract (fraction_width) := '0';
        exp                    := -expon_base;
      when pos_denormal | neg_denormal =>
        if denormalize then
          exp                    := -expon_base;
          fract (fraction_width) := '0';
        else
          exp                    := -expon_base - 1;
          fract (fraction_width) := '1';
        end if;
      when pos_normal | neg_normal =>
        fract (fraction_width) := '1';
        exp                    := to_01(SIGNED(arg(exponent_width-1 downto 0)), 'X');
        exp (exponent_width-1) := not exp(exponent_width-1);
      when others =>
        assert (NO_WARNING)
          report FLOAT_GENERIC_PKG'instance_name
          & " BREAK_NUMBER: " &
          "Meta state detected in break_number process"
          severity warning;
        -- complete the case, if a meta state goes in, a meta state comes out.
        exp                    := (others => '1');
        fract (fraction_width) := '1';
    end case breakcase;
    expon := exp;
  end procedure break_number;
  
  procedure break_number (
    arg         : in  UNRESOLVED_float;
    denormalize : in  BOOLEAN := float_denormalize;
    check_error : in  BOOLEAN := float_check_error;
    fract       : out UNRESOLVED_ufixed;           -- 1 downto -fraction_width
    expon       : out UNRESOLVED_SIGNED;           -- exponent_width-1 downto 0
    sign        : out STD_ULOGIC) is
    constant fraction_width : NATURAL                            := -arg'low;  -- length of FP output fraction
    constant exponent_width : NATURAL                            := arg'high;  -- length of FP output exponent
    constant expon_base     : SIGNED (exponent_width-1 downto 0) :=
      to_signed (2**(exponent_width-1) -1, exponent_width);  -- exponent offset
    variable fptyp : valid_fpstate;
    variable exp   : SIGNED (expon'range);
  begin
    fptyp := Classfp (arg, check_error);
    for i in -1 downto -fraction_width loop
      fract(i) := arg(i);
    end loop;
    sign := to_x01(arg(arg'high));
    breakcase : case fptyp is
      when pos_zero | neg_zero =>
        fract (0) := '0';
        exp       := -expon_base;
      when pos_denormal | neg_denormal =>
        if denormalize then
          exp       := -expon_base;
          fract (0) := '0';
        else
          exp       := -expon_base - 1;
          fract (0) := '1';
        end if;
      when pos_normal | neg_normal | pos_inf | neg_inf =>
        fract (0)              := '1';
        exp                    := to_01(SIGNED(arg(exponent_width-1 downto 0)), 'X');
        exp (exponent_width-1) := not exp(exponent_width-1);
      when others =>
        assert NO_WARNING
          report FLOAT_GENERIC_PKG'instance_name
          & " BREAK_NUMBER: " &
          "Meta state detected in break_number process"
          severity warning;
        -- complete the case, if a meta state goes in, a meta state comes out.
        exp       := (others => '1');
        fract (0) := '1';
    end case breakcase;
    expon := exp;
  end procedure break_number;

  -- Function to return constants.
  function zerofp (
    constant exponent_width : NATURAL := float_exponent_width;  -- exponent
    constant fraction_width : NATURAL := float_fraction_width)  -- fraction
    return UNRESOLVED_float is
    constant result : UNRESOLVED_float (exponent_width downto -fraction_width)
 := (others => '0');                    -- zero
  begin
    return result;
  end function zerofp;
  function nanfp (
    constant exponent_width : NATURAL := float_exponent_width;  -- exponent
    constant fraction_width : NATURAL := float_fraction_width)  -- fraction
    return UNRESOLVED_float is
    variable result : UNRESOLVED_float (exponent_width downto -fraction_width)
 := (others => '0');                    -- zero
  begin
    result (exponent_width-1 downto 0) := (others => '1');
    -- Exponent all "1"
    result (-1)                        := '1';  -- MSB of Fraction "1"
    -- Note: From W. Khan "IEEE Standard 754 for Binary Floating Point"
    -- The difference between a signaling NAN and a quiet NAN is that
    -- the MSB of the Fraction is a "1" in a Signaling NAN, and is a
    -- "0" in a quiet NAN.
    return result;
  end function nanfp;
  function qnanfp (
    constant exponent_width : NATURAL := float_exponent_width;  -- exponent
    constant fraction_width : NATURAL := float_fraction_width)  -- fraction
    return UNRESOLVED_float is
    variable result : UNRESOLVED_float (exponent_width downto -fraction_width)
 := (others => '0');                    -- zero
  begin
    result (exponent_width-1 downto 0) := (others => '1');
    -- Exponent all "1"
    result (-fraction_width)           := '1';  -- LSB of Fraction "1"
    -- (Could have been any bit)
    return result;
  end function qnanfp;
  function pos_inffp (
    constant exponent_width : NATURAL := float_exponent_width;  -- exponent
    constant fraction_width : NATURAL := float_fraction_width)  -- fraction
    return UNRESOLVED_float is
    variable result : UNRESOLVED_float (exponent_width downto -fraction_width)
 := (others => '0');                    -- zero
  begin
    result (exponent_width-1 downto 0) := (others => '1');  -- Exponent all "1"
    return result;
  end function pos_inffp;
  function neg_inffp (
    constant exponent_width : NATURAL := float_exponent_width;  -- exponent
    constant fraction_width : NATURAL := float_fraction_width)  -- fraction
    return UNRESOLVED_float is
    variable result : UNRESOLVED_float (exponent_width downto -fraction_width)
 := (others => '0');                    -- zero
  begin
    result (exponent_width downto 0) := (others => '1');    -- top bits all "1"
    return result;
  end function neg_inffp;
  function neg_zerofp (
    constant exponent_width : NATURAL := float_exponent_width;  -- exponent
    constant fraction_width : NATURAL := float_fraction_width)  -- fraction
    return UNRESOLVED_float is
    variable result : UNRESOLVED_float (exponent_width downto -fraction_width)
 := (others => '0');                    -- zero
  begin
    result (exponent_width) := '1';
    return result;
  end function neg_zerofp;
  -- size_res versions
  function zerofp (
    size_res : UNRESOLVED_float)                   -- variable is only use for sizing
    return UNRESOLVED_float is
  begin
    return zerofp (
      exponent_width => size_res'high,
      fraction_width => -size_res'low);
  end function zerofp;
  function nanfp (
    size_res : UNRESOLVED_float)                   -- variable is only use for sizing
    return UNRESOLVED_float is
  begin
    return nanfp (
      exponent_width => size_res'high,
      fraction_width => -size_res'low);
  end function nanfp;
  function qnanfp (
    size_res : UNRESOLVED_float)                   -- variable is only use for sizing
    return UNRESOLVED_float is
  begin
    return qnanfp (
      exponent_width => size_res'high,
      fraction_width => -size_res'low);
  end function qnanfp;
  function pos_inffp (
    size_res : UNRESOLVED_float)                   -- variable is only use for sizing
    return UNRESOLVED_float is
  begin
    return pos_inffp (
      exponent_width => size_res'high,
      fraction_width => -size_res'low);
  end function pos_inffp;
  function neg_inffp (
    size_res : UNRESOLVED_float)                   -- variable is only use for sizing
    return UNRESOLVED_float is
  begin
    return neg_inffp (
      exponent_width => size_res'high,
      fraction_width => -size_res'low);
  end function neg_inffp;
  function neg_zerofp (
    size_res : UNRESOLVED_float)                   -- variable is only use for sizing
    return UNRESOLVED_float is
  begin
    return neg_zerofp (
      exponent_width => size_res'high,
      fraction_width => -size_res'low);
  end function neg_zerofp;

  -- purpose: writes float into a line (NOTE changed basetype)
  type MVL9plus is ('U', 'X', '0', '1', 'Z', 'W', 'L', 'H', '-', error);
  type char_indexed_by_MVL9 is array (STD_ULOGIC) of CHARACTER;
  type MVL9_indexed_by_char is array (CHARACTER) of STD_ULOGIC;
  type MVL9plus_indexed_by_char is array (CHARACTER) of MVL9plus;

  constant MVL9_to_char : char_indexed_by_MVL9 := "UX01ZWLH-";
  constant char_to_MVL9 : MVL9_indexed_by_char :=
    ('U' => 'U', 'X' => 'X', '0' => '0', '1' => '1', 'Z' => 'Z',
     'W' => 'W', 'L' => 'L', 'H' => 'H', '-' => '-', others => 'U');
  constant char_to_MVL9plus : MVL9plus_indexed_by_char :=
    ('U' => 'U', 'X' => 'X', '0' => '0', '1' => '1', 'Z' => 'Z',
     'W' => 'W', 'L' => 'L', 'H' => 'H', '-' => '-', others => error);

  procedure write (
    L         : inout LINE;             -- input line
    VALUE     : in    UNRESOLVED_float;            -- floating point input
    JUSTIFIED : in    SIDE  := right;
    FIELD     : in    WIDTH := 0) is
    variable s     : STRING(1 to value'high - value'low +3);
    variable sindx : INTEGER;
  begin  -- function write
    s(1)  := MVL9_to_char(STD_ULOGIC(VALUE(VALUE'high)));
    s(2)  := ':';
    sindx := 3;
    for i in VALUE'high-1 downto 0 loop
      s(sindx) := MVL9_to_char(STD_ULOGIC(VALUE(i)));
      sindx    := sindx + 1;
    end loop;
    s(sindx) := ':';
    sindx    := sindx + 1;
    for i in -1 downto VALUE'low loop
      s(sindx) := MVL9_to_char(STD_ULOGIC(VALUE(i)));
      sindx    := sindx + 1;
    end loop;
    write(L, s, JUSTIFIED, FIELD);
  end procedure write;

  procedure READ(L : inout LINE; VALUE : out UNRESOLVED_float) is
    -- Possible data:  0:0000:0000000
    --                 000000000000
    variable c      : CHARACTER;
    variable readOk : BOOLEAN;
    variable i      : INTEGER;          -- index variable
  begin  -- READ
    loop                                -- skip white space
      read(l, c, readOk);
      exit when ((readOk = false) or ((c /= ' ') and (c /= CR) and (c /= HT)));
    end loop;
    for i in value'high downto value'low loop
      value(i) := 'X';
    end loop;
    i := value'high;
    readloop : loop
      if readOk = false then            -- Bail out if there was a bad read
        report FLOAT_GENERIC_PKG'instance_name
          & " READ(float): "
          & "Error end of file encountered.";
        return;
      elsif c = ' ' or c = CR or c = HT then  -- reading done.
        if (i /= value'low) then
          report FLOAT_GENERIC_PKG'instance_name
            & " READ(float): "
            & "Warning: Value truncated.";
          return;
        end if;
      elsif c = ':' or c = '.' then    -- seperator, ignore
        if not (i = -1 or i = value'high-1) then
          report FLOAT_GENERIC_PKG'instance_name
            & " READ(float):  "
            & "Warning: Separator point does not match number format: '"
            & c & "' encountered at location " & INTEGER'image(i) & ".";
        end if;
      elsif (char_to_MVL9plus(c) = error) then
        report FLOAT_GENERIC_PKG'instance_name
          & " READ(float): "
          & "Error: Character '" & c & "' read, expected STD_ULOGIC literal.";
        return;
      else
        value (i) := char_to_MVL9(c);
        i         := i - 1;
        if i < value'low then
          return;
        end if;
      end if;
      read(l, c, readOk);
    end loop readloop;
  end procedure READ;

  procedure READ(L : inout LINE; VALUE : out UNRESOLVED_float; GOOD : out BOOLEAN) is
    -- Possible data:  0:0000:0000000
    --                 000000000000
    variable c      : CHARACTER;
    variable i      : INTEGER;          -- index variable
    variable readOk : BOOLEAN;
  begin  -- READ
    loop                                -- skip white space
      read(l, c, readOk);
      exit when ((readOk = false) or ((c /= ' ') and (c /= CR) and (c /= HT)));
    end loop;
    for i in value'high downto value'low loop
      value(i) := 'X';
    end loop;
    i    := value'high;
    good := true;
    readloop : loop
      if readOk = false then            -- Bail out if there was a bad read
        good := false;
        return;
      elsif c = ' ' or c = CR or c = HT then  -- reading done
        good := false;
        return;
      elsif c = ':' or c = '.' then    -- seperator, ignore
        good := (i = -1 or i = value'high-1);
      elsif (char_to_MVL9plus(c) = error) then
        good := false;
        return;
      else
        value (i) := char_to_MVL9(c);
        i         := i - 1;
        if i < value'low then
          return;
        end if;
      end if;
      read(l, c, readOk);
    end loop readloop;
  end procedure READ;

  procedure owrite (
    L         : inout LINE;             -- access type (pointer)
    VALUE     : in    UNRESOLVED_float;            -- value to write
    JUSTIFIED : in    SIDE  := right;   -- which side to justify text
    FIELD     : in    WIDTH := 0) is    -- width of field
  begin
    write (L         => L,
           VALUE     => to_ostring(VALUE),
           JUSTIFIED => JUSTIFIED,
           FIELD     => FIELD);
  end procedure owrite;

  procedure OREAD(L : inout LINE; VALUE : out UNRESOLVED_float) is
    constant ne     : INTEGER := ((value'length+2)/3) * 3;  -- pad
    variable slv    : STD_LOGIC_VECTOR (ne-1 downto 0);     -- slv
    variable dummy  : CHARACTER;        -- to read the "."
    variable igood  : BOOLEAN;
    variable nybble : STD_LOGIC_VECTOR (2 downto 0);        -- 3 bits
    variable i      : INTEGER;
  begin
    OREAD (L     => L,
           VALUE => nybble,
           good  => igood);
    assert (igood)
      report FLOAT_GENERIC_PKG'instance_name
      & " OREAD: Failed to skip white space " & L.all
      severity error;
    i                     := ne-1 - 3;  -- Top - 3
    slv (ne-1 downto i+1) := nybble;
    while (i /= -1) and igood and L.all'length /= 0 loop
      if (L.all(1) = '.') or (L.all(1) = ':') then
        read (L, dummy);
      else
        OREAD (L     => L,
               VALUE => nybble,
               good  => igood);        
        assert (igood)
          report FLOAT_GENERIC_PKG'instance_name
          & " OREAD: Failed to read the string " & L.all
          severity error;
        slv (i downto i-2) := nybble;
        i                  := i - 3;
      end if;
    end loop;
    assert igood and                    -- We did not get another error
      (i = -1) and                      -- We read everything, and high bits 0
      (or (slv(ne-1 downto VALUE'high-VALUE'low+1)) = '0')
      report FLOAT_GENERIC_PKG'instance_name
      & " OREAD: Vector truncated."
      severity error;
    value := to_float (slv(VALUE'high-VALUE'low downto 0),
                       value'high, -value'low);
  end procedure OREAD;

  procedure OREAD(L : inout LINE; VALUE : out UNRESOLVED_float; GOOD : out BOOLEAN) is
    constant ne     : INTEGER := ((value'length+2)/3) * 3;  -- pad
    variable slv    : STD_LOGIC_VECTOR (ne-1 downto 0);     -- slv
    variable dummy  : CHARACTER;        -- to read the "."
    variable igood  : BOOLEAN;
    variable nybble : STD_LOGIC_VECTOR (2 downto 0);        -- 3 bits
    variable i      : INTEGER;
  begin
    OREAD (L     => L,
           VALUE => nybble,
           good  => igood);
    i                     := ne-1 - 3;  -- Top - 3
    slv (ne-1 downto i+1) := nybble;
    while (i /= -1) and igood and L.all'length /= 0 loop
      if (L.all(1) = '.') or (L.all(1) = ':') then
        read (L, dummy, igood);
      else
        OREAD (L     => L,
               VALUE => nybble,
               good  => igood);        
        slv (i downto i-2) := nybble;
        i                  := i - 3;
      end if;
    end loop;
    good := igood and                   -- We did not get another error
            (i = -1) and                -- We read everything, and high bits 0
            (or (slv(ne-1 downto VALUE'high-VALUE'low+1)) = '0');
    value := to_float (slv(VALUE'high-VALUE'low downto 0),
                       value'high, -value'low);
  end procedure OREAD;

  procedure hwrite (
    L         : inout LINE;             -- access type (pointer)
    VALUE     : in    UNRESOLVED_float;            -- value to write
    JUSTIFIED : in    SIDE  := right;   -- which side to justify text
    FIELD     : in    WIDTH := 0) is    -- width of field
  begin
    write (L         => L,
           VALUE     => to_hstring(VALUE),
           JUSTIFIED => JUSTIFIED,
           FIELD     => FIELD);
  end procedure hwrite;

  procedure HREAD(L : inout LINE; VALUE : out UNRESOLVED_float) is
    constant ne     : INTEGER := ((value'length+3)/4) * 4;  -- pad
    variable slv    : STD_LOGIC_VECTOR (ne-1 downto 0);     -- slv
    variable dummy  : CHARACTER;        -- to read the "."
    variable igood  : BOOLEAN;
    variable nybble : STD_LOGIC_VECTOR (3 downto 0);        -- 4 bits
    variable i      : INTEGER;
  begin
    HREAD (L     => L,
           VALUE => nybble,
           good  => igood);
    assert (igood)
      report FLOAT_GENERIC_PKG'instance_name
      & " HREAD: Failed to skip white space " & L.all
      severity error;
    i                      := ne - 1 - 4;                   -- Top - 4
    slv (ne -1 downto i+1) := nybble;
    while (i /= -1) and igood and L.all'length /= 0 loop
      if (L.all(1) = '.') or (L.all(1) = ':') then
        read (L, dummy);
      else
        HREAD (L     => L,
               VALUE => nybble,
               good  => igood);        
        assert (igood)
          report FLOAT_GENERIC_PKG'instance_name
          & " HREAD: Failed to read the string " & L.all
          severity error;
        slv (i downto i-3) := nybble;
        i                  := i - 4;
      end if;
    end loop;
    assert igood and                    -- We did not get another error
      (i = -1) and                      -- We read everything
      (or (slv(ne-1 downto VALUE'high-VALUE'low+1)) = '0')
      report FLOAT_GENERIC_PKG'instance_name
      & " HREAD: Vector truncated."
      severity error;
    value := to_float (slv(VALUE'high-VALUE'low downto 0),
                       value'high, -value'low);
  end procedure HREAD;

  procedure HREAD(L : inout LINE; VALUE : out UNRESOLVED_float; GOOD : out BOOLEAN) is
    constant ne     : INTEGER := ((value'length+3)/4) * 4;  -- pad
    variable slv    : STD_LOGIC_VECTOR (ne-1 downto 0);     -- slv
    variable dummy  : CHARACTER;        -- to read the "."
    variable igood  : BOOLEAN;
    variable nybble : STD_LOGIC_VECTOR (3 downto 0);        -- 4 bits
    variable i      : INTEGER;
  begin
    HREAD (L     => L,
           VALUE => nybble,
           good  => igood);
    i                     := ne - 1 - 4;                    -- Top - 4
    slv (ne-1 downto i+1) := nybble;
    while (i /= -1) and igood and L.all'length /= 0 loop
      if (L.all(1) = '.') or (L.all(1) = ':') then
        read (L, dummy, igood);
      else
        HREAD (L     => L,
               VALUE => nybble,
               good  => igood);        
        slv (i downto i-3) := nybble;
        i                  := i - 4;
      end if;
    end loop;
    good := igood and                   -- We did not get another error
            (i = -1) and                -- We read everything, and high bits 0
            (or (slv(ne-1 downto VALUE'high-VALUE'low+1)) = '0');
    value := to_float (slv(VALUE'high-VALUE'low downto 0),
                       value'high, -value'low);
  end procedure HREAD;

  function to_string (value     : UNRESOLVED_float) return STRING is
    variable s     : STRING(1 to value'high - value'low +3);
    variable sindx : INTEGER;
  begin  -- function write
    s(1)  := MVL9_to_char(STD_ULOGIC(VALUE(VALUE'high)));
    s(2)  := ':';
    sindx := 3;
    for i in VALUE'high-1 downto 0 loop
      s(sindx) := MVL9_to_char(STD_ULOGIC(VALUE(i)));
      sindx    := sindx + 1;
    end loop;
    s(sindx) := ':';
    sindx    := sindx + 1;
    for i in -1 downto VALUE'low loop
      s(sindx) := MVL9_to_char(STD_ULOGIC(VALUE(i)));
      sindx    := sindx + 1;
    end loop;
    return s;
  end function to_string;

  function to_hstring (value     : UNRESOLVED_float) return STRING is
    variable slv : STD_LOGIC_VECTOR (value'length-1 downto 0);
  begin
    floop : for i in slv'range loop
      slv(i) := to_X01Z (value(i + value'low));
    end loop floop;
    return to_hstring (slv);
  end function to_hstring;

  function to_ostring (value     : UNRESOLVED_float) return STRING is
    variable slv : STD_LOGIC_VECTOR (value'length-1 downto 0);
  begin
    floop : for i in slv'range loop
      slv(i) := to_X01Z (value(i + value'low));
    end loop floop;
    return to_ostring (slv);
  end function to_ostring;

  function from_string (
    bstring                 : STRING;   -- binary string
    constant exponent_width : NATURAL := float_exponent_width;
    constant fraction_width : NATURAL := float_fraction_width)
    return UNRESOLVED_float is
    variable result : UNRESOLVED_float (exponent_width downto -fraction_width);
    variable L      : LINE;
    variable good   : BOOLEAN;
  begin
    L := new STRING'(bstring);
    read (L, result, good);
    deallocate (L);
    assert (good)
      report FLOAT_GENERIC_PKG'instance_name
      & " from_string: Bad string " & bstring
      severity error;
    return result;
  end function from_string;

  function from_ostring (
    ostring                 : STRING;   -- Octal string
    constant exponent_width : NATURAL := float_exponent_width;
    constant fraction_width : NATURAL := float_fraction_width)
    return UNRESOLVED_float is
    variable result : UNRESOLVED_float (exponent_width downto -fraction_width);
    variable L      : LINE;
    variable good   : BOOLEAN;
  begin
    L := new STRING'(ostring);
    oread (L, result, good);
    deallocate (L);
    assert (good)
      report FLOAT_GENERIC_PKG'instance_name
      & " from_ostring: Bad string " & ostring
      severity error;
    return result;
  end function from_ostring;

  function from_hstring (
    hstring                 : STRING;   -- hex string
    constant exponent_width : NATURAL := float_exponent_width;
    constant fraction_width : NATURAL := float_fraction_width)
    return UNRESOLVED_float is
    variable result : UNRESOLVED_float (exponent_width downto -fraction_width);
    variable L      : LINE;
    variable good   : BOOLEAN;
  begin
    L := new STRING'(hstring);
    hread (L, result, good);
    deallocate (L);
    assert (good)
      report FLOAT_GENERIC_PKG'instance_name
      & " from_hstring: Bad string " & hstring
      severity error;
    return result;
  end function from_hstring;

  function from_string (
    bstring  : STRING;                  -- binary string
    size_res : UNRESOLVED_float)                   -- used for sizing only 
    return UNRESOLVED_float is
  begin
    return from_string (bstring        => bstring,
                        exponent_width => size_res'high,
                        fraction_width => -size_res'low);
  end function from_string;

  function from_ostring (
    ostring  : STRING;                  -- Octal string
    size_res : UNRESOLVED_float)                   -- used for sizing only 
    return UNRESOLVED_float is
  begin
    return from_ostring (ostring        => ostring,
                         exponent_width => size_res'high,
                         fraction_width => -size_res'low);
  end function from_ostring;

  function from_hstring (
    hstring  : STRING;                  -- hex string
    size_res : UNRESOLVED_float)                   -- used for sizing only 
    return UNRESOLVED_float is
  begin
    return from_hstring (hstring        => hstring,
                         exponent_width => size_res'high,
                         fraction_width => -size_res'low);
  end function from_hstring;
end package body float_generic_pkg;

