# Pin Placement 

# D Pins
setPinAssignMode -pinEditInBatch true
#editPin -pinWidth 0.1 -pinDepth 0.6 -fixedPin 1 -fixOverlap 1 -unit MICRON -spreadDirection counterclockwise -side Bottom -layer 3 -spreadType center -spacing 2.0 -pin {{D[*]}}
editPin -pinWidth 0.1 -pinDepth 0.6 -fixedPin True -fixOverlap 1 -unit MICRON -spreadDirection counterclockwise -side Bottom -layer 2 -spreadType start -spacing 0.8 -pin {{D[*]}} -start 10.00 100.0
setPinAssignMode -pinEditInBatch false

# Q Pins
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.1 -pinDepth 0.6 -fixedPin True -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Top -layer 2 -spreadType start -spacing 0.8 -pin {{Q[*]}} -start 10.00 100.0
setPinAssignMode -pinEditInBatch false

# CLK, A, CEN, WEN Pins
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.1 -pinDepth 0.6 -fixedPin 1 -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Left -layer 3 -spreadType center -spacing 4.0 -pin {{CLK} {A[*]} {CEN} {WEN}}
setPinAssignMode -pinEditInBatch false

# Legalizing
legalizePin
checkPinAssignment

# Saving the design 
saveDesign pinPlaced.enc
