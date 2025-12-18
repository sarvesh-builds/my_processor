`timescale 1ns/1ps

module test_bench;

    reg clk;

    my_processor dut (
        .clk(clk)
    );

    // -------- CLOCK --------
    initial clk = 0;
    always #5 clk = ~clk;

    // -------- DISPLAY RESULTS --------
    integer i;
	 initial $monitor($time,"Result_sel = %b , Reslut_out : %h , PCsrc : %h , PC : %d",dut.Data_Path.Result_mux.sel,
	 dut.Data_Path.Result_mux.out,dut.Data_Path.PC_mux.sel,dut.Data_Path.PCounter.PC);
    initial begin
		  //dut.Data_Path.Data_memory.mem[64] = 32'h11223344;

        #1000;
//		  $display("Register :%h",dut.Data_Path.Register.reg_mem[13]);
//        for (i = 0; i < 256; i = i + 1) begin
//            $display("x%0d = %h", i,
//                     $signed(dut.Data_Path.Data_memory.mem[i]));
//        end
//        $finish;
        for (i = 0; i < 32; i = i + 1) begin
            $display("x%0d = %h", i,
                     $signed(dut.Data_Path.Register.reg_mem[i]));
        end
        $finish;

    end

endmodule


//dut.Data_Path.Register.reg_mem