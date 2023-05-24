#! /usr/bin/wish

package require sqlite3
package require Tk

####################################################################################
#  this proc merges the data bases found based on the
#    db named  */t1.db  from the entry wid base dir text.
#  line id's coverage numbers are added and written
#    to the target db "merged.db"  
proc merge_dbs {lst} {
    
    #set dirs $lst
    
    set oh [open "$db_shr/merge_log.txt" "w"]
    append db_shr "/dbs_dir/*.db"
    set db_flst [glob $db_shr]
    #set flst_len [llength $db_flst]
    #set prog_inc [expr {100 / $flst_len}]
    #set cov::cov_prog_var 0

    if {[file exist $tdb]} {
        file delete $tdb
    }
    # create a copy of the data base
    file copy -force [lindex $db_flst 0] $tdb
    puts $oh "Copy initial db from [lindex $db_flst 0]"
    sqlite3 head $tdb
    set db_flst [lrange $db_flst 1 end]
    #  for each of the db found
    foreach f $db_flst {
        puts $oh "Merge $f to the merged.db"
        set tc_vars::sim_lbl_txt $f
        if {$f == ""} {continue}
        sqlite3 mdb $f
        set fnames [mdb eval {select * from sourceFiles}]
        puts $oh $fnames
        set hnames [head eval {select * from sourceFiles}]
        puts $oh $hnames
        
        foreach {i f} $fnames {
            set nf 0
            foreach {j h} $hnames {
                if {$h == $f} {
                    set nf 1
                    break
                }
            }
            if {$nf == 0} {
                puts $oh "NOT found in merged: $i  $f "
                set insts [mdb eval {select * from instanceCoverages}]
                puts $oh "$insts"
            }
        }
        
        set inames [mdb eval {select * from instanceCoverages}]
        puts $oh $inames
        set lid [mdb eval {select id from lineCoverages}]
        sqlite3 mcov $tdb
        set mcov_lines [mcov eval {select coverageCount from lineCoverages}]
        set lcnt 0
        foreach l $lid {
            if {$l == ""} {continue}
            set lcov [mdb eval {select coverageCount from lineCoverages where id = $l}]
            if {$lcov == ""} {
                if {$cov::cov_dbg > 1} {
                    puts $oh "ID: $l  produced nul return from source";
                }
                continue
            }
            #puts $lcov
            set mlcov [mcov eval {select coverageCount from lineCoverages where id = $l}]
            if {$mlcov == ""} {
                if {$cov::cov_dbg > 1} {
                    puts $oh "ID: $l  produced nul return from dest";
                }
                continue
            }
            #puts $mlcov
            set new_val [expr {int($lcov) + int($mlcov)}]
            set sln [mcov eval {select line from locations where id = $l}]
            if {$cov::cov_dbg > 1} {
                puts $oh "Prev: $mlcov  Added: $lcov  Sum:  $new_val  Line:  $sln"
            }

            if {$new_val != $mlcov} {
                incr lcnt
                mcov eval {update lineCoverages set coverageCount = $new_val where id = $l}
            }
        }
        puts $oh "Total fields updated: $lcnt"
        mdb close
        mcov close
        incr cov::cov_prog_var $prog_inc
        update
    }
    incr cov::cov_prog_var $prog_inc
    update
    
    set cov::cov_prog_var 95
    #  get coverage info
    sqlite3 mcov $tdb
    #set mcov_lines [mcov eval {select coverageCount from lineCoverages}]
    set fidxs [mcov eval {select id from sourceFiles}]
    #set fnams [mcov eval {select fileName from sourcFiles}]
    foreach i $fidxs {
        set tot_lines 0
        set cov_lines 0
        set ifnam [mcov eval {select fileName from sourceFiles where id = $i}]
        set mcov_lines [mcov eval {select coverageCount from lineCoverages where parentInstanceId = $i}]
        puts $oh "File coverage for:  $ifnam"
        foreach cl $mcov_lines {
            #puts $cl
            if {$cl == ""} {continue}
            if {$cl != "0"} {incr cov_lines; incr tot_lines} else {incr tot_lines}
        }
        puts $oh "Total lines to cover:  $tot_lines"
        puts $oh "Total lines Covered :  $cov_lines"
        if {$tot_lines > "0"} {
            #puts double($tot_lines)
            set percent [expr {double($cov_lines) / double($tot_lines) * 100}]
            puts $oh "Percent covered:  [string range $percent 0 6] %"
        }
    }
    set cov::cov_prog_var 100
    mcov close
}
set oh [open "dump.txt" "w"]


merge_dbs
close $oh

exit
