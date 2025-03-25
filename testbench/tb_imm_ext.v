module ImmExtTb;
    reg [31:0] instruction;
    wire [31:0] imm_ext;

    ImmExt uut (
        .instruction(instruction),
        .imm_ext(imm_ext)
    );

    initial begin
        $monitor("Time: %0t | instruction: %h | imm_ext: %h\n", $time, instruction, imm_ext);

        // Test 1: I-type (ADDI)
        instruction = 32'hFFF00013; // ADDI x0, x0, -1
        #10;
        if (imm_ext !== 32'hFFFFFFFF) $error("Test 1 Failed");
        else $display("Test 1 Passed %h\n", imm_ext);

        // Test 2: S-type (SW)
        instruction = 32'h0064A423; // SW x6, 8(x9)
        #10;
        if (imm_ext !== 32'h00000008) $error("Test 2 Failed %h", imm_ext);
        else $display("Test 2 Passed %h\n", imm_ext);

        // Test 3: B-type (BEQ)
        instruction = 32'hFE420AE3; // BEQ x4, x4, L7
        #10;
        if (imm_ext !== 32'hFFFFFFF4) $error("Test 3 Failed %h", imm_ext);
        else $display("Test 3 Passed %h\n", imm_ext);

        // Test 4: U-type (LUI)
        instruction = 32'h12345037; // LUI x0, 0x12345
        #10;
        if (imm_ext !== 32'h12345000) $error("Test 4 Failed %h", imm_ext);
        else $display("Test 4 Passed %h\n", imm_ext);

        // Test 5: J-type (JAL)
        instruction = 32'h7F8A60EF; // JAL x1, 0xA67F8
        #10;
        if (imm_ext !== 32'h00A67F8) $error("Test 5 Failed %h", imm_ext);
        else $display("Test 5 Passed %h\n", imm_ext);

        $display("All tests completed!");
        $finish;
    end

endmodule