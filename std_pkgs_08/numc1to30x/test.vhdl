-------------- test case header    ------
--!  Test intent :  Coverage of standards.
--!  Test scope  :  abs  a1  Nul  input.
--!  Keywords    : [operations, abs]
--!  References  : [VH2008 16.6]
--!                [Rlink : REQ08xx]
-----------------------------------------------
-- tb1 c1 - c30  from bishop tests.

library not_ieee;
use not_ieee.std_logic_1164.all;
use not_ieee.numeric_std.all;

entity c1to30x is
  generic (
    quiet : boolean := false);  -- make the simulation quiet
end entity;

architecture ops of c1to30x is
  signal ANULL: UNSIGNED (0 downto 1);
  signal BNULL: UNSIGNED (0 downto 1);
  signal SANULL: SIGNED (0 downto 1);
  signal SBNULL: SIGNED (0 downto 1);

begin
  process
    -- for c.28,c.30
    constant min  : Integer := -128;
    constant max  : Integer := 127;
    constant smax : Natural := 8;
    variable i    : Integer;
    variable s    : Signed( smax-1 downto 0 );

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

-- STD_C.1 tests:
    uns8 := (others => '0');
    uns4 := (others => 'X');
    if (uns4 > uns8) then
        assert false report "X compare did not return false C.1";
    end if;
    if (uns8 > uns4) then
        assert false report "X compare did not return false C.1";
    end if;
    assert quiet report "C.1 tests done" severity note;

--STD_C.2 tests:
    sgn6 := (others => '0');
    sgn4 := (others => 'X');
    if (sgn4 > sgn6) then
        assert false report "X compare did not return false C.2";
    end if;
    if (sgn6 > sgn4) then
        assert false report "X compare did not return false C.2";
    end if;
    assert quiet report "C.2 tests done" severity note;

-- STD_C.3 tests
    uns4 := (others => 'X');
    if (snat > uns4) then
        assert false report "X compare did not return false C.3";
    end if;
    assert quiet report "C.3 tests done" severity note;

-- STD_C.4 tests
    sgn4 := (others => 'X');
    if (sint > sgn4) then
        assert false report "X compare did not return false C.4";
    end if;
    if (sint > rsgn_nul) then
        assert false report "nul compare did not return false C.4";
    end if;

    assert quiet report "C.4 tests done" severity note;

-- STD_C.5 tests
    if (uns4 > snat) then
        assert false report "X compare did not return false C.5";
    end if;
    assert quiet report "C.5 tests done" severity note;

-- STD_C.6 tests:
    sgn4 := (others => 'X');
    if (sgn4 > sint) then
        assert false report "X compare did not return false C.6";
    end if;
    assert quiet report "C.6 tests done" severity note;

-- STD_C.7 tests:
    uns8 := (others => '0');
    uns4 := (others => 'X');
    if (uns4 < uns8) then
        assert false report "X compare did not return false C.7";
    end if;
    if (uns8 < uns4) then
        assert false report "X compare did not return false C.7";
    end if;
    assert quiet report "C.7 tests done" severity note;

--STD_C.8 tests:
    sgn6 := (others => '0');
    sgn4 := (others => 'X');
    if (sgn4 < sgn6) then
        assert false report "X compare did not return false C.8";
    end if;
    if (sgn6 < sgn4) then
        assert false report "X compare did not return false C.8";
    end if;
    assert quiet report "C.2 tests done" severity note;

-- STD_C.9 tests
    uns4 := (others => 'X');
    if (snat < uns4) then
        assert false report "X compare did not return false C.9";
    end if;
    assert quiet report "C.9 tests done" severity note;

-- STD_C.10 tests
    sgn4 := (others => 'X');
    if (sint < sgn4) then
        assert false report "X compare did not return false C.10";
    end if;
    assert quiet report "C.10 tests done" severity note;

-- STD_C.11 tests
    if (uns4 < snat) then
        assert false report "X compare did not return false C.11";
    end if;
    assert quiet report "C.11 tests done" severity note;

-- STD_C.12 tests:
    sgn4 := (others => 'X');
    if (sgn4 < sint) then
        assert false report "X compare did not return false C.12" severity failure;
    end if;
    if (rsgn_nul < sint) then
        assert false report "nul compare did not return false C.12" severity failure;
    end if;

    assert quiet report "C.12 tests done" severity note;

-- C.18 Null
    if (rsgn_nul <= sint) then
        assert false report "nul compare did not return false C.18" severity failure;
    end if;
    assert quiet report "C.18 tests done" severity note;

-- C.22 Null
    if (sint >= rsgn_nul) then
        assert false report "nul compare did not return false C.22" severity failure;
    end if;
    assert quiet report "C.22 tests done" severity note;

-- C.25 null
    uns4 := "0101";
    if (uns_nul = unsigned'(uns4)) then
        assert false report "nul compare did not return false C.25" severity failure;
    end if;
    if (unsigned'(uns4) = uns_nul) then
        assert false report "nul compare did not return false C.25" severity failure;
    end if;
    uns6 := (others => 'X');
    if (uns6 = uns4) then
        assert false report "X compare did not return false C.25" severity failure;
    end if;
    if (uns4 = uns6) then
        assert false report "X compare did not return false C.25" severity failure;
    end if;

    assert quiet report "C.25 tests done" severity note;
--  C.26
    sgn6 := (others => 'X');
    sgn4 := "0101";
    if (sgn6 = sgn4) then
        assert false report "X compare did not return false C.26";
    end if;
    if (sgn4 = sgn6) then
        assert false report "X compare did not return false C.26";
    end if;
    assert quiet report "C.26 tests done" severity note;

--  C.27
    uns4 := "0101";
    snat := 50000;
    assert not(snat = uns4) report "Larger natural returned true C.27" severity failure;
    assert quiet report "C.27 tests done" severity note;

-- c.28, c.30 tests, from Wolfgang:
    sgn4 := (others => 'X');
    if (sint = sgn4) then
        assert false report "X compare did not return false C.28";
    end if;
    if (sgn4 = sint) then
        assert false report "X compare did not return false C.30";
    end if;
    assert quiet report "c.28, c.30 tests done" severity note;

    assert FALSE
      report "END OF test suite tb3"
      severity note;

    wait;
  end process;

end ops;
