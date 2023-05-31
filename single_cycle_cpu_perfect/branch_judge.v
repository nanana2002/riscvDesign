
module branch_judge(
  beq,
  bne,
  blt,
  bge,
  bltu,
  bgeu,
  jal,
  jalr,
  zero,
  ALU_result_sig,
  jump_flag

 );
	input beq;
	input bne;
	input blt;
	input bge;
	input bltu;
	input bgeu;
	input jal;
	input jalr;
	
	input zero;
	input ALU_result_sig;
	
	output jump_flag;   //等于1就是要跳，不顺序执行了
	
	assign jump_flag = 	jal |           //这里ALU_result_sig要的应该是alu计算结果大于0输出0，小于0，输出1
						jalr |
						(beq && zero)|
						(bne && (!zero))|
						(blt && ALU_result_sig)|
						(bge && (!ALU_result_sig))|
						(bltu && ALU_result_sig)|
						(bgeu && (!ALU_result_sig));

endmodule
