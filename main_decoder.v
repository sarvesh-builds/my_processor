module main_decoder(op,zero,sign,carry_out,funct3, ResultSrc,MemWrite,ALUSrc,ImmSrc,RegWrite,ALUOp,PCSrc);
	input [6:0]op;
	input zero,sign,carry_out;
	input [2:0]funct3;
	output reg MemWrite,ALUSrc,RegWrite;
	output reg[1:0]ResultSrc,ALUOp;
	output [1:0]PCSrc;
	output reg[2:0]ImmSrc;
	reg Branch,Jump,Jalr;

	assign PCSrc = {(Jump|Branch),Jalr};
		
	always @(*)
		begin
			Branch = 1'b0;
			Jump = 1'b0;
			Jalr = 1'b0;
			case(op)
				7'b0000011 : begin // lb,lh,lw,lbu,lhu
								ResultSrc = 2'b01;
								MemWrite =1'b0;
								ALUSrc = 1'b1;
								ImmSrc =  3'b000;
								RegWrite = 1'b1;
								ALUOp =2'b00 ;
								end
				7'b0010011 : begin //addi,slli,slti,sltiu,xori,srli,srali,ori,andi
								ResultSrc = 2'b01;
								MemWrite =1'b0;
								ALUSrc = 1'b1;
								ImmSrc =  3'b000;
								RegWrite = 1'b1;
								ALUOp =2'b11;
								end
				
				7'b0100011 : begin //sb,sw,sh
								ResultSrc = 2'bxx;
								MemWrite =1'b1;
								ALUSrc = 1'b1;
								ImmSrc =  3'b001;
								RegWrite = 1'b0;
								ALUOp =2'b00;
								end
				7'b0110011 : begin // add,sub,sll,slt,sltu,xor,srl,sra,or,and,lui
								ResultSrc = 2'b00;
								MemWrite =1'b0;
								ALUSrc = 1'b0;
								ImmSrc =  3'bxxx;
								RegWrite = 1'b1;
								ALUOp =2'b10;
							 end
				7'b1100011 : begin  //branch
								ResultSrc = 2'bxx;
								MemWrite =1'b0;
								ALUSrc = 1'b0;
								ImmSrc =  3'b010;
								RegWrite = 1'b0;
								ALUOp =2'b01;
								case(funct3):
									3'b000:Branch=zero;//beq
									3'b001:Branch=~zero;//bne
									3'b100:Branch=sign;//blt
									3'b101:Branch=~sign;//bge
									3'b110:Branch=~carry_out;//bltu
									3'b111:Branch=carry_out;//bgeu
								endcase
							 end
				7'b1101111 : begin // jal     //PC --> PCtarget for Branch and Jal.
								ResultSrc = 2'b10;
								MemWrite =1'b0;
								ALUSrc = 1'bx;
								ImmSrc =  3'b100;
								RegWrite = 1'b1;
								Jump = 1'b1;
								ALUOp =2'bxx; 
							 end 
				7'b1100111 : begin //jalr
								ResultSrc = 2'b10;
								MemWrite =1'b0;
								ALUSrc = 1'b1;
								ImmSrc =  3'b000;
								RegWrite = 1'b1;
								Jalr = 1'b1;
								ALUOp =2'b00; 
							 end
				endcase
	
endmodule
//localparam I=3'b000,S=3'b001,B=3'b010,U=3'b011,J=3'b100; --> ImmSrc

//localparam [3:0]AND=4'b0000,    ----> ALUOp
//				 OR=4'b0001,
//				 ADD=4'b0010,
//				 SUB=4'b0011,
//				 XOR=4'b0100,
//				 SLL=4'b0101,
//				 SRL=4'b0110,
//				 SRA=4'b0111,
//				 SLT=4'b1000,
//				 SLTU=4'b1001;

//| ALUOp | Meaning           | Instruction type |
//| ----- | ----------------- | ---------------- |
//| `00`  | Always ADD        | Load / Store     |
//| `01`  | Always SUB        | Branch           |
//| `10`  | Use funct3/funct7 | R-type           |
//| `11`  | Use funct3        | I-type (ALU imm) |