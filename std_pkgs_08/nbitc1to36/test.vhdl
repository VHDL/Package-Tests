-------------- test case header    ------
--!  Test intent :  Coverage of standards.
--!  Test scope  :  rational operators
--!  Keywords    : [operations, rational]
--!  References  : [VH2008 16.6]
--!                [Rlink : REQ08xx]
-----------------------------------------------
-- c1 to c36  nulls X's and missed.
-- Additions to the Biship test set
-- IEEE 1076.3 numeric_bit package.
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
    variable buvec : unsigned(63 downto 0);
    variable un_nul : unsigned(0 downto 3);
    variable si_nul : signed(0 downto 3);
    variable sir_nul : signed(0 downto 3);

  begin
    -- C.12
    assert not(si_nul < 7)
      report "Error: C.12 should return false with nul passed"
      severity failure;
    
    -- C.14
    svec := signed("1101");
    assert not(si_nul <= svec)
      report "Error: C.14 should return false with nul passed"
      severity failure;
    assert not(svec <= si_nul)
      report "Error: C.14 should return false with nul passed"
      severity failure;
    
    -- C.15
    assert not(21 <= un_nul)
      report "Error: C.15 should return false with nul passed"
      severity failure;
    usvec := unsigned("0111");
    assert not(127 <= usvec)
      report "Error: C.15 should return false larger natrual passed"
      severity failure;
    
    -- C.16
    for j in -10 to 10 loop
      for k in 10 to 14 loop
        svec2 := to_signed(k, 5);
        assert j <= svec2
          report "Error:  -- C.16 did not return the correct condition for values applied."
          severity failure;
      end loop;
    end loop;
    
    assert not(220 <= svec2)
      report "Error:  -- C.16 did not return correct response to large integer."
      severity failure;
      
    assert not(22 <= si_nul)
      report "Error:  -- C.16 did not return correct response to nul input."
      severity failure;
      
    -- C.18
    for j in -10 to 10 loop
      svec2 := to_signed(j, 5);
      for k in 10 to 14 loop
        assert svec2 <= j
          report "Error:  -- C.18 did not return the correct condition for values applied."
          severity failure;
      end loop;
    end loop;
    
    assert svec2 <= 220
      report "Error:  -- C.18 did not return correct response to large integer."
      severity failure;
      
    assert not(si_nul <= 22)
      report "Error:  -- C.18 did not return correct response to nul input."
      severity failure;
      
    -- C.19
    usvec := unsigned("0111");
    assert not(un_nul >= usvec)
      report "Error:  -- C.19 did not return correct response to nul input."
      severity failure;
    assert not(usvec >= un_nul)
      report "Error:  -- C.19 did not return correct response to nul input."
      severity failure;
    
    -- C.20
    svec := signed("1101");
    assert not(si_nul >= svec)
      report "Error: C.20 should return false with nul passed"
      severity failure;
    assert not(svec >= si_nul)
      report "Error: C.20 should return false with nul passed"
      severity failure;
    
    -- C.21
    usvec := unsigned("0111");
    assert 200 >= usvec
      report "Error:  -- C.21 did not return correct response to small input."
      severity failure;
    assert not(2 >= un_nul)
      report "Error:  -- C.21 did not return correct response to nul input."
      severity failure;
    
    -- C.22
    for j in -10 to 10 loop
      svec2 := to_signed(j, 5);
      for k in 10 to 14 loop
        assert k >= svec2
          report "Error: C22 return not as expected"
          severity failure;
      end loop;
    end loop;
    
    assert not(33 >= si_nul)
      report "Error:  -- C.22 did not return correct response to nul input."
      severity failure;
    
    assert 397 >= svec2
      report "Error:  -- C.22 did not return correct response to big input."
      severity failure;
    
    -- C.23
    assert not(un_nul >= 99)
      report "Error:  -- C.23 did not return correct response to nul input."
      severity failure;
    
    assert not(unsigned("01") >= 99)
      report "Error:  -- C.23 did not return correct response to nul input."
      severity failure;
    
    -- C.24
    for j in -10 to 10 loop
      svec2 := to_signed(j, 5);
      for k in 10 to 14 loop
        assert svec2 >= j
          report "Error: C24 return not as expected"
          severity failure;
      end loop;
    end loop;
    
    assert not(si_nul >= 35)
      report "Error:  -- C.24 did not return correct response to nul input."
      severity failure;
    
    assert not(svec2 >= 200)
      report "Error:  -- C.24 did not return correct response to small input."
      severity failure;
    
    -- C.27
    assert not(2 = un_nul)
      report "Error:  -- C.27 did not return correct response to nul input."
      severity failure;
    
    usvec := "0100";
    assert not(212 = usvec)
      report "Error:  -- C.27 did not return correct response to large input."
      severity failure;
    
    -- C.28
    assert not(35 = si_nul)
      report "Error:  -- C.28 did not return correct response to nul input."
      severity failure;
    
    assert not(200 = svec2)
      report "Error:  -- C.28 did not return correct response to large input."
      severity failure;
    
    -- C.29
    assert not(un_nul = 2)
      report "Error:  -- C.29 did not return correct response to nul input."
      severity failure;
    
    usvec := "0100";
    assert not(usvec = 212)
      report "Error:  -- C.29 did not return correct response to large input."
      severity failure;
    
    -- C.30
    assert not(si_nul = 35)
      report "Error:  -- C.30 did not return correct response to nul input."
      severity failure;
    
    assert not(svec2= 200)
      report "Error:  -- C.30 did not return correct response to large input."
      severity failure;
    
    -- C.31
    assert un_nul /= usvec
      report "Error:  -- C.31 did not return correct response to nul input."
      severity failure;
    assert usvec /= un_nul
      report "Error:  -- C.31 did not return correct response to nul input."
      severity failure;
    
    -- C.33
    assert 2 /= usvec
      report "Error:  -- C.33 did not return correct response to nul input."
      severity failure;
    assert 256 /= un_nul
      report "Error:  -- C.33 did not return correct response to null input."
      severity failure;
    assert 256 /= usvec
      report "Error:  -- C.33 did not return correct response to large input."
      severity failure;
    
    -- C.34
    svec := "0100";
    assert not(4 /= svec)
      severity failure;
    assert 4 /= si_nul
      report "Error:  -- C.34 did not return correct response to nul input."
      severity failure;
    
    assert 400 /= svec
      report "Error:  -- C.34 did not return correct response to large input."
      severity failure;
    
    -- C.35
    assert un_nul /= 21
      report "Error:  -- C.35 did not return correct response to nul input."
      severity failure;
    assert usvec /= 212
      report "Error:  -- C.35 did not return correct response to large input."
      severity failure;
    
    -- C.36
    assert not(svec /= 4)
      severity failure;
    assert si_nul /= 4
      report "Error:  -- C.36 did not return correct response to nul input."
      severity failure;
    
    assert svec /= 443
      report "Error:  -- C.36 did not return correct response to large input."
      severity failure;
    
    wait;
  end process;
end architecture;



