-------------- test case header    ------
--!  Test intent :  Coverage of standards.
--!  Test scope  :  abs  a1  Nul  input.
--!  Keywords    : [operations, abs]
--!  References  : [VH2008 16.6]
--!                [Rlink : REQ08xx]
-----------------------------------------------
--  a1 and a2  from bishop tests.

library not_ieee;
use not_ieee.std_logic_1164.all;
use not_ieee.numeric_std.all;

entity test is 
end entity;

architecture ops of test is 

  -- required by A.1, A.2 tests
  constant max_size_checked : integer := 200;
  constant temp1    : signed( max_size_checked-2 downto 0 ) := (others => '1');
  constant temp0    : signed( max_size_checked-2 downto 0 ) := (others => '0');
  constant posmax   : signed( max_size_checked-1 downto 0 ) := '0' & temp1;
  constant neg1     : signed( max_size_checked-1 downto 0 ) := (others => '1');
  constant negmin   : signed( max_size_checked-1 downto 0 ) := ('1', others => '0');
  constant zero     :  signed( max_size_checked-1 downto 0 ) := (others => '0');


  signal stim : signed(7 downto 0) := (others => '1');
  signal clk  : bit;
  signal cnt  : integer := 0;

begin

--  The equation
  process
    variable x : signed( max_size_checked-1 downto 0 ) := zero;
  begin
    if clk'event and clk = '1' and now > 1 ns then
      --                             -01111...1111 = 11111...1111 + 1
      assert -(posmax) = negmin + (-neg1) severity failure;
      --                                                   - (-3) = 3
      assert -signed'('1', '0', '1') = signed'('0', '1', '1') severity failure;
      --                                                    -(3) = -3
      assert -signed'('0', '1', '1') = signed'('1', '0', '1') severity failure;
      --                                                     -(-2)= 2
      assert -signed'('1', '1', '0') = signed'('0', '1', '0') severity failure;
      --                                                     -(2)= -2
      assert -signed'('0', '1', '0') = signed'('1', '1', '0') severity failure;
      --                                                     -(-1)= 1
      assert -signed'('1', '1', '1') = signed'('0', '0', '1') severity failure;
      --                                                     -(1)= -1
      assert -signed'('0', '0', '1') = signed'('1', '1', '1') severity failure;

      assert -zero = zero severity failure;
      --  A2
      assert posmax = abs(negmin + (-neg1)) severity failure;
      --                                                  abs(-3) = 3
      assert abs(signed'('1', '0', '1')) = signed'('0', '1', '1') severity failure;
      --                                                  abs(-2) = 2
      assert abs(signed'('1', '1', '0')) = signed'('0', '1', '0') severity failure;
      --                                                 abs(-1) = 1
      assert abs(signed'('1', '1', '1')) = signed'('0', '0', '1') severity failure;

      assert abs(zero) = zero severity failure;
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

