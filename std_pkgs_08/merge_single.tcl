#! /usr/bin/wish

package require sqlite3
package require Tk
set oh [open "sdump.txt" "w"]

set f [lindex $argv 0]
set tdb "merged.db"

sqlite3 mdb $f
set fnames [mdb eval {select * from sourceFiles}]
puts $oh $fnames
set inames [mdb eval {select * from instanceCoverages}]
puts $oh $inames
#set lcov [mdb eval {select coverageCount from lineCoverages}]
set lid [mdb eval {select id from lineCoverages}]
sqlite3 mcov $tdb
set mcov_lines [mcov eval {select coverageCount from lineCoverages}]
#set idx 0
foreach i $lid {
    
    set lcov [mdb eval {select coverageCount from lineCoverages where id = $i}]
    #if {[lindex $mcov_lines $idx] == ""} {continue}
    set lidx [mdb eval {select id from lineCoverages where }]
    set prev [lindex $mcov_lines $cidx]
    set new_val [expr {int($prev) + int($l)}]
    set mcov_flines [mcov eval {select line from locations}]
    
    if {$l != "0"} {
        set sln [lindex $mcov_flines $idx]
        puts $oh "Prev: $prev  Added: $l  Sum:  $new_val  Line:  $sln"
    }
    
    mcov eval {update lineCoverages set coverageCount = $new_val where id = $cidx}
    incr idx
}
mdb close
mcov close

close $oh
exit
