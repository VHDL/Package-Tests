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
end entity std1164_2;

library not_ieee;
use not_ieee.std_logic_1164.all;
use std.textio.all;
use std.env.all;
architecture testbench of test is 

  signal slv1 : std_logic_vector(7 downto 0);
  signal slv2 : std_logic_vector(7 downto 0);
  signal slvr : std_logic_vector(7 downto 0);
  
begin
  
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
  
    slvr := slv1 nand slv2;
    sulvr := sulv1 nand sulv2;
    assert slvr = "UUUUUUUU"
      report "Error:  nand of undefined vectors does not produce a vector of undefined."
      severity failure;
    assert sulvr = "UUUUUUUU"
      report "Error:  nand of undefined vectors does not produce a vector of undefined."
      severity failure;
    slr  := sl1 nand sl2;
    assert slr = 'U'
      report "Error:  nand of undefined std_ulogic does not produce an output of undefined."
      severity failure;
    
    slv1 := "00000000";
    slv2 := "11111111";
    sulv1 := "00000000";
    sulv2 := "11111111";
    sl1  := '1';
    sl2  := '0';
    slvr := slv1 nand slv2;
    sulvr := sulv1 nand sulv2;
    assert slvr = "11111111"
      report "Error:  nand of vectors does not produce the expected output."
      severity failure;
    assert sulvr = "11111111"
      report "Error:  nand of vectors does not produce the expected output."
      severity failure;
    slr  := sl1 nand sl2;
    assert slr = '1'
      report "Error:  nand of std_ulogic does not produce an output."
      severity failure;
    
    slvr := slv1 nor slv2;
    assert slvr = "00000000"
      report "Error:  nor of vectors does not produce the expected output."
      severity failure;
    slr  := sl1 nor sl2;
    assert slr = '0'
      report "Error:  nand of std_ulogic does not produce an output."
      severity failure;

    slvr := slv1 xnor slv2;
    assert slvr = "00000000"
      report "Error:  xnor of vectors does not produce the expected output."
      severity failure;
    slr  := sl1 xnor sl2;
    assert slr = '0'
      report "Error:  nand of undefined std_ulogic does not produce an output of undefined."
      severity failure;
    
    --  size diffs in  std1164_3-6
    
    --  conversion functions.
    for i in std_ulogic'low to std_ulogic'high loop
      sl1 := i;
      br := to_bit(sl1);
      if sl1 = '1' or sl1 = 'H' then
        assert br = '1'
          report "Error:  to_bit of  1 or H did not return 1"
          severity failure;
      elsif  sl1 = '0' or sl1 = 'L' then
        assert br = '0'
          report "Error:  to_bit of  0 or L did not return 0"
          severity failure;
      else
        assert br = '0'
          report "Error:  to_bit of others did not return default 0"
          severity failure;
        br := to_bit(sl1, '1');
        assert br = '1'
          report "Error:  to_bit of others did not return remap of  1"
          severity failure;
      end if;
    end loop;
    
    b1  := '0';
    slr := to_stdulogic(b1);
    assert slr = '0'
      report "Error:  to_stdulogic did not covert a bit '0' correctly."
      severity failure;
    b1  := '1';
    slr := to_stdulogic(b1);
    assert slr = '1'
      report "Error:  to_stdulogic did not covert a bit '1' correctly."
      severity failure;
    
    --  to_01  std_ulogic
    --  conversion functions.
    for i in std_ulogic'low to std_ulogic'high loop
      sl1 := i;
      slr := to_01(sl1);
      if sl1 = '1' or sl1 = 'H' then
        assert slr = '1'
          report "Error:  to_01 of  1 or H did not return 1"
          severity failure;
      elsif  sl1 = '0' or sl1 = 'L' then
        assert slr = '0'
          report "Error:  to_01 of  0 or L did not return 0"
          severity failure;
      else
        assert slr = '0'
          report "Error:  to_01 of others did not return default 0"
          severity failure;
        slr := to_01(sl1, '1');
        assert slr = '1'
          report "Error:  to_01 of others did not return remap of  1"
          severity failure;
      end if;
    end loop;
    
    --  to_01 bit_vector ->  std_ulogic_vector
    bv1 := "01010101";
    sulvr := to_01(bv1);
    assert sulvr = "01010101"
      report "Error:  to_01 did not return the correct std_ulogic_vector value."
      severity failure;

    b1  := '1';
    sl1  := '1';
    slr := to_01(b1);
    assert slr = sl1
      report "Error:  to_01 did not return the correct std_ulogic value."
      severity failure;

    b1  := '0';
    sl1  := '0';
    slr := to_01(b1);
    assert slr = sl1
      report "Error:  to_01 did not return the correct std_ulogic value."
      severity failure;

    -- to_x01
    sl1  := '1';
    x011 := '1';
    x01r  := to_x01(sl1);
    assert x01r = x011
      report "Error:  to_x01  did not return the correct value from conversion"
      severity failure;
    sl1  := 'U';
    x011 := 'X';
    x01r  := to_x01(sl1);
    assert x01r = x011
      report "Error:  to_x01  did not return the correct value from conversion"
      severity failure;
    sl1  := '-';
    x011 := 'X';
    x01r  := to_x01(sl1);
    assert x01r = x011
      report "Error:  to_x01  did not return the correct value from conversion"
      severity failure;
    sl1  := 'Z';
    x011 := 'X';
    x01r  := to_x01(sl1);
    assert x01r = x011
      report "Error:  to_x01  did not return the correct value from conversion"
      severity failure;
      
    bv1 := "01101001";
    sulvr := to_x01(bv1);
    assert sulvr = "01101001"
      report "Error to_x01 on bit_vector did not return the correct std_ulogic_vector"
      severity failure;
    
    -- to_x01
    b1 := '1';
    x01r := to_x01(b1);
    b1 := '0';
    x01r := to_x01(b1);
    
    -- to_x01z
    for i in std_ulogic'low to std_ulogic'high loop
      sl1 := i;
      x01zr := to_x01z(sl1);
      if sl1 = '1' or sl1 = 'H' then
        assert x01zr = '1'
          report "Error:  to_x01z of  1 or H did not return 1"
          severity failure;
      elsif  sl1 = '0' or sl1 = 'L' then
        assert x01zr = '0'
          report "Error:  to_x01z of  0 or L did not return 0"
          severity failure;
      elsif  sl1 = 'Z' then
        assert x01zr = 'Z'
          report "Error:  to_x01z of Z did not return Z"
          severity failure;
      else
        assert x01zr = 'X'
          report "Error: to_x01z others did not return X"
          severity failure;
      end if;
    end loop;
    
    bv1 := "01010101";
    sulvr := to_x01z(bv1);
    assert sulvr = "01010101"
      report "Error: to_x10z given a bit_vector does not result in the expected std_ulogic_vector."
      severity failure;
    
    b1 := '1';
    x01zr := to_x01z(b1);
    assert x01zr = '1'
      report "Error: to_x10z given a bit does not result in the expected  x01z  value."
      severity failure;
    b1 := '0';
    x01zr := to_x01z(b1);
    assert x01zr = '0'
      report "Error: to_x10z given a bit does not result in the expected  x01z  value."
      severity failure;
    
    --  to ux01
    for i in std_ulogic'low to std_ulogic'high loop
      ux01r := to_ux01(i);
      --report to_string(i) & "";
      if i = '1' or i = 'H' then
        assert ux01r = '1'
          report "Error: to_ux01 given 1 or H did not return 1"
          severity failure;
      elsif i = '0' or i = 'L' then
        assert ux01r = '0'
          report "Error: to_ux01 given 0 or L did not return 0"
          severity failure;
      elsif i = 'U' then
        assert ux01r = 'U'
          report "Error: to_ux01 given U did not return U"
          severity failure;
      else
        assert ux01r = 'X'
          report "Error: to_ux01 given others did not return X"
          severity failure;
        
      end if;
    end loop;
    
    bv1  := "01010101";
    sulvr :=  to_ux01(bv1);
    assert sulvr = "01010101"
      report "Error: to_ux01 given a bit_vector did not return the correct std_ulogic_vector"
      severity failure;
      
    b1 := '1';
    ux01r := to_ux01(b1);
      assert ux01r = '1'
        report "Error: to_ux01 given bit 1 not return 1"
        severity failure;
    b1 := '0';
    ux01r := to_ux01(b1);
      assert ux01r = '0'
        report "Error: to_ux01 given bit 0 not return 0"
        severity failure;
    
    report "Test Passed ...   terminating";
    finish;
  end process;
  
  
end architecture testbench; test 


