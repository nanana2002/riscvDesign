
module riscv(
	input clk,
	input rst_n,
	input [31:0]instr,
	input [31:0]Rd_mem_data,
	
	output [7:0]rom_addr,
	
	output [31:0]Wr_mem_data,
	output W_en,
	output R_en,
	output [31:0]ram_addr,
	output [2:0]RW_type
    );
	
	wire [6:0]opcode;
	wire [2:0]func3;
	wire func7;
	wire MemtoReg;
	wire ALUSrc;
	wire RegWrite;
	wire lui;
	wire U_type;
	wire jal;
	wire jalr;
	wire beq;
	wire bne;
	wire blt;
	wire bge;
	wire bltu;
	wire bgeu;
	wire [3:0]ALUctl;
	
	
//控制器
	control control_inst (
    .opcode(opcode), 
    .func3(func3), 
    .func7(func7), 
    .MemRead(R_en), 
    .MemtoReg(MemtoReg), 
    .MemWrite(W_en), 
    .ALUSrc(ALUSrc), 
    .RegWrite(RegWrite), 
	.lui(lui),
	.U_type(U_type),
    .jal(jal), 
    .jalr(jalr), 
    .beq(beq), 
    .bne(bne), 
    .blt(blt), 
    .bge(bge), 
    .bltu(bltu), 
    .bgeu(bgeu), 
    .RW_type(RW_type), 
    .ALUctl(ALUctl)
    );

//数据选择器

	datapath datapath_inst (
    .clk(clk), 
    .rst_n(rst_n), 
    .instr(instr), 
    .MemtoReg(MemtoReg), 
    .ALUSrc(ALUSrc), 
    .RegWrite(RegWrite), 
	.lui(lui),
	.U_type(U_type),
    .jal(jal), 
    .jalr(jalr), 
    .beq(beq), 
    .bne(bne), 
    .blt(blt), 
    .bge(bge), 
    .bltu(bltu), 
    .bgeu(bgeu), 
    .ALUctl(ALUctl), 
    .Rd_mem_data(Rd_mem_data), 
    .rom_addr(rom_addr), 
    .Wr_mem_data(Wr_mem_data),
	.ALU_result(ram_addr),
	.opcode(opcode),
	.func3(func3),
	.func7(func7)
    );

endmodule
