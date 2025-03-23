# inst, mem_in Pins
setPinAssignMode -pinEditInBatch true
#editPin -pinWidth 0.1 -pinDepth 0.6 -fixedPin True -fixOverlap 1 -unit MICRON -spreadDirection counterclockwise -side left -layer 2 -spreadType start -spacing 0.8 -pin {{D[*]}} -start 5.00 100.0
editPin -pinWidth 0.1 -pinDepth 0.6 -fixedPin True -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side top -layer 2 -spreadType start -spacing 4.0 -pin {{inst[*]} {mem_in[*]}} -start 70.00 500.0
setPinAssignMode -pinEditInBatch false

# out Pins
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.1 -pinDepth 0.6 -fixedPin True -fixOverlap 1 -unit MICRON -spreadDirection counterclockwise -side right -layer 3 -spreadType center -spacing 3.0 -pin {{out[*]}}
setPinAssignMode -pinEditInBatch false

# sum_out Pins
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.1 -pinDepth 0.6 -fixedPin True -fixOverlap 1 -unit MICRON -spreadDirection counterclockwise -side bottom -layer 2 -spreadType start -spacing 2.5 -pin {{sum_out[*]}} -start 20.00 580.0
setPinAssignMode -pinEditInBatch false

# clk, reset pins
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.1 -pinDepth 0.6 -fixedPin 1 -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side left -layer 3 -spreadType center -spacing 4.0 -pin {{clk} {reset}}
setPinAssignMode -pinEditInBatch false

# Legalizing
legalizePin
checkPinAssignment
