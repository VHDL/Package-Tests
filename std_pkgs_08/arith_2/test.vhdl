-------------- test case header    ------
--!  Test intent :  Coverage of std_logic_arith.
--!  Test scope  :  std_logic_arith  - functions
--!  Keywords    : [operations, minus]
--!  References  : [VH2008 16.6]
--!                [Rlink : REQ08xx]
-----------------------------------------------
--  std_logic_arith  generic '-'  tests.

library not_ieee;
use not_ieee.std_logic_1164.all;
use not_ieee.std_logic_arith.all;

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
    variable slvsum : signed(8 downto 0);
    variable uslv : unsigned(7 downto 0);
    variable uslvl : unsigned(7 downto 0);
    variable uslvr : unsigned(7 downto 0);
    
    variable stdlv : std_logic_vector(7 downto 0);
    variable stdlv9 : std_logic_vector(8 downto 0);
    variable stdex : std_logic_vector(7 downto 0);
    variable rstr  : string(1 to 8);
    variable rstr1  : string(1 to 9);
    
  begin
    --  function minus meta's
    --  signed
    slv := signed("10000000");
    for i in std_ulogic'low to std_ulogic'high loop
      slvl := "00000000";
      slvl(4) := i;
      case i is
         when 'Z' | 'W' | 'U' | 'X' | '-' =>
           assert slv - slvl = signed("XXXXXXXX")
             report "Error: function minus(signed) did not return x's when passed meta value"
             severity failure;
         when '1' | 'H' =>
           assert slv - slvl = conv_signed(-144, 8)
             report "Error: function minus(signed) did not return expected value"
             severity failure;
         when '0' | 'L' =>
           assert slv - slvl = signed("10000000")
             report "Error: function minus(signed) did not return expected value"
             severity failure;
      end case;
    end loop;
  
    -- EQ subpgm_id 248
    for i in -10 to 50 loop
      uslvl := CONV_unSIGNED(i, 8);
      for j in -10 to 10 loop
        uslv := CONV_unSIGNED(j, 8);
        uslvr := uslvl-uslv;
        rstr := to_string(CONV_UNSIGNED(i-j, 8));
        assert to_string(uslvr) = rstr report "Error in  ID 248" severity failure;
      end loop;
    end loop;
    --  unsigned
    uslv := unsigned("10000000");
    for i in std_ulogic'low to std_ulogic'high loop
      uslvl := "00000000";
      uslvl(4) := i;
      case i is
         when 'Z' | 'W' | 'U' | 'X' | '-' =>
           assert uslv - uslvl = unsigned("XXXXXXXX")
             report "Error: function minus(unsigned) did not return x's when passed meta value"
             severity failure;
         when '1' | 'H' =>
           assert uslv - uslvl = conv_unsigned(112, 8)
             report "Error: function minus(unsigned) did not return expected value"
             severity failure;
         when '0' | 'L' =>
           assert uslv - uslvl = unsigned("10000000")
             report "Error: function minus(unsigned) did not return expected value"
             severity failure;
      end case;
    end loop;
  

    

    -- EQ subpgm_id 249
    for i in -10 to 50 loop
      slvl := CONV_SIGNED(i, 8);
      for j in -10 to 10 loop
        slv := CONV_SIGNED(j, 8);
        slvr := slvl-slv;
        rstr := to_string(CONV_SIGNED(i-j, 8));
        assert to_string(slvr) = rstr report "Error in  ID 249" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 250
    for i in 0 to 50 loop
      uslvl := CONV_unSIGNED(i, 8);
      for j in -10 to 10 loop
        slv := CONV_SIGNED(j, 8);
        slvsum := uslvl-slv;
        rstr1 := to_string(CONV_SIGNED(i-j, 9));
        assert to_string(slvsum) = rstr1 report "Error in  ID 250" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 251
    for i in -10 to 50 loop
      slvl := CONV_SIGNED(i, 8);
      for j in 0 to 10 loop
        uslv := CONV_unSIGNED(j, 8);
        slvsum := slvl-uslv;
        rstr1 := to_string(CONV_SIGNED(i-j, 9));
        assert to_string(slvsum) = rstr1 report "Error in  ID 251" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 252
    for i in 0 to 50 loop
      uslvl := CONV_unSIGNED(i, 8);
      for j in -10 to 10 loop
        uslvr := uslvl-j;
        rstr := to_string(CONV_unSIGNED(i-j, 8));
        assert to_string(uslvr) = rstr report "Error in  ID 252" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 253
    for i in -10 to 50 loop
      for j in 0 to 10 loop
        uslv := CONV_unSIGNED(j, 8);
        uslvr := i-uslv;
        rstr := to_string(CONV_unSIGNED(i-j, 8));
        assert to_string(uslvr) = rstr report "Error in  ID 253" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 254
    for i in -10 to 50 loop
      slvl := CONV_SIGNED(i, 8);
      for j in -10 to 10 loop
        slvr := slvl-j;
        rstr := to_string(CONV_SIGNED(i-j, 8));
        assert to_string(slvr) = rstr report "Error in  ID 254" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 255
    for i in -10 to 50 loop
      for j in -10 to 10 loop
        slv := CONV_SIGNED(j, 8);
        slvr := i-slv;
        rstr := to_string(CONV_SIGNED(i-j, 8));
        assert to_string(slvr) = rstr report "Error in  ID 255" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 256
    ur := '1';
    for i in 0 to 50 loop
      uslv := CONV_unSIGNED(i, 8);
      uslvr := uslv-ur;
      rstr := to_string(CONV_unSIGNED(i-1, 8));
      assert to_string(uslvr) = rstr report "Error in  ID 256" severity failure;
    end loop;

    ur := '0';
    for i in 0 to 5 loop
      uslv := CONV_unSIGNED(i, 8);
      uslvr := uslv-ur;
      rstr := to_string(CONV_unSIGNED(i, 8));
      assert to_string(uslvr) = rstr report "Error in  ID 256" severity failure;
    end loop;

    -- EQ subpgm_id 257
    ul := '1';
    for i in 0 to 50 loop
      uslv := CONV_unSIGNED(i, 8);
      uslvr := ul-uslv;
      rstr := to_string(CONV_unSIGNED(1-i, 8));
--      report rstr;
      assert to_string(uslvr) = rstr report "Error in  ID 257" severity failure;
    end loop;

    ul := '0';
    for i in -10 to 5 loop
      uslv := CONV_unSIGNED(i, 8);
      uslvr := ul-uslv;
      rstr := to_string(CONV_unSIGNED(-i, 8));
--      report rstr;
      assert to_string(uslvr) = rstr report "Error in  ID 257" severity failure;
    end loop;

    -- EQ subpgm_id 258
    ur := '1';
    for i in -10 to 50 loop
      slv := CONV_SIGNED(i, 8);
      slvr := slv-ur;
      rstr := to_string(CONV_SIGNED(i-1, 8));
      assert to_string(slvr) = rstr report "Error in  ID 258" severity failure;
    end loop;

    ur := '0';
    for i in -10 to 5 loop
      slv := CONV_SIGNED(i, 8);
      slvr := slv-ur;
      rstr := to_string(CONV_SIGNED(i, 8));
      assert to_string(slvr) = rstr report "Error in  ID 258" severity failure;
    end loop;

    -- EQ subpgm_id 259
    ul := '1';
    for i in -10 to 50 loop
      slv := CONV_SIGNED(i, 8);
      slvr := ul-slv;
      rstr := to_string(CONV_SIGNED(1-i, 8));
      assert to_string(slvr) = rstr report "Error in  ID 259" severity failure;
    end loop;

    ul := '0';
    for i in -10 to 5 loop
      slv := CONV_SIGNED(i, 8);
      slvr := ul-slv;
      rstr := to_string(CONV_SIGNED(-i, 8));
      assert to_string(slvr) = rstr report "Error in  ID 259" severity failure;
    end loop;

    -- EQ subpgm_id 272
    for i in -10 to 50 loop
      uslvr := CONV_UNSIGNED(i, 8);
      for j in 0 to 10 loop
        uslvl := CONV_UNSIGNED(j, 8);
        stdlv := uslvr - uslvl;
        rstr := to_string(CONV_UNSIGNED(i-j, 8));
        assert to_string(stdlv) = rstr report "Error in  ID 272" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 273
    for i in -25 to 50 loop
      slvl := CONV_SIGNED(i, 8);
      for j in -10 to 10 loop
        slv := CONV_SIGNED(j, 8);
        stdlv := slvl-slv;
        rstr := to_string(CONV_SIGNED(i-j, 8));
        assert to_string(stdlv) = rstr report "Error in  ID 273" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 274
    for i in 0 to 50 loop
      uslvl := CONV_unSIGNED(i, 8);
      for j in -10 to 10 loop
        slv := CONV_SIGNED(j, 8);
        stdlv9 := uslvl-slv;
        rstr1 := to_string(CONV_std_logic_vector(i-j, 9));
        assert to_string(stdlv9) = rstr1 report "Error in  ID 274" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 275
    for i in 0 to 50 loop
      uslvl := CONV_unSIGNED(i, 8);
      for j in -10 to 10 loop
        slv := CONV_SIGNED(j, 8);
        stdlv9 := slv-uslvl;
        rstr1 := to_string(CONV_std_logic_vector(j-i, 9));
        assert to_string(stdlv9) = rstr1 report "Error in  ID 275" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 276
    for i in -10 to 50 loop
      for j in 0 to 10 loop
        uslv := CONV_UNSIGNED(j, 8);
        stdlv := uslv-i;
        rstr := to_string(CONV_UNSIGNED(j-i, 8));
        assert to_string(stdlv) = rstr report "Error in  ID 276" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 277
    for i in -10 to 50 loop
      for j in 0 to 10 loop
        uslv := CONV_UNSIGNED(j, 8);
        stdlv := i-uslv;
        rstr := to_string(CONV_UNSIGNED(i-j, 8));
        assert to_string(stdlv) = rstr report "Error in  ID 277" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 278
    for i in -25 to 50 loop
      for j in -10 to 10 loop
        slv := CONV_SIGNED(j, 8);
        stdlv := slv-i;
        rstr := to_string(CONV_SIGNED(j-i, 8));
        assert to_string(stdlv) = rstr report "Error in  ID 278" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 279
    for i in -25 to 50 loop
      for j in -10 to 10 loop
        slv := CONV_SIGNED(j, 8);
        stdlv := i-slv;
        rstr := to_string(CONV_UNSIGNED(i-j, 8));
        assert to_string(stdlv) = rstr report "Error in  ID 279" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 280
    ur := '1';
    for i in 0 to 50 loop
      uslv := CONV_unSIGNED(i, 8);
      stdlv := uslv-ur;
      rstr := to_string(CONV_unSIGNED(i-1, 8));
      assert to_string(stdlv) = rstr report "Error in  ID 280" severity failure;
    end loop;

    ur := '0';
    for i in 0 to 5 loop
      uslv := CONV_unSIGNED(i, 8);
      stdlv := uslv-ur;
      rstr := to_string(CONV_unSIGNED(i, 8));
      assert to_string(stdlv) = rstr report "Error in  ID 280" severity failure;
    end loop;

    -- EQ subpgm_id 281
    ur := '1';
    for i in 0 to 50 loop
      uslv := CONV_unSIGNED(i, 8);
      stdlv := ur-uslv;
      rstr := to_string(CONV_unSIGNED(1-i, 8));
      assert to_string(stdlv) = rstr report "Error in  ID 281" severity failure;
    end loop;

    ur := '0';
    for i in 0 to 5 loop
      uslv := CONV_unSIGNED(i, 8);
      stdlv := ur-uslv;
      rstr := to_string(CONV_unSIGNED(-i, 8));
      assert to_string(stdlv) = rstr report "Error in  ID 281" severity failure;
    end loop;

    -- EQ subpgm_id 282
    ur := '1';
    for i in -10 to 50 loop
      slv := CONV_SIGNED(i, 8);
      stdlv := slv-ur;
      rstr := to_string(CONV_SIGNED(i-1, 8));
      assert to_string(stdlv) = rstr report "Error in  ID 282" severity failure;
    end loop;

    ur := '0';
    for i in -10 to 5 loop
      slv := CONV_SIGNED(i, 8);
      stdlv := slv-ur;
      rstr := to_string(CONV_SIGNED(i, 8));
      assert to_string(stdlv) = rstr report "Error in  ID 282" severity failure;
    end loop;

    -- EQ subpgm_id 283
    ur := '1';
    for i in -10 to 50 loop
      slv := CONV_SIGNED(i, 8);
      stdlv := ur-slv;
      rstr := to_string(CONV_SIGNED(1-i, 8));
      assert to_string(stdlv) = rstr report "Error in  ID 283" severity failure;
    end loop;

    ur := '0';
    for i in -10 to 5 loop
      slv := CONV_SIGNED(i, 8);
      stdlv := ur-slv;
      rstr := to_string(CONV_SIGNED(-i, 8));
      assert to_string(stdlv) = rstr report "Error in  ID 283" severity failure;
    end loop;

    assert FALSE
      report "END OF test suite arith_2"
      severity note;

    wait;
  end process;

end ops;

