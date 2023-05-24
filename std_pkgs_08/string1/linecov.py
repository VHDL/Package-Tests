#!/usr/bin/python
#  **********************************************************************
#  **********************************************************************
#  *********  Copyright (c) 2017-2021 Metrics Technologies Inc, *********
#  *********  All rights reserved.                              *********
#  *********                                                    *********
#  *********  Use, disclosure, or distribution is prohibited    *********
#  *********  without prior written permission.                 *********
#  **********************************************************************
#  **********************************************************************

import sqlite3
import sys

if len(sys.argv) == 1:
    fname = "metrics.db"
elif len(sys.argv) == 2:
    fname = sys.argv[1]
else:
    print "usage: linecov.py <metrics.db>"
    exit(1)

conn = sqlite3.connect(fname)

locations = {}
filenames = {}
paths = {}

# Slurp in all filenames and locations
# Possibly wasteful, but I'm not a SQL expert to make the relevant queries
c = conn.cursor()
for row in c.execute('select id, fileName from sourceFiles'):
    filenames[row[0]] = row[1]

#print(filenames)

c = conn.cursor()
for row in c.execute('select id, fileId, line, charindex from locations where type = 1'):
    locations[row[0]] = [ filenames[row[1]], row[2], row[3]]

# Get dotted path to instance
def inst_to_path(id):
    if id not in paths:
        c = conn.cursor()
        query = 'select parentInstanceId, name from InstanceCoverages where instanceId = ?'
        c.execute(query, (id,))
        row = c.fetchone()
        if row[0] is None:
            paths[id] = row[1]
        else:
            paths[id] = inst_to_path(row[0]) + '.' + row[1]
            #print(id)
#    else:
#        pfile = filenames[id]
#        print(pfile)
    return paths[id]

# Return list of lines within locations
# sloc and eloc must refer to same file
cur_fname = ''
cur_lno = 0
cur_line = ''
cur_fd = None

def fetch_source(sloc, eloc):
    global cur_fname, cur_lno, cur_line, cur_fd
    sloc = locations[sloc]
    eloc = locations[eloc]
    fname = sloc[0]
    sline = sloc[1]
    schar = sloc[2]
    efname = eloc[0]
    eline = eloc[1]
    echar = eloc[2]
    result = []
    if fname != efname:
        return [ '<multiple-file span>' ]
    if fname != cur_fname or sline < cur_lno:
        # Need to reopen new file
        if cur_fd is not None:
            cur_fd.close()
        cur_fd = open(fname, 'r')
        cur_lno = 0
        cur_fname = fname
    # Read from file up to desired line
    while cur_lno < sline:
        cur_line = cur_fd.readline()
        cur_line = cur_line.rstrip('\n')
        cur_lno = cur_lno + 1
    if sline == eline:
        # All from one line
        l = len(cur_line)
        rline = cur_line[schar-1:echar]
        rline = rline.rjust(echar)
        rline = '{:>8}   {}'.format(cur_lno, rline)
        result.append(rline)
    else:
        # Start of first line
        l = len(cur_line)
        rline = cur_line[schar-1:]
        rline = rline.rjust(l)
        rline = '{:>8}   {}'.format(cur_lno, rline)
        result.append(rline)
        # Complete lines in middle:
        while cur_lno < eline-1:
            cur_line = cur_fd.readline()
            cur_line = cur_line.rstrip('\n')
            cur_lno = cur_lno + 1
            rline = '{:>8}   {}'.format(cur_lno, cur_line)
            result.append(rline)
        # Line at end
        cur_line = cur_fd.readline()
        cur_line = cur_line.rstrip('\n')
        cur_lno = cur_lno + 1
        rline = cur_line[0:echar]
        rline = '{:>8}   {}'.format(cur_lno, rline)
        result.append(rline)
    return result

insts = []
c = conn.cursor()
for row in c.execute('select distinct parentInstanceId from lineCoverages'):
    insts.append(row[0])

for inst in insts:
    path = inst_to_path(inst)
    print '\nLine coverage for ' + path + ':\n'

    query = 'select startLocationId, endLocationId, coverageCount, reason from lineCoverages where parentInstanceId = ?'
    c = conn.cursor()
    c.execute(query, (inst,))
    lcov = c.fetchall()
    
    tl = lcov[0][0]
    tmp = locations[tl]
    print("Coverage for source: " + str(tmp[0]) + "\n")
    
    for block in lcov:
        sloc = block[0]
        eloc = block[1]
        count = block[2]
        reason = block[3]
        lines = fetch_source(sloc, eloc)

        print '{:>12} {:<14} {}'.format(count, reason, lines[0])
        for l in lines[1:]:
            print '                            ' + l

