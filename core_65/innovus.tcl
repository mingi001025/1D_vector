set start_time [clock seconds]

source loadDesignTech.tcl
source initialFloorplan.tcl
source pinPlace.tcl
source placement.tcl
source clock.tcl
source route.tcl
source reportDesign.tcl
source outputGen.tcl

set end_time [clock seconds] 

set duration [expr {$end_time - $start_time}]
set hours [expr {$duration/3600} ]
set mins [expr {($duration%3600)/60}]
set sec [expr{($duration%60)}] 

puts {"Duration: [format %02d:%02d:%02d"] $hours $mins $sec }
