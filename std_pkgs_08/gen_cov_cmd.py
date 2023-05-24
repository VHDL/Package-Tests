#! /usr/bin/python3


import sys
import os
import os.path

not_path = '../std_pkgs/not_ieee/2008/'

not_comp = 'dvhcom -lib not_ieee -vhdl2008 ' + not_path
t_comp = 'dvhcom -lib work -vhdl2008 '
t_run  = 'dwrapper -code-cov all -linebuf -lib work -top work.'

##########################################
##  write out the compile of not_ieee to the file passed.
def gen_not(fh):
    fh.write(not_comp + 'std_logic_1164.vhdl\n')
    fh.write(not_comp + 'std_logic_1164-body.vhdl\n')
    fh.write(not_comp + 'std_logic_textio.vhdl\n')
    fh.write(not_comp + 'numeric_std.vhdl\n')
    fh.write(not_comp + 'numeric_std-body.vhdl\n')
    fh.write(not_comp + 'ieee_std_context.vhdl\n')
    fh.write(not_comp + 'math_real.vhdl\n')
    fh.write(not_comp + 'math_real-body.vhdl\n')
    fh.write(not_comp + 'numeric_bit.vhdl\n')
    fh.write(not_comp + 'numeric_bit-body.vhdl\n')
    fh.write(not_comp + 'ieee_bit_context.vhdl\n')
    fh.write(not_comp + 'numeric_bit_unsigned.vhdl\n')
    fh.write(not_comp + 'numeric_bit_unsigned-body.vhdl\n')
    fh.write(not_comp + 'numeric_std_unsigned.vhdl\n')
    fh.write(not_comp + 'numeric_std_unsigned-body.vhdl\n')
    fh.write(not_comp + 'fixed_float_types.vhdl\n')
    fh.write(not_comp + 'fixed_generic_pkg.vhdl\n')
    fh.write(not_comp + 'fixed_generic_pkg-body.vhdl\n')
    fh.write(not_comp + 'fixed_pkg.vhdl\n')
    fh.write(not_comp + 'float_generic_pkg.vhdl\n')
    fh.write(not_comp + 'float_generic_pkg-body.vhdl\n')
    fh.write(not_comp + 'float_pkg.vhdl\n')
    fh.write(not_comp + 'math_complex.vhdl\n')
    fh.write(not_comp + 'math_complex-body.vhdl\n')
    fh.write(not_comp + 'math_utility_pkg.vhdl\n')
#${DSIM_UNIT_TESTS_HOME}/std_pkgs/src/synopsys/std_logic_arith.vhdl
#${DSIM_UNIT_TESTS_HOME}/std_pkgs/src/synopsys/std_logic_signed.vhdl
#${DSIM_UNIT_TESTS_HOME}/std_pkgs/src/synopsys/std_logic_unsigned.vhdl
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

    mode = argv[0]
    if mode == "":
        mode = "all"

    flst = find_files('*.vhdl', './')

    ch = open('run_cov', 'w')

    ch.write('rm -fr dbs_dir && \\\n')
    ch.write('mkdir dbs_dir\n')
    ch.write('rm -fr dsim_work && \\\n')
    #ch.write('dlib map -lib ieee ${STD_LIBS}/ieee08  && \\\n')

    ##  compile  not ieee
    gen_not(ch)

    #exit(0)
    ## compile  pkgs
    if mode == "num" or mode == "all":
        for f in flst:
            if f.find('num') < 0:
                #print("Not a num test " + f)
                continue
            if f.find('_pkg.vhdl') > 0:
                ch.write(t_comp + f + '\n')

        ##  compile  tests
        for f in flst:
            if f.find('num') < 0:
                #print("Not a num test " + f)
                continue
            if f.find('test.vhdl') > 0:
                ch.write(t_comp + f + '\n')

        for f in flst:
            if f.find('string') >= 0:
                if f.find('test.vhdl') > 0:
                    ch.write(t_comp + f + '\n')
                    #print("Not a num test " + f)
            if f.find('compare') >= 0:
                if f.find('test.vhdl') > 0:
                    ch.write(t_comp + f + '\n')

    if mode == "nbit" or mode == "all":
        for f in flst:
            if f.find('nbit') < 0:
                #print("Not a num test " + f)
                continue
            if f.find('_pkg.vhdl') > 0:
                ch.write(t_comp + f + '\n')

        for f in flst:
            if f.find('nbit') < 0:
                #print("Not a num test " + f)
                continue
            if f.find('test.vhdl') > 0:
                ch.write(t_comp + f + '\n')




    if mode == "num" or mode == "all":
        ##  run tests.
        for f in flst:
            if f.find('num') < 0:
                continue
            if f.find('test.vhdl') > 0:
                ent_name = get_ent_name(f)
                ch.write(t_run + ent_name + '\n')
                #ch.write('cp metrics.db dbs_dir/' + ent_name + '.db\n')
                ch.write('./linecove.py metrics.db > dbs_dir/' + ent_name + '.txt\n')

        for f in flst:
            if f.find('string') >= 0:
                if f.find('test.vhdl') > 0:
                    ent_name = get_ent_name(f)
                    ch.write(t_run + ent_name + '\n')
                    #ch.write('cp metrics.db dbs_dir/' + ent_name + '.db\n')
                    ch.write('./linecove.py metrics.db > dbs_dir/' + ent_name + '.txt\n')
                    
            if f.find('compare') >= 0:
                if f.find('test.vhdl') > 0:
                    ent_name = get_ent_name(f)
                    ch.write(t_run + ent_name + '\n')
                    #ch.write('cp metrics.db dbs_dir/' + ent_name + '.db\n')
                    ch.write('./linecove.py metrics.db > dbs_dir/' + ent_name + '.txt\n')

    if mode == "nbit" or mode == "all":
        for f in flst:
            if f.find('nbit') < 0:
                continue
            if f.find('test.vhdl') > 0:
                ent_name = get_ent_name(f)
                ch.write(t_run + ent_name + '\n')
                ch.write('cp metrics.db dbs_dir/' + ent_name + '.db\n')


    ch.close()
    #print(flst)
    exit(0)

if __name__ == "__main__":
   main(sys.argv[1:])
