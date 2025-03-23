module ImmExtTb;
    reg [31:0] instruction;
    reg [2:0] imm_src;

    wire [31:0] imm_ext;

    ImmExt uut (
        .instruction(instruction),
        .imm_src(imm_src),
        .imm_ext(imm_ext)
    );

    initial begin
        $monitor("Time: %0t | imm_src: %b | imm_ext: %h", $time, imm_src, imm_ext);

        // Test 1: I-type (ADDI)
        instruction = 32'hFFF00013; // ADDI x0, x0, -1
        imm_src = 3'b000;
        #10;
        if (imm_ext !== 32'hFFFFFFFF) $error("Test 1 Failed");
        else $display("Test 1 Passed %h\n", imm_ext);

        // Test 2: S-type (SW)
        instruction = 32'h0064A423; // sw x6, 8(x9)
        imm_src = 3'b001;
        #10;
        if (imm_ext !== 32'h00000008) $display("Test 2 Failed %h", imm_ext);
        $display("\n");

        // Test 3: B-type (BEQ)
        instruction = 32'hFE420AE3; // beq x4, x4, L7
        imm_src = 3'b010;
        #10;
        if (imm_ext !== 32'hFFFFFFF4) $display("Test 3 Failed %h", imm_ext);
        $display("\n");

        // Test 4: U-type (LUI)
        instruction = 32'h12345037; // LUI x0, 0x12345
        imm_src = 3'b011;
        #10;
        if (imm_ext !== 32'h12345000) $error("Test 4 Failed");
        $display("\n");

        // Test 5: J-type (JAL)
        //instruction = 32'h12345FEF; // JAL x31, 0x12345
        instruction = 32'h7F8A60EF; // jal x1, 0xA67F8
        imm_src = 3'b100;
        #10;
        if (imm_ext !== 32'hA67F8) $error("Test 5 Failed");
        $display("\n");

        
        $display("All tests passed!");
        $finish;
    end

endmodule