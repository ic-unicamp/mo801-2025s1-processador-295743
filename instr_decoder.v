module InstDecoder(
    input [6:0] op,          // Opcode da instrução
    output reg [1:0] imm_src // Tipo de imediato
);

    always @(*) begin
        case (op)
            7'b0000011: imm_src = 2'b00; // I-type (Load)
            7'b0100011: imm_src = 2'b01; // S-type (Store)
            7'b1100011: imm_src = 2'b10; // B-type (Branch)
            7'b1101111: imm_src = 2'b11; // J-type (Jump)
            default:    imm_src = 2'b00; // R-type (default)
        endcase
    end

endmodule