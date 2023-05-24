library not_ieee;
use not_ieee.std_logic_1164.all;
use not_ieee.numeric_std.all;
use work.all;

package comps is

  component a11 is
  end component;

end package;


library not_ieee;
use not_ieee.std_logic_1164.all;
use not_ieee.numeric_std.all;
use work.all;


configuration cover1 of a11 is
--  for ops
    use work.a11(ops);
--  end for;
end cover1;
