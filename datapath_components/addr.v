
module addr( A,B, out); // for PCplus4 , PCtarget
	input[31:0] A,B;
	output [31:0] out;
	
	assign out = A+B;
	
endmodule 