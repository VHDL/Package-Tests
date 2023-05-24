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

entity c31to36 is
  generic (
    quiet : boolean := false);  -- make the simulation quiet
end entity;

architecture ops of c31to36 is
  signal ANULL: UNSIGNED (0 downto 1);
  signal BNULL: UNSIGNED (0 downto 1);
  signal SANULL: SIGNED (0 downto 1);
  signal SBNULL: SIGNED (0 downto 1);

begin
  process

    constant min  : Integer := -128;
    constant max  : Integer := 127;
    constant smax : Natural := 8;
    variable i    : Integer;
    variable s    : Signed( smax-1 downto 0 );

    variable res4,sgn4: signed(3 downto 0);
    variable sgn6: signed(5 downto 0);
    variable res8: signed(7 downto 0);
    variable sgn8: signed(7 downto 0);
    variable sgn10,res10:signed(9 downto 0);
    variable ures4,uns4: unsigned(1 to 4);
    variable uns6: unsigned(2 to 7);
    variable uns10,ures10:unsigned(1 to 10);
    variable sint : integer := 2;
    variable snat : natural := 2;

    variable sgn_nul : signed(0 downto 3)    := (others => '0');
    variable uns_nul : unsigned(0 downto 3)  := (others => '0');
    variable runs_nul : unsigned(0 downto 3) := (others => '0');
    variable rsgn_nul : signed(0 downto 3)   := (others => '0');

  begin

-- STD_C.31 tests:
    uns4 := "1000";
    assert uns4 /= uns_nul report "Failure C.31 null right" severity failure;
    assert uns_nul /= uns4 report "Failure C.31 null left" severity failure;
    uns4 := "XXXX";
    uns6 := "011001";
    assert uns6 /= uns4 report "Failure C.31 X left" severity failure;
    assert uns4 /= uns6 report "Failure C.31 X right" severity failure;

-- STD_C.32 tests:
    sgn4 := "1001";
    sgn6 := (others => 'X');
    assert (sgn4 /= sgn6) report "Failure C.32 X left" severity failure;
    assert (sgn6 /= sgn4) report "Failure C.32 X right" severity failure;

-- STD_C.33 tests:
    uns10 := "0000000000";
    snat := 0;
    for j in 0 to 516 loop
      if snat /= uns10 then
        assert false
          report "Error:  Natural not eq unsigned" & integer'image(snat)
          severity failure;
      end if;

--      assert not(j /= to_integer(uns10)) report "Failure C.33: " & to_string(j) severity failure;
      uns10 := uns10 + "0000000001";
      snat := snat + 1;
    end loop;
    uns4 := "0111";
    assert (20000 /= uns4)
      report "Failure large left natural not seen as NOT equal"
      severity failure;

    assert (snat /= uns_nul)
      report "Failure C.33 null right"
      severity failure;

    uns4 := "XXXX";
    assert (snat /= uns4)
      report "Failure C.33 X's right"
      severity failure;

-- std_C.34
    sgn4 := "1001";
    sgn6 := (others => 'X');
    sgn8 := (others => '0');
    for j in -128 to 127 loop
      assert j /= signed'(sgn8) report "Failure C.34  integer compare signed." severity failure;
      sgn8 := sgn8 + "00000001";
    end loop;

    assert (sint /= sgn6) report "Failure C.34  X's vector compare" severity failure;
    assert (sint /= sgn_nul) report "Failure C.34  Nul vector compare" severity failure;
    assert ((-50000) /= sgn4) report "Failure C.34  Big  Int compare" severity failure;

-- std_C.35
    uns4 := "1000";
    uns10 := "0000000000";
    for j in 0 to 520 loop
      assert not(unsigned'(uns10) /= j) report "Failure C.35 natural / unsigned compare error" severity failure;
      uns10 := uns10 + "0000000001";
    end loop;

    assert uns_nul /= snat report "Failure C.31 null vecor" severity failure;
    uns4 := "XXXX";
    assert uns4 /= snat report "Failure C.31 X vector" severity failure;
    uns4 := "1000";
    assert uns4 /= 50000 report "Failure C.31 Large natural" severity failure;

-- std_C.36
    sgn4 := "1001";
    sgn6 := (others => 'X');
    sgn8 := (others => '0');
    for j in -128 to 127 loop
      assert signed'(sgn8) /= j report "Failure C.36  integer compare signed." severity failure;
      sgn8 := sgn8 + "00000001";
    end loop;

    assert (sgn6 /= sint) report "Failure C.36  X's vector compare" severity failure;
    assert (sgn_nul /= sint) report "Failure C.36  Nul vector compare" severity failure;
    assert (sgn4 /= (-80500)) report "Failure C.36  Big  Int compare" severity failure;



    wait;
  end process;

end ops;
