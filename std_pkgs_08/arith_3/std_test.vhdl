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

entity std_arith_3 is
end entity;

architecture ops of std_arith_3 is

begin
  process
  
    variable r : std_logic;
    variable ur : std_ulogic;
    variable ul : std_ulogic;
    variable slv : signed(7 downto 0);
    variable slvl : signed(7 downto 0);
    variable slvr : signed(15 downto 0);
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
    
  begin

    -- EQ subpgm_id 295
    for i in 200 to 250 loop
      uslvl := CONV_unSIGNED(i, 8);
      for j in 0 to 10 loop
        uslv := CONV_unSIGNED(j, 8);
        uslvr := uslvl*uslv;             --  <<  output  16 bits
        rstrm := to_string(CONV_unSIGNED(i*j, 16));
        assert to_string(uslvr) = rstrm report "Error in  ID 295" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 296
    for i in -10 to 50 loop
      slvl := CONV_SIGNED(i, 8);
      for j in -10 to 10 loop
        slv := CONV_SIGNED(j, 8);
        slvr := slvl*slv;             --  <<  output  16 bits
        rstrm := to_string(CONV_SIGNED(i*j, 16));
        assert to_string(slvr) = rstrm report "Error in  ID 296" severity failure;
      end loop;
    end loop;

    uslv := "10000000";
    for i in std_ulogic'low to std_ulogic'high loop
      uslvl := "00000000";
      uslvl(4) := i;
      case i is
        when 'X' | 'Z' | 'U' | 'W' | '-' =>
          assert uslvl*uslv = unsigned("XXXXXXXX")
            report "Error:  meta value in * operation did not return x's  mult(signed)"
            severity failure;
        when '1' | 'H' =>
          assert uslvl*uslv = unsigned("0000100000000000")
            report "Error:  meta value in * operation did not return 16  mult(signed)"
            severity failure;
        when '0' | 'L' =>
          assert uslvl*uslv = unsigned("000000000")
            report "Error:  meta value in * operation did not return 0  mult(signed)"
            severity failure;
      end case;
    end loop;
    
    slv := "10000000";
    for i in std_ulogic'low to std_ulogic'high loop
      slvl := "00000000";
      slvl(4) := i;
      case i is
        when 'X' | 'Z' | 'U' | 'W' | '-' =>
          assert slvl*slv = signed("XXXXXXXX")
            report "Error:  meta value in * operation did not return x's  mult(signed)"
            severity failure;
        when '1' | 'H' =>
          assert slvl*slv = signed("1111100000000000")
            report "Error:  meta value in * operation did not return 16  mult(signed)"
            severity failure;
        when '0' | 'L' =>
          assert slvl*slv = signed("000000000")
            report "Error:  meta value in * operation did not return 0  mult(signed)"
            severity failure;
      end case;
    end loop;
    
    
    
    -- EQ subpgm_id 297
    for i in 200 to 250 loop
      uslvl := CONV_unSIGNED(i, 8);
      for j in 0 to 10 loop
        slv := CONV_SIGNED(j, 8);
        slvrs := uslvl*slv;             --  <<  output  17 bits
        rstrms := to_string(CONV_SIGNED(i*j, 17));
        assert to_string(slvrs) = rstrms report "Error in  ID 297" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 298
    for i in -10 to 50 loop
      slvl := CONV_SIGNED(i, 8);
      for j in 0 to 10 loop
        uslv := CONV_unSIGNED(j, 8);
        slvrs := slvl*uslv;             --  <<  output  17 bits
        rstrms := to_string(CONV_SIGNED(i*j, 17));
        assert to_string(slvrs) = rstrms report "Error in  ID 298" severity failure;
      end loop;
    end loop;
-----------------------------------------------------------------------------------------

    -- EQ subpgm_id 300
    for i in 200 to 250 loop
      uslvl := CONV_unSIGNED(i, 8);
      for j in 0 to 10 loop
        uslv := CONV_unSIGNED(j, 8);
        stdlv16 := uslvl*uslv;             --  <<  output  16 bits
        rstrm := to_string(CONV_unSIGNED(i*j, 16));
        assert to_string(stdlv16) = rstrm report "Error in  ID 300" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 301
    for i in -10 to 50 loop
      slvl := CONV_SIGNED(i, 8);
      for j in -10 to 10 loop
        slv := CONV_SIGNED(j, 8);
        stdlv16 := slvl*slv;             --  <<  output  16 bits
        rstrm := to_string(CONV_SIGNED(i*j, 16));
        assert to_string(stdlv16) = rstrm report "Error in  ID 301" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 302
    for i in 200 to 250 loop
      uslvl := CONV_unSIGNED(i, 8);
      for j in 0 to 10 loop
        slv := CONV_SIGNED(j, 8);
        stdlv17 := uslvl*slv;             --  <<  output  17 bits
        rstrms := to_string(CONV_SIGNED(i*j, 17));
        assert to_string(stdlv17) = rstrms report "Error in  ID 302" severity failure;
      end loop;
    end loop;

    -- EQ subpgm_id 303
    for i in -10 to 50 loop
      slvl := CONV_SIGNED(i, 8);
      for j in 0 to 10 loop
        uslv := CONV_unSIGNED(j, 8);
        stdlv17 := slvl*uslv;             --  <<  output  17 bits
        rstrms := to_string(CONV_SIGNED(i*j, 17));
        assert to_string(stdlv17) = rstrms report "Error in  ID 303" severity failure;
      end loop;
    end loop;

    assert FALSE
      report "END OF test suite arith_3"
      severity note;

    wait;
  end process;

end ops;
