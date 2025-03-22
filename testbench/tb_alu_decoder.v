module ALUDecoderTb();

    reg is_imm;
    reg funct7_5;
    reg [2:0] funct3;
    reg [1:0] alu_op;
    wire [2:0] alu_control;

    ALUDecoder uut(
        .is_imm(is_imm),
        .funct7_5(funct7_5),
        .funct3(funct3),
        .alu_op(alu_op),
        .alu_control(alu_control)
    );

    initial begin  
        $dumpfile("build/tb_alu_decoder.vcd");
        $dumpvars(0, ALUDecoderTb);
    
        // Test 1: ADD (LW, SW, ADDI)
        alu_op = 2'b00;
        #10;
        if (alu_control !== 3'b000) $error("Test 1 Failed: Expected ALU_ADD (3'b000), got %b", alu_control);

        // Test 2: SUB (Branches)
        alu_op = 2'b01;
        #10;
        if (alu_control !== 3'b001) $error("Test 2 Failed: Expected ALU_SUB (3'b001), got %b", alu_control);

        // Test 3: R-type ADD
        alu_op = 2'b10;
        funct3 = 3'b000;
        is_imm = 0;
        funct7_5 = 0;
        #10;
        if (alu_control !== 3'b000) $error("Test 3 Failed: Expected ALU_ADD (3'b000), got %b", alu_control);

        // Test 4: R-type SUB
        alu_op = 2'b10;
        funct3 = 3'b000;
        is_imm = 0;
        funct7_5 = 1;
        #10;
        if (alu_control !== 3'b001) $error("Test 4 Failed: Expected ALU_SUB (3'b001), got %b", alu_control);

        // Test 5: R-type SLL
        alu_op = 2'b10;
        funct3 = 3'b001;
        #10;
        if (alu_control !== 3'b101) $error("Test 5 Failed: Expected ALU_SLL (3'b101), got %b", alu_control);

        // Test 6: R-type SLT
        alu_op = 2'b10;
        funct3 = 3'b010;
        #10;
        if (alu_control !== 3'b010) $error("Test 6 Failed: Expected ALU_SLT (3'b010), got %b", alu_control);

        // Test 7: R-type SLTU
        alu_op = 2'b10;
        funct3 = 3'b011;
        #10;
        if (alu_control !== 3'b011) $error("Test 7 Failed: Expected ALU_SLTU (3'b011), got %b", alu_control);

        // Test 8: R-type XOR
        alu_op = 2'b10;
        funct3 = 3'b100;
        #10;
        if (alu_control !== 3'b100) $error("Test 8 Failed: Expected ALU_XOR (3'b100), got %b", alu_control);

        // Test 9: R-type SRL
        alu_op = 2'b10;
        funct3 = 3'b101;
        is_imm = 0;
        funct7_5 = 0;
        #10;
        if (alu_control !== 3'b110) $error("Test 9 Failed: Expected ALU_SRL (3'b110), got %b", alu_control);

        // Test 10: R-type SRA
        alu_op = 2'b10;
        funct3 = 3'b101;
        is_imm = 0;
        funct7_5 = 1;
        #10;
        if (alu_control !== 3'b111) $error("Test 10 Failed: Expected ALU_SRA (3'b111), got %b", alu_control);

        // Test 11: R-type OR
        alu_op = 2'b10;
        funct3 = 3'b110;
        #10;
        if (alu_control !== 3'b011) $error("Test 11 Failed: Expected ALU_OR (3'b011), got %b", alu_control);

        // Test 12: R-type AND
        alu_op = 2'b10;
        funct3 = 3'b111;
        #10;
        if (alu_control !== 3'b010) $error("Test 12 Failed: Expected ALU_AND (3'b010), got %b", alu_control);

        // Test 13: I-type ADDI
        alu_op = 2'b11;
        funct3 = 3'b000;
        #10;
        if (alu_control !== 3'b000) $error("Test 13 Failed: Expected ALU_ADD (3'b000), got %b", alu_control);

        // Test 14: I-type SLLI
        alu_op = 2'b11;
        funct3 = 3'b001;
        #10;
        if (alu_control !== 3'b101) $error("Test 14 Failed: Expected ALU_SLL (3'b101), got %b", alu_control);

        // Test 15: I-type SLTI
        alu_op = 2'b11;
        funct3 = 3'b010;
        #10;
        if (alu_control !== 3'b010) $error("Test 15 Failed: Expected ALU_SLT (3'b010), got %b", alu_control);

        // Test 16: I-type SLTIU
        alu_op = 2'b11;
        funct3 = 3'b011;
        #10;
        if (alu_control !== 3'b011) $error("Test 16 Failed: Expected ALU_SLTU (3'b011), got %b", alu_control);

        // Test 17: I-type XORI
        alu_op = 2'b11;
        funct3 = 3'b100;
        #10;
        if (alu_control !== 3'b100) $error("Test 17 Failed: Expected ALU_XOR (3'b100), got %b", alu_control);

        // Test 18: I-type SRLI
        alu_op = 2'b11;
        funct3 = 3'b101;
        is_imm = 1;
        funct7_5 = 0;
        #10;
        if (alu_control !== 3'b110) $error("Test 18 Failed: Expected ALU_SRL (3'b110), got %b", alu_control);

        // Test 19: I-type SRAI
        alu_op = 2'b11;
        funct3 = 3'b101;
        is_imm = 1;
        funct7_5 = 1;
        #10;
        if (alu_control !== 3'b111) $error("Test 19 Failed: Expected ALU_SRA (3'b111), got %b", alu_control);
        // Test 20: I-type ORI
        alu_op = 2'b11;
        funct3 = 3'b110;
        #10;
        if (alu_control !== 3'b011) $error("Test 20 Failed: Expected ALU_OR (3'b011), got %b", alu_control);

        // Test 21: I-type ANDI
        alu_op = 2'b11;
        funct3 = 3'b111;
        #10;
        if (alu_control !== 3'b010) $error("Test 21 Failed: Expected ALU_AND (3'b010), got %b", alu_control);

        // End of tests
        $display("All tests completed.");
        $finish;
    end

endmodule