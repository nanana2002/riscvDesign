//把pc_if_i输给pc_reg的pc_new
//pc_reg在下一个时钟下降沿，把pc_new通过pc_out输出，且起名为pc_if_o
//pc_if_o[9:2]为指令在指令寄存器里的地址，地址输出为rom_addr


module if_stage(
	input clk,
	input rst_n,
	input [31:0]pc_if_i,  
	output [31:0]pc_if_o,
	output [7:0]rom_addr

    );

	pc_reg pc_reg_inst (
    .clk(clk), 
    .rst_n(rst_n), 
    .pc_new(pc_if_i),      //下一个时钟周期的pc值
    .pc_out(pc_if_o)      //更新后的pc值
    );
	
	assign rom_addr=pc_if_o[9:2];    //指令在rom中的地址

endmodule


