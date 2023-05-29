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

entity test is 
end entity;

architecture ops of test is 

  signal clk  : bit;
  signal cnt  : integer := 0;
  signal result : signed(0 downto 1);
  signal n0r : u_signed(0 downto 7);
  signal n0rx : u_signed(7 downto 0);
  signal resx : u_signed(7 downto 0);
  constant somex : u_signed(7 downto 0) := "0000000X";
  constant zv    : u_signed(7 downto 0) := "00000000";

begin


--  The equation
  process
    variable v_out : signed(0 downto 1);
  begin
    if clk'event and clk = '1' and now > 1 ns then
      result <= - n0r;
      v_out := - n0r;
      resx <=  - n0rx;
      wait for 0 ps;
      report "Expect Null: " & "'" & to_string(result) & "'";
      report to_string(resx);
    end if;
    wait on clk;
  end process;

--  clock gen and termination
  process
    variable v_res : u_signed(7 downto 0);
  begin
    clk <= not clk;
    cnt <= cnt + 1;
    wait for 1 ns;
    if (cnt > 10) then
      report "Test Passed ... a divide by zero error will now cause the simulation to terminate" severity note;
      v_res  :=  n0rx / zv;
      wait for 1 ns;
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
      n0rx <= v_stm;
    end if;
  end process;
end ops;

