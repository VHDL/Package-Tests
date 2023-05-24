#! /usr/bin/python3
import sys
import os
import os.path
import subprocess
import random
from random import Random

envVars = os.environ
if "PYTHONPATH" not in envVars:
    if "DSIM_REGRESS" not in envVars:
        print("Error:  DSIM_REGRESS not set.  Exiting.")
        sys.exit(-1)

    sys.path.append(envVars.get("DSIM_REGRESS") + "/lib/python")

from metrics.basics import *
from metrics.txt_colors import *
from metrics.test_location import *

ops1 = ["+", "-", "abs"]
ops2 = ["+", "-", "*"]
comps = ["=", "/=", "<=", ">=" "<", ">"]
types1 = ["signed", "unsigned"]
types2 = ["signed", "unsigned", "integer", "std_logic"]
rtns1 = ["signed", "unsigned", "std_logic_vector"]
rtns2 = ["signed", "unsigned", "std_logic_vector"]
rtns3 = "boolean"

mran = Random()

for o in ops1:
    for L in types1:
        for R in types1:
            tlst = []
            mran.seed()
            lo_size = mran.randrange(-50, 0)
            hi_size = lo_size + 50
            
            tlst.append("for i in " + lo_size + " downto " + hi_size + "loop")
            tlst.append("  for j in " + lo_size + " downto " + hi_size + "loop")
            
            tlst.append("  
                



#    for i in -10 to 50 loop
#      for j in 0 to 10 loop
#        uslv := CONV_UNSIGNED(j, 8);
#        stdlv := uslv+i;
#        rstr := to_string(CONV_UNSIGNED(i+j, 8));
#        assert to_string(stdlv) = rstr report "Error in  ID 264" severity failure;
#      end loop;
#    end loop;

