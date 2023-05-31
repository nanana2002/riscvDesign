//pc_reg的作用是，把pc_new告诉他
//然后他在时钟下降沿，把pc_new通过pc_out输出


`include "define.v"
module pc_reg(
	clk,
	rst_n,
	pc_new,   //下一个时钟周期的pc值
	pc_out    //更新后的pc值
    );
	input clk;
	input rst_n;
	input [31:0]pc_new;
	
	output reg [31:0]pc_out;
	
	always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			pc_out<=`zero_word;        //这个在宏定义里
		else
			pc_out<=pc_new;
	end	
endmodule



