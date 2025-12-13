module immediate_extnd(instr,imm_src, imm_ext);
	input [31:0] instr;
	input [2:0]imm_src;
	output reg [31:0]imm_ext;
	localparam I=3'b000,S=3'b001,B=3'b010,U=3'b011,J=3'b100;
	
	always @(*)
		case (imm_src)
			I: begin
				imm_ext = {{20{instr[31]}},instr[31:20]};
				end
			S: begin
				imm_ext = {{20{instr[31]}},instr[31:25],instr[11:7]};
				end
			B: begin
				imm_ext = {{19{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
				end
			U: begin
				imm_ext ={{instr[31:12]},12'b0};
				end
			J: begin
				imm_ext = {{11{instr[31]}},instr[31],instr[19:12],instr[20],instr[30:21],1'b0};
				end
			default : imm_ext= 32'b0;
			endcase
			
endmodule
	