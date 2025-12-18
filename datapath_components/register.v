module register (clk,A1,A2,A3,WD3,WE3, RD1,RD2);
	input clk,WE3;
	input [4:0] A1,A2,A3;
	input [31:0] WD3;
	output [31:0] RD1,RD2;
	
	reg [31:0]reg_mem[0:31];

	integer i;
	//initial reg_mem[1] = 0;
	initial begin
    for (i = 0; i <32; i = i + 1) begin
        reg_mem[i] = 0;
		end
	//$readmemh("rmem.hex", reg_mem);
	end
	
	assign RD1 = (A1 != 0) ? reg_mem[A1]:32'b0;
	assign RD2 = (A2 != 0) ? reg_mem[A2]:32'b0;
	
	always @(posedge clk)
		if( WE3 && (A3!=0))
			reg_mem[A3] <= WD3;
		
endmodule


	