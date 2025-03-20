// generate ALU signals
module ALUCDecoder(
    // inputs alu control
    input [1:0] alu_op, //signal comes from the control unit
    input [2:0] funct3 //signal comes from the instruction
    input [6:0] funct7, //signal comes from the instruction

    output [3:0] alu_control  // output alu control
);

    always @(*) begin
        case (alu_op)
            // lw, sw
            2'b00: begin 
                alu_control = 4'b0000; // ADD
            end
            // beq, bne, blt, bge, bltu, bgeu
            2'b01: begin
                alu_control = 4'b0110; // SUB
            end
            // jalr 
            
            2'b10: begin // R-type
                case (funct3)
                    3'b000: alu_control = 4'b0000; // ADD
                    3'b001: alu_control = 4'b0001; // SLL
                    3'b010: alu_control = 4'b0010; // SLT
                    3'b011: alu_control = 4'b0011; // SLTU
                    3'b100: alu_control = 4'b0100; // XOR
                    3'b101: alu_control = 4'b0101; // SRL
                    3'b110: alu_control = 4'b0110; // OR
                    3'b111: alu_control = 4'b0111; // AND
                    default: alu_control = 4'b0000; // ADD
                endcase
            end
            2'b01: begin
                alu_control = 4'b1000; // SUB
            end
            2'b10: begin
                case (funct7)
                    7'b0000000: alu_control = 4'b1001; // MUL
                    7'b0100000: alu_control = 4'b1010; // DIV
                    7'b0000001: alu_control = 4'b1011; // REM
                    default: alu_control = 4'b0000; // ADD
                endcase
            end
            default: alu_control = 4'b0000; // ADD
        endcase
    end


endmodule