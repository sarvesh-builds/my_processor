module datapath(clk,reset,PCsrc,WE3,imm_src,Alusrc,alu_ctrl,WE,Result_src,zero,sign,carry_out,Instr);
   input clk,reset,WE3,Alusrc,WE;
	input[1:0] PCsrc;
	input [3:0]alu_ctrl;
	input [2:0]imm_src;
	input [2:0]Result_src;
	output zero,sign,carry_out;
	output [31:0]Instr;
	wire [31:0]PCnxt,PC,PCplus4_out,PCtarget_out,imm_ext,Result,SrcA,RD2,SrcB,Alu_result,RD;

	PCntr 		PCounter(clk,reset,PCnxt, PC);
	instr_mem   Instr_Memory( PC , Instr);
	addr 			PCplus4  (PC, 32'd4, PCplus4_out);
	addr			PCtarget (PC, imm_ext, PCtarget_out); 
	pcmux_3x1	PC_mux(PCsrc,PCplus4_out,Alu_result,PCtarget_out,PCnxt);
	register 	Register (clk,Instr[19:15],Instr[24:20],Instr[11:7], Result,WE3,SrcA, RD2 ); // "Result" is from mux next to data_memory
	immediate_extnd Extend(Instr,imm_src, imm_ext);
	mux_2x1		Alu_mux (Alusrc,RD2,imm_ext, SrcB); 
	alu 			ALU	  (SrcA,SrcB,alu_ctrl, Alu_result,zero,sign,carry_out);
	data_mem		Data_memory(clk,WE,Alu_result,RD2,Instr[14:12], RD);//<---- data_mem(clk,WE,A,WD,funct3, RD);
	
	Rmux_5x1		Result_mux(Result_src,Alu_result,RD,PCplus4_out,imm_ext,PCtarget_out, Result);
	
	
endmodule 
