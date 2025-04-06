module ImmExt (
    input [31:0] instruction,
    output reg [31:0] imm_ext
);

    localparam [6:0]
        LW_OP        = 7'b0000011,
        SW_OP        = 7'b0100011,
        JAL_OP       = 7'b1101111,
        LUI_OP       = 7'b0110111,
        JALR_OP      = 7'b1100111,
        AUIPC_OP     = 7'b0010111,
        BRANCH_OP    = 7'b1100011,
        IMM_OP       = 7'b0010011;


    always @(*) begin
        case (instruction[6:0])
            BRANCH_OP: // SB type
                imm_ext = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
                
            JAL_OP: // UJ type JAL
                imm_ext = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            
            AUIPC_OP: // AUIPC U type
                imm_ext = {instruction[31:12], 12'h000};
                
            LUI_OP: // LUI U type
                imm_ext = {instruction[31:12], 12'h000};
            LW_OP: // lw instruction 
                imm_ext = {{20{instruction[31]}}, instruction[31:20]};
            IMM_OP: // I type instruction
                case (instruction[14:12])
                    3'b001: imm_ext = {{27{instruction[24]}}, instruction[24:20]};
                    3'b011: imm_ext = {20'h00000, instruction[31:20]};
                    3'b101: imm_ext = {{27'h0000000}, instruction[24:20]};
                    default: imm_ext = {{20{instruction[31]}}, instruction[31:20]};
                endcase
            JALR_OP: // I type instruction JALR
                imm_ext = {{20{instruction[31]}}, instruction[31:20]};
            
            SW_OP: // sw instruction  (S type)
                imm_ext = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            default: 
                imm_ext = 32'h00000000;
        endcase
    end

endmodule