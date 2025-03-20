module ALU(
    input [31:0] src_a,
    input [31:0] src_b,
    input [3:0] alu_op,
    output reg [31:0] result,
    output zero // active when the result is zero 
);

    // PPARAMENTROS ERRADOS
    localparam OP_ADD  = 4'b0010; // SUM
    localparam OP_SUB  = 4'b0110; // SUB
    localparam OP_AND  = 4'b0000; // AND
    localparam OP_OR   = 4'b0001; // OR
    localparam OP_XOR  = 4'b1010; // XOR
    localparam OP_SLL  = 4'b1000; // SHIFT_LEFT
    localparam OP_SRL  = 4'b1001; // SHIFT_RIGHT
    localparam OP_SLT  = 4'b0111; // SLT
    localparam OP_SLTU = 4'b1111; // SLT_U

    assign zero = (result == 32'b0); // set zero if the result is zero

    always @(*) begin
        case (alu_op)
            OP_ADD:  result = src_a + src_b;               // Addition
            OP_SUB:  result = src_a - src_b;               // Subtraction
            OP_AND:  result = src_a & src_b;               // Bitwise AND
            OP_OR:   result = src_a | src_b;               // Bitwise OR
            OP_XOR:  result = src_a ^ src_b;               // Bitwise XOR
            OP_SLL:  result = src_a << src_b[4:0];         // Logical shift left
            OP_SRL:  result = src_a >> src_b[4:0];         // Logical shift right
            OP_SLT:  result = ($signed(src_a) < $signed(src_b)) ? 32'b1 : 32'b0; // Signed comparison
            OP_SLTU: result = (src_a < src_b) ? 32'b1 : 32'b0; // Unsigned comparison
            default: result = 32'b0;                       // Default case
        endcase
    end

endmodule
