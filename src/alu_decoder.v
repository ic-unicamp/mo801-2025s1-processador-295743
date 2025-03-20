// generate ALU signals
module ALUCDecoder(
    // inputs alu control
    input op5, //Representa o bit mais significativo do campo opcode. O valor X indica um valor não relevante para a decisão (não importa).
    input [1:0] alu_op, //signal comes from the control unit
    input [2:0] funct3 //signal comes from the instruction
    input [6:0] funct7, //signal comes from the instruction

    output [2:0] alu_control  // output alu control
);
    // FALTA ADICIONAR AS OUTRAS OPERAÇÕES DAS INTRUÇÕES RV321
    always @(*) begin
        case (alu_op)
            // lw, sw
            2'b00: begin 
                alu_control = 3'b010; // ADD
            end
            // beq
            2'b01: begin
                alu_control = 3'b110; // SUB
            end
            2'b10: begin
                case (funct3) 
                    3'b000: begin // addi, add e sub
                        if (!op5 && funct7[5]) 
                            alu_control = 3'b110; // sub
                        else 
                            alu_control = 3'b010; // add
                    end
                    3'b010: begin // slli e sll
                        alu_control = 3'b111; // slt
                    end 
                    3'b110: begin 
                        alu_control = 3'b001; // or
                    end
                    3'b111: begin
                        alu_control = 3'b000; // and
                    end
                    default: 
                        alu_control = 3'b010; // and

                endcase
            end
            
        endcase 
           
    end


endmodule