-- file numeric_bit_tb3.vhd is a simulation testbench for 
-- IEEE 1076.3 numeric_bit package.
-- This is the third file in the series, following
-- numeric_bit_tb2.vhd
--
library IEEE;

use IEEE.numeric_bit.all;

entity test is 
end entity std_nbitc73to84;

architecture t1 of test is  
  -- for c1_ Bhasker tests
  signal ANULL: UNSIGNED (0 downto 1);
  signal BNULL: UNSIGNED (0 downto 1);
  signal SANULL: SIGNED (0 downto 1);
  signal SBNULL: SIGNED (0 downto 1);
begin
  process
    variable svec : signed(3 downto 0);
    variable svec1 : signed(4 downto 0);
    variable svec2 : signed(4 downto 0);
    variable rsvec : signed(9 downto 0);
    variable usvec : unsigned(3 downto 0);
    variable buvec : unsigned(63 downto 0);
    variable un_nul : unsigned(0 downto 3);
    variable si_nul : signed(0 downto 3);
    variable sir_nul : signed(0 downto 3);

    variable rbit : bit;

  begin
    -- C.75
    usvec := "0111";
    rbit := "?="(23, usvec);
    assert rbit = '0'
      report "Error: C.75 did not return expected '0'"
      severity failure;
    rbit := "?="(7, usvec);
    assert rbit = '1'
      report "Error: C.75 did not return expected '1'"
      severity failure;
    
    -- C.76
    svec := "1001";
    --report integer'image(to_integer(svec));
    assert (-7 ?= svec) = '1'
      report "Error: C.76 did not return expected '1'"
      severity failure;
    assert (-23 ?= svec) = '0'
      report "Error: C.76 did not return expected '0'"
      severity failure;

    -- C.77
    assert (usvec ?= 23) = '0'
      report "Error: C.77 did not return expected '0'"
      severity failure;
    assert (usvec ?= 7) = '1'
      report "Error: C.77 did not return expected '1'"
      severity failure;

    -- C.78
    assert (svec ?= -7) = '1'
      report "Error: C.78 did not return expected '1'"
      severity failure;
    assert (svec ?= -8) = '0'
      report "Error: C.78 did not return expected '0'"
      severity failure;
    
    -- C.81
    assert (23 ?/= usvec) = '1'
      report "Error: C.81 did not return expected '1'"
      severity failure;
    assert (7 ?/= usvec) = '0'
      report "Error: C.81 did not return expected '0'"
      severity failure;
    
    -- C.82
    assert (-7 ?/= svec) = '0'
      report "Error: C.82 did not return expected '0'"
      severity failure;
    assert (-6 ?/= svec) = '1'
      report "Error: C.82 did not return expected '1'"
      severity failure;
    
    -- C.83
    assert (usvec ?/= 23) = '1'
      report "Error: C.83 did not return expected '1'"
      severity failure;
    assert (usvec ?/= 7) = '0'
      report "Error: C.83 did not return expected '0'"
      severity failure;
    
    -- C.84
    assert (svec ?/= -7) = '0'
      report "Error: C.84 did not return expected '0'"
      severity failure;
    assert (svec ?/= -6) = '1'
      report "Error: C.84 did not return expected '1'"
      severity failure;
    
    wait;
  end process;
end architecture t1; test 



