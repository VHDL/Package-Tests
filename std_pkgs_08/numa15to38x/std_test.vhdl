-------------- test case header    ------
--!  Test intent :  Coverage of standards.
--!  Test scope  :  abs  a1  Nul  input.
--!  Keywords    : [operations, abs]
--!  References  : [VH2008 16.6]
--!                [Rlink : REQ08xx]
-----------------------------------------------
-- tb1 A15 - a38  from bishop tests.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity std_a15to38bx is
  generic (
    quiet : boolean := false);  -- make the simulation quiet
end entity;

architecture ops of std_a15to38bx is
  signal ANULL: UNSIGNED (0 downto 1);
  signal BNULL: UNSIGNED (0 downto 1);
  signal SANULL: SIGNED (0 downto 1);
  signal SBNULL: SIGNED (0 downto 1);

begin
  process 
    -- required A15_38
    variable res4,sgn4: signed(3 downto 0);
    variable sgn6: signed(5 downto 0);
    variable res8: signed(7 downto 0);
    variable sgn10,res10:signed(9 downto 0);
    variable ures4,uns4: unsigned(1 to 4);
    variable uns6: unsigned(2 to 7);
    variable uns8: unsigned(0 to 7);
    variable uns10,ures10:unsigned(1 to 10);
    variable sint : integer := 2;
    variable snat : natural := 2;
    
    variable sgn_nul : signed(0 downto 3)    := (others => '0');
    variable uns_nul : unsigned(0 downto 3)  := (others => '0');
    variable runs_nul : unsigned(0 downto 3) := (others => '0');
    variable rsgn_nul : signed(0 downto 3)   := (others => '0');
    
  begin


    assert quiet report "start of tests" severity note;

--  ************************************************
--  ************************************************
-- A15_38 tests from Kingsley ::::::
    uns6:=to_unsigned(5,6);
    uns4:= (others => 'X');
    uns10:=uns6*uns4;    -- A.15
    for i in uns10'range loop
        assert uns10(i) = 'X' report "A.15  X not found ?" severity failure;
    end loop;
    uns4:=to_unsigned(5,4);
    uns6:= (others => 'X');
    uns10:=uns6*uns4;    -- A.15
    for i in uns10'range loop
        assert uns10(i) = 'X' report "A.15  X not found ?" severity failure;
    end loop;
    
    runs_nul := uns4 * uns_nul;
    runs_nul := uns_nul * uns4;
    
    assert quiet report "A.15x test done" severity note;
    
    -- A.16 tests
    sgn6:=to_signed(7,6);
    sgn4:=(others => 'X');
    res10:=sgn6*sgn4;    -- A.16
    for i in res10'range loop
        assert res10(i) = 'X' report "A.16  X not found ?" severity failure;
    end loop;
    sgn4:=to_signed(7,4);
    sgn6:=(others => 'X');
    res10:=sgn6*sgn4;    -- A.16
    for i in res10'range loop
        assert res10(i) = 'X' report "A.16  X not found ?" severity failure;
    end loop;
    
    sgn6:=to_signed(-7,6);
    sgn4:="0010";
    res10:=sgn6*sgn4;    -- A.16
    assert to_integer(res10) = -14 report "A.16  neg mult ?" severity failure;
    sgn6:="000110";
    sgn4:=to_signed(-3,4);
    res10:=sgn6*sgn4;    -- A.16
    assert to_integer(res10) = -18 report "A.16  neg mult ?" severity failure;
    
    rsgn_nul := sgn4 * sgn_nul;
    rsgn_nul := sgn_nul * sgn4;
    
    assert quiet report "A.16x test done" severity note;

    -- A.17 and A.18 tests
    uns4:=(others => 'X');
    uns8:=snat*uns4;         -- A.18
    for i in uns8'range loop
        assert uns8(i) = 'X' report "A.18  X not found ?" severity failure;
    end loop;
    uns8:=uns4*snat;         -- A.17
    for i in uns8'range loop
        assert uns8(i) = 'X' report "A.17  X not found ?" severity failure;
    end loop;
    uns4:= "0010";
    uns8:=snat*uns4;
    assert to_integer(uns8) = 4 report "Error 2x2 not 4?  A.18";
    uns8:=uns4*snat;
    assert to_integer(uns8) = 4 report "Error 2x2 not 4?  A.17";
    
    assert quiet report "A.17x, A.18x tests done" severity note;

    -- A.19 and A.20 tests
    sgn4 := (others => 'X');
    res8:=sint*sgn4;         -- A.20
    for i in res8'range loop
        assert res8(i) = 'X' report "A.20  X not found ?" severity failure;
    end loop;
    res8:=sgn4*sint;         -- A.19
    for i in res8'range loop
        assert res8(i) = 'X' report "A.19  X not found ?" severity failure;
    end loop;
    sgn4 := "0010";
    res8:=sint*sgn4;         -- A.20
    assert to_integer(res8) = 4 report "Error 2x2 not 4?  A.20";
    res8:=sgn4*sint;         -- A.19
    assert to_integer(res8) = 4 report "Error 2x2 not 4?  A.19";
    assert quiet report "A.19x, A.20x tests done" severity note;
    
    -- Id: A.21, A.23, and A.24
    uns10:=(others => 'X');
    uns4:=to_unsigned(3,4);
    ures10:=uns10/uns4;
    for i in ures10'range loop
        assert ures10(i) = 'X' report "A.21x  X not found ?" severity failure;
    end loop;
    uns4:="0010";
    uns4 := uns4/50000;     ---<<<  735
    report to_string(uns4);
    ures10:=uns10/21;
    for i in ures10'range loop
        assert ures10(i) = 'X' report "A.23x  X not found ?" severity failure;
    end loop;
    runs_nul := uns_nul/snat;
    
    uns4:=(others => 'X');
    ures10:=8/("000000"&uns4);
    for i in ures10'range loop
        assert ures10(i) = 'X' report "A.24x  X not found ?" severity failure;
    end loop;
    runs_nul := snat/uns_nul;
    
    -- nul values
    uns4:=(others => '1');
    runs_nul := uns4/uns_nul;
    runs_nul := uns_nul/uns4;
    report "Expect truncation warning here ...";
    uns4:="0010";
    uns4 :=  20000000/uns4;
    
    assert quiet report "A.21, A.23, A.24 tests done" severity note;

    -- Id: A.22, A.25 and A.26
    sgn10:=to_signed(34,10);
    sgn4:=(others => 'X');
    res10:=sgn10/sgn4;
    for i in res10'range loop
        assert res10(i) = 'X' report "A.22  X not found ?" severity failure;
    end loop;
    
    sgn4:=(others => '1');
    rsgn_nul := sgn4/sgn_nul;
    rsgn_nul := sgn_nul/sgn4;
    
    sgn10:=(others => 'X');
    res10:=sgn10/(-76);
    for i in res10'range loop
        assert res10(i) = 'X' report "A.25  X not found ?" severity failure;
    end loop;
    
    rsgn_nul := sgn_nul/sint;
    sgn4 := "0010";
    sgn4 := sgn4/50000000;
    
    res10:=16/sgn10;
    for i in res10'range loop
        assert res10(i) = 'X' report "A.26  X not found ?" severity failure;
    end loop;
    
    rsgn_nul := sint/sgn_nul;
    report "Expect truncation warning here ...";
    sgn4 := "0010";
    sgn4:=20000000/sgn4;
    
    assert quiet report "A.22, A.25, A.26 tests done" severity note;

    -- Id: A.27, A.29 and A.30
    uns10:=to_unsigned(328,10);
    uns4:=(others => 'X');
    ures4:=uns10 rem uns4;
    for i in ures4'range loop
        assert ures4(i) = 'X' report "A.27  X not found ?" severity failure;
    end loop;
    -- unsigned nul
    runs_nul := uns10 rem uns_nul;
    runs_nul :=  uns_nul rem uns10;
    
    uns10:=(others => 'X');
    ures10:=uns10 rem 5;
    for i in ures10'range loop
        assert ures10(i) = 'X' report "A.29  X not found ?" severity failure;
    end loop;
    -- unsigned nul
    runs_nul := uns_nul rem snat;
    
    report "Expect truncation How do I get here ...";
    uns4:="0100";
    snat := 2000;
    -- A.29
    --ures4:= uns4 rem snat;
    -- A.30
    --ures4:= snat rem uns4;
    
    
    uns4:=(others => 'X');
    ures10:=1023 rem ("000000"&uns4);
    for i in ures10'range loop
        assert ures10(i) = 'X' report "A.30  X not found ?" severity failure;
    end loop;
    -- unsigned nul
    --runs_nul := snat rem uns_nul;   ----<<<<<   this causes error in numeric_std
    
    assert quiet report "A.27, A.29, A.30 tests done" severity note;
    


    -- Id: A.28, A.31 and A.32
    sgn4:= (others => 'X');
    sgn10:= "0111101010";
    res10:= sgn4 rem sgn10;
    for i in res10'range loop
        assert res10(i) = 'X' report "A.28  X not found ?" severity failure;
    end loop;
    rsgn_nul := sgn_nul rem sgn10;
    rsgn_nul := sgn10 rem sgn_nul;
    
    
    sgn10:= (others => 'X');
    res10:= sgn10 rem 33;
    for i in res10'range loop
        assert res10(i) = 'X' report "A.31  X not found ?" severity failure;
    end loop;
    rsgn_nul := sgn_nul rem 22;
    
    report "Need to Implement A.30 truncation warning here ...";
    --sgn4:= "1000";
    --sgn25:= sgn4 rem 20000000;
    --sgn4:= sgn4 rem 2;
    
    res10:= 33 rem sgn10;
    for i in res10'range loop
        assert res10(i) = 'X' report "A.32  X not found ?" severity failure;
    end loop;
    rsgn_nul := 22 rem sgn_nul;
    
    report "Need to Implement A.31 truncation warning here ...";
    --sgn10:= "1000011010";
    --res10:= 330000 rem sgn10;
    
    
    assert quiet report "A.28, A.31, A.32 tests done" severity note;

    -- Id: A.33, A.35 and A.36
    uns10:=to_unsigned(983,10);
    uns4:=(others => 'X');
    uns6:=to_unsigned(8,6);
    ures4:=uns6 mod uns4;
    for i in ures4'range loop
        assert ures4(i) = 'X' report "A.33x  X not found ?" severity failure;
    end loop;
    runs_nul := uns6 mod uns_nul;
    
    report "Need to Implement truncation A.35 warning here ...";
    --uns4:="0010";
    --uns4 :=  20000000 mod uns4;
    
    uns10:=(others => 'X');
    ures10:=uns10 mod 333;
    for i in ures10'range loop
        assert ures10(i) = 'X' report "A.35x  X not found ?" severity failure;
    end loop;
    runs_nul := uns_nul mod 14;
    
    ures10:=25 mod ("000000"&uns4);
    for i in ures10'range loop
        assert ures10(i) = 'X' report "A.36x  X not found ?" severity failure;
    end loop;
    runs_nul := 3 mod uns_nul;
    assert quiet report "A.33, A.35, A.36 tests done" severity note;

    -- Id: A.34, A.37 and A.38
    sgn10:=to_signed(283,10);
    sgn4:=(others => 'X');
    res4:=sgn10 mod sgn4;
    for i in res4'range loop
        assert res4(i) = 'X' report "A.34x  X not found ?" severity failure;
    end loop;
    rsgn_nul := sgn10 mod sgn_nul;
    
    sgn10:=(others => 'X');
    res10:=sgn10 mod 666;
    for i in res10'range loop
        assert res10(i) = 'X' report "A.37x  X not found ?" severity failure;
    end loop;
    rsgn_nul := sgn_nul mod 63;
    
    res10:=5 mod resize(sgn4,10);
    for i in res10'range loop
        assert res10(i) = 'X' report "A.38x  X not found ?" severity failure;
    end loop;
    rsgn_nul := 23 mod sgn_nul;
    assert quiet report "A.34, A.37, A.38 tests done" severity note;
    finish;
  end process;

end ops;
