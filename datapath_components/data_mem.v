module data_mem(clk,WE,A,WD,funct3, RD);
	
	input clk,WE;
	input [31:0]A,WD;
	input [2:0]funct3;
	
	output reg [31:0]RD;
	
	reg [31:0]mem[0:63];	
	
//Read Memory should be byte or halfword or word addressable; this can decided based on the funct3
//assign RD = mem[A[31:2]]; This is word addressable , cannot access half word or byte
//Based on funct3 the memory should read byte or h.word (make it 32bit then) or word then assign it to RD(32bit)
	always @(*) // read is commbinational
		begin
		RD = 32'b0;
		case(funct3)
			3'b000://lb
				begin
					case(A[1:0])
						2'b00: RD = {{24{mem[A[31:2]][7]}},mem[A[31:2]][7:0]};     //first byte
						2'b01: RD = {{24{mem[A[31:2]][15]}},mem[A[31:2]][15:8]};   //second byte
						2'b10: RD = {{24{mem[A[31:2]][23]}},mem[A[31:2]][23:16]};  //third byte
						2'b11: RD = {{24{mem[A[31:2]][31]}},mem[A[31:2]][31:24]};  //last byte
					endcase
				end
			3'b001://lh
				begin
					case(A[1])
						1'b0: RD = {{16{mem[A[31:2]][15]}},mem[A[31:2]][15:0]};		// lower half word
						1'b1: RD = {{16{mem[A[31:2]][31]}},mem[A[31:2]][31:16]};    // upper half word
					endcase
				end
			3'b010://lw
				begin
					RD = mem[A[31:2]];
				end
			3'b100://lbu
				begin
					case(A[1:0])
						2'b00: RD = { 24'b0 , mem[A[31:2]][7:0]};
						2'b01: RD = { 24'b0 , mem[A[31:2]][15:8]};
						2'b10: RD = { 24'b0 , mem[A[31:2]][23:16]};
						2'b11: RD = { 24'b0 , mem[A[31:2]][31:24]};
					endcase
				end
			3'b101://lhu
				begin
					case(A[1])
						1'b0: RD ={16'b0 , mem[A[31:2]][15:0]};
						1'b1: RD ={16'b0 , mem[A[31:2]][31:16]};
					endcase
				end
			default : RD = 32'b0;
		endcase
		end

	//Remember A is 32 bit , WD is 32 bit ; byte or half word are embedded in WD.		
	always @(posedge clk) // write is sequential sync
	begin
	if (WE) begin
		case(funct3)
			3'b000:// sb
				begin
				case(A[1:0])
					2'b00: mem[A[31:2]][7:0]<=WD[7:0];
					2'b01: mem[A[31:2]][15:8]<=WD[7:0];
					2'b10: mem[A[31:2]][23:16]<=WD[7:0];
					2'b11: mem[A[31:2]][31:24]<=WD[7:0];
				endcase
				end
			3'b001: // sh
				begin
				case(A[1])
					1'b0: mem[A[31:2]][15:0] <= WD[15:0];
					1'b1: mem[A[31:2]][31:16] <= WD[15:0];
				endcase
				end
			3'b010: //sw
				begin
				mem[A[31:2]] <= WD; 				
				end
			default:;
		endcase
		end
	end
	
endmodule
