module ALU_tb;
    reg [31:0] src_a;
    reg [31:0] src_b;
    reg [3:0] alu_op;

    wire [31:0] result;
    wire zero;

    ALU uut (
        .src_a(src_a),
        .src_b(src_b),
        .alu_op(alu_op),
        .result(result),
        .zero(zero)
    );

    initial begin
        // Test 1: ADD
        src_a = 32'h00000005;
        src_b = 32'h00000003;
        alu_op = 4'b0000; // OP_ADD
        #10;
        if (result !== 32'h00000008) $error("Test 1 Failed: Expected 8, got %h", result);

        // Test 2: SUB
        src_a = 32'h00000005;
        src_b = 32'h00000003;
        alu_op = 4'b0001; // OP_SUB
        #10;
        if (result !== 32'h00000002) $error("Test 2 Failed: Expected 2, got %h", result);

        // Test 3: AND
        src_a = 32'h0000000F;
        src_b = 32'h0000000A;
        alu_op = 4'b0010; // OP_AND
        #10;
        if (result !== 32'h0000000A) $error("Test 3 Failed: Expected A, got %h", result);

        // Test 4: OR
        src_a = 32'h0000000F;
        src_b = 32'h0000000A;
        alu_op = 4'b0011; // OP_OR
        #10;
        if (result !== 32'h0000000F) $error("Test 4 Failed: Expected F, got %h", result);

        // Test 5: XOR
        src_a = 32'h0000000F;
        src_b = 32'h0000000A;
        alu_op = 4'b0100; // OP_XOR
        #10;
        if (result !== 32'h00000005) $error("Test 5 Failed: Expected 5, got %h", result);

        // Test 6: SLL
        src_a = 32'h00000001;
        src_b = 32'h00000002;
        alu_op = 4'b0101; // OP_SLL
        #10;
        if (result !== 32'h00000004) $error("Test 6 Failed: Expected 4, got %h", result);

        // Test 7: SRL
        src_a = 32'h80000000;
        src_b = 32'h00000001;
        alu_op = 4'b0110; // OP_SRL
        #10;
        if (result !== 32'h40000000) $error("Test 7 Failed: Expected 40000000, got %h", result);

        // Test 8: SRA
        src_a = 32'h80000000;
        src_b = 32'h00000001;
        alu_op = 4'b0111; // OP_SRA
        #10;
        if (result !== 32'hC0000000) $error("Test 8 Failed: Expected C0000000, got %h", result);

        // Test 9: SLT (signed)
        src_a = 32'hFFFFFFFE; // -2
        src_b = 32'h00000001; // 1
        alu_op = 4'b1000; // OP_SLT
        #10;
        if (result !== 32'h00000001) $error("Test 9 Failed: Expected 1, got %h", result);

        // Test 10: SLTU (unsigned)
        src_a = 32'h00000001;
        src_b = 32'h00000002;
        alu_op = 4'b1001; // OP_SLTU
        #10;
        if (result !== 32'h00000001) $error("Test 10 Failed: Expected 1, got %h", result);

        // End of tests
        $display("All tests completed.");
        $finish;
    end

endmodule