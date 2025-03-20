module ALUTb();
    reg [31:0] src_a;
    reg [31:0] src_b;
    reg [3:0] alu_op;
    wire [31:0] result;
    wire zero;

    ALU alu(
        .src_a(src_a),
        .src_b(src_b),
        .alu_op(alu_op),
        .result(result),
        .zero(zero)
    );

    initial begin
        $dumpfile("tb_alu.vcd");
        $dumpvars(0, ALUTb);

        alu_op = 4'b0010; // SUM
        src_a = 32'h1;
        src_b = 32'h1;

        #1;

        if(result == 32'h2) begin
            $display("Addition is correct\n");
        end else begin
            $display("Addition is not correct\n");
        end

        alu_op = 4'b0110; // SUB
        src_a = 32'h2;
        src_b = 32'h1;

        #1;
        if(result == 32'h1) begin
            $display("Subtraction is correct\n");
        end else begin
            $display("Subtraction is not correct\n");
        end

        #1;

        alu_op = 4'b0000; // AND
        src_a = 32'h00000000;
        src_b = 32'hFFFFFFFF;

        #1;
        if(result == 32'h00000000) begin
            $display("Bitwise AND is correct\n");
        end else begin
            $display("Bitwise AND is not correct\n");
        end

        #1;
        alu_op = 4'b0001; // OR
        src_a = 32'h00000000;
        src_b = 32'hFFFFFFFF;

        #1;
        if(result == 32'hFFFFFFFF) begin
            $display("Bitwise OR is correct\n");
        end else begin
            $display("Bitwise OR is not correct\n");
        end

        #1;
        alu_op = 4'b1010; // XOR
        src_a = 32'h00000000;
        src_b = 32'hFFFFFFFF;

        #1;
        if(result == 32'hFFFFFFFF) begin
            $display("Bitwise XOR is correct\n");
        end else begin
            $display("Bitwise XOR is not correct\n");
        end

        #1;
        alu_op = 4'b1000; // SHIFT_LEFT
        src_a = 32'h00000001;
        src_b = 32'h1;

        #1; 
        if(result == 32'h00000002) begin
            $display("Shift Left Logical is correct\n");
        end else begin
            $display("Shift Left Logical is not correct\n");
        end

        #1;
        alu_op = 4'b1001; // SHIFT_RIGHT
        src_a = 32'h00000002;
        src_b = 32'h1;

        #1;
        if(result == 32'h00000001) begin
            $display("Shift Right Logical is correct\n");
        end else begin
            $display("Shift Right Logical is not correct\n");
        end

        #1;
        alu_op = 4'b0111; // SLT
        src_a = 32'h00000001;
        src_b = 32'h00000002;

        #1;
        if(result == 32'h00000001) begin
            $display("Set Less Than (signed) is correct\n");
        end else begin
            $display("Set Less Than (signed) is not correct\n");
        end

        #1;
        alu_op = 4'b1111; // SLT_U
        src_a = 32'h00000001;
        src_b = 32'h00000002;

        #1;
        if(result == 32'h00000001) begin
            $display("Set Less Than Unsigned is correct\n");
        end else begin
            $display("Set Less Than Unsigned is not correct\n");
        end
        
        $finish;
    end

endmodule