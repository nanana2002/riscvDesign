//pc_if_o输入后叫做pc_if_id_i，
//pc_if_o其实就是pc_reg在得到pc_new的下一个时钟下降沿，把pc_new通过pc_out输出的值
//md写不下去了画图吧

`include "define.v"

module if_id_regs(
	input clk,
	input rst_n,
	input [31:0]pc_if_id_i,
	input [31:0]instr_if_id_i,
	output reg [31:0]pc_if_id_o,
	output reg [31:0]instr_if_id_o
    );

	always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			pc_if_id_o<=`zero_word;
		else
			pc_if_id_o<=pc_if_id_i;
	end
	
	always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			instr_if_id_o<=`zero_word;
		else
			instr_if_id_o<=instr_if_id_i;
	end

endmodule


