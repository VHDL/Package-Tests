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

entity d1to4x is
  generic (
    quiet : boolean := false);  -- make the simulation quiet
end entity;

architecture ops of d1to4x is
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

    variable uv4 : std_ulogic_vector(2 to 5);
    variable uv6 : std_ulogic_vector(5 downto 0);
    variable uvnul : std_ulogic_vector(4 to 0);

    variable rint : integer;
    variable rnat : natural;

    variable stdv : std_logic;

    variable sgn_nul : signed(0 downto 3)    := (others => '0');
    variable uns_nul : unsigned(0 downto 3)  := (others => '0');
    variable runs_nul : unsigned(0 downto 3) := (others => '0');
    variable rsgn_nul : signed(0 downto 3)   := (others => '0');

  begin
  -- D.1
    uns6 := "XXXXXX";
    rnat := to_integer(uns_nul);
    assert rnat = 0 Report "Error D.1 to_integer did not return 0 when given a Null vector." severity failure;
    rnat := to_integer(uns6);
    assert rnat = 0 Report "Error D.1 to_integer did not return 0 when given X's vector." severity failure;
  -- D.2
    sgn6 := "XXXXXX";
    rint := to_integer(sgn_nul);
    assert rint = 0 report "Error D.2 to_integer did not return 0 when given a Null vector." severity failure;
    rint := to_integer(sgn6);
    assert rint = 0 Report "Error D.2 to_integer did not return 0 when given X's vector." severity failure;
  --  to_unsigned
    uns6 := to_unsigned(2,uns6);
    assert uns6 = unsigned'("000010") report "Error: expected 000010  got: " & to_string(uns6);
    sgn6 := to_signed(-2,sgn6);
    assert sgn6 = signed'("111110") report "Error: expected 111110 got: " & to_string(sgn6);

  -- resize
    uns6 := "000110";
    uns4 := "0001";
    ures10 := uns6 + resize(uns4,ures10);
    assert to_integer(ures10) = 7 report "Error:  resize natural" severity failure;

    sgn6 := "111110";
    sgn4 := "0010";
    res10 := sgn6 + resize(sgn4, res10);
    assert to_integer(res10) = 0 report "Error: resize integer" severity failure;

  -- M.2
    assert not(std_match(uns_nul, uns6)) report "Error: M.2 std_match passed NULL did not return False." severity failure;
    assert not(std_match(uns6, uns_nul)) report "Error: M.2 std_match passed NULL did not return False." severity failure;

  -- M.3
    assert not(std_match(sgn_nul, sgn6)) report "Error: M.3 std_match passed NULL did not return False." severity failure;
    assert not(std_match(sgn6, sgn_nul)) report "Error: M.3 std_match passed NULL did not return False." severity failure;

  -- M.5
    assert not(std_match(uvnul, uv4)) report "Error: M.5 std_match passed left NULL did not return False." severity failure;
    assert not(std_match(uv4, uvnul)) report "Error: M.5 std_match passed right NULL did not return False." severity failure;
    assert not(std_match(uv4, uv6)) report "Error: M.5 std_match passed diff lengths did not return False." severity failure;

  --  to_01
    runs_nul := to_01(uns_nul);
    rsgn_nul := to_01(sgn_nul);


    report "Test Passed ..." severity note;
    wait;
  end process;
end ops;
