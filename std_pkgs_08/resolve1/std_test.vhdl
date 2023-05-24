------------------------------------------------
--!  Test intent : std_logic_1164  package tests.
--!  Test scope  : std_logic resolution.
--!  Keywords    : [std_logic, resolution]
--!  References  : [VH1993 Annex D:]
--
-------------------------------------------------
--  std_logic resolution.
library ieee;
use ieee.std_logic_1164.all;
--use not_ieee.subs_pkg.all;

entity std_std2 is
  -- local copy of resolution table
  TYPE mstdlogic_table IS ARRAY(std_logic, std_logic) OF std_logic;
  CONSTANT mresolution_table : mstdlogic_table := (
    --       ---------------------------------------------------------
    --       | U     X    0    1    Z    W    L    H    -        |   |
    --       ---------------------------------------------------------
             ( 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U' ), -- | U |
             ( 'U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X' ), -- | X |
             ( 'U', 'X', '0', 'X', '0', '0', '0', '0', 'X' ), -- | 0 |
             ( 'U', 'X', 'X', '1', '1', '1', '1', '1', 'X' ), -- | 1 |
             ( 'U', 'X', '0', '1', 'Z', 'W', 'L', 'H', 'X' ), -- | Z |
             ( 'U', 'X', '0', '1', 'W', 'W', 'W', 'W', 'X' ), -- | W |
             ( 'U', 'X', '0', '1', 'L', 'W', 'L', 'W', 'X' ), -- | L |
             ( 'U', 'X', '0', '1', 'H', 'W', 'W', 'H', 'X' ), -- | H |
             ( 'U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X' ) -- | - |
        );

end entity std_std2;

architecture rtl of std_std2 is
  signal r  : std_logic;
  signal p3 : std_logic;
  signal p4 : std_logic;
  signal clk : std_logic := '0';
  
  signal solo : std_logic_vector(0 downto 0);
  signal solo1 : std_logic;
  signal nvec : std_logic_vector(0 downto 1);
  signal rnvec : std_logic;

  signal cnt : integer := 0;
  
begin
  proc1: process
  begin
    wait for 1 ns;
    clk <= not clk;
  end process;

  solo(0) <= r;
  solo1 <= resolved(solo(0 downto 0));
  rnvec <= resolved(nvec);

  proc2: process(clk)
  begin
    if clk'event and clk = '1' then

      cnt <= cnt + 1;
      if cnt > 81 then
        report "Sim end ... Test Passed" severity failure;
      end if;  
    end if;
  end process;

  proc3: process(clk)
  begin
    if clk'event and clk = '1' then
      case cnt is
        -- U     X    0    1    Z    W    L    H    -
        when 0 to 8 =>
          r <= 'U';
          p3 <= 'U';
          when 9 to 17 =>
          r <= 'X';
          p3 <= 'X';
          when 18 to 26 =>
          r <= '0';
          p3 <= '0';
          when 27 to 35 =>
          r <= '1';
          p3 <= '1';
          when 36 to 44 =>
          r <= 'Z';
          p3 <= 'Z';
          when 45 to 53 =>
          r <= 'W';
          p3 <= 'W';
          when 54 to 62 =>
          r <= 'L';
          p3 <= 'L';
          when 63 to 71 =>
          r <= 'H';
          p3 <= 'H';
          when 72 to 80 =>
          r <= '-';
          p3 <= '-';
          when others =>
          r <= 'X';
          p3 <= 'X';
        end case;
    end if;
  end process;

  proc4: process(clk)
    variable v_val: std_logic := 'U';
  begin
    if clk'event and clk = '1' then
      r <= v_val;
      p4 <= v_val;
      if v_val = '-' then
        v_val := 'U';
      else
        v_val := std_logic'succ(v_val);
      end if;
    end if;
 end process;

  proc5: process(clk)
    variable v_tlogic : std_logic;
  begin
    if clk'event and clk = '0' then
      assert r = mresolution_table(p4, p3)
        report "Error: resolution not as expected" & LF &
               "   p3 driven    : " & std_logic'image(p3) & LF &
               "   p4 driven    : " & std_logic'image(p4) & LF &
               "            r is: " & std_logic'image(r) & LF &
               "local resolve is: "  & std_logic'image(mresolution_table(p4, p3))
               severity failure;
               
      assert solo1 = r report "Error: Solo1  not equal  r" severity failure;
      assert rnvec = 'Z' report "Error:  resolved nul vector did not return Z." severity failure;
    end if;
  end process;
end rtl;
