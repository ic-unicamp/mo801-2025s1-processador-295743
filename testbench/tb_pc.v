module PCTb();
    reg clk, reset, pc_write;
    reg [31:0] next_pc;
    wire [31:0] current_pc;

    PC uut (
        .clock(clk),
        .reset(reset),
        .pc_write(pc_write),
        .next_pc(next_pc),
        .current_pc(current_pc)
    );

    initial begin
        clk = 0;
        reset = 1;
        #10 reset = 0; // Release reset after 10ns
        forever #5 clk = ~clk; // Generate clock
    end

    initial begin
        $dumpfile("build/tb_pc.vcd");
        $dumpvars(0, PCTb);
        // Test 1: Reset condition
        #15;
        if (current_pc !== 32'h0) $error("Reset failed");

        // Test 2: Update PC
        pc_write = 1;
        next_pc = 32'h0000_0004;
        #10; // Wait for clock edge
        if (current_pc !== 32'h4) $error("PC update failed");

        // Test 3: Hold PC
        pc_write = 0;
        next_pc = 32'hdead_beef;
        #10;
        if (current_pc === 32'hdead_beef) $error("PC updated without pc_write");
        $finish;
    end
endmodule