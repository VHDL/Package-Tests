-----------------------------------------------------------------------------
-- Title      : Test routines for the new functions in std_logic_1164
--              for vhdl-200x-ft
-- check of to_slv and to_bv aliases
-- check of all to_string functions
-- check of all read and write functions
-- check of all std_ulogic and boolean functions
-- check of the implicit minimum and maximum functions
-- Last Modified: $Date: 2006-06-16 16:05:36-04 $
-- RCS ID: $Id: test_new1164.vhdl,v 1.1 2006-06-16 16:05:36-04 l435385 Exp $
--
--  Created for VHDL-200X-ft, David Bishop (dbishopx@gmail.com)
-----------------------------------------------------------------------------
entity test is 
  generic (
    quiet : BOOLEAN := false);          -- run quietly
end entity;

library not_ieee;
use not_ieee.std_logic_1164.all;
use std.textio.all;
use std.env.all;
architecture testbench of test is 

  signal clk : std_logic := '0';
  
begin
  --  rising and falling  edge functions
  process
    variable cnt : integer := 0;
  begin
    clk <= not clk;
    wait for 1 ns;
    cnt := cnt + 1;
    if cnt > 10 then
      wait;
    end if;
  end process;
  
  process(clk)
  begin
    if rising_edge(clk) then
      report "Rising edge ...";
    end if;
    if falling_edge(clk) then
       report "Falling edge ...";
    end if;
  end process;
  
  
  process
  
  begin
    --  is_x
    for i in std_logic'low to std_logic'high loop
      --report to_string(i);
      case i is
        when 'U' | 'Z' | 'X' | 'W' | '-' =>
          assert is_x(i)
            report "Error: is_x expected return true but did not."
            severity failure;
        when others =>
          assert not is_x(i)
            report "Error: is_x expected return true but did not."
            severity failure;
      end case;
    end loop;
    wait;
  end process;
  
end architecture;


