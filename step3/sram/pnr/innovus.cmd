#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Fri Mar 21 21:52:16 2025                
#                                                     
#######################################################

#@(#)CDS: Innovus v15.23-s045_1 (64bit) 04/22/2016 12:32 (Linux 2.6.18-194.el5)
#@(#)CDS: NanoRoute 15.23-s045_1 NR160414-1105/15_23-UB (database version 2.30, 317.6.1) {superthreading v1.26}
#@(#)CDS: AAE 15.23-s014 (64bit) 04/22/2016 (Linux 2.6.18-194.el5)
#@(#)CDS: CTE 15.23-s022_1 () Apr 22 2016 09:38:45 ( )
#@(#)CDS: SYNTECH 15.23-s008_1 () Apr 12 2016 21:52:59 ( )
#@(#)CDS: CPE v15.23-s045
#@(#)CDS: IQRC/TQRC 15.1.4-s213 (64bit) Tue Feb  9 17:31:28 PST 2016 (Linux 2.6.18-194.el5)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
getDrawView
loadWorkspace -name Physical
win
floorPlan -site core -r 1 0.95 1.0 1.0 1.0 1.0
set init_pwr_net VDD
set init_gnd_net VSS
set init_verilog ./netlist/sram_w16.v
set init_design_netlisttype Verilog
set init_design_settop 1
set init_top_cell sram_w16
set init_lef_file /home/linux/ieng6/ee260bwi25/public/PDKdata/lef/tcbn65gplus_8lmT2.lef
create_library_set -name WC_LIB -timing $worst_timing_lib
create_library_set -name BC_LIB -timing $best_timing_lib
create_rc_corner -name Cmax -cap_table $worst_captbl -T 125
create_rc_corner -name Cmin -cap_table $best_captbl -T -40
create_delay_corner -name WC -library_set WC_LIB -rc_corner Cmax
create_delay_corner -name BC -library_set BC_LIB -rc_corner Cmin
create_constraint_mode -name CON -sdc_file [list $sdc]
create_analysis_view -name WC_VIEW -delay_corner WC -constraint_mode CON
create_analysis_view -name BC_VIEW -delay_corner BC -constraint_mode CON
init_design -setup WC_VIEW -hold BC_VIEW
set_interactive_constraint_modes {CON}
setDesignMode -process 65
floorPlan -site core -r 1 0.95 1.0 1.0 1.0 1.0
globalNetConnect VDD -type pgpin -pin VDD -inst * -verbose
globalNetConnect VSS -type pgpin -pin VSS -inst * -verbose
setAddStripeMode -break_at block_ring
addStripe -nets {VDD VSS} -layer M4 -width 1 -spacing 1 -number_of_sets 2 -start_from left -start 5 -stop 115
sroute
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.1 -pinDepth 0.6 -fixedPin True -fixOverlap 1 -unit MICRON -spreadDirection counterclockwise -side Bottom -layer 2 -spreadType start -spacing 0.8 -pin {{D[*]}} -start 10.00 100.0
setPinAssignMode -pinEditInBatch false
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.1 -pinDepth 0.6 -fixedPin True -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Top -layer 2 -spreadType start -spacing 0.8 -pin {{Q[*]}} -start 10.00 100.0
setPinAssignMode -pinEditInBatch false
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.1 -pinDepth 0.6 -fixedPin 1 -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Left -layer 3 -spreadType center -spacing 4.0 -pin {{CLK} {A[*]} {CEN} {WEN}}
setPinAssignMode -pinEditInBatch false
legalizePin
checkPinAssignment
saveDesign pinPlaced.enc
zoomBox -4.299 127.959 111.041 96.018
zoomBox 103.972 124.523 121.815 110.248
zoomBox 111.249 116.569 116.172 112.559
zoomBox -14.171 134.262 148.492 -11.335
setMaxRouteLayer 4
saveDesign floorplan.enc
setPlaceMode -timingDriven true -reorderScan false -congEffort medium -modulePlan false
setOptMode -effort high -powerEffort high -leakageToDynamicRatio 0.5 -fixFanoutLoad true -restruct true -verbose true
place_opt_design
saveDesign placement.enc
set_ccopt_property -update_io_latency false
create_ccopt_clock_tree_spec -file constraints/sram_w16.ccopt
ccopt_design
set_propagated_clock [all_clocks]
optDesign -postCTS -hold
saveDesign cts.enc
setNanoRouteMode -quiet -drouteAllowMergedWireAtPin false
setNanoRouteMode -quiet -drouteFixAntenna true
setNanoRouteMode -quiet -routeWithTimingDriven true
setNanoRouteMode -quiet -routeWithSiDriven true
setNanoRouteMode -quiet -routeSiEffort medium
setNanoRouteMode -quiet -routeWithSiPostRouteFix false
setNanoRouteMode -quiet -drouteAutoStop true
setNanoRouteMode -quiet -routeSelectedNetOnly false
setNanoRouteMode -quiet -drouteStartIteration default
routeDesign
setExtractRCMode -engine postRoute
extractRC
setAnalysisMode -analysisType onChipVariation -cppr both
optDesign -postRoute -setup -hold
optDesign -postRoute -drv
optDesign -postRoute -inc
saveDesign route.enc
verifyGeometry
addFiller -cell {DCAP DCAP4 DCAP16 DCAP32 DCAP64} -prefix FILLER_
saveDesign filler.enc
verifyConnectivity
zoomBox 111.275 9.358 118.937 -0.931
zoomBox 118.882 -0.295 118.897 -0.341
zoomBox -21.326 123.451 136.062 -21.689
streamOut sram_w16.gds2
write_lef_abstract -stripePin -PGPinLayers 4 -extractBlockPGPinLayers 4 sram_w16.lef -specifyTopLayer 4
defOut -netlist -routing sram_w16.def
saveNetlist sram_w16.pnr.v
setAnalysisMode -setup
set_analysis_view -setup WC_VIEW -hold WC_VIEW
do_extract_model -view WC_VIEW -format dotlib ${design}_WC.lib
write_sdf -view WC_VIEW ${design}_WC.sdf
setAnalysisMode -hold
set_analysis_view -setup BC_VIEW -hold BC_VIEW
do_extract_model -view BC_VIEW -format dotlib ${design}_BC.lib
write_sdf -view BC_VIEW ${design}_BC.sdf
verifyGeometry
verifyConnectivity
report_timing -max_paths 5 > ${design}.post_route.timing.rpt
report_power -outfile sram_w16.post_route.power.rpt
summaryReport -nohtml -outfile sram_w16.post_route.summary.rpt
