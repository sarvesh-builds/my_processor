module instr_mem(A,RD);
	input [31:0]A;
	output reg [31:0]RD;
	
	reg [31:0] mem [0:63];
	
	always @(*)
		RD <= mem[A[31:2]];
	
endmodule

	