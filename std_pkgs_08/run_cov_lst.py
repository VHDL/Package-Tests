#! /usr/bin/python3


import sys
import os
import os.path
import subprocess
import glob

envVars = os.environ
if "PYTHONPATH" not in envVars:
    if "DSIM_REGRESS" not in envVars:
        print("Error:  DSIM_REGRESS not set.  Exiting.")
        sys.exit(-1)

    sys.path.append(envVars.get("DSIM_REGRESS") + "/lib/python")


from metrics.basics import *
from metrics.txt_colors import *
from metrics.test_location import *


not_path = '../std_pkgs/not_ieee/2008/'

not_comp = 'dvhcom -lib not_ieee -vhdl2008 ' + not_path
t_comp = 'dvhcom -lib work -vhdl2008 '
t_run  = 'dwrapper -code-cov all -linebuf -lib work -top work.'

##########################################
##  write out the compile of not_ieee to the file passed.
def gen_not():
    do_cmd(not_comp + 'std_logic_1164.vhdl')
    do_cmd(not_comp + 'std_logic_1164-body.vhdl')
    do_cmd(not_comp + 'std_logic_textio.vhdl')
    do_cmd(not_comp + 'numeric_std.vhdl')
    do_cmd(not_comp + 'numeric_std-body.vhdl')
    do_cmd(not_comp + 'ieee_std_context.vhdl')
    do_cmd(not_comp + 'math_real.vhdl')
    do_cmd(not_comp + 'math_real-body.vhdl')
    do_cmd(not_comp + 'numeric_bit.vhdl')
    do_cmd(not_comp + 'numeric_bit-body.vhdl')
    do_cmd(not_comp + 'ieee_bit_context.vhdl')
    do_cmd(not_comp + 'numeric_bit_unsigned.vhdl')
    do_cmd(not_comp + 'numeric_bit_unsigned-body.vhdl')
    do_cmd(not_comp + 'numeric_std_unsigned.vhdl')
    do_cmd(not_comp + 'numeric_std_unsigned-body.vhdl')
    do_cmd(not_comp + 'fixed_float_types.vhdl')
    do_cmd(not_comp + 'fixed_generic_pkg.vhdl')
    do_cmd(not_comp + 'fixed_generic_pkg-body.vhdl')
    do_cmd(not_comp + 'fixed_pkg.vhdl')
    do_cmd(not_comp + 'float_generic_pkg.vhdl')
    do_cmd(not_comp + 'float_generic_pkg-body.vhdl')
    do_cmd(not_comp + 'float_pkg.vhdl')
    do_cmd(not_comp + 'math_complex.vhdl')
    do_cmd(not_comp + 'math_complex-body.vhdl')
    do_cmd(not_comp + 'math_utility_pkg.vhdl')
    do_cmd(not_comp + 'std_logic_arith.vhdl')
    do_cmd(not_comp + 'std_logic_arith-body.vhdl')
    do_cmd(not_comp + 'std_logic_signed.vhdl')
    do_cmd(not_comp + 'std_logic_unsigned.vhdl')
#-f vital2000_f

####################################################3
# get the entity name from test file.
def get_ent_name (fh):
    rtn = ''
    if os.path.exists(fh):
        tf = open(fh, 'r')
        #print('Opened ' + fh)
        idx = 0
        for l in tf:
            #if idx < 20:
            #    print(l)
            #    idx = idx + 1
            l = l.lower()
            is_ent = l.find('entity ')
            #print(is_ent)
            if is_ent >= 0:
                #print(l)
                sl = l.split()
                rtn = sl[1]
                break
        
        tf.close()
    return rtn

def find_files(filename, search_path):
   result = []
   #print(search_path)
   for file in os.listdir():
       if os.path.isdir(file):
           for f in os.listdir(file):
               if f == 'test.vhdl' or f == 'not_test_pkg.vhdl':
                   pth = file + "/" + f
                   result.append(pth)
               #print(f)
         #result.append(os.path.join(root, filename))
   return result




def main(argv):
    
    if argv:
        lf = argv
        gen_not()
    else:
        lf = open("cov_test_list.txt", "r")
        # cleanuop
        do_cmd("rm -fr dbs_dir")
        do_cmd("mkdir dbs_dir")
        do_cmd("rm -fr dsim_work")
        ##  compile  not ieee
        gen_not()
    
    for f in lf:
        bdir = f.strip('\n')
        #if f[0] == '#':
        #    continue
        print(bdir)
        files = bdir + '*.vhdl'
        #print(files)
        vlst = glob.glob(files)
        #print(vlst)
        #tfile = bdir + 'test_pkg.vhdl'
        #print(tfile)
        
        for i in vlst:
            print(i)
        
#        continue
        for v in vlst:
            if v.find('_pkg.vhdl') > 0:
                if v.find("test_pkg") >= 0:
                    continue
                print("Compile package " + v)
                do_cmd(t_comp + v)
        
        for v in vlst:
            if v.find('test.vhdl') >= 0:
                if v.find("std_") >= 0:
                    continue
                print("Compile test " + v)
                do_cmd(t_comp + v)
                
        for f in vlst:
            if f.find('test.vhdl') > 0:
                if f.find("std_") >= 0:
                    continue
                ent_name = get_ent_name(f)
                print("Run  test " + ent_name)
                do_cmd(t_run + ent_name)
                do_cmd("./linecov.py metrics.db > dbs_dir/" + ent_name + ".txt")
        
        
if __name__ == "__main__":
   main(sys.argv[1:])
   exit(0)
