addi x1,x0,0xff
addi x2,x0,4
sll x3,x1,x2
srl x4,x1,x2
sra x5,x1,x2

addi x6,x0,-0xff
sll x7,x6,x2
srl x8,x6,x2
sra x9,x6,x2

slli x11,x1,4
srli x12,x1,4
srai x13,x1,4

slli x11,x6,4
srli x12,x6,4
srai x13,x6,4
