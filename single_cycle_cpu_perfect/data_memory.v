
//数据存储器
`include "define.v"
module data_memory(
	clk,
	rst_n,
	W_en,
	R_en,
	addr,
	RW_type,
	din,
	dout
    );
	
	
	input clk;                 //时钟信号
	input rst_n;               //读出的指令
	
	input W_en;                //写使能
	input R_en;             //读使能
	
	input [31:0]addr;            //读写地址
	input [2:0]RW_type;         //读写类型

	input [31:0]din;       //要写入存储器的数据
	output [31:0]dout;       //要从数据存储器读出的数据

	reg [31:0]ram[255:0];      //数据存储器储存空间
	
	wire [31:0]Rd_data;          //读的数据     
                wire [31:0]Wr_data;          //写的数据   

	reg [31:0]Wr_data_B;          //字节拼接
	wire [31:0]Wr_data_H;        //半字拼接
	
assign Rd_data=ram[addr[31:2]];        //读基准?????????

always@(*)
	begin
		case(addr[1:0])    //通过地址的最后两位确定数据的读法？？？
			2'b00:Wr_data_B={Rd_data[31:8],din[7:0]};
			2'b01:Wr_data_B={Rd_data[31:16],din[7:0],Rd_data[7:0]};
			2'b10:Wr_data_B={Rd_data[31:24],din[7:0],Rd_data[15:0]};
			2'b11:Wr_data_B={din[7:0],Rd_data[23:0]};
		endcase
	end

//半字拼接，addr[1] 确定拼接顺序
assign Wr_data_H=(addr[1]) ? {din[15:0],Rd_data[15:0]} : {Rd_data[31:16],din[15:0]} ;
	
//根据写类型，选择写入的数据
//等于2'b00 将8bit扩展为32bit 数据为字节拼接  ；等于2b'01 16bit扩展为32bit 数据为半字拼接 ；
//又不是00又不是01，则为10 读取或写入32bit
assign Wr_data=(RW_type[1:0]==2'b00) ? Wr_data_B :( (RW_type[1:0]==2'b01) ? Wr_data_H : din   );

//上升沿写入数据

always@(posedge clk)
begin
	if(W_en)          //如果写使能 wr_data 写入地址为addr[9:2]的ram数据区域
		ram[addr[9:2]]<=Wr_data;
end

 
//读数据


reg [7:0]Rd_data_B;
wire [15:0]Rd_data_H;

wire [31:0] Rd_data_B_ext;
wire [31:0] Rd_data_H_ext;

//根据地址，对数据截取
always@(*)
begin
	case(addr[1:0])
		2'b00:Rd_data_B=Rd_data[7:0];
		2'b01:Rd_data_B=Rd_data[15:8];
		2'b10:Rd_data_B=Rd_data[23:16];
		2'b11:Rd_data_B=Rd_data[31:24];
	endcase
end
		
assign Rd_data_H=(addr[1])? Rd_data[31:16]:Rd_data[15:0];

//将8bit符号扩展为32bit，RW_type[2]是用来判断是否是无符号数
assign Rd_data_B_ext=(RW_type[2]) ? {24'd0,Rd_data_B} : {{24{Rd_data_B[7]}},Rd_data_B};

//16bit符号扩展为32bit，RW_type[2]是用来判断是否是无符号数
assign Rd_data_H_ext=(RW_type[2]) ? {16'd0,Rd_data_H} : {{16{Rd_data_H[15]}},Rd_data_H};

//根据读类型，选择读的数据
//等于2'b00 将8bit扩展为32bit 数据为字节拼接  ；等于2b'01 16bit扩展为32bit 数据为半字拼接 ；
//又不是00又不是01，则为10 读取或写入32bit
assign dout=(RW_type[1:0]==2'b00) ? Rd_data_B_ext : ((RW_type[1:0]==2'b01) ? Rd_data_H_ext : Rd_data );


endmodule

