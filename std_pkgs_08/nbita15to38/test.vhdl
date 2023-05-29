-- file numeric_bit_tb2.vhd is a simulation testbench for 
-- IEEE 1076.3 numeric_bit package.
-- This is the second file in the series, following
-- numeric_bit_tb1.vhd
--
library not_IEEE;

use not_IEEE.numeric_bit.all;

entity test is 
  generic (
    quiet : boolean := false);  -- make the simulation quiet
end entity;

architecture t1 of test is  
  -- required by A.1, A.2 tests
  constant max_size_checked : integer := 200;
  constant temp1    : signed( max_size_checked-2 downto 0 ) :=
    (others => '1');

  constant temp0    : signed( max_size_checked-2 downto 0 ) :=
    (others => '0');
  
  constant posmax   : signed( max_size_checked-1 downto 0 ) := 
    '0' & temp1;

  constant neg1 : signed( max_size_checked-1 downto 0 ) := 
    (others => '1');

  constant negmin   : signed( max_size_checked-1 downto 0 ) :=
    ('1', others => '0');

  constant zero     :  signed( max_size_checked-1 downto 0 ) :=
    (others => '0');

  -- required by s1_8 tests
  signal s_unull : unsigned(0 downto 1);
  signal s_snull : signed(0 downto 1);

begin
  process
    -- required by A.1, A.2 tests
    variable x : signed( max_size_checked-1 downto 0 ) := zero;
    -- required by s1_8 tests
    variable i : integer;
    
    variable svec : signed(3 downto 0);
    variable svec1 : signed(4 downto 0);
    variable svec2 : signed(4 downto 0);
    variable rsvec : signed(9 downto 0);
    variable usvec : unsigned(3 downto 0);
    variable buvec : unsigned(63 downto 0);
    variable un_nul : unsigned(0 downto 3);
    variable si_nul : signed(0 downto 3);
    variable sir_nul : signed(0 downto 3);
    
    
  begin

    assert quiet report "start of tests" severity note;
    
    -- A.15
    usvec :=  "0100";
    un_nul := s_unull * usvec;
    --  output a null line
    report "A.15 A null return '" & to_string(un_nul) & "'";
    
    --  A.16
    for k in -10 to 10 loop
      svec1 := to_signed(k,5);
      for j in -10 to 10 loop
        svec2 := to_signed(j,5);
        rsvec := svec1 * svec2;
        i := k * j;
        assert i = to_integer(rsvec)
          severity failure;
      end loop;
    end loop;
    
    si_nul := si_nul * si_nul;
    report "A.16  A null result '" & to_string(si_nul) & "'";
    
    -- A.19
    svec1 := "00010";
    for k in -10 to 10 loop
      rsvec := svec1 * k;
      assert to_integer(rsvec) = (2*k)
      severity failure;
    end loop;
    
    -- A.20
    for k in -10 to 10 loop
      rsvec := k * svec1;
      assert to_integer(rsvec) = (2*k)
      severity failure;
    end loop;
    
    -- A.21
    un_nul := s_unull / usvec;
    --  output a null line
    report "A.21  A null result '" & to_string(un_nul) & "'";
    
    -- A.22
    for k in -10 to 10 loop
      svec1 := to_signed(k,5);
      for j in -10 to 10 loop
        if j = 0 then next; end if;
        svec2 := to_signed(j,5);
        svec2 := svec1 / svec2;
        i := k / j;
        assert i = to_integer(svec2)
          severity failure;
      end loop;
    end loop;
    
    si_nul := si_nul / svec2;
    report "A.22 A null result '" & to_string(si_nul) & "'";
    
    si_nul := svec2 / si_nul;
    report "A.22 A null result '" & to_string(si_nul) & "'";
    
    -- A.23
    un_nul := s_unull / 6;
    report "A.23  A null result '" & to_string(un_nul) & "'";
    usvec  := "0010";
    usvec := usvec / 6000000;
    assert to_integer(usvec) = 0
      report "A.23 return expected to be 0"
      severity failure;
    
    -- A.24
    un_nul := 6 / s_unull;
    report "A.24  A null result '" & to_string(un_nul) & "'";
    usvec  := "0010";
    usvec := 6000000 / usvec;
    assert to_integer(usvec) = 0
      report "A.24 return expected " & to_string(usvec)
      severity failure;
    
    -- A.25
    for k in -10 to 10 loop
      svec1 := to_signed(k,5);
      for j in -10 to 10 loop
        if j = 0 then next; end if;
        svec2 := svec1 / j;
        assert to_integer(svec2) = (k/j)
          severity failure;
      end loop;
    end loop;
    
    si_nul := si_nul / 6;
    report "A.25  A null result '" & to_string(si_nul) & "'";
    svec1 := svec1 / 6000000;
    assert to_integer(svec1) = 0
      report "A.25 not return 0 ";
    
    -- A.26
    for k in -10 to 10 loop
      if k = 0 then next; end if;
      svec1 := to_signed(k,5);
      for j in -10 to 10 loop
        svec2 := j / svec1;
        assert to_integer(svec2) = (j/k)
          severity failure;
      end loop;
    end loop;
    
    si_nul := 6 / si_nul;
    report "A.26  A null result '" & to_string(si_nul) & "'";
    svec1 := "00010";
    svec1 := 6000000 / svec1;
    assert to_integer(svec1) = 0 report "A.26 not return 0's ";
    
    -- A.27
    un_nul := "rem"(un_nul, un_nul);
    report "A.27  A null result '" & to_string(si_nul) & "'";
    
    un_nul := un_nul rem un_nul;
    report "A.27  A null result '" & to_string(si_nul) & "'";
    
    -- A.28
    for k in -10 to 10 loop
      if k = 0 then next; end if;
      svec1 := to_signed(k,5);
      for j in -10 to 10 loop
        svec2 := to_signed(j,5);
        svec2 := svec2 rem svec1;
        assert to_integer(svec2) = (j rem k)
          severity failure;
      end loop;
    end loop;
    
    sir_nul := si_nul rem svec2;
    report "A.28  A null result '" & to_string(sir_nul) & "'";
    
    -- A.29
    un_nul := un_nul rem 2;
    report "A.29  A null result '" & to_string(sir_nul) & "'";
    
    svec1 := svec2 rem 200000;
    assert to_integer(svec1) = 0
      severity failure;
    
    -- A.30
    un_nul := 2 rem un_nul;
    report "A.30  A null result '" & to_string(sir_nul) & "'";
    
    --  ????
--    usvec := "0000";
--    buvec := (others => '0');
--    for k in 1 to 100 loop
--      buvec(3 downto 0) := buvec rem k;
--      buvec := buvec rem k;
--    end loop;
--    report to_string(buvec);
    --assert to_integer(usvec) = 0
    --  severity failure;
    
    -- A.31
    for k in -10 to 10 loop
      svec1 := to_signed(k,5);
      for j in -10 to 10 loop
        if j = 0 then next; end if;
        svec2 := svec1 rem j;
        assert to_integer(svec2) = (k rem j)
          severity failure;
      end loop;
    end loop;
    
    si_nul := si_nul rem 22;
    report "A.31  A null result '" & to_string(si_nul) & "'";
    
    -- A.32
    for k in -10 to 10 loop
      if k = 0 then next; end if;
      svec1 := to_signed(k,5);
      for j in -10 to 10 loop
        svec2 := j rem svec1;
        assert to_integer(svec2) = (j rem k)
          severity failure;
      end loop;
    end loop;
    
    si_nul := 21 rem si_nul;
    report "A.32  A null result '" & to_string(si_nul) & "'";
    
    -- A.33
    un_nul := un_nul mod usvec;
    report "A.33  A null result '" & to_string(sir_nul) & "'";
    
    -- A.34
    for k in -10 to 10 loop
      svec1 := to_signed(k,5);
      for j in -10 to 10 loop
        if j = 0 then next; end if;
        svec2 := to_signed(j,5);
        svec2 := svec1 mod svec2;
        assert to_integer(svec2) = "mod"(k,j)
          severity failure;
      end loop;
    end loop;
    
    si_nul := si_nul mod si_nul;
    report "A.34  A null result '" & to_string(si_nul) & "'";
    
    -- A.35
    un_nul := un_nul mod 21;
    report "A.35  A null result '" & to_string(un_nul) & "'";
    
    -- A.36
    un_nul := 21 mod un_nul;
    report "A.36  A null result '" & to_string(un_nul) & "'";
    
    -- A.37
    for k in -10 to 10 loop
      svec1 := to_signed(k,5);
      for j in -10 to 10 loop
        if j = 0 then next; end if;
        svec2 := svec1 mod j;
        assert to_integer(svec2) = "mod"(k,j)
          severity failure;
      end loop;
    end loop;
    
    si_nul := si_nul mod 3;
    report "A.37  A null result '" & to_string(si_nul) & "'";
    
    -- A.38
    for k in -10 to 10 loop
      if k = 0 then next; end if;
      svec1 := to_signed(k,5);
      for j in -10 to 10 loop
        svec2 := j mod svec1;
        assert to_integer(svec2) = "mod"(j,k)
          severity failure;
      end loop;
    end loop;
    
    si_nul := 3 mod si_nul;
    report "A.38  A null result '" & to_string(si_nul) & "'";
    
    -- S.1 tests
    assert shift_left(s_unull, 0)'length = 0
      report "Test S.1.1 failing."
      severity FAILURE;
    assert shift_left(s_unull, 1)'length = 0
      report "Test S.1.2 failing."
      severity FAILURE;
    assert shift_left(s_unull, 100)'length = 0
      report "Test S.1.3 failing."
      severity FAILURE;

    assert shift_left(unsigned'("0"), 0) = unsigned'("0")
      report "Test S.1.4 failing."
      severity FAILURE;
    assert shift_left(unsigned'("0"), 1) = unsigned'("0")
      report "Test S.1.5 failing."
      severity FAILURE;
    assert shift_left(unsigned'("0"), 50) = unsigned'("0")
      report "Test S.1.6 failing."
      severity FAILURE;

    assert shift_left(unsigned'("1"), 0) = unsigned'("1")
      report "Test S.1.7 failing."
      severity FAILURE;
    assert shift_left(unsigned'("1"), 1) = unsigned'("0")
      report "Test S.1.8 failing."
      severity FAILURE;
    assert shift_left(unsigned'("1"), 39) = unsigned'("0")
      report "Test S.1.9 failing."
      severity FAILURE;

    assert shift_left(unsigned'("000"), 0) = unsigned'("000")
      report "Test S.1.10 failing."
      severity FAILURE;
    assert shift_left(unsigned'("000"), 1) = unsigned'("000")
      report "Test S.1.11 failing."
      severity FAILURE;
    assert shift_left(unsigned'("000"), 2) = unsigned'("000")
      report "Test S.1.12 failing."
      severity FAILURE;
    assert shift_left(unsigned'("000"), 3) = unsigned'("000")
      report "Test S.1.13 failing."
      severity FAILURE;

    assert shift_left(unsigned'("111"), 0) = unsigned'("111")
      report "Test S.1.14 failing."
      severity FAILURE;
    assert shift_left(unsigned'("111"), 1) = unsigned'("110")
      report "Test S.1.15 failing."
      severity FAILURE;
    assert shift_left(unsigned'("111"), 2) = unsigned'("100")
      report "Test S.1.16 failing."
      severity FAILURE;
    assert shift_left(unsigned'("111"), 3) = unsigned'("000")
      report "Test S.1.17 failing."
      severity FAILURE;

    assert shift_left(unsigned'("001"), 0) = unsigned'("001")
      report "Test S.1.18 failing."
      severity FAILURE;
    assert shift_left(unsigned'("001"), 1) = unsigned'("010")
      report "Test S.1.19 failing."
      severity FAILURE;
    assert shift_left(unsigned'("001"), 2) = unsigned'("100")
      report "Test S.1.20 failing."
      severity FAILURE;
    assert shift_left(unsigned'("001"), 3) = unsigned'("000")
      report "Test S.1.21 failing."
      severity FAILURE;

    assert quiet report "S.1 tests done" severity note;

    -- S.2 tests
    assert shift_right(s_unull, 0)'length = 0
      report "Test S.2.1 failing."
      severity FAILURE;
    assert shift_right(s_unull, 1)'length = 0
      report "Test S.2.2 failing."
      severity FAILURE;
    assert shift_right(s_unull, 100)'length = 0
      report "Test S.2.3 failing."
      severity FAILURE;

    assert shift_right(unsigned'("0"), 0) = unsigned'("0")
      report "Test S.2.4 failing."
      severity FAILURE;
    assert shift_right(unsigned'("0"), 1) = unsigned'("0")
      report "Test S.2.5 failing."
      severity FAILURE;
    assert shift_right(unsigned'("0"), 50) = unsigned'("0")
      report "Test S.2.6 failing."
      severity FAILURE;

    assert shift_right(unsigned'("1"), 0) = unsigned'("1")
      report "Test S.2.7 failing."
      severity FAILURE;
    assert shift_right(unsigned'("1"), 1) = unsigned'("0")
      report "Test S.2.8 failing."
      severity FAILURE;
    assert shift_right(unsigned'("1"), 39) = unsigned'("0")
      report "Test S.2.9 failing."
      severity FAILURE;

    assert shift_right(unsigned'("000"), 0) = unsigned'("000")
      report "Test S.2.10 failing."
      severity FAILURE;
    assert shift_right(unsigned'("000"), 1) = unsigned'("000")
      report "Test S.2.11 failing."
      severity FAILURE;
    assert shift_right(unsigned'("000"), 2) = unsigned'("000")
      report "Test S.2.12 failing."
      severity FAILURE;
    assert shift_right(unsigned'("000"), 3) = unsigned'("000")
      report "Test S.2.13 failing."
      severity FAILURE;

    assert shift_right(unsigned'("111"), 0) = unsigned'("111")
      report "Test S.2.14 failing."
      severity FAILURE;
    assert shift_right(unsigned'("111"), 1) = unsigned'("011")
      report "Test S.2.15 failing."
      severity FAILURE;
    assert shift_right(unsigned'("111"), 2) = unsigned'("001")
      report "Test S.2.16 failing."
      severity FAILURE;
    assert shift_right(unsigned'("111"), 3) = unsigned'("000")
      report "Test S.2.17 failing."
      severity FAILURE;

    assert shift_right(unsigned'("100"), 0) = unsigned'("100")
      report "Test S.2.18 failing."
      severity FAILURE;
    assert shift_right(unsigned'("100"), 1) = unsigned'("010")
      report "Test S.2.19 failing."
      severity FAILURE;
    assert shift_right(unsigned'("100"), 2) = unsigned'("001")
      report "Test S.2.20 failing."
      severity FAILURE;
    assert shift_right(unsigned'("100"), 3) = unsigned'("000")
      report "Test S.2.21 failing."
      severity FAILURE;

    assert quiet report "S.2 tests done" severity note;

    -- S.3 tests
    assert shift_left(s_snull, 0)'length = 0
      report "Test S.3.1 failing."
      severity FAILURE;
    assert shift_left(s_snull, 1)'length = 0
      report "Test S.3.2 failing."
      severity FAILURE;
    assert shift_left(s_snull, 100)'length = 0
      report "Test S.3.3 failing."
      severity FAILURE;

    assert shift_left(signed'("0"), 0) = signed'("0")
      report "Test S.3.4 failing."
      severity FAILURE;
    assert shift_left(signed'("0"), 1) = signed'("0")
      report "Test S.3.5 failing."
      severity FAILURE;
    assert shift_left(signed'("0"), 50) = signed'("0")
      report "Test S.3.6 failing."
      severity FAILURE;

    assert shift_left(signed'("1"), 0) = signed'("1")
      report "Test S.3.7 failing."
      severity FAILURE;
    assert shift_left(signed'("1"), 1) = signed'("0")
      report "Test S.3.8 failing."
      severity FAILURE;
    assert shift_left(signed'("1"), 39) = signed'("0")
      report "Test S.3.9 failing."
      severity FAILURE;

    assert shift_left(signed'("000"), 0) = signed'("000")
      report "Test S.3.10 failing."
      severity FAILURE;
    assert shift_left(signed'("000"), 1) = signed'("000")
      report "Test S.3.11 failing."
      severity FAILURE;
    assert shift_left(signed'("000"), 2) = signed'("000")
      report "Test S.3.12 failing."
      severity FAILURE;
    assert shift_left(signed'("000"), 3) = signed'("000")
      report "Test S.3.13 failing."
      severity FAILURE;

    assert shift_left(signed'("111"), 0) = signed'("111")
      report "Test S.3.14 failing."
      severity FAILURE;
    assert shift_left(signed'("111"), 1) = signed'("110")
      report "Test S.3.15 failing."
      severity FAILURE;
    assert shift_left(signed'("111"), 2) = signed'("100")
      report "Test S.3.16 failing."
      severity FAILURE;
    assert shift_left(signed'("111"), 3) = signed'("000")
      report "Test S.3.17 failing."
      severity FAILURE;

    assert shift_left(signed'("001"), 0) = signed'("001")
      report "Test S.3.18 failing."
      severity FAILURE;
    assert shift_left(signed'("001"), 1) = signed'("010")
      report "Test S.3.19 failing."
      severity FAILURE;
    assert shift_left(signed'("001"), 2) = signed'("100")
      report "Test S.3.20 failing."
      severity FAILURE;
    assert shift_left(signed'("001"), 3) = signed'("000")
      report "Test S.3.21 failing."
      severity FAILURE;

    assert quiet report "S.3 tests done" severity note;

    -- S.4 tests
    assert shift_right(s_snull, 0)'length = 0
      report "Test S.4.1 failing."
      severity FAILURE;
    assert shift_right(s_snull, 1)'length = 0
      report "Test S.4.2 failing."
      severity FAILURE;
    assert shift_right(s_snull, 100)'length = 0
      report "Test S.4.3 failing."
      severity FAILURE;

    assert shift_right(signed'("0"), 0) = signed'("0")
      report "Test S.4.4 failing."
      severity FAILURE;
    assert shift_right(signed'("0"), 1) = signed'("0")
      report "Test S.4.5 failing."
      severity FAILURE;
    assert shift_right(signed'("0"), 50) = signed'("0")
      report "Test S.4.6 failing."
      severity FAILURE;

    assert shift_right(signed'("1"), 0) = signed'("1")
      report "Test S.4.7 failing."
      severity FAILURE;
    assert shift_right(signed'("1"), 1) = signed'("1")
      report "Test S.4.8 failing."
      severity FAILURE;
    assert shift_right(signed'("1"), 39) = signed'("1")
      report "Test S.4.9 failing."
      severity FAILURE;

    assert shift_right(signed'("000"), 0) = signed'("000")
      report "Test S.4.10 failing."
      severity FAILURE;
    assert shift_right(signed'("000"), 1) = signed'("000")
      report "Test S.4.11 failing."
      severity FAILURE;
    assert shift_right(signed'("000"), 2) = signed'("000")
      report "Test S.4.12 failing."
      severity FAILURE;
    assert shift_right(signed'("000"), 3) = signed'("000")
      report "Test S.4.13 failing."
      severity FAILURE;

    assert shift_right(signed'("111"), 0) = signed'("111")
      report "Test S.4.14 failing."
      severity FAILURE;
    assert shift_right(signed'("111"), 1) = signed'("111")
      report "Test S.4.15 failing."
      severity FAILURE;
    assert shift_right(signed'("111"), 2) = signed'("111")
      report "Test S.4.16 failing."
      severity FAILURE;
    assert shift_right(signed'("111"), 3) = signed'("111")
      report "Test S.4.17 failing."
      severity FAILURE;

    assert shift_right(signed'("100"), 0) = signed'("100")
      report "Test S.4.18 failing."
      severity FAILURE;
    assert shift_right(signed'("100"), 1) = signed'("110")
      report "Test S.4.19 failing."
      severity FAILURE;
    assert shift_right(signed'("100"), 2) = signed'("111")
      report "Test S.4.20 failing."
      severity FAILURE;
    assert shift_right(signed'("100"), 3) = signed'("111")
      report "Test S.4.21 failing."
      severity FAILURE;

    assert quiet report "S.4 tests done" severity note;

    -- S.5 tests
    assert rotate_left(s_unull, 0)'length = 0
      report "Test S.5.1 failing."
      severity FAILURE;
    assert rotate_left(s_unull, 1)'length = 0
      report "Test S.5.2 failing."
      severity FAILURE;
    assert rotate_left(s_unull, 100)'length = 0
      report "Test S.5.3 failing."
      severity FAILURE;

    assert rotate_left(unsigned'("0"), 0) = unsigned'("0")
      report "Test S.5.4 failing."
      severity FAILURE;
    assert rotate_left(unsigned'("0"), 1) = unsigned'("0")
      report "Test S.5.5 failing."
      severity FAILURE;
    assert rotate_left(unsigned'("0"), 50) = unsigned'("0")
      report "Test S.5.6 failing."
      severity FAILURE;

    assert rotate_left(unsigned'("1"), 0) = unsigned'("1")
      report "Test S.5.7 failing."
      severity FAILURE;
    assert rotate_left(unsigned'("1"), 1) = unsigned'("1")
      report "Test S.5.8 failing."
      severity FAILURE;
    assert rotate_left(unsigned'("1"), 39) = unsigned'("1")
      report "Test S.5.9 failing."
      severity FAILURE;

    assert rotate_left(unsigned'("000"), 0) = unsigned'("000")
      report "Test S.5.10 failing."
      severity FAILURE;
    assert rotate_left(unsigned'("000"), 1) = unsigned'("000")
      report "Test S.5.11 failing."
      severity FAILURE;
    assert rotate_left(unsigned'("000"), 2) = unsigned'("000")
      report "Test S.5.12 failing."
      severity FAILURE;
    assert rotate_left(unsigned'("000"), 3) = unsigned'("000")
      report "Test S.5.13 failing."
      severity FAILURE;

    assert rotate_left(unsigned'("111"), 0) = unsigned'("111")
      report "Test S.5.14 failing."
      severity FAILURE;
    assert rotate_left(unsigned'("111"), 1) = unsigned'("111")
      report "Test S.5.15 failing."
      severity FAILURE;
    assert rotate_left(unsigned'("111"), 2) = unsigned'("111")
      report "Test S.5.16 failing."
      severity FAILURE;
    assert rotate_left(unsigned'("111"), 3) = unsigned'("111")
      report "Test S.5.17 failing."
      severity FAILURE;

    assert rotate_left(unsigned'("011"), 0) = unsigned'("011")
      report "Test S.5.18 failing."
      severity FAILURE;
    assert rotate_left(unsigned'("011"), 1) = unsigned'("110")
      report "Test S.5.19 failing."
      severity FAILURE;
    assert rotate_left(unsigned'("011"), 2) = unsigned'("101")
      report "Test S.5.20 failing."
      severity FAILURE;
    assert rotate_left(unsigned'("011"), 3) = unsigned'("011")
      report "Test S.5.21 failing."
      severity FAILURE;

    assert quiet report "S.5 tests done" severity note;

    -- S.6 tests
    assert rotate_right(s_unull, 0)'length = 0
      report "Test S.6.1 failing."
      severity FAILURE;
    assert rotate_right(s_unull, 1)'length = 0
      report "Test S.6.2 failing."
      severity FAILURE;
    assert rotate_right(s_unull, 100)'length = 0
      report "Test S.6.3 failing."
      severity FAILURE;

    assert rotate_right(unsigned'("0"), 0) = unsigned'("0")
      report "Test S.6.4 failing."
      severity FAILURE;
    assert rotate_right(unsigned'("0"), 1) = unsigned'("0")
      report "Test S.6.5 failing."
      severity FAILURE;
    assert rotate_right(unsigned'("0"), 50) = unsigned'("0")
      report "Test S.6.6 failing."
      severity FAILURE;

    assert rotate_right(unsigned'("1"), 0) = unsigned'("1")
      report "Test S.6.7 failing."
      severity FAILURE;
    assert rotate_right(unsigned'("1"), 1) = unsigned'("1")
      report "Test S.6.8 failing."
      severity FAILURE;
    assert rotate_right(unsigned'("1"), 39) = unsigned'("1")
      report "Test S.6.9 failing."
      severity FAILURE;

    assert rotate_right(unsigned'("000"), 0) = unsigned'("000")
      report "Test S.6.10 failing."
      severity FAILURE;
    assert rotate_right(unsigned'("000"), 1) = unsigned'("000")
      report "Test S.6.11 failing."
      severity FAILURE;
    assert rotate_right(unsigned'("000"), 2) = unsigned'("000")
      report "Test S.6.12 failing."
      severity FAILURE;
    assert rotate_right(unsigned'("000"), 3) = unsigned'("000")
      report "Test S.6.13 failing."
      severity FAILURE;

    assert rotate_right(unsigned'("111"), 0) = unsigned'("111")
      report "Test S.6.14 failing."
      severity FAILURE;
    assert rotate_right(unsigned'("111"), 1) = unsigned'("111")
      report "Test S.6.15 failing."
      severity FAILURE;
    assert rotate_right(unsigned'("111"), 2) = unsigned'("111")
      report "Test S.6.16 failing."
      severity FAILURE;
    assert rotate_right(unsigned'("111"), 3) = unsigned'("111")
      report "Test S.6.17 failing."
      severity FAILURE;

    assert rotate_right(unsigned'("110"), 0) = unsigned'("110")
      report "Test S.6.18 failing."
      severity FAILURE;
    assert rotate_right(unsigned'("110"), 1) = unsigned'("011")
      report "Test S.6.19 failing."
      severity FAILURE;
    assert rotate_right(unsigned'("110"), 2) = unsigned'("101")
      report "Test S.6.20 failing."
      severity FAILURE;
    assert rotate_right(unsigned'("110"), 3) = unsigned'("110")
      report "Test S.6.21 failing."
      severity FAILURE;

    assert quiet report "S.6 tests done" severity note;

    -- S.7 tests
    assert rotate_left(s_snull, 0)'length = 0
      report "Test S.7.1 failing."
      severity FAILURE;
    assert rotate_left(s_snull, 1)'length = 0
      report "Test S.7.2 failing."
      severity FAILURE;
    assert rotate_left(s_snull, 100)'length = 0
      report "Test S.7.3 failing."
      severity FAILURE;

    assert rotate_left(signed'("0"), 0) = signed'("0")
      report "Test S.7.4 failing."
      severity FAILURE;
    assert rotate_left(signed'("0"), 1) = signed'("0")
      report "Test S.7.5 failing."
      severity FAILURE;
    assert rotate_left(signed'("0"), 50) = signed'("0")
      report "Test S.7.6 failing."
      severity FAILURE;

    assert rotate_left(signed'("1"), 0) = signed'("1")
      report "Test S.7.7 failing."
      severity FAILURE;
    assert rotate_left(signed'("1"), 1) = signed'("1")
      report "Test S.7.8 failing."
      severity FAILURE;
    assert rotate_left(signed'("1"), 39) = signed'("1")
      report "Test S.7.9 failing."
      severity FAILURE;

    assert rotate_left(signed'("000"), 0) = signed'("000")
      report "Test S.7.10 failing."
      severity FAILURE;
    assert rotate_left(signed'("000"), 1) = signed'("000")
      report "Test S.7.11 failing."
      severity FAILURE;
    assert rotate_left(signed'("000"), 2) = signed'("000")
      report "Test S.7.12 failing."
      severity FAILURE;
    assert rotate_left(signed'("000"), 3) = signed'("000")
      report "Test S.7.13 failing."
      severity FAILURE;

    assert rotate_left(signed'("111"), 0) = signed'("111")
      report "Test S.7.14 failing."
      severity FAILURE;
    assert rotate_left(signed'("111"), 1) = signed'("111")
      report "Test S.7.15 failing."
      severity FAILURE;
    assert rotate_left(signed'("111"), 2) = signed'("111")
      report "Test S.7.16 failing."
      severity FAILURE;
    assert rotate_left(signed'("111"), 3) = signed'("111")
      report "Test S.7.17 failing."
      severity FAILURE;

    assert rotate_left(signed'("011"), 0) = signed'("011")
      report "Test S.7.18 failing."
      severity FAILURE;
    assert rotate_left(signed'("011"), 1) = signed'("110")
      report "Test S.7.19 failing."
      severity FAILURE;
    assert rotate_left(signed'("011"), 2) = signed'("101")
      report "Test S.7.20 failing."
      severity FAILURE;
    assert rotate_left(signed'("011"), 3) = signed'("011")
      report "Test S.7.21 failing."
      severity FAILURE;

    assert quiet report "S.7 tests done" severity note;

    -- S.8 tests
    assert rotate_right(s_snull, 0)'length = 0
      report "Test S.8.1 failing."
      severity FAILURE;
    assert rotate_right(s_snull, 1)'length = 0
      report "Test S.8.2 failing."
      severity FAILURE;
    assert rotate_right(s_snull, 100)'length = 0
      report "Test S.8.3 failing."
      severity FAILURE;

    assert rotate_right(signed'("0"), 0) = signed'("0")
      report "Test S.8.4 failing."
      severity FAILURE;
    assert rotate_right(signed'("0"), 1) = signed'("0")
      report "Test S.8.5 failing."
      severity FAILURE;
    assert rotate_right(signed'("0"), 50) = signed'("0")
      report "Test S.8.6 failing."
      severity FAILURE;

    assert rotate_right(signed'("1"), 0) = signed'("1")
      report "Test S.8.7 failing."
      severity FAILURE;
    assert rotate_right(signed'("1"), 1) = signed'("1")
      report "Test S.8.8 failing."
      severity FAILURE;
    assert rotate_right(signed'("1"), 39) = signed'("1")
      report "Test S.8.9 failing."
      severity FAILURE;

    assert rotate_right(signed'("000"), 0) = signed'("000")
      report "Test S.8.10 failing."
      severity FAILURE;
    assert rotate_right(signed'("000"), 1) = signed'("000")
      report "Test S.8.11 failing."
      severity FAILURE;
    assert rotate_right(signed'("000"), 2) = signed'("000")
      report "Test S.8.12 failing."
      severity FAILURE;
    assert rotate_right(signed'("000"), 3) = signed'("000")
      report "Test S.8.13 failing."
      severity FAILURE;

    assert rotate_right(signed'("111"), 0) = signed'("111")
      report "Test S.8.14 failing."
      severity FAILURE;
    assert rotate_right(signed'("111"), 1) = signed'("111")
      report "Test S.8.15 failing."
      severity FAILURE;
    assert rotate_right(signed'("111"), 2) = signed'("111")
      report "Test S.8.16 failing."
      severity FAILURE;
    assert rotate_right(signed'("111"), 3) = signed'("111")
      report "Test S.8.17 failing."
      severity FAILURE;

    assert rotate_right(signed'("100"), 0) = signed'("100")
      report "Test S.8.18 failing."
      severity FAILURE;
    assert rotate_right(signed'("100"), 1) = signed'("010")
      report "Test S.8.19 failing."
      severity FAILURE;
    assert rotate_right(signed'("100"), 2) = signed'("001")
      report "Test S.8.20 failing."
      severity FAILURE;
    assert rotate_right(signed'("100"), 3) = signed'("100")
      report "Test S.8.21 failing."
      severity FAILURE;

    assert quiet report "S.8 tests done" severity note;

    -- alex Z. A.1, A.2 tests
    -- A.1 tests
    ------------
    --                             -01111...1111 = 11111...1111 + 1  
    assert -(posmax) = negmin + (-neg1) severity failure;


    --                                                   - (-3) = 3   
    assert -signed'('1', '0', '1') = signed'('0', '1', '1')
      severity failure;
    
    --                                                    -(3) = -3
    assert -signed'('0', '1', '1') = signed'('1', '0', '1')
      severity failure;


    --                                                     -(-2)= 2
    assert -signed'('1', '1', '0') = signed'('0', '1', '0')
      severity failure;

    --                                                     -(2)= -2
    assert -signed'('0', '1', '0') = signed'('1', '1', '0')
      severity failure;


    --                                                     -(-1)= 1
    assert -signed'('1', '1', '1') = signed'('0', '0', '1')
      severity failure;
    
    --                                                     -(1)= -1
    assert -signed'('0', '0', '1') = signed'('1', '1', '1')
      severity failure; 


    assert -zero = zero severity failure;
    
    assert not(s_unull = s_unull)
      severity failure;
      
    assert not(abs(s_snull) = s_snull)
      severity failure;

    assert -(s_snull) /= s_snull
      severity failure;

    
    assert quiet report "A.1 tests done" severity note;

    -- A.2 tests


    assert posmax = abs(negmin + (-neg1)) severity failure;


    --                                                  abs(-3) = 3   
    assert abs(signed'('1', '0', '1')) = signed'('0', '1', '1')
      severity failure;
    

    --                                                  abs(-2) = 2
    assert abs(signed'('1', '1', '0')) = signed'('0', '1', '0')
      severity failure;


    --                                                 abs(-1) = 1
    assert abs(signed'('1', '1', '1')) = signed'('0', '0', '1')
      severity failure;

    assert abs(zero) = zero severity failure;


--   assert to_integer(abs(to_signed(-12345, max_size_checked))) = 
--                                    12345         severity failure;

--   assert to_integer(abs(to_signed(-4568432, max_size_checked))) = 
--                                    4568432       severity failure;
    
    assert quiet report "A.2 tests done" severity note;
    
    assert FALSE
      report "END OF test suite tb2"
      severity note;

    wait;
  end process;
end architecture;



