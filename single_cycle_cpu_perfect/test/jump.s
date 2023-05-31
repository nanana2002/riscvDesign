addi x1,x0,1
addi x2,x0,2
jal x31,label1
addi x3,x0,3
label1:
addi x4,x0,4
add x5,x2,x2
beq x4,x5,label2
addi x6,x0,6
label2:
bne x4,x5,label3
addi x7,x0,7
label3:
bne x7,x6,label4
addi x8,x0,8
label4:
addi x9,x0,0x30
jalr x10,x9,12
addi x11,x0,11
addi x12,x0,-12
addi x13,x0,-13
blt x13,x12,label5
addi x14,x0,-14
label5:
bltu x13,x12,label6
addi x15,x0,-15
label6:
bltu x12,x13,label7
addi x16,x0,-16
label7:
bge x12,x13,label8
addi x17,x0,-17
label8:
bge x1,x2,label9
addi x18,x0,-18
label9:
bgeu x12,x13,label10
addi x19,x0,-19
label10:
bgeu x13,x12,label11
addi x20,x0,-20
label11:
addi x21,x0,-20
addi x22,x0,-20
bge x21,x22,label12
addi x23,x0,-23
label12:
addi x24,x0,-24