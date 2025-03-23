module ImmExt (
    input [31:0] instruction,
    input [2:0] imm_src,
    output reg [31:0] imm_ext
);

    always @(*) begin
        case (imm_src)
            // I-type: ADDI, LW, JALR, etc.
            3'b000: 
                imm_ext = {{20{instruction[31]}}, instruction[31:20]};
            
            // S-type: SW, SH, SB
            3'b001: 
                imm_ext = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            
            // B-type: BEQ, BNE, etc.
            3'b010: 
                imm_ext = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            
            // U-type: LUI, AUIPC
            3'b011: 
                imm_ext = {instruction[31:12], 12'b0};
            
            // J-type: JAL
            3'b100: 
                imm_ext = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};  

            // Default: Zero (ou I-type)
            default: 
                imm_ext = 32'b0;
        endcase
    end

endmodule