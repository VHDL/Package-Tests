-------------- test case header    ------
--!  Test intent :  Coverage of standards.
--!  Test scope  :  reduction
--!  Keywords    : [operations, abs]
--!  References  : [VH2008 16.6]
--!                [Rlink : REQ08xx]
-----------------------------------------------
-- ?=  function length diff failure.

library not_ieee;
use not_ieee.std_logic_1164.all;
use not_ieee.numeric_std.all;
use std.textio.all;
use std.env.all;

entity std1164_11 is
end entity;

architecture ops of std1164_11 is
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



begin

  -- purpose: test the read routines
  -- type   : combinational
  -- inputs :
  -- outputs:
  read_test : process is
    variable checknum   : STD_ULOGIC_VECTOR (11 downto 0);  -- std_ulogic_vector
    variable hchecknum   : STD_ULOGIC_VECTOR (15 downto 0);  -- std_ulogic_vector
    variable sulr : std_ulogic;
    
  begin  -- process read_test
    
    sulr := checknum ?= hchecknum;
    
    report "Test passed ...";
    finish;
  end process read_test;
end ops;
