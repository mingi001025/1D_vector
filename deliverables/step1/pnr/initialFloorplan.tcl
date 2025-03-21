# Floorplan
floorPlan -site core -r 1 0.60 10.0 10.0 10.0 10.0

globalNetConnect VDD -type pgpin -pin VDD -inst * -verbose
globalNetConnect VSS -type pgpin -pin VSS -inst * -verbose

# Note, power ring is not used for the sub-module in hierarchical syn & pnr
addRing -spacing {top 2 bottom 2 left 2 right 2} -width {top 3 bottom 3 left 3 right 3} -layer {top M1 bottom M1 left M2 right M2} -center 1 -type core_rings -nets {VSS VDD} 

setAddStripeMode -break_at {block_ring}

### Note: Change the number of strip  by looking at the layout #########
# addStripe -number_of_sets 2  -spacing 1 -layer M4 -width 1 -nets { VSS VDD }
#################################################

addStripe -nets {VDD VSS} -layer M4 -direction vertical -width 2 -spacing 6 -number_of_sets 22

sroute


