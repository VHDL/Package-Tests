#! /usr/bin/wish
package require sqlite3


set oh [open "./merge_log.txt" "w"]
set tdb "merged.db"
#  get coverage info
sqlite3 mcov $tdb
#set mcov_lines [mcov eval {select coverageCount from lineCoverages}]
set fidxs [mcov eval {select id from sourceFiles}]
#set fnams [mcov eval {select fileName from sourcFiles}]
foreach i $fidxs {
    set tot_lines 0
    set cov_lines 0
    set ifnam [mcov eval {select fileName from sourceFiles where id = $i}]
    set 
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
        puts double($tot_lines)
        set percent [expr {double($cov_lines) / double($tot_lines) * 100}]
        puts $oh "Percent covered:  $percent %"
    }

}
mcov close
close $oh
