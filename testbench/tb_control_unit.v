// start: 20 march 2025
module ControlUnit(
    input clock,
    input reset,
    input [6:0] opcode,

    output reg result_src,
    output reg [3:0] alu_op,
    output reg write_enable,
    output reg [4:0] write_reg,
    output reg [4:0] read_reg1,
    output reg [4:0] read_reg2
);

    // RV32I OPCODES DEFINITIONS
    localparam OPCODE_R_TYPE = 7'b0110011; // R-type instructions
    localparam OPCODE_I_TYPE = 7'b0010011; // I-type instructions
    localparam OPCODE_LUI    = 7'b0110111; // Load Upper Immediate (LUI)
    localparam OPCODE_AUIPC  = 7'b0010111; // Add Upper Immediate to PC
    localparam OPCODE_JAL    = 7'b1101111; // Jump and Link
    localparam OPCODE_JALR   = 7'b1100111; // Jump and Link Register
    localparam OPCODE_BRANCH = 7'b1100011; // Branch
    localparam OPCODE_LOAD   = 7'b0000011; // Load
    localparam OPCODE_STORE  = 7'b0100011; // Store

    // control logic
    always @(posedge clock or posedge reset) begin
        if(reset) begin
            // resete all control signals
            result_src = 1'b0;
            alu_op = 4'b0000;
            write_enable = 1'b0;
            write_reg = 5'b00000;
            read_reg1 = 5'b00000;
            read_reg2 = 5'b00000;
        end else begin
            // decode opcode and set control signals
            case(opcode)
                OPCODE_R_TYPE: begin
                    result_src = 1'b1;
                    alu_op = 4'b0000; // OP_ADD
                    write_enable = 1'b1;
                    write_reg = 5'b00000;
                    read_reg1 = 5'b00000;
                    read_reg2 = 5'b00000;
                end
                OPCODE_I_TYPE: begin
                    result_src = 1'b1;
                    alu_op = 4'b0000; // OP_ADD
                    write_enable = 1'b1;
                    write_reg = 5'b00000;
                    read_reg1 = 5'b00000;
                    read_reg2 = 5'b00000;
                end
                OPCODE_LUI: begin
                    result_src = 1'b0;
                    alu_op = 4'b0000; // OP_ADD
                    write_enable = 1'b1;
                    write_reg = 5'b00000;
                    read_reg1 = 5'b00000;
                    read_reg2 = 5'b00000;
                end
                OPCODE_AUIPC: begin
                    result_src = 1'b0;
                    alu_op = 4'b0000; // OP_ADD
                    write_enable = 1'b1;
                    write_reg = 5'b00000;
                    read_reg1 = 5'b00000;
                    read_reg2 = 5'b00000;
                end
                OPCODE_JAL: begin
                    result_src = 1'b0;
                    alu_op = 4'b0000; // OP_ADD
                    write_enable = 1'b1;
                    write_reg = 5'b00000;
                    read_reg1 = 5'b00000;
                    read_reg2 = 5'b00000;
                end
                OPCODE_JALR: begin
                    result_src = 1'b0;
                    alu_op = 4'b0000; // OP_ADD
                    write_enable = 1'b1;
                    write_reg = 5'b00000;
                    read_reg1 = 5'b00000;
                    read_reg2 = 5'b00000;
                end
                OPCODE_BRANCH: begin
                    result_src = 1'b0;
                    alu_op = 4'b0000; // OP_ADD
                    write_enable = 1
                end
            endcase

        end

    end

endmodule