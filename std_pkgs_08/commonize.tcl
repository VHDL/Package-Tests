#! /usr/bin/tclsh


set tdirs [glob -type d *]

foreach t $tdirs {
    ##  edit  test.vhdl
    set tx [file exist "$t/test.vhdl"]
    if {$tx == 1} {
        set th [open "$t/test.vhdl" "r"]
        set tlst {}
        while {![eof $th]} {
            lappend tlst [gets $th]
        }
        close $th
    }  else {
        puts "Test not found in $t"
    }
    set nlst {}
    if {$tlst != {}} {
        foreach l $tlst {
            set is_ent [string first "entity" $l]
            set is_arc [string first "architecture" $l]
            if {$is_ent >= 0} {
                set is_def [string first "is" $l]
                if {$is_def >= 0} {
                    set sl [split $l]
                    set sl [lreplace $sl 1 1 "test"]
                    set l ""
                    foreach s $sl {
                        append l $s " "
                    }
                } 
            }
            if {$is_arc >= 0} {
                set sl [split $l]
                set sl [lreplace $sl 3 3 "test"]
                set l ""
                foreach s $sl {
                    append l $s " "
                } 
            }
            set nlst [lappend nlst $l]
        }
    }
    set oh [open "$t/test.vhdl" "w"]
    
    foreach l $nlst {
        puts $oh $l
    }
    close $oh
    
    ## edit std_test.vhdl
    set tx [file exist "$t/std_test.vhdl"]
    if {$tx == 1} {
        set th [open "$t/std_test.vhdl" "r"]
        set tlst {}
        while {![eof $th]} {
            lappend tlst [gets $th]
        }
        close $th
    }  else {
        puts "Test not found in $t"
    }
    set nlst {}
    if {$tlst != {}} {
        foreach l $tlst {
            set is_ent [string first "entity" $l]
            set is_arc [string first "architecture" $l]
            if {$is_ent >= 0} {
                set is_def [string first "is" $l]
                if {$is_def >= 0} {
                    set sl [split $l]
                    set sl [lreplace $sl 1 1 "test"]
                    set l ""
                    foreach s $sl {
                        append l $s " "
                    }
                } 
            }
            if {$is_arc >= 0} {
                set sl [split $l]
                set sl [lreplace $sl 3 3 "test"]
                set l ""
                foreach s $sl {
                    append l $s " "
                } 
            }
            set nlst [lappend nlst $l]
        }
    }
    set oh [open "$t/std_test.vhdl" "w"]
    
    foreach l $nlst {
        puts $oh $l
    }
    close $oh
    
}
