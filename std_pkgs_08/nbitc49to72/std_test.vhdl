-- file numeric_bit_tb3.vhd is a simulation testbench for 
-- IEEE 1076.3 numeric_bit package.
-- This is the third file in the series, following
-- numeric_bit_tb2.vhd
--
library IEEE;

use IEEE.numeric_bit.all;

entity test is 
end entity std_nbitc49to72;

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
    -- C.51
    usvec := "0111";
    rbit := "?>"(23, usvec);
    assert rbit = '1'
      report "Error: C.51 did not return expected '1'"
      severity failure;
    rbit := "?>"(2, usvec);
    assert rbit = '0'
      report "Error: C.51 did not return expected '0'"
      severity failure;
    
    -- C.52
    svec := "1001";
    assert (23 ?> svec) = '1'
      report "Error: C.51 did not return expected '1'"
      severity failure;
    assert (-23 ?> svec) = '0'
      report "Error: C.51 did not return expected '0'"
      severity failure;

    -- C.53
    rbit := "?>"(usvec, 23);
    assert rbit = '0'
      report "Error: C.53 did not return expected '0'"
      severity failure;
    rbit := "?>"(usvec, 2);
    assert rbit = '1'
      report "Error: C.53 did not return expected '1'"
      severity failure;
    
    -- C.54
    assert (svec ?> 23) = '0'
      report "Error: C.54 did not return expected '0'"
      severity failure;
    assert (svec ?> -22) = '1'
      report "Error: C.54 did not return expected '1'"
      severity failure;
    
    -- C.57
    assert (23 ?< usvec) = '0'
      report "Error: C.57 did not return expected '0'"
      severity failure;
    assert (2 ?< usvec) = '1'
      report "Error: C.57 did not return expected '1'"
      severity failure;
    
    -- C.58
    assert (23 ?< svec) = '0'
      report "Error: C.58 did not return expected '0'"
      severity failure;
    assert (-23 ?< svec) = '1'
      report "Error: C.58 did not return expected '1'"
      severity failure;
    
    -- C.59
    assert (usvec ?< 20) = '1'
      report "Error: C.59 did not return expected '1'"
      severity failure;
    assert (usvec ?< 2) = '0'
      report "Error: C.59 did not return expected '0'"
      severity failure;
    
    -- C.60
    assert (svec ?< 23) = '1'
      report "Error: C.60 did not return expected '1'"
      severity failure;
    assert (svec ?< -20) = '0'
      report "Error: C.60 did not return expected '0'"
      severity failure;
    
    -- C.63
    assert (23 ?<= usvec) = '0'
      report "Error: C.63 did not return expected '0'"
      severity failure;
    assert (3 ?<= usvec) = '1'
      report "Error: C.63 did not return expected '1'"
      severity failure;
    assert (7 ?<= usvec) = '1'
      report "Error: C.63 did not return expected '1'"
      severity failure;
    
    -- C.64
    assert (svec ?<= 23) = '1'
      report "Error: C.64 did not return expected '1'"
      severity failure;
    assert (svec ?<= -23) = '0'
      report "Error: C.64 did not return expected '0'"
      severity failure;
    assert (svec ?<= -7) = '1'
      report "Error: C.64 did not return expected '1'"
      severity failure;
    
    -- C.65
    assert (usvec ?<= 23) = '1'
      report "Error: C.65 did not return expected '1'"
      severity failure;
    assert (usvec ?<= 3) = '0'
      report "Error: C.65 did not return expected '0'"
      severity failure;
    assert (usvec ?<= 7) = '1'
      report "Error: C.65 did not return expected '1'"
      severity failure;
    
    -- C.66
    --report integer'image(to_integer(svec));
    assert (23 ?<= svec) = '0'
      report "Error: C.66 did not return expected '0'"
      severity failure;
    assert (-23 ?<= svec) = '1'
      report "Error: C.66 did not return expected '1'"
      severity failure;
    assert (-7 ?<= svec) = '1'
      report "Error: C.66 did not return expected '1'"
      severity failure;
    
    -- C.69
    assert (23 ?>= usvec) = '1'
      report "Error: C.69 did not return expected '1'"
      severity failure;
    assert (3 ?>= usvec) = '0'
      report "Error: C.69 did not return expected '0'"
      severity failure;
    assert (7 ?>= usvec) = '1'
      report "Error: C.69 did not return expected '1'"
      severity failure;
    
    -- C.70
    assert (23 ?>= svec) = '1'
      report "Error: C.70 did not return expected '1'"
      severity failure;
    assert (-33 ?>= svec) = '0'
      report "Error: C.70 did not return expected '0'"
      severity failure;
    assert (-7 ?>= svec) = '1'
      report "Error: C.70 did not return expected '1'"
      severity failure;

    -- C.71
    assert (usvec ?>= 23) = '0'
      report "Error: C.71 did not return expected '0'"
      severity failure;
    assert (usvec ?>= 3) = '1'
      report "Error: C.71 did not return expected '1'"
      severity failure;
    assert (usvec ?>= 7) = '1'
      report "Error: C.71 did not return expected '1'"
      severity failure;

    -- C.72
    assert (svec ?>= 23) = '0'
      report "Error: C.72 did not return expected '0'"
      severity failure;
    assert (svec ?>= -23) = '1'
      report "Error: C.72 did not return expected '1'"
      severity failure;
    assert (svec ?>= -7) = '1'
      report "Error: C.72 did not return expected '1'"
      severity failure;
  
    wait;
  end process;
end architecture t1; test 



