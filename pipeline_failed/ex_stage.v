module ex_stage(
	input [3:0]ALUctl_ex_i,
	input beq_ex_i,
	input bne_ex_i,
	input blt_ex_i,
	input bge_ex_i,
	input bltu_ex_i,
	input bgeu_ex_i,
	input jal_ex_i,
	input jalr_ex_i,
	input ALUSrc_ex_i,
	input [31:0]pc_ex_i,
	input [31:0]imme_ex_i,
	input [31:0]Rd_data1_ex_i,
	input [31:0]Rd_data2_ex_i,
	output [31:0]ALU_result_ex_o,
	output [31:0]pc_new_ex_o,
	output [31:0]pc_jump_o,
	//output [31:0]Rd_data2_ex_o,
	output [31:0]imme_ex_o,
	output [31:0]pc_order_ex_o
    );

	wire [31:0]ALU_DB;
	wire zero;
	wire ALU_result_sig;
	wire jump_flag;
	wire [31:0]pc_order;
	wire [31:0]pc_jump_order;
	wire [31:0]pc_jalr;
	
	
	assign pc_jalr={ALU_result_ex_o[31:1],1'b0};
	assign ALU_result_sig=ALU_result_ex_o[31];
	assign imme_ex_o=imme_ex_i;
	assign pc_order_ex_o=pc_order;
	
	alu alu_inst (
    .ALU_DA(Rd_data1_ex_i), 
    .ALU_DB(ALU_DB), 
    .ALU_CTL(ALUctl_ex_i), 
    .ALU_ZERO(zero), 
    .ALU_OverFlow(), 
    .ALU_DC(ALU_result_ex_o)
    );

	branch_judge branch_judge_inst (
    .beq(beq_ex_i), 
    .bne(bne_ex_i), 
    .blt(blt_ex_i), 
    .bge(bge_ex_i), 
    .bltu(bltu_ex_i), 
    .bgeu(bgeu_ex_i), 
    .jal(jal_ex_i), 
    .jalr(jalr_ex_i), 
    .zero(zero), 
    .ALU_result_sig(ALU_result_sig), 
    .jump_flag(jump_flag)
    );

///pc+4	
	cla_adder32 pc_adder_4 (
    .A(pc_ex_i), 
    .B(32'd4), 
    .cin(1'd0), 
    .result(pc_order), 
    .cout()
    );
	
///pc+imme
	cla_adder32 pc_adder_imme (
    .A(pc_ex_i), 
    .B(imme_ex_i), 
    .cin(1'd0), 
    .result(pc_jump_o), 
    .cout()
    );

///pc_sel
	mux pc_mux (
    .data1(pc_jump_o), 
    .data2(pc_order), 
    .sel(jump_flag), 
    .dout(pc_jump_order)
    );
///pc_jalr
	mux pc_jalr_mux (
    .data1(pc_jalr), 
    .data2(pc_jump_order), 
    .sel(jalr_ex_i), 
    .dout(pc_new_ex_o)
    );

///ALUdata_sel	
	mux ALU_data_mux (
    .data1(imme_ex_i), 
    .data2(Rd_data2_ex_i), 
    .sel(ALUSrc_ex_i), 
    .dout(ALU_DB)
    );
	
	
	
endmodule


