
//寄存器组的工作方式

`include "define.v"
//`define INITIAL
module registers(
	clk,
	rst_n,        //给寄存器复位0
	W_en,
	Rs1,
	Rs2,
	Rd,
	Wr_data,
	Rd_data1,              //源寄存器1的数据
	Rd_data2
    );
	input clk;
	input rst_n;
	input W_en;
	input [4:0]Rs1;                  //源寄存器1的地址
	input [4:0]Rs2;
	input [4:0]Rd;                    //目的寄存器的地址
	input [31:0]Wr_data;
	
	output [31:0]Rd_data1;          //源寄存器1的数据
	output [31:0]Rd_data2;
	
	reg [31:0] regs [31:0];          //32个32位寄存器，寄存器组
	
	
//write
`ifdef INITIAL
	always@(posedge clk )
		begin
			if(W_en & (Rd!=0))
			regs[Rd]<=Wr_data;	
		end
`else		
	always@(posedge clk )
		begin
			if(!rst_n)
				begin
					regs[0]<=`zero_word;
					regs[1]<=`zero_word;
					regs[2]<=`zero_word;
					regs[3]<=`zero_word;
					regs[4]<=`zero_word;
					regs[5]<=`zero_word;
					regs[6]<=`zero_word;
					regs[7]<=`zero_word;
					regs[8]<=`zero_word;
					regs[9]<=`zero_word;
					regs[10]<=`zero_word;
					regs[11]<=`zero_word;
					regs[12]<=`zero_word;
					regs[13]<=`zero_word;
					regs[14]<=`zero_word;
					regs[15]<=`zero_word;
					regs[16]<=`zero_word;
					regs[17]<=`zero_word;
					regs[18]<=`zero_word;
					regs[19]<=`zero_word;
					regs[20]<=`zero_word;
					regs[21]<=`zero_word;
					regs[22]<=`zero_word;
					regs[23]<=`zero_word;
					regs[24]<=`zero_word;
					regs[25]<=`zero_word;
					regs[26]<=`zero_word;
					regs[27]<=`zero_word;
					regs[28]<=`zero_word;
					regs[29]<=`zero_word;
					regs[30]<=`zero_word;
					regs[31]<=`zero_word;
				end
			else if(W_en & (Rd!=0))         //如果写使能了，目标寄存器地址也有了
			regs[Rd]<=Wr_data;	//将读入的数据Wr_data写入Rd内地址对应的寄存器
		
		end
`endif	

		
//read

	assign Rd_data1=(Rs1==5'd0)?`zero_word: regs[Rs1];         //源寄存器1的数据，如果源寄存器1地址有了那么把数据拿来，如果地址没有赋0
	assign Rd_data2=(Rs2==5'd0)?`zero_word: regs[Rs2];
	
endmodule

