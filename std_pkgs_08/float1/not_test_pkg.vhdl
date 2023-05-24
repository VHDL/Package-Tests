
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library not_ieee;
use not_ieee.numeric_std.all;

package not_test_pkg is


  --  conversion functions for bv to  std_ulogic
  function bv2un(bv : bit_vector) return not_ieee.numeric_std.unsigned;
  
  function bv2un(bv : bit_vector) return not_ieee.numeric_std.signed;
  
                      
  function klsfr(bv: bit_vector) return bit_vector;  -- do LSFR on bit_vector 8, 16 32
  function klsfr(bv: not_ieee.numeric_std.unsigned) return not_ieee.numeric_std.unsigned;  -- do LSFR on bit_vector 8, 16 32
  function klsfr(bv: not_ieee.numeric_std.signed) return not_ieee.numeric_std.signed;  -- do LSFR on bit_vector 8, 16 32

end not_test_pkg;


package body not_test_pkg is

  --  conversion functions for bv to  std_ulogic
  function bv2un(bv : bit_vector) return not_ieee.numeric_std.unsigned is
      variable sz : natural := bv'length;
      variable rtn : not_ieee.numeric_std.unsigned(sz-1 downto 0);
  begin
    for i in sz-1 downto 0 loop
      if(bv(i) = '1') then
        rtn(i) := '1';
      elsif(bv(i) = '0') then
        rtn(i) := '0';
      else
        rtn(i) := 'U';
      end if;
    end loop;
    return rtn;
  end function;
  
  function bv2un(bv : bit_vector) return not_ieee.numeric_std.signed is
      variable sz : natural := bv'length;
      variable rtn : not_ieee.numeric_std.signed(sz-1 downto 0);
  begin
    for i in sz-1 downto 0 loop
      if(bv(i) = '1') then
        rtn(i) := '1';
      elsif(bv(i) = '0') then
        rtn(i) := '0';
      else
        rtn(i) := 'U';
      end if;
    end loop;
    return rtn;
  end function;
  
  -- bitvector lsfr
  function klsfr(bv: bit_vector) return bit_vector is
    alias v : bit_vector(bv'high downto 0) is bv;
    variable rtn : bit_vector(bv'high downto 0);
    variable len : integer := bv'length;
  begin
    case len is
      when 8 =>
        rtn := v(6 downto 0) & ((v(7) xor v(4)) xor (v(1) xor v(2)));
      when 16 =>
        rtn := v(14 downto 0) & ((v(15) xor v(14)) xor (v(12) xor v(3)));
      when 32 =>
        rtn := v(30 downto 0) & ((v(31) xor v(6)) xor (v(5) xor v(1)));
      when others =>
        report "ERROR: LSFR size not implemented ..." severity failure;
    end case;
    return rtn;
  end function;

  -- signed lsfr
  function klsfr(bv: not_ieee.numeric_std.signed) return not_ieee.numeric_std.signed is
    alias v : not_ieee.numeric_std.signed(bv'high downto 0) is bv;
    variable rtn : not_ieee.numeric_std.signed(bv'high downto 0);
    variable len : integer := bv'length;
  begin
  --report "signed  LSFR ....";
    case len is
      when 8 =>
        rtn := v(6 downto 0) & ((v(7) xor v(4)) xor (v(1) xor v(2)));
      when 16 =>
        rtn := v(14 downto 0) & ((v(15) xor v(14)) xor (v(12) xor v(3)));
      when 32 =>
        rtn := v(30 downto 0) & ((v(31) xor v(6)) xor (v(5) xor v(1)));
      when others =>
        report "ERROR: LSFR size not implemented ..." severity failure;
    end case;
    return rtn;
  end function;

  -- signed lsfr
  function klsfr(bv: not_ieee.numeric_std.unsigned) return not_ieee.numeric_std.unsigned is
    alias v : not_ieee.numeric_std.unsigned(bv'high downto 0) is bv;
    variable rtn : not_ieee.numeric_std.unsigned(bv'high downto 0);
    variable len : integer := bv'length;
  begin
    --report "unsigned  LSFR ....";
    case len is
      when 8 =>
        rtn := v(6 downto 0) & ((v(7) xor v(4)) xor (v(1) xor v(2)));
      when 16 =>
        rtn := v(14 downto 0) & ((v(15) xor v(14)) xor (v(12) xor v(3)));
      when 32 =>
        rtn := v(30 downto 0) & ((v(31) xor v(6)) xor (v(5) xor v(1)));
      when others =>
        report "ERROR: LSFR size not implemented ..." severity failure;
    end case;
    --report "unsigned  LSFR exit";
    return rtn;
  end function;

  
end not_test_pkg;
