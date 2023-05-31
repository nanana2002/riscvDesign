//定义指令代码
`define		zero_word		32'd0

`define		B_type			7'b1100011     //BEQ、BNE、BLT、BGE、BLTU、BGEU
`define		I_type			7'b0010011    //ADDI SLTI SLTIU XORI ORI ANDI SLLI SRLI SRAI 
`define		R_type			7'b0110011    //ADD SUB SLL SLT XOR SRL SRA OR AND

`define		lui			7'b0110111
`define		auipc			7'b0010111   //U_type两条指令操作码不同

`define		jal			7'b1101111
`define		jalr			7'b1100111   //J_type两条指令操作码不同

`define		load			7'b0000011   //LB、LH、LW、LBU、LHU
`define		store			7'b0100011   //SB、SH、SW

`define 	ADD  			4'b0001
`define 	SUB  			4'b0011
`define 	SLL  			4'b1100
`define 	SLT  			4'b1001
`define 	SLTU 			4'b1000
`define 	XOR  			4'b0110
`define 	SRL  			4'b1101
`define 	SRA  			4'b1110
`define 	OR   			4'b0101
`define 	AND  			4'b0100