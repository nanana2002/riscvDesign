
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
	wire MemWrite;            //流水线后增加的3个信号
	wire MemRead;
	wire [2:0]RW_type_id;
	
//控制器
	control control_inst (
    .opcode(opcode), 
    .func3(func3), 
    .func7(func7), 
   // .MemRead(R_en),   R_en和W_en和RW_type不再是从控制器里出来的了
  //  .MemWrite(W_en), 
  //.RW_type(RW_type), 

    .MemRead(MemRead), //流水线加的3个MemRead、MemWrite、RW_type_id
    .MemWrite(MemWrite), 
    .RW_type(RW_type_id), 

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
    //流水线新增
    .MemRead(MemRead), 
    .MemWrite(MemWrite), 
    .RW_type(RW_type_id), 
	.MemRead_ex_mem_o(R_en), //output control，control模块失去的三个信号
    .MemWrite_ex_mem_o(W_en), //output control
    .RW_type_ex_mem_o(RW_type), //output control
    .loaddata(Rd_mem_data), 
  //  .Rd_mem_data(Rd_mem_data), 原作没写
    .rom_addr(rom_addr), 
    .Wr_mem_data(Wr_mem_data),
	.ALU_result_ex_mem_o(ram_addr),
	.opcode(opcode),
	.func3(func3),
	.func7(func7)
    );

endmodule
