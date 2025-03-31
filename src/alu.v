module ALU(
    input [31:0] src_a,
    input [31:0] src_b,
    input [3:0] alu_control, 
    output reg [31:0] result,
    output zero 
);
    localparam [3:0]
        AND  = 4'b0000,
        OR   = 4'b0001,
        ADD  = 4'b0010,
        SUB  = 4'b0110,
        SLT  = 4'b0111,
        NOR  = 4'b1100,
        XOR  = 4'b1010,
        EQ   = 4'b1110,
        SLL  = 4'b1000,
        SRL  = 4'b1001,
        SRA  = 4'b0011,
        GE   = 4'b1011,
        GEU  = 4'b1101,
        SLTU = 4'b1111;

    assign zero = (result == 32'b0);

    always @(*) begin
        case (alu_control)
            AND:  result = src_a & src_b;               // Bitwise AND
            OR:  result = src_a | src_b;               // Bitwise OR
            ADD:  result = src_a + src_b;               // Addition
            SUB:  result = src_a - src_b;               // Subtraction
            SLT:  result = ($signed(src_a) < $signed(src_b)) ? 1 : 0; // SLT
            SLTU:  result = (src_a < src_b) ? 1 : 0;     // SLTU
            SLL:  result = src_a << src_b[4:0];         // Logical shift left
            SRL:  result = src_a >> src_b[4:0];         // Logical shift right
            SRA:  result = src_a >>> src_b[4:0];        // Shift Right Arithmetic
            NOR: result = ~(src_a | src_b);
            XOR: result = src_a ^ src_b;               // Bitwise XOR
            EQ:  result = src_a == src_b;
            GE: result = (src_a>=src_b) ? 32'h1 : 32'h0;
            GEU: result = ($unsigned(src_a)>=$unsigned(src_b)) ? 32'h1 : 32'h0;
            default: 
                result = OP_ADD;                       // Default case
        endcase
    end

endmodule