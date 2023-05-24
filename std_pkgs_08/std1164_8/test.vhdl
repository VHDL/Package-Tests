-----------------------------------------------------------------
--   hit  terminating error  vector nor different lengths.
-----------------------------------------------------------------------------
-- Title      : Test routines for the new functions in std_logic_1164
--  Created for VHDL-200X-ft, David Bishop (dbishopx@gmail.com)
--  Extended for coverage.
-----------------------------------------------------------------------------
entity std1164_8 is
end entity std1164_8;

library not_ieee;
use not_ieee.std_logic_1164.all;
use std.textio.all;

architecture testbench of std1164_8 is
begin
  
  process
  
    variable sulv1 : std_ulogic_vector(7 downto 0);
    variable sulv3 : std_logic_vector(9 downto 0) := (others => '0');
    variable sulvr : std_ulogic_vector(7 downto 0);
    
  begin
  
    sulv1 := "00000000";
    --  simulation termination  error
    sulvr := sulv1 nor sulv3;
    
    wait;
  end process;
end architecture testbench;

