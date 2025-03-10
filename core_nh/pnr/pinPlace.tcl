# Pin Placement 

# mem_in clk inst reset
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.1 -pinDepth 0.6 -fixedPin 1 -fixOverlap 1 -unit MICRON -spreadDirection counterclockwise -side Left -layer 3 -spreadType center -spacing 2 -pin {{mem_in[*]} {clk} {inst[*]} {reset}}
setPinAssignMode -pinEditInBatch false

# Sum Out Out Pins
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.1 -pinDepth 0.6 -fixedPin 1 -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Bottom -layer 3 -spreadType center -spacing 1 -pin {{out[*]} {sum_out[*]}}
setPinAssignMode -pinEditInBatch false

# Legalizing
legalizePin

# Saving the design 
saveDesign pinPlaced.enc
