
//译码模块

`include "define.v"
module instr_decode(
	input [31:0]instr,                 //32位指令
	output [6:0]opcode,            //7位操作码
	output [2:0]func3,              
	output func7,                       //func7的第6位
	output [4:0]Rs1,
	output [4:0]Rs2,
	output [4:0]Rd,
	output [31:0]imme
	 );
	 
	wire I_type;
	wire U_type;
	wire J_type;
	wire B_type;
	wire S_type;
	
	wire [31:0]I_imme;
	wire [31:0]U_imme;
	wire [31:0]J_imme;
	wire [31:0]B_imme;
	wire [31:0]S_imme;
	
	
	assign opcode=instr[6:0];                     //先从32位指令中提取出7位opcode
	assign func3=instr[14:12];                    //RISB
	assign func7=instr[30];                         //R
	assign Rs1=instr[19:15];                        //RISB
	assign Rs2=instr[24:20];                       //RSB
	assign Rd =instr[11:7];                          //RIUJ
	
	assign I_type=(instr[6:0]==`jalr) | (instr[6:0]==`load) | (instr[6:0]==`I_type);
	assign U_type=(instr[6:0]==`lui) | (instr[6:0]==`auipc);
	assign J_type=(instr[6:0]==`jal);
	assign B_type=(instr[6:0]==`B_type);
	assign S_type=(instr[6:0]==`store);
	
	
	assign I_imme={{20{instr[31]}},instr[31:20]}; 
	assign U_imme={instr[31:12],{12{1'b0}}};
	assign J_imme={{12{instr[31]}},instr[19:12],instr[20],instr[30:21],1'b0};   
	assign B_imme={{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0};
	assign S_imme={{20{instr[31]}},instr[31:25],instr[11:7]}; 
	
	assign imme= I_type?I_imme :                                 //选择，指令是I_type吗？是就用I_imme，不是就看是不是U_type?全都不是就赋0
				 U_type?U_imme :
				 J_type?J_imme :
				 B_type?B_imme :
				 S_type?S_imme : 32'd0;



endmodule

