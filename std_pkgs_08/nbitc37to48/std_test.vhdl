-- file numeric_bit_tb3.vhd is a simulation testbench for 
-- IEEE 1076.3 numeric_bit package.
-- This is the third file in the series, following
-- numeric_bit_tb2.vhd
--
library IEEE;

use IEEE.numeric_bit.all;

entity test is 
end entity;

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

  begin
    -- C.37
    usvec := "0010";
    un_nul := minimum(un_nul, usvec);
    report "C.37 Null return value: '" & to_string(un_nul) & "'";
    un_nul := minimum(usvec, un_nul);
    report "C.37 Null return value: '" & to_string(un_nul) & "'";
    
    -- C.38
    svec := "0010";
    si_nul := minimum(si_nul, svec);
    report "C.38 Null return value: '" & to_string(si_nul) & "'";
    si_nul := minimum(svec, si_nul);
    report "C.38 Null return value: '" & to_string(si_nul) & "'";
    
    -- C.39
    usvec := "0011";
    assert minimum(2,usvec) = "0010"
      report "Min of unsigned 2 and '0011' was not: " & to_string(minimum(2,usvec))
      severity failure;
    
    -- C.40
    svec := "1011";
    assert minimum(2,svec) = "1011"
      report "Min of signed 2 and '1011' was not: " & to_string(minimum(2,svec))
      severity failure;
    
    -- C.41
    usvec := "0011";
    assert minimum(usvec,2) = "0010"
      report "Min of unsigned 2 and '0011' was not: " & to_string(minimum(2,usvec))
      severity failure;
    
    -- C.42
    svec := "1011";
    assert minimum(svec,2) = "1011"
      report "Min of signed 2 and '1011' was not: " & to_string(minimum(2,svec))
      severity failure;
    
    -- C.43
    usvec := "0010";
    un_nul := maximum(un_nul, usvec);
    report "C.43 Null return value: '" & to_string(un_nul) & "'";
    un_nul := maximum(usvec, un_nul);
    report "C.43 Null return value: '" & to_string(un_nul) & "'";
    
    -- C.44
    svec := "0010";
    si_nul := maximum(si_nul, svec);
    report "C.44 Null return value: '" & to_string(si_nul) & "'";
    si_nul := maximum(svec, si_nul);
    report "C.44 Null return value: '" & to_string(si_nul) & "'";
    
    -- C.45
    usvec := "0011";
    assert maximum(2,usvec) = "0011"
      report "Max of unsigned 2 and '0011' was not: " & to_string(maximum(2,usvec))
      severity failure;
    
    -- C.46
    svec := "1011";
    assert maximum(2,svec) = "0010"
      report "Max of signed 2 and '1011' was not: " & to_string(maximum(2,svec))
      severity failure;
    
    -- C.47
    usvec := "0011";
    assert maximum(usvec,2) = "0011"
      report "Max of unsigned 2 and '0011' was not: " & to_string(maximum(2,usvec))
      severity failure;
    
    -- C.48
    svec := "1011";
    assert maximum(svec,2) = "0010"
      report "Min of signed 2 and '1011' was not: " & to_string(maximum(2,svec))
      severity failure;
    
    wait;
  end process;
end architecture; 



