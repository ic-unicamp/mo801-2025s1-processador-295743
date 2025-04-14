module ALUDecoder(   
    input is_imm,   
    input [1:0] alu_op,        
    input [6:0] funct7,  
    input [2:0] funct3,         
    output reg [3:0] alu_out  
);

    localparam [3:0] 
        ADD  = 4'b0010,  // ADD, ADDI, LW, SW
        SUB  = 4'b0110,  // SUB, branches
        BGE  = 4'b0111,  // SLT, SLTI 
        BGEU = 4'b1111,  // SLTU, SLTIU 
        XOR  = 4'b1010,  // XOR, XORI
        SLL  = 4'b1000,  // SLL, SLLI
        SRL  = 4'b1001,  // SRL, SRLI
        SRA  = 4'b0011,  // SRA, SRAI
        OR   = 4'b0001,  // OR, ORI
        AND  = 4'b0000,  // AND, ANDI
        BLT  = 4'b1011,
        BLTU = 4'b1101,
        SLT = 4'b0111,
        SLTU = 4'b1111,
        EQ = 4'b1110;


    always @(*) begin

        case (alu_op)
            2'b00: 
                alu_out = ADD; 
            2'b01:  // beq 
                case (funct3) 
                    3'b000: //beq
                        alu_out = SUB;
                    3'b100: // blt
                        alu_out =  BLT;
                    3'b110: // bltu
                        alu_out = BLTU;
                    3'b101: //bge
                        alu_out = BGE;
                    3'b111:
                        alu_out = BGEU;
                    3'b001: //bne -- igualdade
                        alu_out = EQ;
                    default: alu_out = SUB;
                endcase
            
            2'b10: begin 
                case (funct3)
                    3'b000: alu_out = ((is_imm==1'b0) && (funct7[5]==1'b1)) ? SUB : ADD; // SUB/ADD
                    3'b001: alu_out = SLL; 
                    3'b010: alu_out = SLT;
                    3'b011: alu_out = SLTU; 
                    3'b100: alu_out = XOR;
                    3'b101: alu_out = (funct7[5]==1'b1) ? 4'b0011 : 4'b1001; // SRA/SRL
                    3'b110: alu_out = OR;
                    3'b111: alu_out = AND;
                    default: alu_out = ADD; // Default (ADD)
                endcase
            end
            default: 
                alu_out = ADD;
        endcase
    end

endmodule