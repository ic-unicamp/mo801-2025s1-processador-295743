module ALU(
    input [31:0] src_a,
    input [31:0] src_b,
    input [3:0] alu_op, 
    output reg [31:0] result,
    output zero // ativo quando o resultado é zero
);
    localparam [3:0] 
        OP_ADD  = 4'b0000,  // ADD, ADDI, LW, SW
        OP_SUB  = 4'b0001,  // SUB, branches
        OP_AND  = 4'b0010,  // AND, ANDI
        OP_OR   = 4'b0011,  // OR, ORI
        OP_XOR  = 4'b0100,  // XOR, XORI
        OP_SLL  = 4'b0101,  // SLL, SLLI
        OP_SRL  = 4'b0110,  // SRL, SRLI
        OP_SRA  = 4'b0111,  // SRA, SRAI
        OP_SLT  = 4'b1000,  // SLT, SLTI
        OP_SLTU = 4'b1001;  // SLTU, SLTIU

    // Atribua zero = 1 se o resultado for zero
    assign zero = (result == 32'b0);

    always @(*) begin
        case (alu_op)
            OP_ADD:  result = src_a + src_b;               // Addition
            OP_SUB:  result = src_a - src_b;               // Subtraction
            OP_AND:  result = src_a & src_b;               // Bitwise AND
            OP_OR:   result = src_a | src_b;               // Bitwise OR
            OP_XOR:  result = src_a ^ src_b;               // Bitwise XOR
            OP_SLL:  result = src_a << src_b[4:0];         // Logical shift left
            OP_SRL:  result = src_a >> src_b[4:0];         // Logical shift right
            OP_SRA:  result = $signed(src_a) >>> src_b[4:0]; // Arithmetic shift right
            OP_SLT:  result = ($signed(src_a) < $signed(src_b)) ? 32'b1 : 32'b0; // Signed comparison
            OP_SLTU: result = (src_a < src_b) ? 32'b1 : 32'b0; // Unsigned comparison
            default: result = OP_ADD;                       // Default case
        endcase
    end

endmodule