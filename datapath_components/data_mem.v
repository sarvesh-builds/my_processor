module data_mem(clk,WE,A,WD, RD);
	
	input clk,WE;
	input [31:0]A,WD;
	output [31:0]RD;
	
	reg [31:0]mem[0:63];
	
	assign RD = mem[A[31:2]];
	
	always @(posedge clk)
	if (WE)
		mem[A[31:2]] <= WD;
		
endmodule
