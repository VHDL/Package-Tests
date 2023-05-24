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
--use work.not_test_pkg.all;

entity c49to84x is
  generic (
    quiet : boolean := false);  -- make the simulation quiet
end entity;

architecture ops of c49to84x is
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

    variable stdv : std_logic;

    variable sgn_nul : signed(0 downto 3)    := (others => '0');
    variable uns_nul : unsigned(0 downto 3)  := (others => '0');
    variable runs_nul : unsigned(0 downto 3) := (others => '0');
    variable rsgn_nul : signed(0 downto 3)   := (others => '0');

  begin
  -- c.49
    uns6 := "100011";
    if ((uns_nul ?> uns6) /= 'X') then
      report "Error C.49 null left vector did not return 'X'" severity failure;
    end if;
    if ((uns6 ?> uns_nul) /= 'X') then
      report "Error C.49 null right vector did not return 'X'" severity failure;
    end if;
    uns6 := "10-011";
    uns8 := "00011100";
    if ((uns8 ?> uns6) /= 'X') then
      report "Error C.49 - in right vector did not return 'X'" severity failure;
    end if;

  -- c.50
    sgn6 := "100011";
    if ((sgn6 ?> sgn_nul) /= 'X') then
      report "Error C.50 - in right vector did not return 'X'" severity failure;
    end if;
    if ((sgn_nul ?> sgn6) /= 'X') then
      report "Error C.50 - in left vector did not return 'X'" severity failure;
    end if;

    sgn6 := "10-011";
    res8 := "00111001";
    if ((res8 ?> sgn6) /= 'X') then
      report "Error C.50 - in right vector did not return 'X'" severity failure;
    end if;

  -- c.51
    uns6 := "100011";
    if ((50 ?> uns6) /= '1') then
      report "Error C.51 - natrual compare vector did not return '1'" severity failure;
    end if;
    if ((snat ?> uns6) /= '0') then
      report "Error C.51 - natrual compare vector did not return '0'" severity failure;
    end if;

  -- c.52
    sgn6 := "100100";
    --report to_string(to_integer(sgn6));
    if ((-29 ?> sgn6) /= '0') then
      report "Error C.52 - integer compare vector did not return '0'" severity failure;
    end if;
    if ((sint ?> sgn6) /= '1') then
      report "Error C.52 - integer compare vector did not return '1'" severity failure;
    end if;
  -- c.53
    uns6 := "100011";
    if ((uns6 ?> 36) /= '0') then
      report "Error C.53 - natural compare vector did not return '0'" severity failure;
    end if;
    if ((uns6 ?> 16) /= '1') then
      report "Error C.53 - natural compare vector did not return '1'" severity failure;
    end if;
  -- c.54
    sgn6 := "100100";
    --report to_string(to_integer(sgn6));
    if ((sgn6 ?> -29) /= '1') then
      report "Error C.54 - integer compare vector did not return '0'" severity failure;
    end if;
    if ((sgn6 ?> sint) /= '0') then
      report "Error C.54 - integer compare vector did not return '1'" severity failure;
    end if;

  -- c.55
    uns6 := "100011";
    if ((uns_nul ?< uns6) /= 'X') then
      report "Error C.55 null left vector did not return 'X'" severity failure;
    end if;
    if ((uns6 ?< uns_nul) /= 'X') then
      report "Error C.55 null left vector did not return 'X'" severity failure;
    end if;
    uns6 := "10-011";
    uns8 := "00011100";
    if ((uns8 ?< uns6) /= 'X') then
      report "Error C.55 - in right vector did not return 'X'" severity failure;
    end if;

  -- c.56
    sgn6 := "100011";
    if ((sgn6 ?< sgn_nul) /= 'X') then
      report "Error C.56 - in right vector did not return 'X'" severity failure;
    end if;
    if ((sgn_nul ?< sgn6) /= 'X') then
      report "Error C.56 - in right vector did not return 'X'" severity failure;
    end if;
    sgn6 := "10-011";
    res8 := "00111001";
    if ((res8 ?< sgn6) /= 'X') then
      report "Error C.56 - in right vector did not return 'X'" severity failure;
    end if;

  -- c.57
    uns6 := "100011";
    if ((50 ?< uns6) /= '0') then
      report "Error C.57 - natrual compare vector did not return '0'" severity failure;
    end if;
    if ((snat ?< uns6) /= '1') then
      report "Error C.57 - natrual compare vector did not return '1'" severity failure;
    end if;

  -- c.58
    sgn6 := "100100";
    --report to_string(to_integer(sgn6));
    if ((-29 ?< sgn6) /= '1') then
      report "Error C.58 - integer compare vector did not return '1'" severity failure;
    end if;
    if ((sint ?< sgn6) /= '0') then
      report "Error C.58 - integer compare vector did not return '0'" severity failure;
    end if;
  -- c.59
    uns6 := "100011";
    if ((uns6 ?< 36) /= '1') then
      report "Error C.59 - natural compare vector did not return '1'" severity failure;
    end if;
    if ((uns6 ?< 16) /= '0') then
      report "Error C.59 - natural compare vector did not return '0'" severity failure;
    end if;
  -- c.60
    sgn6 := "100100";
    --report to_string(to_integer(sgn6));
    if ((sgn6 ?< -29) /= '0') then
      report "Error C.60 - integer compare vector did not return '0'" severity failure;
    end if;
    if ((sgn6 ?< sint) /= '1') then
      report "Error C.60 - integer compare vector did not return '1'" severity failure;
    end if;

  -- c.61
    uns6 := "100011";
    if ((uns_nul ?<= uns6) /= 'X') then
      report "Error C.61 null left vector did not return 'X'" severity failure;
    end if;
    if ((uns6 ?<= uns_nul) /= 'X') then
      report "Error C.61 null right vector did not return 'X'" severity failure;
    end if;
    uns6 := "10-011";
    uns8 := "00011100";
    if ((uns8 ?<= uns6) /= 'X') then
      report "Error C.61 - in right vector did not return 'X'" severity failure;
    end if;

  -- c.62
    sgn6 := "100011";
    if ((sgn6 ?<= sgn_nul) /= 'X') then
      report "Error C.62 null right vector did not return 'X'" severity failure;
    end if;
    if ((sgn_nul ?<= sgn6) /= 'X') then
      report "Error C.62 null left vector did not return 'X'" severity failure;
    end if;
    sgn6 := "10-011";
    res8 := "10000101";
    if ((res8 ?<= sgn6) /= 'X') then
      report "Error C.62 - in right vector did not return 'X'" severity failure;
    end if;

  -- C.63
    uns6 := "100011";
    if ((50 ?<= uns6) /= '0') then
      report "Error C.63 natrual compare vector did not return '0'" severity failure;
    end if;
    if ((snat ?<= uns6) /= '1') then
      report "Error C.63 natrual compare vector did not return '1'" severity failure;
    end if;
  -- C.64
    sgn6 := "100100";
    --report to_string(to_integer(sgn6));
    if ((-29 ?<= sgn6) /= '1') then
      report "Error C.64  integer compare vector did not return '1'" severity failure;
    end if;
    if ((-28 ?<= sgn6) /= '1') then
      report "Error C.64  integer compare = vector did not return '1'" severity failure;
    end if;
    if ((-27 ?<= sgn6) /= '0') then
      report "Error C.64  integer compare vector did not return '0'" severity failure;
    end if;
    if ((sint ?<= sgn6) /= '0') then
      report "Error C.64  integer compare vector did not return '0'" severity failure;
    end if;
  -- C.65
    uns6 := "100011";
    if ((uns6 ?<= 36) /= '1') then
      report "Error C.65 - natural compare vector did not return '1'" severity failure;
    end if;
    if ((uns6 ?<= 16) /= '0') then
      report "Error C.65 - natural compare vector did not return '0'" severity failure;
    end if;
  -- C.66
    sgn6 := "100100";
    --report to_string(to_integer(sgn6));
    if ((sgn6 ?<= -29) /= '0') then
      report "Error C.66 integer compare vector did not return '0'" severity failure;
    end if;
    if ((sgn6 ?<= sint) /= '1') then
      report "Error C.66 integer compare vector did not return '1'" severity failure;
    end if;

  -- C.67
    uns6 := "100011";
    if ((uns_nul ?>= uns6) /= 'X') then
      report "Error C.67 null left vector did not return 'X'" severity failure;
    end if;
    if ((uns6 ?>= uns_nul) /= 'X') then
      report "Error C.67 null right vector did not return 'X'" severity failure;
    end if;
    uns6 := "10-011";
    uns8 := "00011100";
    if ((uns8 ?>= uns6) /= 'X') then
      report "Error C.67 - in right vector did not return 'X'" severity failure;
    end if;


  -- C.68
    sgn6 := "100011";
    if ((sgn6 ?>= sgn_nul) /= 'X') then
      report "Error C.68 - in right vector did not return 'X'" severity failure;
    end if;
    if ((sgn_nul ?>= sgn6) /= 'X') then
      report "Error C.68 - in left vector did not return 'X'" severity failure;
    end if;

    sgn6 := "10-011";
    res8 := "00111001";
    if ((res8 ?>= sgn6) /= 'X') then
      report "Error C.68 - in right vector did not return 'X'" severity failure;
    end if;
  -- c.69
    uns6 := "100011";
    if ((50 ?>= uns6) /= '1') then
      report "Error C.69 natrual compare vector did not return '1'" severity failure;
    end if;
    if ((snat ?>= uns6) /= '0') then
      report "Error C.69 natrual compare vector did not return '0'" severity failure;
    end if;

  -- c.70
    sgn6 := "100100";
    --report to_string(to_integer(sgn6));
    if ((-29 ?>= sgn6) /= '0') then
      report "Error C.70 integer compare vector did not return '0'" severity failure;
    end if;
    if ((sint ?>= sgn6) /= '1') then
      report "Error C.70 integer compare vector did not return '1'" severity failure;
    end if;
  -- c.71
    uns6 := "100011";
    if ((uns6 ?>= 36) /= '0') then
      report "Error C.71 natural compare vector did not return '0'" severity failure;
    end if;
    if ((uns6 ?>= 16) /= '1') then
      report "Error C.71 natural compare vector did not return '1'" severity failure;
    end if;
  -- c.72
    sgn6 := "100100";
    --report to_string(to_integer(sgn6));
    if ((sgn6 ?>= -29) /= '1') then
      report "Error C.72 integer compare vector did not return '0'" severity failure;
    end if;
    if ((sgn6 ?>= sint) /= '0') then
      report "Error C.72 integer compare vector did not return '1'" severity failure;
    end if;

  -- c.73
    uns6 := "100011";
    if ((uns_nul ?= uns6) /= 'X') then
      report "Error C.73 null left vector did not return 'X'" severity failure;
    end if;
    if ((uns6 ?= uns_nul) /= 'X') then
      report "Error C.73 null right vector did not return 'X'" severity failure;
    end if;

  -- c.74
    sgn6 := "100011";
    if ((sgn6 ?= sgn_nul) /= 'X') then
      report "Error C.74 nul in right vector did not return 'X'" severity failure;
    end if;
    if ((sgn_nul ?= sgn6) /= 'X') then
      report "Error C.74 nul in left vector did not return 'X'" severity failure;
    end if;

  -- c.75
    uns6 := "100011";
    if ((35 ?= uns6) /= '1') then
      report "Error C.75 natrual compare vector did not return '1'" severity failure;
    end if;
    if ((snat ?= uns6) /= '0') then
      report "Error C.75 natrual compare vector did not return '0'" severity failure;
    end if;

  -- c.76
    sgn6 := "100100";
    if ((-28 ?= sgn6) /= '1') then
      report "Error C.76 integer compare vector did not return '1'" severity failure;
    end if;
    if ((sint ?= sgn6) /= '0') then
      report "Error C.76 - integer compare vector did not return '0'" severity failure;
    end if;

  -- c.77
    uns6 := "100011";
    if ((uns6 ?= 35) /= '1') then
      report "Error C.77 natrual compare vector did not return '1'" severity failure;
    end if;
    if ((uns6 ?= snat) /= '0') then
      report "Error C.77 natrual compare vector did not return '0'" severity failure;
    end if;

  -- c.78
    sgn6 := "100100";
    if ((sgn6 ?= -28) /= '1') then
      report "Error C.78 integer compare vector did not return '1'" severity failure;
    end if;
    if ((sgn6 ?= sint) /= '0') then
      report "Error C.78 - integer compare vector did not return '0'" severity failure;
    end if;

  -- c.79
    uns6 := "100011";
    if ((uns_nul ?/= uns6) /= 'X') then
      report "Error C.79 null left vector did not return 'X'" severity failure;
    end if;
    if ((uns6 ?/= uns_nul) /= 'X') then
      report "Error C.79 null right vector did not return 'X'" severity failure;
    end if;

  -- c.80
    sgn6 := "100011";
    if ((sgn6 ?/= sgn_nul) /= 'X') then
      report "Error C.80 nul in right vector did not return 'X'" severity failure;
    end if;
    if ((sgn_nul ?/= sgn6) /= 'X') then
      report "Error C.80 nul in left vector did not return 'X'" severity failure;
    end if;

  -- c.81
    uns6 := "100011";
    if ((35 ?/= uns6) /= '0') then
      report "Error C.81 natrual compare vector did not return '0'" severity failure;
    end if;
    if ((snat ?/= uns6) /= '1') then
      report "Error C.81 natrual compare vector did not return '1'" severity failure;
    end if;

  -- c.82
    sgn6 := "100100";
    if ((-28 ?/= sgn6) /= '0') then
      report "Error C.82 integer compare vector did not return '0'" severity failure;
    end if;
    if ((sint ?/= sgn6) /= '1') then
      report "Error C.82 integer compare vector did not return '1'" severity failure;
    end if;

  -- c.83
    uns6 := "100011";
    if ((uns6 ?/= 35) /= '0') then
      report "Error C.83 natrual compare vector did not return '0'" severity failure;
    end if;
    if ((uns6 ?/= snat) /= '1') then
      report "Error C.83 natrual compare vector did not return '1'" severity failure;
    end if;

  -- c.84
    sgn6 := "100100";
    --report to_string(to_integer(sgn6));
    if ((sgn6 ?/= -28) /= '0') then
      report "Error C.84 integer compare vector did not return '0'" severity failure;
    end if;
    if ((sgn6 ?/= sint) /= '1') then
      report "Error C.84 integer compare vector did not return '1'" severity failure;
    end if;

    report "Test Passed ...   Done C.49 to C.84 ..." severity note;
    wait;
  end process;
end ops;
