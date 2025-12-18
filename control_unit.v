module control_unit(clk,instr,zero,Less,LessUnsigned, PCsrc,ResultSrc,MemWrite,ALUSrc,ImmSrc,
							RegWrite,ALUcontrol);
	input [31:0]instr;
	input clk,zero,Less,LessUnsigned;
	output MemWrite,ALUSrc,RegWrite;
	output [2:0]ResultSrc;
	output [2:0]ImmSrc;
	output [1:0]PCsrc;
	output [3:0]ALUcontrol;
	wire [1:0] ALUOp;
	
	main_decoder MAIN_DECODER(instr[6:0],zero,Less,LessUnsigned,instr[14:12], ResultSrc,MemWrite,ALUSrc,ImmSrc,RegWrite,ALUOp,PCsrc);
	alu_decoder	ALU_DECODER(ALUOp,instr[14:12],instr[31:25], ALUcontrol);

	//alu_decoder
	//main_decoder
	
endmodule

	
	
	