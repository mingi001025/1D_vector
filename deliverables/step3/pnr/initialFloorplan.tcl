# Floorplan
floorPlan -site core -s 440 600 10.0 10.0 10.0 10.0

globalNetConnect VDD -type pgpin -pin VDD -inst * -verbose
globalNetConnect VSS -type pgpin -pin VSS -inst * -verbose

addRing -spacing {top 1 bottom 1 left 1 right 1} -width {top 2 bottom 2 left 2 right 2}  -layer {top M1 bottom M1 left M2 right M2} -center 1 -type core_rings -nets {VSS  VDD}

setAddStripeMode -break_at {block_ring}

### Note: Change the number of strip  by looking at the layout #########
#addStripe [fill out]
addStripe -number_of_sets 3  -spacing 1 -layer M5 -direction horizontal -width 1 -nets { VSS VDD } -start 100 -stop 460
#################################################

setObjFPlanBox Instance qmem_instance 50.0 220.0 170.0 340.0
setObjFPlanBox Instance kmem_instance 270.0 220.0 390.0 340.0
setObjFPlanBox Instance psum_mem_instance 160.0 40.0 280.0 160.0

#flipOrRotateObject -rotate R90 -name qmem_instance 
#flipOrRotateObject -flip MY -name qmem_instance 

addHaloToBlock {3 3 3 3} qmem_instance
addHaloToBlock {3 3 3 3} kmem_instance
addHaloToBlock {3 3 3 3} psum_mem_instance

addRing -nets {VDD VSS} -type block_rings -around each_block -layer {top M1 bottom M1 left M2 right M2} -width {top 0.5 bottom 0.5 left 0.5 right 0.5} -spacing {top 0.5 bottom 0.5 left 0.5 right 0.5} 


globalNetConnect VDD -type pgpin -pin VDD -sinst add_instance0 -verbose -override
globalNetConnect VSS -type pgpin -pin VSS -sinst add_instance1 -verbose -override        


sroute 


