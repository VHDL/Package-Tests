-------------- test case header    ------
--!  Test intent :  Coverage of standards.
--!  Test scope  :  reduction
--!  Keywords    : [operations, abs]
--!  References  : [VH2008 16.6]
--!                [Rlink : REQ08xx]
-----------------------------------------------
-- tb1 l37 - 50  reduction

library not_ieee;
use not_ieee.std_logic_1164.all;
use not_ieee.numeric_std.all;

entity c37to48x is
  generic (
    quiet : boolean := false);  -- make the simulation quiet
end entity;

architecture ops of c37to48x is
  signal ANULL: UNSIGNED (0 downto 1);
  signal BNULL: UNSIGNED (0 downto 1);
  signal SANULL: SIGNED (0 downto 1);
  signal SBNULL: SIGNED (0 downto 1);

begin

  process
    variable res4,sgn4: signed(3 downto 0);
    variable sgn6: signed(5 downto 0);
    variable rsgn6: signed(5 downto 0);
    variable res8: signed(7 downto 0);
    variable sgn10,res10:signed(9 downto 0);
    variable ures4,uns4: unsigned(1 to 4);
    variable uns6: unsigned(2 to 7);
    variable runs6: unsigned(5 downto 0);
    variable uns8: unsigned(0 to 7);
    variable uns10,ures10:unsigned(1 to 10);
    variable sint : integer := 2;
    variable snat : natural := 2;

    variable sgn_nul : signed(0 downto 3)    := (others => '0');
    variable uns_nul : unsigned(0 downto 3)  := (others => '0');
    variable runs_nul : unsigned(0 downto 3) := (others => '0');
    variable rsgn_nul : signed(0 downto 3)   := (others => '0');

  begin
  -- c.37
    runs_nul := minimum(uns_nul, uns4);
    runs_nul := minimum(uns4, uns_nul);
    --assert runs_nul = anull report "Error Nul not eq Nul" severity failure;
    uns4 := "XXXX";
    uns6 := "000000";
    runs6 := minimum(uns4, uns6);
    for i in runs6'low to runs6'high loop
        assert runs6(i) = 'X' report "C.37  X not found ?" severity failure;
    end loop;
    runs6 := minimum(uns6, uns4);
    for i in runs6'low to runs6'high loop
        assert runs6(i) = 'X' report "C.37  X not found ?" severity failure;
    end loop;
    report "Done C.37 X's  and  Nul..." severity note;
  -- c.38
    rsgn_nul := minimum(sgn_nul, sgn6);
    rsgn_nul := minimum(sgn6, sgn_nul);

    sgn4 := "XXXX";
    sgn6 := "000000";
    rsgn6 := minimum(sgn4, sgn6);
    for i in rsgn6'low to rsgn6'high loop
        assert rsgn6(i) = 'X' report "C.37  X not found ?" severity failure;
    end loop;
    rsgn6 := minimum(sgn6, sgn4);
    for i in rsgn6'low to rsgn6'high loop
        assert rsgn6(i) = 'X' report "C.37  X not found ?" severity failure;
    end loop;
    report "Done C.38 X's  and  Nul..." severity note;

  -- c.39
    uns6 := "000000";
    runs6 := minimum(snat, uns6);
    assert to_integer(runs6) = 0 report "C.39 Min of nat 1 and  unsign 0  not  0" severity failure;
  -- c.41
    runs6 := minimum(uns6, snat);
    assert to_integer(runs6) = 0 report "c.41 Min of nat 1 and  unsign 0  not  0" severity failure;
  -- c40
    sgn6 := "000000";
    rsgn6 := minimum(sint, sgn6);
    assert to_integer(rsgn6) = 0 report "C.40 Min of nat 1 and  sign 0  not  0" severity failure;
  -- c42
    rsgn6 := minimum(sgn6, sint);
    assert to_integer(rsgn6) = 0 report "C.42 Min of nat 1 and  sign 0  not  0" severity failure;

    report "Done C.39 to C.42 ..." severity note;

  -- c.43
    runs_nul := maximum(uns_nul, uns4);
    runs_nul := maximum(uns4, uns_nul);
    uns4 := "XXXX";
    uns6 := "000000";
    runs6 := maximum(uns4, uns6);
    for i in runs6'low to runs6'high loop
        assert runs6(i) = 'X' report "C.43  X not found ?" severity failure;
    end loop;
    runs6 := maximum(uns6, uns4);
    for i in runs6'low to runs6'high loop
        assert runs6(i) = 'X' report "C.43  X not found ?" severity failure;
    end loop;
    report "Done C.43 X's  and  Nul..." severity note;
  -- c.44
    rsgn_nul := maximum(sgn_nul, sgn6);
    rsgn_nul := maximum(sgn6, sgn_nul);

    sgn4 := "XXXX";
    sgn6 := "000000";
    rsgn6 := maximum(sgn4, sgn6);
    for i in rsgn6'low to rsgn6'high loop
        assert rsgn6(i) = 'X' report "C.44  X not found ?" severity failure;
    end loop;
    rsgn6 := maximum(sgn6, sgn4);
    for i in rsgn6'low to rsgn6'high loop
        assert rsgn6(i) = 'X' report "C.44  X not found ?" severity failure;
    end loop;
    report "Done C.44 X's  and  Nul..." severity note;


  -- c.45
    uns6 := "000000";
    runs6 := maximum(snat, uns6);
    assert to_integer(runs6) = 2 report "C.45 Max of int2 and  unsign 0  not  2" severity failure;
  -- c.47
    runs6 := maximum(uns6, snat);
    assert to_integer(runs6) = 2 report "c.47 Max of int2 and  unsign 0  not  2" severity failure;
  -- c46
    sgn6 := "000000";
    rsgn6 := maximum(sint, sgn6);
    assert to_integer(rsgn6) = 2 report "C.46 Max of int2 and  sign 0  not  2" severity failure;
  -- c48
    rsgn6 := maximum(sgn6, sint);
    assert to_integer(rsgn6) = 2 report "C.48 Max of int2 and  sign 0  not  2" severity failure;

    report "Done C.45 to C.48 ..." severity note;

    wait;
  end process;
end ops;
