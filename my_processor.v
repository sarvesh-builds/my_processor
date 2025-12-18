module my_processor(clk);
	input clk;
	//datapath to controller
	wire[31:0]instr;
	wire zero,Less,LessUnsigned; 
	//controller to datapath
	wire MemWrite,ALUSrc,RegWrite;
	wire [1:0]PCsrc;
	wire [2:0]ResultSrc,ImmSrc;
	wire [3:0]ALUcontrol;
	
	control_unit Controller(clk,instr,zero,Less,LessUnsigned, PCsrc,ResultSrc,MemWrite,ALUSrc,ImmSrc,
							RegWrite,ALUcontrol);
							
	datapath Data_Path(clk,PCsrc,RegWrite,ImmSrc,ALUSrc,ALUcontrol,MemWrite,ResultSrc,zero,Less,LessUnsigned,instr);

							
endmodule
