module datapath(
	input 	clk,
	input   rst_n,
	input   [31:0]instr,            //指令寄存器读出的指令

	input   MemtoReg,         //写回寄存器的数据选择器控制信号
	input   ALUSrc,               //ALU的数据来源的数据选择器控制信号
	input   RegWrite,           //寄存器的写使能控制信号
	input   lui,                      //lui指令标志，写回寄存器的数据选择器的控制信号
	input   U_type,               //U-type指令标志，写回寄存器的数据选择器的控制信号
	input   jal,                      //jal指令标志，选择pc的数据选择器的控制信号，同时也是写回寄存器的数据选择器的控制信号
	input   jalr,                    //jalr指令标志，选择pc的数据选择器的控制信号，同时也是写回寄存器的数据选择器的控制信号
	input   beq,                   //beq指令标志，判断是否跳转的控制信号
	input   bne,
	input   blt,
	input   bge,
	input   bltu,
	input   bgeu,
	input   [3:0]ALUctl,        //ALU的控制信号，决定ALU进行什么运算
	
	input [31:0]Rd_mem_data,           //从数据存储器读出的数据，作为写回寄存器的数据来源之一
	output  [7:0]rom_addr,                //指令存储器的地址
	output [31:0]Wr_mem_data,       //数据存储器的写数据
	output [31:0]ALU_result,             //ALU的运算结果，作为数据存储器的读（写）地址
	output [6:0]opcode,                    //7位操作码
	output [2:0]func3,
	output func7
	
	
    );
	
	
	
	
	
	
	wire [4:0]Rs1;
	wire [4:0]Rs2;
	wire [4:0]Rd;
	wire [31:0]imme;
	
	wire [31:0] Wr_reg_data;
	wire [31:0] Rd_data1;
	wire [31:0] Rd_data2;
	
	wire zero;
	
	wire [31:0]pc_order;                   //pc如果不跳的话该是几
	wire [31:0]pc_jump;                    //pc跳了该是几
	
	wire   [31:0]pc_new;
	wire [31:0]pc_out;
	
	wire jump_flag;                   
	
	wire [31:0]ALU_DB;
	wire [31:0]WB_data;
	
	wire reg_sel;
	wire [31:0]Wr_reg_data1;
	wire [31:0]Wr_reg_data2;
	wire [31:0]pc_jump_order;
	wire [31:0]pc_jalr;
	
	
	assign reg_sel=jal | jalr ;
	assign Wr_mem_data=Rd_data2;
	assign rom_addr=pc_out[9:2];
	assign pc_jalr={ALU_result[31:1],1'b0};
	
	pc_reg pc_reg_inst (
    .clk(clk), 
    .rst_n(rst_n), 
    .pc_new(pc_new),                 //下一个时钟周期的pc值
    .pc_out(pc_out)                    //output	更新后的pc值
    );

	
	instr_decode instr_decode_inst (
    .instr(instr), 
    .opcode(opcode), 
    .func3(func3), 
    .func7(func7), 
    .Rs1(Rs1), 
    .Rs2(Rs2), 
    .Rd(Rd), 
    .imme(imme)
    );
	
    registers registers_inst (
    .clk(clk), 
    .rst_n(rst_n),
    .W_en(RegWrite), 
    .Rs1(Rs1), 
    .Rs2(Rs2), 
    .Rd(Rd), 
    .Wr_data(Wr_reg_data), 
    .Rd_data1(Rd_data1), 
    .Rd_data2(Rd_data2)
    );

	
	alu alu_inst (
    .ALU_DA(Rd_data1), 
    .ALU_DB(ALU_DB), 
    .ALU_CTL(ALUctl), 
    .ALU_ZERO(zero), 
    .ALU_OverFlow(), 
    .ALU_DC(ALU_result)
    );

	branch_judge branch_judge_inst (
    .beq(beq), 
    .bne(bne), 
    .blt(blt), 
    .bge(bge), 
    .bltu(bltu), 
    .bgeu(bgeu), 
    .jal(jal), 
    .jalr(jalr), 
    .zero(zero), 
    .ALU_result_sig(ALU_result[31]), 
    .jump_flag(jump_flag)
    );

	

	
//pc+4	
	cla_adder32 pc_adder_4 (
    .A(pc_out), 
    .B(32'd4), 
    .cin(1'd0), 
    .result(pc_order),      
    .cout()
    );
	
//pc+imme
	cla_adder32 pc_adder_imme (
    .A(pc_out), 
    .B(imme), 
    .cin(1'd0), 
    .result(pc_jump), 
    .cout()
    );
	

//pc_sel
	mux pc_mux (
    .data1(pc_jump), 
    .data2(pc_order), 
    .sel(jump_flag), 
    .dout(pc_jump_order)                 //jump_flag==pc_jump_order?pc_jump:pc_order
    );
 

//下面全是数据选择器
//pc_jalr
	mux pc_jalr_mux (
    .data1(pc_jalr), 
    .data2(pc_jump_order), 
    .sel(jalr), 
    .dout(pc_new)
    );

	
	
//ALUdata_sel	
	mux ALU_data_mux (
    .data1(imme), 
    .data2(Rd_data2), 
    .sel(ALUSrc), 
    .dout(ALU_DB)
    );
	
	
//ALU_result or datamem	
	mux WB_data_mux (
    .data1(Rd_mem_data), 
    .data2(ALU_result), 
    .sel(MemtoReg), 
    .dout(WB_data)
    );
	
	
//Wr_data_sel
	mux jalr_mux (
    .data1(pc_order), 
    .data2(WB_data), 
    .sel(reg_sel), 
    .dout(Wr_reg_data2)
    );
	
	mux lui_mux (
    .data1(imme), 
    .data2(pc_jump), 
    .sel(lui), 
    .dout(Wr_reg_data1)
    );
	
	mux Wr_reg_mux (
    .data1(Wr_reg_data1), 
    .data2(Wr_reg_data2), 
    .sel(U_type), 
    .dout(Wr_reg_data)
    );

endmodule

