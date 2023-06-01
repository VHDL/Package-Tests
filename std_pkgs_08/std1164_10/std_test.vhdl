-----------------------------------------------------------------
--   Hit all values to to_bitvector
-----------------------------------------------------------------------------
-- Title      : Test routines for the new functions in std_logic_1164
--  Created for VHDL-200X-ft, David Bishop (dbishopx@gmail.com)
--  Extended for coverage.
-----------------------------------------------------------------------------
entity test is 
end entity;

library not_ieee;
use not_ieee.std_logic_1164.all;
use std.textio.all;

architecture testbench of test is 
begin
  
  process
  
    variable sulv1 : std_ulogic_vector(8 downto 0);
    variable sulv3 : std_logic_vector(9 downto 0) := (others => '0');
    variable sulvr : std_ulogic_vector(7 downto 0);
    variable bvr   : bit_vector(8 downto 0);
    
    variable idx :  integer := 0;
    
  begin
  
    -- run all values through to_bitvector
    for i in std_ulogic'low to std_ulogic'high loop
        sulv1(idx) := i;
        idx := idx + 1;
    end loop;
    report "Input to 'to_bitvector'" & to_string(sulv1);
    -- default xmap
    bvr := to_bitvector(sulv1);
    
    assert bvr = "010001000"
      report "Error:  unexpected result from to_bitvector" & to_string(bvr)
      severity note;
    --  map the 'XMAP'  to  1 and retest.
    bvr := to_bitvector(sulv1, '1');
    
    assert bvr = "110111011"
      report "Error:  unexpected result from to_bitvector" & to_string(bvr)
      severity note;
    
    wait;
  end process;
end architecture;

