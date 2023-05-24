#! /usr/bin/python3
import sys
import os
import os.path
import subprocess

envVars = os.environ
if "PYTHONPATH" not in envVars:
    if "DSIM_REGRESS" not in envVars:
        print("Error:  DSIM_REGRESS not set.  Exiting.")
        sys.exit(-1)

    sys.path.append(envVars.get("DSIM_REGRESS") + "/lib/python")

from metrics.basics import *
from metrics.txt_colors import *
from metrics.test_location import *

#######################################
##  def to sort the output from line_cov.py
##    Some lines are way out of order and that
##    causes the current merge system to break.
##    sorting the file based on line number.
##    
##  Mark file as sorted once done, enables skipping
##    if already sorted before
##
##  Input:   file to sort
##  Output:  Sorted file writen out.
##
def sort_file(fn):
    fh = open(fn, "r")
    fline = fh.readline().strip()
    #  if previously sorted skip
    if fline.find("sorted") >= 0:
        return
    flst = []
    tlst = []
    rlst = []
    
    fdic = {}
    
    for ln in fh:
        ln = ln.strip('\n')
        #print(ln)
        if ln == "":
            continue
        
        if ln.find('Line coverage') >= 0:
            if tlst == '':
                rlst.append(ln)
            else:
                tlst.append(rlst)
                rlst = []
                rlst.append(ln)
                
        elif ln.find('Coverage for') >= 0:
            rlst.append(ln)
        else:
            rlst.append(ln)
    
    fh.close()    
    idx = 0
    
    nf_lst = []
    for t in tlst:
        if t == '':
            continue
        
        so_lst = []
        line1 = ''
        line2 = ''
        for l in t:
            #print(l)
            ##  drop info lines.
            if l.find('Line coverage') >= 0:
                line1 = l
                continue
            if l.find('Coverage for') >= 0:
                line2 = l
                continue
            
            if len(so_lst) == 0:
                so_lst.append(l)
                continue
           
            nlnum = int(l[31:36].strip())
            for idx in range(0, len(so_lst)):
                slnum = int(so_lst[idx][31:36].strip())
                if idx == len(so_lst) -1:
                    so_lst.append(l)
                    break
                
                if nlnum <= slnum:
                    so_lst.insert(idx,l)
                    break
                else:
                    continue
        
        so_lst.insert(0, line2)
        so_lst.insert(0, line1)
        
        nf_lst.append(so_lst)
    
    fh = open(fn, 'w')
    fh.write("sorted\n")
    
    for n in nf_lst:
        for l in n:
            fh.write(l + "\n")
            #print(l)
    fh.close()
    

########################################3
##   def to sum the line
##      lst  the list to find the line in
##      dic  dictionary file_name => lst line # start
##      fname  the file name being accessed for adding
##      ln     the cover line content 
##   return modified list (cover count addition)
##
def sum_line(lst, dic, fname, ln):
    
    idx = dic[fname]
    cnt = ln[0:12].strip()
    reason = ln[13:30]
    line_num = ln[31:36]
    code = ln[37:-1]
    #print("Line at index: " + str(idx) + " is: " + lst[idx])
    found = 0
    tstr = ''
    ncnt = 0
    while idx < len(lst):
        lln = lst[idx]
        lcnt = lln[0:12].strip()
        lreason = lln[13:30]
        lline_num = lln[31:36]
        lcode = lln[37:-1]
        #print(code)
        if lline_num == line_num and lcode == code:
            #print("Found Matching line: \n  From: " + str(lln) + "\n    To: " + str(ln) + "\n At idx: " + str(idx))
            
            found = 1
            ncnt = int(cnt) + int(lcnt)
            #print("line: " + line_num + "\n  cnt Prev: " + str(cnt) + "\n  cnt to  add: " + str(lcnt))
            tstr = '{:>12} {:<14} {}'.format(ncnt, reason, line_num)
            
            #print("Output: " + tstr)
            lst[idx] = tstr
            
        idx += 1
        
    if found == 0:
        print("ERROR:  Line not found: " + ln)
        
    return lst
##############################################################################

not_path = '../std_pkgs/not_ieee/2008/'

not_comp = 'dvhcom -lib not_ieee -vhdl2008 ' + not_path
t_comp = 'dvhcom -lib work -vhdl2008 '
t_run  = 'dwrapper -code-cov all -linebuf -lib work -top work.'

lin_lst = []
lin_lst = os.listdir('./dbs_dir')

cstd_lst = []  #  The over all list with sums of coverage
cstd_idx = 1   #   index start as 1  like a file??
file_dic = {}  #  The dic  file to cstd_idx
fc_lst = []    #  the list of files should index into cstd_lst
tlst = []

cfile_name = ""
last_fname = ""
first_file = 1
fskip = 0

new_add = 0    #  0 when a new file is found  1 when add to existing

for c in lin_lst:
    fn = './dbs_dir/' + c
    sort_file(fn)
    
    fh = open(fn, "r")
    for ln in fh:
        #print(ln)
        if ln == "":
            continue
        
        if ln.find("sorted") != -1:
            continue
        
        ln = ln.strip('\n')
        if ln.find("Coverage") != -1:
            #print("This is a new file " + ln)##.setdefault("Name",
            
            fskip = 0
            if cstd_lst:
                first_file = 0
            sln = ln.split(':')
            cfile_name = sln[1].strip()
            print("This file " + c)
            if cfile_name.find('test') >= 0:
                #print("Found test case file")
                fskip = 1
                cstd_lst.append(ln)
                cstd_idx += 1
                continue
            
            is_on = -1
            try:
                is_on = file_dic[cfile_name]
                new_add = 1
            except KeyError:
                print(">>> add new file to file dic:" + cfile_name)
                file_dic.setdefault(cfile_name, cstd_idx)
                cstd_lst.append(ln)
                cstd_idx += 1
                fskip = 0
                new_add = 0
                
            continue
        
        elif ln.find("Line coverage") != -1:
            if fskip == 1:
                continue
                
            elif new_add == 0:
                #print("This is a new instance " + ln)
                cstd_lst.append(ln)
                cstd_idx += 1

        else:
            if fskip == 1:
                continue
            elif first_file == 1:
                cstd_lst.append(ln)
                cstd_idx += 1
                continue
            cnt = ln[0:12].strip()
            reason = ln[13:30]
            line_num = ln[31:36]
            code = ln[37:-1]
            #print(cnt + " " + reason + " " + line_num)
            if cnt == '':
                continue
            else:
                if new_add == 0:
                    cstd_lst.append(ln)
                    cstd_idx += 1
                    #print(ln)
                else:
                    found = 0
                    for i in cstd_lst:
                        if line_num in i:
                            if reason in i:
                                found = 1
                                break
                    #  if the line has not been added,  append it.
                    if found == 0:
                        cstd_lst.append(ln)
                        cstd_idx += 1
                        continue
                        
                    #print(str(cnt))
                    if cnt != '0':
                        cstd_lst = sum_line(cstd_lst, file_dic, cfile_name, ln)
            
    fh.close()

      
## output the merged data
of = open("merged_out.txt", 'w')
for o in cstd_lst:
    of.write(o + "\n")
of.close()


##  now calculate the coverage
file_name = ""
lines = 0
lines_cov = 0
for o in cstd_lst:
    if o.find("Coverage") != -1:
        if file_name != "":
            per = lines_cov / lines * 100
            print(file_name + "\n   lines to cover: " + str(lines) + "\n   lines covered: " + str(lines_cov) + "\n Percent: " + str(per))
            lines = 0
            lines_cov = 0
        so = o.split(':')
        file_name = so[1].strip()
        
    elif o.find("Line coverage") >= 0:
        continue
    else:
        cnt = o[0:12].strip()
        lines += 1
        if cnt != '0':
            lines_cov += 1
            
per = lines_cov / lines * 100
print(file_name + "\n   lines to cover: " + str(lines) + "\n   lines covered: " + str(lines_cov) + "\n Percent: " + str(per))

exit(0)
