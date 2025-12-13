                        
module PCntr(clk,reset,PCnxt, PC);
	input clk,reset;
	input [31:0]PCnxt;
	output reg[31:0] PC;
	
	always@(posedge clk)
		if (reset)
			PC = 32'd0;
		else
			PC <= PCnxt;
		
endmodule

		