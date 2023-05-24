-------------- test case header    ------
--!  Test intent :  Coverage of std_logic_arith.
--!  Test scope  :  std_logic_arith  + functions
--!  Keywords    : [operations, plus]
--!  References  : [VH2008 16.6]
--!                [Rlink : REQ08xx]
-----------------------------------------------
--  std_logic_arith  generic '+'  tests.

library not_ieee;
use not_ieee.std_logic_1164.all;
use not_ieee.std_logic_arith.all;

entity arith_1 is
end entity;

architecture ops of arith_1 is

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
    -- function plus (signed) metas
    slv := signed("10000000");
    for i in std_ulogic'low to std_ulogic'high loop
      slvl := "00000000";
      slvl(4) := i;
      case i is
         when 'Z' | 'W' | 'U' | 'X' | '-' =>
           assert slv + slvl = signed("XXXXXXXX")
             report "Error: function plus(signed) did not return x's when passed meta value"
             severity failure;
         when '1' | 'H' =>
           assert slv + slvl = conv_signed(-112, 8)
             report "Error: function plus(signed) did not return expected value"
             severity failure;
         when '0' | 'L' =>
           assert slv + slvl = signed("10000000")
             report "Error: function plus(signed) did not return expected value"
             severity failure;
      end case;
    end loop;
  
    -- function plus (unsigned) metas
    uslv := unsigned("10000000");
    for i in std_ulogic'low to std_ulogic'high loop
      uslvl := "00000000";
      uslvl(4) := i;
      case i is
         when 'Z' | 'W' | 'U' | 'X' | '-' =>
           assert uslv + uslvl = unsigned("XXXXXXXX")
             report "Error: function plus(signed) did not return x's when passed meta value"
             severity failure;
         when '1' | 'H' =>
           assert uslv + uslvl = conv_unsigned(144, 8)
             report "Error: function plus(signed) did not return expected value"
             severity failure;
         when '0' | 'L' =>
           assert uslv + uslvl = unsigned("10000000")
             report "Error: function plus(signed) did not return expected value"
             severity failure;
      end case;
    end loop;
  
    -- EQ subpgm_id 236
    for i in -10 to 50 loop
      uslvl := CONV_unSIGNED(i, 8);
      for j in -10 to 10 loop
        uslv := CONV_unSIGNED(j, 8);
        uslvr := uslvl+uslv;
        rstr := to_string(CONV_UNSIGNED(i+j, 8));
        assert to_string(uslvr) = rstr report "Error in  ID 236" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 237
    for i in -10 to 50 loop
      slvl := CONV_SIGNED(i, 8);
      for j in -10 to 10 loop
        slv := CONV_SIGNED(j, 8);
        slvr := slvl+slv;
        rstr := to_string(CONV_SIGNED(i+j, 8));
        assert to_string(slvr) = rstr report "Error in  ID 237" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 238
    for i in 0 to 50 loop
      uslvl := CONV_unSIGNED(i, 8);
      for j in -10 to 10 loop
        slv := CONV_SIGNED(j, 8);
        slvsum := uslvl+slv;
        rstr1 := to_string(CONV_SIGNED(i+j, 9));
        assert to_string(slvsum) = rstr1 report "Error in  ID 238" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 239
    for i in -10 to 50 loop
      slvl := CONV_SIGNED(i, 8);
      for j in 0 to 10 loop
        uslv := CONV_unSIGNED(j, 8);
        slvsum := slvl+uslv;
        rstr1 := to_string(CONV_SIGNED(i+j, 9));
        assert to_string(slvsum) = rstr1 report "Error in  ID 239" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 240
    for i in 0 to 50 loop
      uslvl := CONV_unSIGNED(i, 8);
      for j in -10 to 10 loop
        uslvr := uslvl+j;
        rstr := to_string(CONV_unSIGNED(i+j, 8));
        assert to_string(uslvr) = rstr report "Error in  ID 240" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 241
    for i in -10 to 50 loop
      for j in 0 to 10 loop
        uslv := CONV_unSIGNED(j, 8);
        uslvr := i+uslv;
        rstr := to_string(CONV_unSIGNED(i+j, 8));
        assert to_string(uslvr) = rstr report "Error in  ID 241" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 242
    for i in -10 to 50 loop
      slvl := CONV_SIGNED(i, 8);
      for j in -10 to 10 loop
        slvr := slvl+j;
        rstr := to_string(CONV_SIGNED(i+j, 8));
        assert to_string(slvr) = rstr report "Error in  ID 242" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 243
    for i in -10 to 50 loop
      for j in -10 to 10 loop
        slv := CONV_SIGNED(j, 8);
        slvr := i+slv;
        rstr := to_string(CONV_SIGNED(i+j, 8));
        assert to_string(slvr) = rstr report "Error in  ID 243" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 244
    ur := '1';
    for i in 0 to 50 loop
      uslv := CONV_unSIGNED(i, 8);
      uslvr := uslv+ur;
      rstr := to_string(CONV_unSIGNED(i+1, 8));
      assert to_string(uslvr) = rstr report "Error in  ID 244" severity failure;
    end loop;

    ur := '0';
    for i in 0 to 5 loop
      uslv := CONV_unSIGNED(i, 8);
      uslvr := uslv+ur;
      rstr := to_string(CONV_unSIGNED(i, 8));
      assert to_string(uslvr) = rstr report "Error in  ID 244" severity failure;
    end loop;

    -- EQ subpgm_id 245
    ul := '1';
    for i in 0 to 50 loop
      uslv := CONV_unSIGNED(i, 8);
      uslvr := ul+uslv;
      rstr := to_string(CONV_unSIGNED(i+1, 8));
      assert to_string(uslvr) = rstr report "Error in  ID 245" severity failure;
    end loop;

    ul := '0';
    for i in -10 to 5 loop
      uslv := CONV_unSIGNED(i, 8);
      uslvr := ul+uslv;
      rstr := to_string(CONV_unSIGNED(i, 8));
      assert to_string(uslvr) = rstr report "Error in  ID 245" severity failure;
    end loop;

    -- EQ subpgm_id 246
    ur := '1';
    for i in -10 to 50 loop
      slv := CONV_SIGNED(i, 8);
      slvr := slv+ur;
      rstr := to_string(CONV_SIGNED(i+1, 8));
      assert to_string(slvr) = rstr report "Error in  ID 246" severity failure;
    end loop;

    ur := '0';
    for i in -10 to 5 loop
      slv := CONV_SIGNED(i, 8);
      slvr := slv+ur;
      rstr := to_string(CONV_SIGNED(i, 8));
      assert to_string(slvr) = rstr report "Error in  ID 246" severity failure;
    end loop;

    -- EQ subpgm_id 247
    ul := '1';
    for i in -10 to 50 loop
      slv := CONV_SIGNED(i, 8);
      slvr := ul+slv;
      rstr := to_string(CONV_SIGNED(i+1, 8));
      assert to_string(slvr) = rstr report "Error in  ID 247" severity failure;
    end loop;

    ul := '0';
    for i in -10 to 5 loop
      slv := CONV_SIGNED(i, 8);
      slvr := ul+slv;
      rstr := to_string(CONV_SIGNED(i, 8));
      assert to_string(slvr) = rstr report "Error in  ID 247" severity failure;
    end loop;

    -- EQ subpgm_id 260
    for i in -10 to 50 loop
      uslvr := CONV_UNSIGNED(i, 8);
      for j in 0 to 10 loop
        uslvl := CONV_UNSIGNED(j, 8);
        stdlv := uslvl+uslvr;
        rstr := to_string(CONV_UNSIGNED(i+j, 8));
        assert to_string(stdlv) = rstr report "Error in  ID 260" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 261
    for i in -25 to 50 loop
      slvl := CONV_SIGNED(i, 8);
      for j in -10 to 10 loop
        slv := CONV_SIGNED(j, 8);
        stdlv := slvl+slv;
        rstr := to_string(CONV_SIGNED(i+j, 8));
        assert to_string(stdlv) = rstr report "Error in  ID 261" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 262
    for i in 0 to 50 loop
      uslvl := CONV_unSIGNED(i, 8);
      for j in -10 to 10 loop
        slv := CONV_SIGNED(j, 8);
        stdlv9 := uslvl+slv;
        rstr1 := to_string(CONV_std_logic_vector(i+j, 9));
        assert to_string(stdlv9) = rstr1 report "Error in  ID 262" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 263
    for i in 0 to 50 loop
      uslvl := CONV_unSIGNED(i, 8);
      for j in -10 to 10 loop
        slv := CONV_SIGNED(j, 8);
        stdlv9 := slv+uslvl;
        rstr1 := to_string(CONV_std_logic_vector(i+j, 9));
        assert to_string(stdlv9) = rstr1 report "Error in  ID 263" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 264
    for i in -10 to 50 loop
      for j in 0 to 10 loop
        uslv := CONV_UNSIGNED(j, 8);
        stdlv := uslv+i;
        rstr := to_string(CONV_UNSIGNED(i+j, 8));
        assert to_string(stdlv) = rstr report "Error in  ID 264" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 265
    for i in -10 to 50 loop
      for j in 0 to 10 loop
        uslv := CONV_UNSIGNED(j, 8);
        stdlv := i+uslv;
        rstr := to_string(CONV_UNSIGNED(i+j, 8));
        assert to_string(stdlv) = rstr report "Error in  ID 265" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 266
    for i in -25 to 50 loop
      for j in -10 to 10 loop
        slv := CONV_SIGNED(j, 8);
        stdlv := i+slv;
        rstr := to_string(CONV_SIGNED(i+j, 8));
        assert to_string(stdlv) = rstr report "Error in  ID 266" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 267
    for i in -25 to 50 loop
      for j in -10 to 10 loop
        slv := CONV_SIGNED(j, 8);
        stdlv := slv+i;
        rstr := to_string(CONV_UNSIGNED(i+j, 8));
        assert to_string(stdlv) = rstr report "Error in  ID 267" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 268
    ur := '1';
    for i in 0 to 50 loop
      uslv := CONV_unSIGNED(i, 8);
      stdlv := uslv+ur;
      rstr := to_string(CONV_unSIGNED(i+1, 8));
      assert to_string(stdlv) = rstr report "Error in  ID 268" severity failure;
    end loop;

    ur := '0';
    for i in 0 to 5 loop
      uslv := CONV_unSIGNED(i, 8);
      stdlv := uslv+ur;
      rstr := to_string(CONV_unSIGNED(i, 8));
      assert to_string(stdlv) = rstr report "Error in  ID 268" severity failure;
    end loop;

    -- EQ subpgm_id 269
    ur := '1';
    for i in 0 to 50 loop
      uslv := CONV_unSIGNED(i, 8);
      stdlv := ur+uslv;
      rstr := to_string(CONV_unSIGNED(i+1, 8));
      assert to_string(stdlv) = rstr report "Error in  ID 269" severity failure;
    end loop;

    ur := '0';
    for i in 0 to 5 loop
      uslv := CONV_unSIGNED(i, 8);
      stdlv := ur+uslv;
      rstr := to_string(CONV_unSIGNED(i, 8));
      assert to_string(stdlv) = rstr report "Error in  ID 269" severity failure;
    end loop;

    -- EQ subpgm_id 270
    ur := '1';
    for i in -10 to 50 loop
      slv := CONV_SIGNED(i, 8);
      stdlv := slv+ur;
      rstr := to_string(CONV_SIGNED(i+1, 8));
      assert to_string(stdlv) = rstr report "Error in  ID 270" severity failure;
    end loop;

    ur := '0';
    for i in -10 to 5 loop
      slv := CONV_SIGNED(i, 8);
      stdlv := slv+ur;
      rstr := to_string(CONV_SIGNED(i, 8));
      assert to_string(stdlv) = rstr report "Error in  ID 270" severity failure;
    end loop;

    -- EQ subpgm_id 271
    ur := '1';
    for i in -10 to 50 loop
      slv := CONV_SIGNED(i, 8);
      stdlv := ur+slv;
      rstr := to_string(CONV_SIGNED(i+1, 8));
      assert to_string(stdlv) = rstr report "Error in  ID 271" severity failure;
    end loop;

    ur := '0';
    for i in -10 to 5 loop
      slv := CONV_SIGNED(i, 8);
      stdlv := ur+slv;
      rstr := to_string(CONV_SIGNED(i, 8));
      assert to_string(stdlv) = rstr report "Error in  ID 271" severity failure;
    end loop;

    assert FALSE
      report "END OF test suite arith_1"
      severity note;

    wait;
  end process;

end ops;
