-------------- test case header    ------
--!  Test intent :  Coverage of standards.
--!  Test scope  :  abs  a1  Nul  input.
--!  Keywords    : [operations, abs]
--!  References  : [VH2008 16.6]
--!                [Rlink : REQ08xx]
-----------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test is 
end entity;

architecture ops of test is 

  signal clk  : bit := '0';
  signal cnt  : integer := 0;
  signal result : signed(7 downto 0);
  signal n0r    : signed(7 downto 0) := (others => '1');

begin


--  The equation
  process
    variable v_out : signed(0 downto 1);
  begin
    if clk'event and clk = '1' and now > 1 ns then
      result <= n0r / 0;
      wait;
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

end ops;

