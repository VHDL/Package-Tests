-------------- test case header    ------
--!  Test intent :  Coverage of standards.
--!  Test scope  :  reduction
--!  Keywords    : [operations, abs]
--!  References  : [VH2008 16.6]
--!                [Rlink : REQ08xx]
-----------------------------------------------
-- more intense strings.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use std.env.all;

entity std_string3 is
  generic (
    quiet : boolean := false);  -- make the simulation quiet
end entity;

architecture ops of std_string3 is
  type stdlogic_table is array(STD_ULOGIC, STD_ULOGIC) of STD_ULOGIC;
  constant qeq : stdlogic_table := (
    -- left ---------------------------------------------------------
    -- ?=   |  U    X    0    1    Z    W    L    H    -        |  right |
    --      ---------------------------------------------------------
             ('U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', '1'),  -- | U |
             ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', '1'),  -- | X |
             ('U', 'X', '1', '0', 'X', 'X', '1', '0', '1'),  -- | 0 |
             ('U', 'X', '0', '1', 'X', 'X', '0', '1', '1'),  -- | 1 |
             ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', '1'),  -- | Z |
             ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', '1'),  -- | W |
             ('U', 'X', '1', '0', 'X', 'X', '1', '0', '1'),  -- | L |
             ('U', 'X', '0', '1', 'X', 'X', '0', '1', '1'),  -- | H |
             ('1', '1', '1', '1', '1', '1', '1', '1', '1')   -- | - |
             );

  constant qlt : stdlogic_table := (
    -- right ---------------------------------------------------------
    -- ?<   |  U    X    0    1    Z    W    L    H    -        |  left |
    --      ---------------------------------------------------------
             ('U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'X'),  -- | U |
             ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | X |
             ('U', 'X', '0', '1', 'X', 'X', '0', '1', 'X'),  -- | 0 |
             ('U', 'X', '0', '0', 'X', 'X', '0', '0', 'X'),  -- | 1 |
             ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | Z |
             ('U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'),  -- | W |
             ('U', 'X', '0', '1', 'X', 'X', '0', '1', 'X'),  -- | L |
             ('U', 'X', '0', '0', 'X', 'X', '0', '0', 'X'),  -- | H |
             ('X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X')   -- | - |
             );


  procedure report_error (
    constant errmes   :    STRING;      -- error message
    actual            : in STRING;      -- data from algorithm
    constant expected :    STRING)  is  -- reference data
  begin  -- function report_error
    assert (actual = expected)
      report "TEST_NEW1164: " & errmes & LF
      & "Actual   '" & actual & "' /= " & LF
      & "Expected '" & expected &"'"
      severity error;
    return;
  end procedure report_error;
  signal start_readtest, readtest_done : BOOLEAN := false;  -- start reading test
  signal start_stest, stest_done       : BOOLEAN := false;  -- start reading test

  signal start_testalias, testalias_done    : BOOLEAN := false;
  signal start_booltest, booltest_done      : BOOLEAN := false;
  signal start_minmaxtest, minmaxtest_done  : BOOLEAN := false;
  signal start_qestionequ, questionequ_done : BOOLEAN := false;  -- test ?= operators

begin

  -- purpose: test the read routines
  -- type   : combinational
  -- inputs :
  -- outputs:
  read_test : process is
    constant rstring    : STRING := "110010101011";  -- constant string
    constant rstringh   : STRING := "CAB";           -- constant string
    constant rstringo   : STRING := "3210";          -- constant string
    constant rstringo1   : STRING := "7654";          -- constant string
    constant rstringd   : STRING := "3243";          -- constant string
    constant rstringn   : STRING := "-853";          -- constant string
    constant leadu1      : STRING := "_0011000111001";  -- constant string
    constant leadu2      : STRING := "00110__0011100";  -- constant string
    constant leadu3      : STRING := "00110130011100";  -- constant string
    constant bstringw1   : STRING := "Hello" & LF & " World";  -- line feed in string.
    constant bstring1   : STRING := "";              -- empty string
    constant bstring2   : STRING := "11*111*1111*";  -- illegal characters
    constant bstring3   : STRING := "11 111 1111";   -- space characters
    constant bstring4   : STRING := " 11 ";          -- space padding
    variable checknum   : STD_ULOGIC_VECTOR (11 downto 0);  -- std_ulogic_vector
    variable checknums  : STD_LOGIC_VECTOR (11 downto 0);   -- std_logic_vector
    variable checknums2 : STD_LOGIC_VECTOR (12 downto 0);   -- std_logic_vector
    variable checknums3 : STD_ULOGIC_VECTOR (12 downto 0);   -- std_logic_vector
    variable l          : LINE;         -- line variable
    variable checkbool  : BOOLEAN;      -- check boolean
    variable shortnum   : STD_ULOGIC_VECTOR (9 downto 0);  -- std_ulogic_vector
    
    variable nullv : STD_ULOGIC_VECTOR (12 to 0);   -- null std_logic_vector
    variable sul1 : std_ulogic;
    variable sul2 : std_ulogic;
    variable sulr : std_ulogic;
    variable rvec : std_ulogic_vector(1 downto 0);
    
    variable short : unsigned(10 downto 0);
    variable inter : unsigned(11 downto 0);
    variable intero : unsigned(11 downto 0);
    variable hval : unsigned(15 downto 0);
    variable hsum : unsigned(15 downto 0) := "0100010001000100";
    variable hvalr : unsigned(15 downto 0);
    variable hchecknum   : STD_ULOGIC_VECTOR (15 downto 0);  -- std_ulogic_vector
    
  begin  -- process read_test
    for i in std_ulogic'low to std_ulogic'high loop
      L := new string'(to_string(i));
      read(L, sul1, checkbool);
      report_error ("std_ulogic read ",
                    to_string(sul1),
                    to_string(i));
    end loop;
    --  invalid character  1136
    L := new string'(to_string('2'));
    read(L, sul1, checkbool);
    report_error ("std_ulogic read ",
                  to_string(sul1),
                  "U");
    deallocate (L);
    --  leading spaces
    L := new string'(" 1");
    read(L, sul1, checkbool);
    report_error ("std_ulogic read ",
                  to_string(sul1),
                  "1");
    deallocate (L);
    --  L  is null  1133
    read(L, sul1, checkbool);
    report_error ("std_ulogic read ",
                  to_string(sul1),
                  "U");
    
    -- test the READ routines
    L := new STRING'(leadu1);
    read (L, checknums3, checkbool);
    report_error ("Lead underscore Read",
                  to_string(checknums3),
                  "UUUUUUUUUUUUU");
    deallocate (L);
    
    L := new STRING'(leadu2);
    read (L, checknums3, checkbool);
    report_error ("Lead underscore Read",
                  to_string(checknums3),
                  "UUUUUUUUUUUUU");
    deallocate (L);
    
    for i in std_ulogic'low to std_ulogic'high loop
      L := new string'(to_string(i));
      read(L, sul1);
      report_error ("std_ulogic read ",
                    to_string(sul1),
                    to_string(i));
      deallocate (L);
    end loop;
    
    --  null vector as target to read to  1187
    L := new string'("000110101");
    read(L, nullv, checkbool);
    assert checkbool report "Read to null vector not return good.";
    report_error ("std_ulogic read into null vector",
                  to_string(nullv),
                  "");
    deallocate (L);
    
    --  invalid Null  L  1199
    read(L, sul1);
    report_error ("std_ulogic read Null into std_ulogic",
                  to_string(sul1),
                  "U");
    deallocate (L);
    
    --  invalid character  1204
    L := new string'(to_string('2'));
    read(L, sul1);
    report_error ("std_ulogic read not std_ulogic value",
                  to_string(sul1),
                  "U");
    deallocate (L);
    
    
    for i in std_ulogic'low to std_ulogic'high loop
      checknum := (others => i);
      checknums := checknum;
      L := new string'(to_string(checknum));
      read(L, checknum);
      report_error ("std_ulogic read ",
                    to_string(checknum),
                    to_string(checknums));
      deallocate (L);
    end loop;
    
    --  null vector as target to read to  1222
    L := new string'(to_string(checknum));
    read(L, nullv);
    report_error ("std_ulogic read ",
                  to_string(nullv),
                  "");
    deallocate (L);
    
     L := new string'(leadu1);
    read(L, checknums3);
    report_error ("std_ulogic read ",
                  to_string(checknums3),
                  "UUUUUUUUUUUUU");
    deallocate (L);
    
     L := new string'(leadu2);
    read(L, checknums3);
    report_error ("std_ulogic read ",
                  to_string(checknums3),
                  "UUUUUUUUUUUUU");
    deallocate (L);
    
     L := new string'(leadu3);
    read(L, checknums3);
    report_error ("std_ulogic read ",
                  to_string(checknums3),
                  "UUUUUUUUUUUUU");
    deallocate (L);
    
    --  line 1226 ?
    L := new string'("");
    read(L, checknums3);
    report_error ("std_ulogic read enpty string",
                  to_string(checknums3),
                  "UUUUUUUUUUUUU");
    deallocate (L);
    
    
    
    --L := new string'("0");
    sul1 := '1';
    write(L, sul1, right, 5);
    read(L, sulr);
    report_error ("std_ulogic write justified width 5 ",
                  to_string(sulr),
                  "1");
    deallocate (L);
    
    -- oread  with  good
    L := new string'(rstringo);
    oread(L, checknum, checkbool);
    report_error ("oread Numbers1 ",
                  to_string(checknum),
                  "011010001000");
    assert checkbool
      report "Error:  oread did not return OK when expected to"
      severity failure;
    deallocate (L);
      
    L := new string'(rstringo1);
    oread(L, checknum, checkbool);
    report_error ("oread Numbers2 ",
                  to_string(checknum),
                  "111110101100");
    assert checkbool
      report "Error:  oread did not return OK when expected to"
      severity failure;
    deallocate (L);
    --  not Octal chars
    L := new string'("8901");
    oread(L, checknum, checkbool);
    report_error ("oread Non-numbers ",
                  to_string(checknum),
                  "UUUUUUUUUUUU");
    assert not checkbool
      report "Error:  oread did not return Error when expected to"
      severity failure;
    deallocate (L);
    --  underscores ok
    L := new string'("3_2_1_0");
    oread(L, checknum, checkbool);
    report_error ("oread legal underscore ",
                  to_string(checknum),
                  "011010001000");
    assert checkbool
      report "Error:  oread did not return OK when expected to"
      severity failure;
    deallocate (L);
    --  vector wont fit in target
    L := new string'("3210");
    oread(L, short, checkbool);
    report_error ("oread short target ",
                  to_string(short),
                  "11010001000");
    assert checkbool
      report "Error:  oread did not return OK when expected to"
      severity failure;
    deallocate (L);
    --  leading underscore
    L := new string'("_701");
    oread(L, checknum, checkbool);
    report_error ("oread leading underscore ",
                  to_string(checknum),
                  "UUUUUUUUUUUU");
    assert not checkbool
      report "Error:  oread did not return Error when expected to"
      severity failure;
    deallocate (L);
    --  two undersore
    L := new string'("370__1");
    oread(L, checknum, checkbool);
    report_error ("oread double underscore ",
                  to_string(checknum),
                  "UUUUUUUUUUUU");
    assert not checkbool
      report "Error:  oread did not return Error when expected to"
      severity failure;
    deallocate (L);
    -- null  line
    oread(L, checknum, checkbool);
    report_error ("oread null 'L' ",
                  to_string(checknum),
                  "UUUUUUUUUUUU");
    assert not checkbool
      report "Error:  oread did not return Error when expected to"
      severity failure;

    -- null  std_ulogic_vector
    L := new string'("3701");
    oread(L, nullv, checkbool);
    report_error ("oread null std_ulogic_vector ",
                  to_string(nullv),
                  "");
    assert checkbool
      report "Error:  oread did not return Error when expected to"
      severity failure;
    
    -- truncated  std_ulogic_vector
    L := new string'("7777");
    oread(L, shortnum, checkbool);
    report_error ("oread short std_ulogic_vector ",
                  to_string(shortnum),
                  "UUUUUUUUUU");
    assert not checkbool
      report "Error:  oread short vector target came back good."
      severity failure;
    
    -- oread
    L := new string'(rstringo);
    oread(L, checknum);
    report_error ("oread Numbers1 ",
                  to_string(checknum),
                  "011010001000");
    deallocate (L);
      
    L := new string'(rstringo);
    oread(L, nullv);
    report_error ("Oread to null vector ",
                  to_string(nullv),
                  "");
    deallocate (L);
      
    L := new string'(rstringo1);
    oread(L, checknum);
    report_error ("oread Numbers2 ",
                  to_string(checknum),
                  "111110101100");
    deallocate (L);
    --  not Octal chars
    L := new string'("8901");
    oread(L, checknum);
    report_error ("oread Non-numbers ",
                  to_string(checknum),
                  "UUUUUUUUUUUU");
    deallocate (L);
    --  underscores ok
    L := new string'("3_2_1_0");
    oread(L, checknum);
    report_error ("oread legal underscores ",
                  to_string(checknum),
                  "011010001000");
    deallocate (L);
    --  leading underscore
    L := new string'("_701");
    oread(L, checknum);
    report_error ("oread leading underscore ",
                  to_string(checknum),
                  "UUUUUUUUUUUU");
    deallocate (L);
    --  two undersore
    L := new string'("370__1");
    oread(L, checknum);
    report_error ("oread double undersore ",
                  to_string(checknum),
                  "UUUUUUUUUUUU");
    deallocate (L);
    -- null  line
    oread(L, checknum);
    report_error ("oread null 'L' ",
                  to_string(checknum),
                  "UUUUUUUUUUUU");
    
    -- truncated  std_ulogic_vector
    L := new string'("7777");
    oread(L, shortnum);
    report_error ("oread short std_ulogic_vector ",
                  to_string(shortnum),
                  "UUUUUUUUUU");
    
    --  hread  with GOOD
    --  all legal hex values.
    hval := "0011001000010000";
    for i in 0 to 3 loop
      L := new string'(to_hstring(hval));
      hread(L, hchecknum, checkbool);
      report_error ("hread numbers ",
                    to_string(hchecknum),
                    to_string(hval));
      deallocate (L);
      assert checkbool
        report "Error: hread results did not return GOOD"
        severity failure;
      hval := hval + hsum;
    end loop;
    --  non-hex values.
    L := new string'("aBz1");
    hread(L, hchecknum, checkbool);
    report_error ("hread numbers ",
                  to_string(hchecknum),
                  "UUUUUUUUUUUUUUUU");
    assert not checkbool
      report "Error: hread results did not return BAD"
      severity failure;
    deallocate (L);
    
    --  underscores.
    L := new string'("a_b_cd");
    hread(L, hchecknum, checkbool);
    report_error ("hread numbers ",
                  to_string(hchecknum),
                  "1010101111001101");
    assert checkbool
      report "Error: hread results did not return GOOD"
      severity failure;
    deallocate (L);
    
    --  leading underscore.
    L := new string'("_a_b_cd");
    hread(L, hchecknum, checkbool);
    report_error ("hread numbers ",
                  to_string(hchecknum),
                  "UUUUUUUUUUUUUUUU");
    assert not checkbool
      report "Error: hread results did not return BAD"
      severity failure;
    deallocate (L);
    
    --  double underscore.
    L := new string'("a_b__cd");
    hread(L, hchecknum, checkbool);
    report_error ("hread numbers ",
                  to_string(hchecknum),
                  "UUUUUUUUUUUUUUUU");
    assert not checkbool
      report "Error: hread results did not return BAD"
      severity failure;
    deallocate (L);
    
    --  null L
    hread(L, hchecknum, checkbool);
    report_error ("hread numbers null line",
                  to_string(hchecknum),
                  "UUUUUUUUUUUUUUUU");
    assert not checkbool
      report "Error: hread results did not return BAD"
      severity failure;
    deallocate (L);
    
    --  null val
    L := new string'("abcd");
    hread(L, nullv, checkbool);
    report_error ("hread numbers null value",
                  to_string(hchecknum),
                  "UUUUUUUUUUUUUUUU");
    assert checkbool
      report "Error: hread results did not return BAD read to null vector"
      severity failure;
    deallocate (L);
    
    --  truncated value
    L := new string'("bcd");
    hread(L, short, checkbool);
    report_error ("hread truncated value",
                  to_string(short),
                  "UUUUUUUUUUU");
    assert not checkbool
      report "Error: hread results did not return BAD truncated value"
      severity failure;
    deallocate (L);
    
    
    --  hread  with no return
    --  all legal hex values.
    hval := "0011001000010000";
    for i in 0 to 3 loop
      L := new string'(to_hstring(hval));
      hread(L, hchecknum);
      report_error ("hread numbers ",
                    to_string(hchecknum),
                    to_string(hval));
      deallocate (L);
      hval := hval + hsum;
    end loop;
    --  non-hex values.
    L := new string'("aBz1");
    hread(L, hchecknum);
    report_error ("hread numbers ",
                  to_string(hchecknum),
                  "UUUUUUUUUUUUUUUU");
    deallocate (L);
    
    --  underscores.
    L := new string'("a_b_cd");
    hread(L, hchecknum);
    report_error ("hread numbers ",
                  to_string(hchecknum),
                  "1010101111001101");
    deallocate (L);
    
    --  leading underscore.
    L := new string'("_a_b_cd");
    hread(L, hchecknum);
    report_error ("hread numbers leading underscore",
                  to_string(hchecknum),
                  "UUUUUUUUUUUUUUUU");
    deallocate (L);
    
    --  double underscore.
    L := new string'("a_b__cd");
    hread(L, hchecknum);
    report_error ("hread numbers double undersore ",
                  to_string(hchecknum),
                  "UUUUUUUUUUUUUUUU");
    deallocate (L);
    
    --  null L
    hread(L, hchecknum);
    report_error ("hread numbers null line",
                  to_string(hchecknum),
                  "UUUUUUUUUUUUUUUU");
    deallocate (L);
    
    --  null value
    L := new string'("abcd");
    hread(L, nullv);
    report_error ("hread numbers null vector",
                  to_string(hchecknum),
                  "UUUUUUUUUUUUUUUU");
    deallocate (L);
    
    --  truncated value
    L := new string'("bcd");
    hread(L, short);
    report_error ("hread truncated value",
                  to_string(short),
                  "UUUUUUUUUUU");
    deallocate (L);
    
    --  ?<
    for i in std_ulogic'high downto std_ulogic'low loop
      for j in std_ulogic'high downto std_ulogic'low loop
        sulr := i ?< j;
        sul1 := qlt(i, j);
        --report "Result: " & to_string(sulr) & " of " & to_string(i) &
        --       " ?<= " & to_string(j);
        assert (sulr = sul1)
          report "Error:  ?<  expected: " & to_string(sul1) & " Got: "  & to_string(sulr)
          severity failure;
      end loop;
    end loop;
    
    --  ?>
    for i in std_ulogic'high downto std_ulogic'low loop
      for j in std_ulogic'high downto std_ulogic'low loop
        sulr := i ?> j;
        sul1 := not (i ?<= j);
        --report "Result: " & to_string(sulr) & " of " & to_string(i) &
        --       " ?> " & to_string(j);
        assert (sulr = sul1)
          report "Error:  ?>  expected: " & to_string(sul1) & " Got: "  & to_string(sulr)
          severity failure;
      end loop;
    end loop;
    
    --  ?<=
    for i in std_ulogic'high downto std_ulogic'low loop
      for j in std_ulogic'high downto std_ulogic'low loop
        sulr := i ?<= j;
        rvec(1) := qlt(i, j);
        rvec(0) := qeq(i, j);
        sul1 := or(rvec);
        --report "Result: " & to_string(sulr) & " of " & to_string(i) &
        --       " ?<= " & to_string(j) & "  Vector: " & to_string(rvec);
        assert (sulr = sul1)
          report "Error:  ?<=  expected: " & to_string(sul1) & " Got: "  & to_string(sulr)
          severity failure;
      end loop;
    end loop;
    
    --  ?>=
    for i in std_ulogic'high downto std_ulogic'low loop
      for j in std_ulogic'high downto std_ulogic'low loop
        sulr := i ?>= j;
        sul1 := not qlt(i, j);
        --report "Result: " & to_string(sulr) & " of " & to_string(i) &
        --       " ?>= " & to_string(j);
        assert (sulr = sul1)
          report "Error:  ?>=  did not return the correct result"
          severity failure;
      end loop;
    end loop;
    
    report "Test passed ...";
    finish;
  end process read_test;
end ops;
