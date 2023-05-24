-------------- test case header    ------
--!  Test intent :  Coverage of std_logic_arith.
--!  Test scope  :  std_logic_arith  + functions
--!  Keywords    : [operations, plus]
--!  References  : [VH2008 16.6]
--!                [Rlink : REQ08xx]
-----------------------------------------------
--  std_logic_arith  generic '+'  tests.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity std_arith_1 is
end entity;

architecture ops of std_arith_1 is

begin
  process
  
    variable r : std_logic;
    variable ur : std_ulogic;
    variable ul : std_ulogic;
    variable slv : signed(7 downto 0);
    variable slvmax : signed(31 downto 0);
    variable slvexp : signed(31 downto 0);
    variable slvl : signed(7 downto 0);
    variable slvr : signed(7 downto 0);
    variable slvv : signed(7 downto 0);
    variable slvsum : signed(8 downto 0);
    variable uslv : unsigned(7 downto 0);
    variable uslvl : unsigned(7 downto 0);
    variable uslvr : unsigned(7 downto 0);
    variable uslvv : unsigned(7 downto 0);
    variable uslv1w : unsigned(0 downto 0);
    variable uv1w : unsigned(0 downto 0);
    
    variable stdlv : std_logic_vector(7 downto 0);
    variable stdlv32 : std_logic_vector(31 downto 0);
    variable stdlv32r : std_logic_vector(31 downto 0);
    variable stdlv9 : std_logic_vector(8 downto 0);
    variable stdex : std_logic_vector(7 downto 0);
    variable rstr  : string(1 to 8);
    variable rstr1  : string(1 to 9);
    
    variable cnt : integer;
    variable cntr : integer;
    variable sint : small_int;
    variable int1 : small_int := 1;
    variable int0 : small_int := 0;
    
  begin
    -- EQ subpgm_id 358
    uslv := "00000001";
    uslvv := (others => '0');
    uslvl := conv_unsigned(128,8);
    uslvr := shl(uslv, uslvl);
    assert uslvr = uslvv report "Error: large shift size not return expected  ID 358" severity failure;

    uslv := "00000001";
    uslvv := (others => 'X');
    uslvl := "0000X100";
    uslvr := shl(uslv, uslvl);
    assert uslvr = uslvv report "Error: X's in shift size not return expected  ID 358" severity failure;

    -- EQ subpgm_id 359
    slv := "00000001";
    slvv := (others => '0');
    uslvl := conv_unsigned(128,8);
    slvr := shl(slv, uslvl);
    assert slvr = slvv report "Error: large shift size not return expected  ID 359" severity failure;

    slv := "00000001";
    slvv := (others => 'X');
    uslvl := "0000X100";
    slvr := shl(slv, uslvl);
    assert slvr = slvv report "Error: X's in shift size not return expected  ID 359" severity failure;


    -- EQ subpgm_id 360
    for i in 7 downto 0 loop
      uslv := "10000000";
      uslvl := conv_unsigned(i,8);
      uslvr := shr(uslv, uslvl);
      cnt := 128/2**i;
      assert cnt = conv_integer(uslvr) report "Error Shift Right  ID 360" severity failure;
    end loop;

    for i in 7 downto 0 loop
      uslv := "10X00U0Z";
      uslvl := conv_unsigned(i,8);
      uslvr := shr(uslv, uslvl);
      cnt := 128/2**i;
      assert cnt = conv_integer(uslvr) report "Error Shift Right  ID 360" severity failure;
    end loop;
   
    uslvv := "XXXXXXXX";
    uslv := "10000000";
    uslvl := "0000X100";
    uslvr := shr(uslv, uslvl);
    assert uslvr = uslvv report "Error: a shift count with X did not return X.s  ID 360" severity failure;
    --  over rotate,  larger than vector size.
    uslv := "10000000";
    uslvl := conv_unsigned(128,8);
    uslvr := shr(uslv, uslvl);
    uslvv := (others => '0');
    assert uslvr = uslvv report "Error: large shift size not return expected  ID 360" severity failure;

    --  subpgm_id 361
    for i in 7 downto 0 loop
      slv := "01000000";
      uslvl := conv_unsigned(i,8);
      slvr := shr(slv, uslvl);
      cnt := 64/2**i;
      assert cnt = conv_integer(slvr) report "Error Shift Right  ID 360" severity failure;
    end loop;

    for i in 7 downto 0 loop
      slv := "10000000";
      uslvl := conv_unsigned(i,8);
      slvr := shr(slv, uslvl);
      cnt := -128/2**i;
      assert cnt = conv_integer(slvr) report "Error Shift Right  ID 360" severity failure;
    end loop;

    slv := "00000001";
    slvv := (others => '0');
    uslvl := conv_unsigned(1,8);
    slvr := shr(slv, uslvl);
    assert slvr = slvv report "Error: shr not return expected  ID 361" severity failure;

    slv := "00000001";
    slvv := (others => 'X');
    uslvl := ("00X00100");
    slvr := shr(slv, uslvl);
    assert slvr = slvv report "Error: x's in shift not return expected  ID 361" severity failure;
    
    slv := "00000001";
    slvv := (others => '0');
    uslvl := ("00100100");
    slvr := shr(slv, uslvl);
    assert slvr = slvv report "Error: large shift size not return expected  ID 361" severity failure;
    
    -- subpgm_id 365
    cnt := 25;
    cntr := conv_integer(cnt);
    assert cntr = cnt report "Error:  conv_integer on integer type  ID 365" severity failure;

    --report "  >>>>>>>    ID 367";
    -- subpgm_id 367
    slv := signed("Z0X0U0W1");
    cnt := conv_integer(slv);
    slv := signed("00000001");
    assert cnt = 1
      report "Error:  conv_integer on meta values did not return correct  ID 367" 
      severity failure;

    slvmax := (others => '0');
    slvmax(31) := '1';
    cnt := conv_integer(slvmax);
    assert cnt = integer'low
      report "Error:  conv_integer on signed all 1's not return correct  ID 367" 
      severity failure;
    
    -- subpgm_id 373
    slv := "0X000001";
    cnt := 15;
    uslvr := conv_unsigned(slv, 8);
    uslvv := (others => 'X');
    assert uslvr = uslvv
      report "Error:  conv_integer on meta values did not return correct  ID 373" 
      severity failure;

    -- subpgm_id 375
    ur :='X';
    ul :='X';
    uslv1w := conv_unsigned(ur, 1);
    uv1w := conv_unsigned('X', 1);
    assert uslv1w = uv1w
      report "Error:  conv_integer on meta values did not return correct  ID 375" 
      severity failure;

    -- subpgm_id 376
    cnt := integer'low;
    slvmax := conv_signed(cnt, 32);

    -- subpgm_id 377
    uslvl := "00100100";
    slvr := conv_signed(uslvl, 8);
    slv := "00100100";
    assert slv = slvr
      report "Error conv_signed  did not return the correct value  ID  377"
      severity failure;
    
    uslvl := "Z01X01U-";
    slvr := conv_signed(uslvl, 8);
    slv := "XXXXXXXX";
    assert slv = slvr
      report "Error conv_signed  did not return the correct value  ID  377"
      severity failure;

    -- subpgm_id 370
    for i in std_ulogic'low to std_ulogic'high loop
      sint := conv_integer(i);
      if i = '1' or i = 'H' then
        assert sint = int1
          report "Error: conv_integer on std_ulogic not return correct value ID 370"
          severity failure;
      else
        assert sint = int0
          report "Error: conv_integer on std_ulogic not return correct value ID 370"
          severity failure;
      end if;
    end loop;

    -- subpgm_id 380
    for i in std_ulogic'low to std_ulogic'high loop
      slv := conv_signed(i, 8);
      if i = '1' or i = 'H' then
        assert slv = signed("00000001")
          report "Error: conv_integer on std_ulogic not return correct value ID 380"
          severity failure;
      elsif i = '0' or i = 'L' then
        assert slv = signed("00000000")
          report "Error: conv_integer on std_ulogic not return correct value ID 380"
          severity failure;
      else
        assert slv = signed("XXXXXXXX")
          report "Error: conv_integer on std_ulogic not return correct value ID 380"
          severity failure;
      end if;
    end loop;

    -- subpgm_id 381
    stdlv32 := conv_std_logic_vector(integer'low, 32);
    stdlv32r := "10000000000000000000000000000000";
    assert stdlv32 = stdlv32r
      report "Error: return from conv_std_logic_vector not as expected ID 381"
      severity failure;
    
    -- subpgm_id 382
    uslv := "11110000";
    stdlv32 := conv_std_logic_vector(uslv, 32);
    stdlv32r := "00000000000000000000000011110000";
    assert stdlv32 = stdlv32r
      report"Error: return from conv_std_logic_vector not as expected ID 382"
      severity failure;

    uslv := "1Z1X0U0W";
    stdlv32 := conv_std_logic_vector(uslv, 32);
    stdlv32r := (others => 'X');
    assert stdlv32 = stdlv32r
      report"Error: return from conv_std_logic_vector not as expected ID 382"
      severity failure;

    -- subpgm_id 383
    slv := "11110000";
    stdlv32 := conv_std_logic_vector(slv, 32);
    stdlv32r := "11111111111111111111111111110000";
    assert stdlv32 = stdlv32r
      report"Error: return from conv_std_logic_vector not as expected ID 383"
      severity failure;

    slv := "1Z1X0U0W";
    stdlv32 := conv_std_logic_vector(slv, 32);
    stdlv32r := (others => 'X');
    assert stdlv32 = stdlv32r
      report"Error: return from conv_std_logic_vector not as expected ID 383"
      severity failure;

    -- subpgm_id 384
    ur := '1';
    stdlv32 := conv_std_logic_vector(ur, 32);
    stdlv32r := "00000000000000000000000000000001";
    assert stdlv32 = stdlv32r
      report"Error: return from conv_std_logic_vector not as expected ID 384"
      severity failure;

    for ur in std_ulogic'low to std_ulogic'high loop
      stdlv32 := conv_std_logic_vector(ur, 32);
      stdlv32r := (others => '0');
      case ur is
        when 'X' | 'W' | 'Z' | 'U' | '-' =>
          stdlv32r := (others => 'X');
        when '1' | 'H' =>
          stdlv32r(0) := '1';
        when '0' | 'L' =>
          null;
      end case;
      assert stdlv32 = stdlv32r
        report"Error: return from conv_std_logic_vector not as expected ID 384"
        severity failure;
    end loop;


    -- subpgm_id 385
    stdlv := "11101001";
    stdlv32 := ext(stdlv, 32);
    report to_string(stdlv32);
    stdlv := "Z11X1W-1";
    stdlv32 := ext(stdlv, 32);
    report to_string(stdlv32);
    
    -- subpgm_id 386
    stdlv := "11101001";
    stdlv32 := sxt(stdlv, 32);
    report to_string(stdlv32);
    stdlv := "Z11X1W-1";
    stdlv32 := sxt(stdlv, 32);
    report to_string(stdlv32);
    

    assert FALSE
      report "END OF test suite arith_1"
      severity note;

    wait;
  end process;

end ops;
