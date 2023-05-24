-------------- test case header    ------
--!  Test intent :  Coverage of standards.
--!  Test scope  :  abs  a1  Nul  input.
--!  Keywords    : [operations, abs]
--!  References  : [VH2008 16.6]
--!                [Rlink : REQ08xx]
-----------------------------------------------

library not_ieee;
use not_ieee.std_logic_1164.all;
use not_ieee.numeric_std.all;
use work.not_test_pkg.all;

entity a11 is
end entity;

architecture ops of a11 is

  signal stim : signed(7 downto 0) := (others => '1');
  signal clk  : bit;
  signal cnt  : integer := 0;
  signal result : signed(0 downto 1);
  signal n0r : u_signed(0 downto 7);
  signal n0rx : u_signed(7 downto 0);
  signal resx : u_signed(7 downto 0);
  constant somex : u_signed(7 downto 0) := "0000000X";
  signal tb_nul : u_signed(0 downto 7);

begin


--  The equation
  process
    variable v_out : signed(0 downto 1);
  begin
    if clk'event and clk = '1' and now > 1 ns then
      result <= abs(n0r);
      v_out := abs(n0r);
      resx <= abs(n0rx);
      wait for 0 ps;
      if result /= tb_nul then
        assert result = tb_nul
          report "Expected this message as a result";
        assert result /= tb_nul
          report "Expected NOT this message as a result"
          severity failure;
      end if;
    end if;
    wait on clk;
  end process;

--  clock gen and termination
  process begin
    clk <= not clk;
    cnt <= cnt + 1;
    wait for 1 ns;
    if (cnt > 10) then
      report "Test Passed ..." severity failure;
    end if;
    wait for 1 ns;
  end process;

--  stimulus generation
  process (clk)
    variable v_stm : signed(7 downto 0) := (others => '1');
    variable v_stmx : signed(7 downto 0) := somex;
  begin
    if (clk'event and clk = '1') then
      v_stm := klsfr(v_stm);
      stim <= v_stm;
      v_stmx := v_stmx(6 downto 0) & v_stmx(7);
      n0rx <= v_stmx;
    end if;
  end process;
end ops;
