module my_processor(clk);
	input clk;
	//datapath to controller
	wire[31:0]instr;
	wire zero,sign,carry_out; 
	//controller to datapath
	wire MemWrite,ALUSrc,RegWrite;
	wire [1:0]PCsrc;
	wire [2:0]ResultSrc,ImmSrc;
	wire [3:0]ALUcontrol;
	control_unit Controller(clk,instr,zero,sign,carry_out, PCsrc,ResultSrc,MemWrite,ALUSrc,ImmSrc,
							RegWrite,ALUcontrol);
							
	datapath Data_Path(clk,reset,PCsrc,RegWrite,ImmSrc,ALUSrc,ALUcontrol,MemWrite,ResultSrc,zero,sign,carry_out,instr);

							
endmodule
