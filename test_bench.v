`timescale 1ns/1ps

module test_bench;

    // Top-level inputs to datapath
    reg         clk;
    reg         reset;
    reg         PCsrc;
    reg         WE3;
    reg  [2:0]  imm_src;
    reg         Alusrc;
    reg  [3:0]  alu_ctrl;
    reg         WE;
    reg  [1:0]  Result_src;

    wire        zero;

    // Instantiate DUT (named-port mapping)
    datapath uut (
        .clk        (clk),
        .reset      (reset),
        .PCsrc      (PCsrc),
        .WE3        (WE3),
        .imm_src    (imm_src),
        .Alusrc     (Alusrc),
        .alu_ctrl   (alu_ctrl),
        .zero       (zero),
        .WE         (WE),
        .Result_src (Result_src)
    );

    // clock generator
    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz-like, 10ns period

    // helper task: check equality and print pass/fail
    task assert_eq32(input [31:0] got, input [31:0] exp, input [256*1:0] msg);
    begin
        if (got === exp) $display("PASS: %s -- got 0x%08h", msg, got);
        else           $display("FAIL: %s -- got 0x%08h expected 0x%08h", msg, got, exp);
    end
    endtask
	 integer i;

    initial begin
        $display("\n=== Datapath self-check starting ===\n");

        // 1) reset and initialization
        reset = 1;
        PCsrc = 0;
        WE3 = 0;
        imm_src = 3'b000;
        Alusrc = 0;
        alu_ctrl = 4'b0000;
        WE = 0;
        Result_src = 2'b00;
        #20;
        reset = 0;
        #10;

        // -------------------------------------------------
        // TEST 1: Register file WRITE via writeback path
        // We force Instr[11:7] = rd = 5, and force Result value,
        // assert WE3 and pulse clock to write reg[5] <= Result.
        // -------------------------------------------------
        $display("TEST 1: register write via writeback (rd=5)");

        // Prepare: ensure reg_mem cleared
        ///integer i;
        for (i = 0; i < 32; i = i + 1) begin
            uut.Register.reg_mem[i] = 32'd0; // direct hierarchical init
        end

        // Force an instruction with rd = 5 (instr[11:7] = 5)
        // rd bits are at instr[11:7] -> 5 << 7 = 0x00000280
        force uut.Instr = 32'h00000280;

        // Force the writeback value to Result (internal net)
        force uut.Result = 32'hABCD_1234;

        WE3 = 1;       // enable register write
        @(posedge clk); // perform synchronous write
        #1;
        WE3 = 0;

        // release forced nets
        release uut.Instr;
        release uut.Result;

        // Check reg 5 content
        assert_eq32(uut.Register.reg_mem[5], 32'hABCD_1234, "Register x5 write");

        // -------------------------------------------------
        // TEST 2: ALU ADD using register operands
        // - Preload reg[1]=10, reg[2]=5 in register file
        // - Force Instr so rs1=1 (instr[19:15]=1), rs2=2 (instr[24:20]=2)
        // - Set Alusrc=0 (use reg B), alu_ctrl = ADD
        // - Check ALU result (uUt.Alu_result) == 15
        // -------------------------------------------------
        $display("\nTEST 2: ALU ADD from reg[1]=10 and reg[2]=5");

        uut.Register.reg_mem[1] = 32'd10;
        uut.Register.reg_mem[2] = 32'd5;

        // Build Instr: rs1=1 -> (1<<15) = 0x00008000; rs2=2 -> (2<<20) = 0x00200000
        force uut.Instr = 32'h00208000;

        Alusrc = 0;            // use reg operand RD2
        alu_ctrl = 4'b0010;    // ADD (match your ALU encoding)
        #2; // give combinational paths time

        // read ALU result
        assert_eq32(uut.Alu_result, 32'd15, "ALU ADD result (10 + 5)");

        // release
        release uut.Instr;

        // -------------------------------------------------
        // TEST 3: Data memory read (word-addressable)
        // - Initialize data memory at word index 3 with 0xDEADBEEF
        // - Drive Alu_result = 12 (byte address -> word index 3)
        // - Check datapath RD net equals that word
        // -------------------------------------------------
        $display("\nTEST 3: Data memory read (word index 3)");

        // init mem[3]
        uut.Data_memory.mem[3] = 32'hDEAD_BEEF;

        // Force the ALU result (address) to 12 (points to mem[3])
        force uut.Alu_result = 32'd12;
        #2; // wait for combinational read to reflect

        assert_eq32(uut.RD, 32'hDEAD_BEEF, "Data memory read at byte addr 12");

        release uut.Alu_result;

        // -------------------------------------------------
        $display("\n=== Datapath self-check finished ===\n");
        #10;
        $finish;
    end

endmodule
