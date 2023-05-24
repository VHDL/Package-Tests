-------------------------------------------------------------------------------
-- Synthesis test for the floating point math package
-- This test is designed to be synthesizable and exercise much of the package.
-- Created for vhdl-200x by David Bishop (dbishopx@gmail.com)
-- --------------------------------------------------------------------
--   modification history : Last Modified $Date: 2006-06-08 10:50:32-04 $
--   Version $Id: float_synth.vhdl,v 1.1 2006-06-08 10:50:32-04 l435385 Exp $
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;
use ieee.float_pkg.all;
use ieee.math_real.all;

entity float1 is
  
end entity float1;

architecture rtl of float1 is
  subtype fp16 is float (6 downto -9);    -- 16 bit
  
begin  -- architecture rtl

  -- purpose: "0000" test the "+" operator
  cmd0reg: process (clk, rst_n) is
    variable f1 : fp16;
    variable f2 : fp16;
    variable rf : fp16;
  begin  -- process cmd0reg
    for i in -13 to 13 loop
        f1 := fp16'i;
        f2 := fp16'i + 0.25;
        rf := f1 + f2;
    end loop;

  end process cmd0reg;


end architecture rtl;

