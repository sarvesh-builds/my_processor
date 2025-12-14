module pcmux_3x1(sel,in0,in1,in2,out);
	input [1:0]sel;
	input [31:0]in0,in1,in2;
	output[31:0] out;
	
	assign out = (sel == 2'b00) ? in0 : //PC+4
                (sel == 2'b01) ? in1 : //Aluresult
                (sel == 2'b10) ? in2 :in0; //PCtarget

endmodule
		