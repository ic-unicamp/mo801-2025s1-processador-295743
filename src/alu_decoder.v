module ALUDecoder(
    input is_imm,              
    input [6:0] funct7,  
    input [2:0] funct3,         
    input [1:0] alu_op,        
    output reg [3:0] alu_out  
);

    localparam [3:0] 
        ADD  = 4'b0010,  // ADD, ADDI, LW, SW
        SUB  = 4'b0110,  // SUB, branches
        SLT  = 4'b0111,  // SLT, SLTI 
        SLTU = 4'b1111,  // SLTU, SLTIU 
        XOR  = 4'b1010,  // XOR, XORI
        SLL  = 4'b1000,  // SLL, SLLI
        SRL  = 4'b1001,  // SRL, SRLI
        SRA  = 4'b0011,  // SRA, SRAI
        OR   = 4'b0001,  // OR, ORI
        AND  = 4'b0000,  // AND, ANDI
        EQ   = 4'b1110,  // BEQ
        GE   = 4'b1011,  // BGE
        GEU  = 4'b1101;  // BGEU

    always @(*) begin

        case (alu_op)
            alu_out = ADD;
            2'b00: alu_out = 4'b0010; 
            2'b01: begin
                case (funct3)
                    3'b000: alu_out = SUB; 
                    3'b001: alu_out = EQ;
                    3'b100: alu_out = GE;
                    3'b110: alu_out = GEU;
                    3'b101: alu_out = SLT;
                    3'b111: alu_out = SLTU;
                    default: alu_out = SUB; // Default (SUB)
                endcase
            end
            
            2'b10: begin // R-type instructions
                case (funct3)
                    3'b000: alu_out = ((is_imm==1'b0) && (funct7[5] == 1'b1)) ? SUB : ADD;
                    3'b001: alu_out = SLL; 
                    3'b010: alu_out = SLT;
                    3'b011: alu_out = SLTU; 
                    3'b100: alu_out = XOR;
                    3'b101: alu_out = (funct7[5] == 1'b1) ? SRA : SRL;
                    3'b110: alu_out = OR;
                    3'b111: alu_out = AND;
                    default: alu_out = ADD; // Default (ADD)
                endcase
            end
        endcase
    end

endmodule