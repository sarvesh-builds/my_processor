                        
module PCntr(clk,PCnxt, PC);
	input clk;
	input [31:0]PCnxt;
	output reg[31:0] PC;
	
	initial PC = 32'b0;

	always@(posedge clk)
			PC <= PCnxt;
		
endmodule

		