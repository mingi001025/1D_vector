#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Sat Mar 22 00:01:24 2025                
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
set init_pwr_net VDD
set init_gnd_net VSS
set init_verilog ./netlist/core.v
set init_design_netlisttype Verilog
set init_design_settop 1
set init_top_cell core
set init_lef_file {/home/linux/ieng6/ee260bwi25/public/PDKdata/lef/tcbn65gplus_8lmT2.lef ./subckt/sram_w16.lef}
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
floorPlan -site core -s 440 600 10.0 10.0 10.0 10.0
globalNetConnect VDD -type pgpin -pin VDD -inst * -verbose
globalNetConnect VSS -type pgpin -pin VSS -inst * -verbose
addRing -spacing {top 1 bottom 1 left 1 right 1} -width {top 2 bottom 2 left 2 right 2} -layer {top M1 bottom M1 left M2 right M2} -center 1 -type core_rings -nets {VSS  VDD}
setAddStripeMode -break_at block_ring
addStripe -number_of_sets 3 -spacing 1 -layer M5 -direction horizontal -width 1 -nets { VSS VDD } -start 100 -stop 460
setObjFPlanBox Instance qmem_instance 50.0 220.0 170.0 340.0
setObjFPlanBox Instance kmem_instance 270.0 220.0 390.0 340.0
setObjFPlanBox Instance psum_mem_instance 160.0 40.0 280.0 160.0
addHaloToBlock {3 3 3 3} qmem_instance
addHaloToBlock {3 3 3 3} kmem_instance
addHaloToBlock {3 3 3 3} psum_mem_instance
addRing -nets {VDD VSS} -type block_rings -around each_block -layer {top M1 bottom M1 left M2 right M2} -width {top 0.5 bottom 0.5 left 0.5 right 0.5} -spacing {top 0.5 bottom 0.5 left 0.5 right 0.5}
globalNetConnect VDD -type pgpin -pin VDD -sinst add_instance0 -verbose -override
globalNetConnect VSS -type pgpin -pin VSS -sinst add_instance1 -verbose -override
sroute
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.1 -pinDepth 0.6 -fixedPin True -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side top -layer 2 -spreadType start -spacing 4.0 -pin {{inst[*]} {mem_in[*]}} -start 70.00 500.0
setPinAssignMode -pinEditInBatch false
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.1 -pinDepth 0.6 -fixedPin True -fixOverlap 1 -unit MICRON -spreadDirection counterclockwise -side right -layer 3 -spreadType center -spacing 3.0 -pin {{out[*]}}
setPinAssignMode -pinEditInBatch false
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.1 -pinDepth 0.6 -fixedPin True -fixOverlap 1 -unit MICRON -spreadDirection counterclockwise -side bottom -layer 2 -spreadType start -spacing 2.5 -pin {{sum_out[*]}} -start 20.00 580.0
setPinAssignMode -pinEditInBatch false
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.1 -pinDepth 0.6 -fixedPin 1 -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side left -layer 3 -spreadType center -spacing 4.0 -pin {{clk} {reset}}
setPinAssignMode -pinEditInBatch false
legalizePin
checkPinAssignment
saveDesign floorplan.enc
setMaxRouteLayer 4
setPlaceMode -timingDriven true -reorderScan false -congEffort medium -modulePlan True -placeIOPins false
setOptMode -effort high -powerEffort high -leakageToDynamicRatio 0.5 -fixFanoutLoad true -restruct true -verbose true
place_opt_design
saveDesign placement.enc
gui_select -rect {-428.239 403.810 928.436 420.305}
set_ccopt_property -update_io_latency false
create_ccopt_clock_tree_spec -file ./constraints/core.ccopt
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
optDesign -postRoute -drv
optDesign -postRoute -inc
verifyGeometry
zoomBox 142.884 515.149 212.986 475.975
zoomBox 187.512 493.487 191.757 490.279
zoomBox 188.695 492.209 190.048 490.992
optDesign -postRoute -drv
optDesign -postRoute -inc
verifyGeometry
fit
zoomBox 173.334 498.553 198.407 484.512
zoomBox 187.980 492.545 190.477 490.824
zoomBox 188.739 492.007 189.590 491.345
fit
saveDesign route.enc
streamOut core.gds2 -merge ./subckt/add.gds2
streamOut core.gds2 -merge ./subckt/sram_w16.gds2
write_lef_abstract core.lef
defOut -netlist -routing core.def
saveNetlist core.pnr.v
setAnalysisMode -setup
set_analysis_view -setup WC_VIEW -hold WC_VIEW
do_extract_model -view WC_VIEW -format dotlib ${design}_WC.lib
write_sdf -view WC_VIEW ${design}_WC.sdf
setAnalysisMode -hold
set_analysis_view -setup BC_VIEW -hold BC_VIEW
do_extract_model -view BC_VIEW -format dotlib ${design}_BC.lib
write_sdf -view BC_VIEW ${design}_BC.sdf
addFiller -cell {DCAP DCAP4 DCAP16 DCAP32 DCAP64} -prefix FILLER_
verifyGeometry
ecoRoute -help
ecoRoute
verifyGeometry
zoomBox 170.325 509.586 207.434 473.480
zoomBox 187.898 493.604 190.870 489.940
zoomBox 188.729 492.112 189.591 491.228
zoomBox -2.108 626.225 73.236 563.099
streamOut core.gds2 -merge ./subckt/sram_w16.gds2
streamOut core.gds2 -merge ./subckt/sram_w16.gds2
write_lef_abstract core.lef
defOut -netlist -routing core.def
saveNetlist core.pnr.v
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
report_power -outfile core.post_route.power.rpt
summaryReport -nohtml -outfile core.post_route.summary.rpt
saveDesign route.enc4
