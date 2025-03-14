# Pin Placement 

# D Pins
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.1 -pinDepth 0.6 -fixedPin 1 -fixOverlap 1 -unit MICRON -spreadDirection counterclockwise -side Bottom -layer 3 -spreadType center -spacing 0.8 -pin {{D[*]}}
setPinAssignMode -pinEditInBatch false

# Q Pins
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.1 -pinDepth 0.6 -fixedPin 1 -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Top -layer 3 -spreadType center -spacing 0.8 -pin {{Q[*]}}
setPinAssignMode -pinEditInBatch false

# CLK, A, CEN, WEN Pins
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.1 -pinDepth 0.6 -fixedPin 1 -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Left -layer 3 -spreadType center -spacing 0.8 -pin {{CLK} {A[*]} {CEN} {WEN}}
setPinAssignMode -pinEditInBatch false




# Legalizing
legalizePin

# Saving the design 
saveDesign pinPlaced.enc
