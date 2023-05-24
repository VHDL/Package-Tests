  function maximum (
    l, r : integer)                    -- inputs
    return integer is
  begin  -- function max
    if l > r then return l;
    else return r;
    end if;
  end function maximum;

  function minimum (
    l, r : integer)                    -- inputs
    return integer is
  begin  -- function min
    if l > r then return r;
    else return l;
    end if;
  end function minimum;


