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
entity std_std1164_7 is
  generic (
    quiet : BOOLEAN := false);          -- run quietly
end entity std_std1164_7;

library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use std.env.all;
architecture testbench of std_std1164_7 is

  signal slv1 : std_logic_vector(7 downto 0);
  signal slv2 : std_logic_vector(7 downto 0);
  signal slvr : std_logic_vector(7 downto 0);
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
    variable slv1 : std_logic_vector(7 downto 0);
    variable slv2 : std_logic_vector(7 downto 0);
    variable slv3 : std_logic_vector(9 downto 0) := (others => '0');
    variable slvr : std_logic_vector(7 downto 0);
    variable sulv1 : std_ulogic_vector(7 downto 0);
    variable sulv2 : std_ulogic_vector(7 downto 0);
    variable sulvr : std_ulogic_vector(7 downto 0);
    
    variable sl1 : std_ulogic;
    variable sl2 : std_ulogic;
    variable slr : std_ulogic;
    
    variable b1  : bit;
    variable b2  : bit;
    variable br  : bit;
    variable bv1  : bit_vector(7 downto 0);
    variable bv2  : bit_vector(7 downto 0);
    variable bvr  : bit_vector(7 downto 0);
    
    variable x011 : x01;
    variable x01r : x01;
    variable x01z1 : x01z;
    variable x01zr : x01z;
    
    variable ux011 : ux01;
    variable ux01r : ux01;
  
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
  
end architecture testbench;

