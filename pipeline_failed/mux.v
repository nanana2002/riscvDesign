
module mux(data1,data2,sel,dout               //数据选择器？
    );
	input [31:0]data1;
	input [31:0]data2;
	input sel;
	output [31:0]dout;
	
	assign dout = sel ? data1 : data2 ;

endmodule
