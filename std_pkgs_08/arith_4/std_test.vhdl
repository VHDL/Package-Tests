-------------- test case header    ------
--!  Test intent :  Coverage of std_logic_arith.
--!  Test scope  :  std_logic_arith  * functions
--!  Keywords    : [operations, multiply]
--!  References  : [VH2008 16.6]
--!                [Rlink : REQ08xx]
-----------------------------------------------
--  std_logic_arith  generic '*'  tests.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity test is 
end entity;

architecture ops of test is 

begin
  process
  
    variable r : std_logic;
    variable ur : std_ulogic;
    variable ul : std_ulogic;
    variable slv : signed(7 downto 0);
    variable slvl : signed(7 downto 0);
    variable slvr : signed(7 downto 0);
    variable slvrs : signed(16 downto 0);
    variable slvsum : signed(8 downto 0);
    variable uslv : unsigned(7 downto 0);
    variable uslvl : unsigned(7 downto 0);
    variable uslvr : unsigned(15 downto 0);
    variable uslvrs : unsigned(16 downto 0);
    
    variable stdlv : std_logic_vector(7 downto 0);
    variable stdlv16 : std_logic_vector(15 downto 0);
    variable stdlv17 : std_logic_vector(16 downto 0);
    variable stdex : std_logic_vector(7 downto 0);
    variable rstr  : string(1 to 8);
    variable rstrm  : string(1 to 16);
    variable rstrms  : string(1 to 17);
    
    variable cnt : integer;
    
  begin
    
    -- EQ subpgm_id 284
    for i in 0 to 10 loop
      uslv := CONV_unSIGNED(i, 8);
      uslvl := + uslv;
      assert uslvl = uslv report "Error: + function ID 284." severity failure;
    end loop;
    
    -- EQ subpgm_id 285
    for i in -10 to 10 loop
      slv := CONV_SIGNED(i, 8);
      slvl := + slv;
      assert slvl = slv report "Error: + function ID 285." severity failure;
    end loop;
    
    -- EQ subpgm_id 289
    for i in 0 to 10 loop
      uslv := CONV_unSIGNED(i, 8);
      stdlv := + uslv;
      assert to_string(stdlv) = to_string(uslv) report "Error: + function ID 289." severity failure;
    end loop;
    
    -- EQ subpgm_id 290
    for i in -10 to 10 loop
      slv := CONV_SIGNED(i, 8);
      stdlv := + slv;
      assert to_string(stdlv) = to_string(slv) report "Error: + function ID 290." severity failure;
    end loop;
    
    -- EQ subpgm_id 292
    for i in -10 to 10 loop
      slv := CONV_SIGNED(i, 8);
      stdex := conv_std_logic_vector(0-i, 8);
      stdlv := - slv;
      assert stdlv = stdex report "Error: + function ID 292." severity failure;
    end loop;
    
    -- EQ subpgm_id 294
    for i in -10 to 10 loop
      slv := CONV_SIGNED(i, 8);
      stdlv := abs(slv);
      stdex := CONV_std_logic_vector(abs(i), 8);
      assert stdlv = stdex report "Error: abs function ID 294." severity failure;
    end loop;
    --  <
    -- EQ subpgm_id 305
    uslvl := "00001011";
    for i in 0 to 10 loop
      uslv := CONV_unSIGNED(i, 8);
      assert (uslv < uslvl) report "Error: < function ID 305." severity failure;
    end loop;
    
     -- EQ subpgm_id 306
    slvl := "00001011";
    for i in -10 to 10 loop
      slv := CONV_SIGNED(i, 8);
      assert (slv < slvl) report "Error: < function ID 306." severity failure;
    end loop;
    
     -- EQ subpgm_id 307
    slvl := "00001011";
    for i in 0 to 10 loop
      uslv := CONV_unSIGNED(i, 8);
      assert (uslv < slvl) report "Error: < function ID 307." severity failure;
    end loop;
    
     -- EQ subpgm_id 308
    uslvl := "00001011";
    for i in -10 to 10 loop
      slv := CONV_SIGNED(i, 8);
      assert (slv < uslvl) report "Error: < function ID 308." severity failure;
    end loop;
    
    -- EQ subpgm_id 309
    uslvl := "00001011";
    for i in 0 to 10 loop
      assert (i < uslvl) report "Error: < function ID 309." severity failure;
    end loop;
    
    -- EQ subpgm_id 310
    uslvl := "00001011";
    for i in 20 to 30 loop
      assert (uslvl < i) report "Error: < function ID 310." severity failure;
    end loop;
    
     -- EQ subpgm_id 311
    slvl := "00001011";
    for i in -10 to 10 loop
      assert (i < slvl) report "Error: < function ID 311." severity failure;
    end loop;
    
     -- EQ subpgm_id 312
    slvl := "10001011";
    for i in -10 to 10 loop
      assert (slvl < i) report "Error: < function ID 312." severity failure;
    end loop;
    
    --  <=
    -- EQ subpgm_id 314
    uslvl := "00001011";
    for i in 0 to 11 loop
      uslv := CONV_unSIGNED(i, 8);
      assert (uslv <= uslvl) report "Error: <= function ID 314." severity failure;
    end loop;
    
    -- EQ subpgm_id 315
    slvl := "00001011";
    for i in -10 to 11 loop
      slv := CONV_SIGNED(i, 8);
      assert (slv <= slvl) report "Error: <= function ID 315." severity failure;
    end loop;
    
    -- EQ subpgm_id 316
    slvl := "00001011";
    for i in 0 to 11 loop
      uslv := CONV_unSIGNED(i, 8);
      assert (uslv <= slvl) report "Error: <= function ID 316." severity failure;
    end loop;
    
    -- EQ subpgm_id 317
    uslvl := "00001011";
    for i in -10 to 11 loop
      slv := CONV_SIGNED(i, 8);
      assert (slv <= uslvl) report "Error: <= function ID 317." severity failure;
    end loop;
    
    -- EQ subpgm_id 318
    uslvl := "00001011";
    for i in 11 to 20 loop
      assert (uslvl <= i) report "Error: <= function ID 318." severity failure;
    end loop;
    
    -- EQ subpgm_id 319
    uslvl := "00001011";
    for i in 0 to 11 loop
      assert (i <= uslvl) report "Error: <= function ID 319." severity failure;
    end loop;
    
     -- EQ subpgm_id 320
    slvl := "00001011";
    for i in 11 to 20 loop
      assert (slvl <= i) report "Error: <= function ID 320." severity failure;
    end loop;
    
     -- EQ subpgm_id 321
    slvl := "00001011";
    for i in -10 to 11 loop
      assert (i <= slvl) report "Error: <= function ID 321." severity failure;
    end loop;
    
   -- >
    -- EQ subpgm_id 323
    uslvl := "00001011";
    for i in 0 to 10 loop
      uslv := CONV_unSIGNED(i, 8);
      assert (uslvl > uslv) report "Error: > function ID 323." severity failure;
    end loop;
    
     -- EQ subpgm_id 324
    slvl := "00001011";
    for i in -10 to 10 loop
      slv := CONV_SIGNED(i, 8);
      assert (slvl > slv) report "Error: > function ID 324." severity failure;
    end loop;
    
     -- EQ subpgm_id 326
    slvl := "00001011";
    for i in 0 to 10 loop
      uslv := CONV_unSIGNED(i, 8);
      assert (slvl > uslv) report "Error: > function ID 326." severity failure;
    end loop;
    
     -- EQ subpgm_id 325
    uslvl := "00001011";
    for i in -10 to 10 loop
      slv := CONV_SIGNED(i, 8);
      assert (uslvl > slv) report "Error: > function ID 325." severity failure;
    end loop;
    
    -- EQ subpgm_id 327
    uslvl := "00001011";
    for i in 0 to 10 loop
      assert (uslvl > i) report "Error: > function ID 327." severity failure;
    end loop;
    
    -- EQ subpgm_id 328
    uslvl := "00001011";
    for i in 20 to 30 loop
      assert (i > uslvl) report "Error: > function ID 328." severity failure;
    end loop;
    
     -- EQ subpgm_id 329
    slvl := "00001011";
    for i in -10 to 10 loop
      assert (slvl > i) report "Error: > function ID 329." severity failure;
    end loop;
    
     -- EQ subpgm_id 330
    slvl := "10001011";
    for i in -10 to 10 loop
      assert (i > slvl) report "Error: > function ID 330." severity failure;
    end loop;
    
    --  <=
    -- EQ subpgm_id 332
    uslvl := "00001011";
    for i in 0 to 11 loop
      uslv := CONV_unSIGNED(i, 8);
      assert (uslvl >= uslv) report "Error: >= function ID 332." severity failure;
    end loop;
    
    -- EQ subpgm_id 333
    slvl := "00001011";
    for i in -10 to 11 loop
      slv := CONV_SIGNED(i, 8);
      assert (slvl >= slv) report "Error: >= function ID 333." severity failure;
    end loop;
    
    -- EQ subpgm_id 335
    slvl := "00001011";
    for i in 0 to 11 loop
      uslv := CONV_unSIGNED(i, 8);
      assert (slvl >= uslv) report "Error: >= function ID 335." severity failure;
    end loop;
    
    -- EQ subpgm_id 334
    uslvl := "00001011";
    for i in -10 to 11 loop
      slv := CONV_SIGNED(i, 8);
      assert (uslvl >= slv) report "Error: >= function ID 334." severity failure;
    end loop;
    
    -- EQ subpgm_id 336
    uslvl := "00001011";
    for i in 11 to 20 loop
      assert (i >= uslvl) report "Error: >= function ID 336." severity failure;
    end loop;
    
    -- EQ subpgm_id 335
    uslvl := "00001011";
    for i in 0 to 11 loop
      assert (uslvl >= i) report "Error: >= function ID 335." severity failure;
    end loop;
    
     -- EQ subpgm_id 339
    slvl := "00001011";
    for i in 11 to 20 loop
      assert (i >= slvl) report "Error: >= function ID 339." severity failure;
    end loop;
    
     -- EQ subpgm_id 338
    slvl := "00001011";
    for i in -10 to 11 loop
      assert (slvl >= i) report "Error: >= function ID 338." severity failure;
    end loop;
    
    --  =
    -- EQ subpgm_id 341
    uslv := (others => '0');
    uslvl := (others => '0');
    for i in 0 to 20 loop
      assert uslv = uslvl  report "Error: = function ID 341." severity failure;
      uslv := uslv + 1;
      uslvl := uslvl +'1';
    end loop;
    uslv := (others => '0');
    assert uslv = uslvl  report "Note: = expected fail function ID 341." severity note;

    -- EQ subpgm_id 342
    slv := conv_signed(-10, 8);
    slvl := conv_signed(-10, 8);
    for i in -10 to 20 loop
      assert slv = slvl  report "Error: = function ID 342." severity failure;
      slv := slv + 1;
      slvl := slvl +'1';
    end loop;
    slv := conv_signed(-10, 8);
    assert slv = slvl  report "Note: = expected fail function ID 342." severity note;

    -- EQ subpgm_id 343
    uslv := (others => '0');
    slvl := conv_signed(0, 8);
    for i in -10 to 20 loop
      assert uslv = slvl  report "Error: = function ID 343." severity failure;
      uslv := uslv + 1;
      slvl := slvl +'1';
    end loop;
    uslv := (others => '0');
    assert uslv = slvl  report "note: = expected fail function ID 343." severity note;

    -- EQ subpgm_id 344
    uslv := (others => '0');
    slvl := conv_signed(0, 8);
    for i in -10 to 20 loop
      assert slvl = uslv  report "Error: = function ID 344." severity failure;
      uslv := uslv + 1;
      slvl := slvl +'1';
    end loop;

    -- EQ subpgm_id 345
    uslv := (others => '0');
    for i in 0 to 20 loop
      assert uslv = i  report "Error: = function ID 345." severity failure;
      uslv := uslv + 1;
    end loop;

    -- EQ subpgm_id 346
    uslv := (others => '0');
    for i in 0 to 20 loop
      assert i = uslv  report "Error: = function ID 346." severity failure;
      uslv := uslv + 1;
    end loop;

    -- EQ subpgm_id 347
    slv := conv_signed(-10, 8);
    for i in -10 to 20 loop
      assert slv = i  report "Error: = function ID 347." severity failure;
      slv := slv + 1;
    end loop;

    -- EQ subpgm_id 348
    slv := conv_signed(-10, 8);
    for i in -10 to 20 loop
      assert i = slv  report "Error: = function ID 348." severity failure;
      slv := slv + 1;
    end loop;

    slv := conv_signed(-10, 8);
    slvl := conv_signed(0, 8);
    uslv := (others => '0');
    uslvl := "00101001";
    cnt := 1000;
    
    assert uslv /= uslvl report "Error: /= function ID 350." severity failure;
    assert uslv /= uslv  report "Note:  Not equal  but are ..  coverage ID 350" severity note;
    assert slv /= slvl report "Error: /= function ID 351." severity failure;
    assert uslv /= slv report "Error: /= function ID 352." severity failure;
    assert slv /= uslvl report "Error: /= function ID 353." severity failure;
    assert uslv /= 6 report "Error: /= function ID 354." severity failure;
    assert 0 /= uslvl report "Error: /= function ID 355." severity failure;
    assert slv /= 33 report "Error: /= function ID 356." severity failure;
    assert 15 /= slvl report "Error: /= function ID 357." severity failure;

    assert FALSE
      report "END OF test suite arith_4"
      severity note;

    wait;
  end process;

end ops;

