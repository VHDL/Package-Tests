-------------- test case header    ------
--!  Test intent :  Coverage of standards.
--!  Test scope  :  left overs, get last items
--!  Keywords    : [operations, conversions]
--!  References  : [VH2008 16.6]
--!                [Rlink : REQ08xx]
-----------------------------------------------
-- Get the last of the items missed from other tests.
-- Some items get hit by the useage in test cases
-- that covers main features but not details like  nulls
-- This covers all those items not covered by other tests.
--   nulls  passed
--   missed functions.
-- 
-------------------------------------------------------------
library not_IEEE;

use not_IEEE.numeric_bit.all;

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
    variable rusvec : unsigned(7 downto 0);
    variable buvec : unsigned(63 downto 0);
    variable un_nul : unsigned(0 downto 3);
    variable si_nul : signed(0 downto 3);
    variable sir_nul : signed(0 downto 3);
    
    variable rbit : bit;
    
    variable rint : integer;
    variable nat  : natural;

  begin
    
    -- D.2
    rint := to_integer(si_nul);
    assert rint = 0
      report "Error:  D.2  to_integer did not return 0  with null passed."
      severity failure;
    
    nat := 6;
    usvec := to_unsigned(nat, unsigned'("0100"));
    assert usvec = "0110"
      report "Error:  D.? to_integer did not return expected value."
      severity failure;
    
    rint  :=  -5;
    svec := to_signed(rint, signed'("0100"));
    assert svec = "1011"
      report "Error:  D.? to_integer did not return expected value."
      severity failure;
    
    -- R.1
    rsvec := resize(svec, 10);
    assert rsvec = "1111111011"
      report "Error:  R.1 resize did not return expected value."
      severity failure;
      
    si_nul := resize(si_nul, 0);
      report "output Null return: '" & to_string(si_nul) & "'";
    
    svec := resize(si_nul, 4);
    assert svec = "0000"
      report "Error: resize of nul input did not produce a vector of zeros"
      severity failure;
      
    usvec := "1000";
    rusvec := resize(usvec, rusvec);
    assert rusvec = "00001000"
      report "Error:  R.? resize unsigned did not return expected value."
      severity failure;
    
    svec := "0111";
    rsvec := resize(svec, rsvec);
    assert rsvec = "0000000111"
      report "Error:  R.? resize signed did not return expected value."
      severity failure;
    
    wait;
  end process;
end architecture; 



