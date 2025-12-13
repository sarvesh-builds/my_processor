module datapath(clk,reset,PCsrc,WE3,imm_src,Alusrc,alu_ctrl,zero,WE,Result_src);
   input clk,reset,PCsrc,WE3,Alusrc,WE;
	input [3:0]alu_ctrl;
	input [2:0]imm_src;
	input [1:0]Result_src;
	output zero;
	wire [31:0]PCnxt,PC,Instr,PCplus4_out,PCtarget_out,imm_ext,Result,SrcA,RD2,SrcB,Alu_result,RD;

	PCntr 		PCounter(clk,reset,PCnxt, PC);
	instr_mem   Instr_Memory( PC , Instr);
	addr 			PCplus4  (PC, 32'd4, PCplus4_out);
	addr			PCtarget (PC, imm_ext, PCtarget_out); 
	mux_2x1		PC_mux   (PCsrc, PCplus4_out, PCtarget_out , PCnxt);
	register 	Register (clk,Instr[19:15],Instr[24:20],Instr[11:7], Result,WE3,SrcA, RD2 ); // "Result" is from mux next to data_memory
	immediate_extnd Extend(Instr,imm_src, imm_ext);
	mux_2x1		Alu_mux (Alusrc,RD2,imm_ext, SrcB); 
	alu 			ALU	  (SrcA,SrcB,alu_ctrl, Alu_result,zero);//
	data_mem		Data_memory(clk,WE,Alu_result,RD2, RD);
	mux_3x1		Result_mux(Result_src,Alu_result,RD,PCplus4_out,Result);
	
	
endmodule 
