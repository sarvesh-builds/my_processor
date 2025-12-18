module alu (A,B,alu_ctrl, result,zero,Less,LessUnsigned);
	input [31:0]A,B;
	input [3:0]alu_ctrl;
	output reg [31:0]result;
	output zero,Less,LessUnsigned;
	//output reg carry_out;
	
	localparam [3:0]AND=4'b0000,
				 OR=4'b0001,
				 ADD=4'b0010,
				 SUB=4'b0011,
				 XOR=4'b0100,
				 SLL=4'b0101,
				 SRL=4'b0110,
				 SRA=4'b0111,
				 SLT=4'b1000,
				 SLTU=4'b1001;
	
	assign zero = (result == 32'b0);
//	assign sign = result[31];
	
//	assign zero = (alu_out == 0) ? 1'b1 : 1'b0;
	assign Less = ($signed(A) < $signed(B));
	assign LessUnsigned = (A < B);
	
	
	always@(*)
		case(alu_ctrl)
			AND: result = A & B;
			OR:  result = A | B;
	   	ADD: result = A+B;
			SUB: result = A-B;
			XOR: result = A^B;
			SLL: result = A << B[4:0];
			SRL: result = A >> B[4:0];
			SRA: result = $signed(A)>>> B[4:0];
			SLT: result = ($signed(A) < $signed(B))? 32'd1:32'd0;
			SLTU: result = (A<B)? 32'd1:32'd0;
			default : result = 32'b0;
			endcase
			
endmodule


