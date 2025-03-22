module ALUDecoder(
    input is_imm, 
    input funct7_5, 
    input [2:0] funct3,
    input [1:0] alu_op, 
    output reg [2:0] alu_control  
);

    // Defina os códigos de controle da ALU (3 bits)
    localparam [2:0] 
        ALU_ADD  = 3'b000,  // ADD, ADDI, LW, SW
        ALU_SUB  = 3'b001,  // SUB, branches
        ALU_AND  = 3'b010,  // AND, ANDI
        ALU_OR   = 3'b011,  // OR, ORI
        ALU_XOR  = 3'b100,  // XOR, XORI
        ALU_SLL  = 3'b101,  // SLL, SLLI
        ALU_SRL  = 3'b110,  // SRL, SRLI
        ALU_SRA  = 3'b111,  // SRA, SRAI
        ALU_SLT  = 3'b010,  // SLT, SLTI (reutiliza código de AND)
        ALU_SLTU = 3'b011;  // SLTU, SLTIU (reutiliza código de OR)

    always @(*) begin
        case (alu_op)
            2'b00: alu_control = ALU_ADD; // ADD (para LW, SW, ADDI)
            2'b01: alu_control = ALU_SUB; // SUB (para branches)
            2'b10: begin // R-type instructions
                case (funct3) 
                    3'b000: alu_control = (!is_imm && funct7_5) ? ALU_SUB : ALU_ADD; // ADD/SUB
                    3'b001: alu_control = ALU_SLL; // SLL
                    3'b010: alu_control = ALU_SLT; // SLT
                    3'b011: alu_control = ALU_SLTU; // SLTU
                    3'b100: alu_control = ALU_XOR; // XOR
                    3'b101: alu_control = (!is_imm && funct7_5) ? ALU_SRA : ALU_SRL; // SRL/SRA
                    3'b110: alu_control = ALU_OR; // OR
                    3'b111: alu_control = ALU_AND; // AND   
                    default: alu_control = ALU_ADD; // Default (ADD)
                endcase
            end

            2'b11: begin // I-type instructions
                case (funct3)
                    3'b000: alu_control = ALU_ADD; // ADDI
                    3'b001: alu_control = ALU_SLL; // SLLI
                    3'b010: alu_control = ALU_SLT; // SLTI
                    3'b011: alu_control = ALU_SLTU; // SLTIU
                    3'b100: alu_control = ALU_XOR; // XORI
                    3'b101: alu_control = (funct7_5) ? ALU_SRA : ALU_SRL; // SRLI/SRAI
                    3'b110: alu_control = ALU_OR; // ORI
                    3'b111: alu_control = ALU_AND; // ANDI
                    default: alu_control = ALU_ADD; // Default (ADD)
                endcase
            end
            
            default: alu_control = ALU_ADD; // Default (ADD)
        endcase 
    end

endmodule