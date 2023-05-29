-----------------------------------------------------------------
--   hit  terminating error  vector nand different lengths.
-----------------------------------------------------------------------------
-- Title      : Test routines for the new functions in std_logic_1164
--  Created for VHDL-200X-ft, David Bishop (dbishopx@gmail.com)
--  Extended for coverage.
-----------------------------------------------------------------------------
entity test is 
end entity std_std1164_3;

library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

architecture testbench of test is 
begin
  
  process
  
    variable sulv1 : std_ulogic_vector(7 downto 0);
    variable sulv2 : std_ulogic_vector(7 downto 0);
    variable sulv3 : std_logic_vector(9 downto 0) := (others => '0');
    variable sulvr : std_ulogic_vector(7 downto 0);
    
  
  begin
  
    sulv1 := "00000000";
    sulv2 := "11111111";
    --  simulation termination  error
    sulvr := sulv1 nand sulv3;
    
    wait;
  end process;
  
  
end architecture testbench; test 


