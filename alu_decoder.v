module alu_decoder(ALUOp,funct3,funct7, ALUcontrol);
	input [1:0]ALUOp;
	input [2:0]funct3;
	input [6:0]funct7;
	output reg[3:0]ALUcontrol;
	
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
	
	always @(*)
	begin
		case(ALUOp)
			2'b00:begin
						ALUcontrol = ADD;
					end
			2'b01:begin
						ALUcontrol = SUB;
					end
			2'b10:begin
						case(funct3)
							3'b000:begin
										if (funct7[5])
											ALUcontrol = SUB;
										else
											ALUcontrol = ADD;
									end
							3'b001: ALUcontrol = SLL;
							3'b010: ALUcontrol = SLT;
							3'b011: ALUcontrol = SLTU;
							3'b100: ALUcontrol = XOR;
							3'b101:begin
										if (funct7[5])
											ALUcontrol = SRA;
										else
											ALUcontrol = SRL;
									end
							3'b110: ALUcontrol = OR;
							3'b111: ALUcontrol = AND;
						endcase
					end
			2'b11:begin
						case(funct3)
							3'b000:ALUcontrol = ADD;
							3'b001: ALUcontrol = SLL;
							3'b010: ALUcontrol = SLT;
							3'b011: ALUcontrol = SLTU;
							3'b100: ALUcontrol = XOR;
							3'b101:begin
										if (funct7[5])
											ALUcontrol = SRA;
										else
											ALUcontrol = SRL;
									end
							3'b110: ALUcontrol = OR;
							3'b111: ALUcontrol = AND;
							endcase
					end
			default :ALUcontrol = ADD;
		endcase
	end
endmodule
			

				
			
//| ALUOp | Meaning           | Instruction type |
//| ----- | ----------------- | ---------------- |
//| `00`  | Always ADD        | Load / Store     |
//| `01`  | Always SUB        | Branch           |
//| `10`  | Use funct3/funct7 | R-type           |
//| `11`  | Use funct3        | I-type (ALU imm) |