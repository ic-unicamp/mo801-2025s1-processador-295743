module ALU(
    input [31:0] src_a,
    input [31:0] src_b,
    input [3:0] alu_op, 
    output reg [31:0] result,
    output zero // ativo quando o resultado é zero
);
    localparam [3:0] 
        OP_AND = 4'b0000, // AND
        OP_OR  = 4'b0001, // OR
        OP_ADD = 4'b0010, // ADD
        OP_SUB = 4'b0110, // SUB
        OP_SLT = 4'b0111, // SLT
        OP_NOR = 4'b1100, // NOR
        OP_XOR = 4'b1010, // XOR
        OP_EQ  = 4'b1110, // EQUAL
        OP_SLL = 4'b1000, // SHIFT_LEFT
        OP_SRL = 4'b1001, // SHIFT_RIGHT
        OP_GE  = 4'b1011, // GREATER_EQUAL
        OP_SRA = 4'b0011, // SHIFT_RIGHT_A
        OP_GEU = 4'b1101, // GREATER_EQUAL_U
        OP_SLTU= 4'b1111; // SLT_U


    // Atribua zero = 1 se o resultado for zero
    assign zero = (result == 32'b0);

    always @(*) begin
        case (alu_op)
            OP_AND:  result = src_a & src_b;               // Bitwise AND
            OP_OR:   result = src_a | src_b;               // Bitwise OR
            OP_ADD:  result = src_a + src_b;               // Addition
            OP_SUB:  result = src_a - src_b;               // Subtraction
            OP_SLT:  result = ($signed(src_a) < $signed(src_b)) ? 32'b1 : 32'b0; // Signed comparison
            OP_SLTU: result = ($unsigned(src_a) < $unsigned(src_b)) ? 32'b1 : 32'b0; // Unsigned comparison
            OP_NOR: result = ~(src_a | src_b);            // Bitwise NOR
            OP_XOR:  result = src_a ^ src_b;               // Bitwise XOR
            OP_EQ:  result = (src_a == src_b) ? 32'b1 : 32'b0; // Equality
            OP_SLL:  result = src_a << src_b[4:0];         // Logical shift left
            OP_SRL:  result = src_a >> src_b[4:0];         // Logical shift right
            OP_SRA:  result = src_a >>> src_b[4:0]; // Arithmetic shift right
            OP_GE:  result = ($signed(src_a) >= $signed(src_b)) ? 32'h1 : 32'h0; // Signed greater or equal
            OP_GEU: result = ($unsigned(src_a) >= $unsigned(src_b)) ? 32'h1 : 32'h0; // Unsigned greater or equal
            default: result = OP_ADD;                       // Default case
        endcase
    end

endmodule