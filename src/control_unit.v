// start: 20 march 2025
module ControlUnit(
    input 
        clock,
        reset,
        mem_response,
        [6:0] op,
        [2:0] funct3,
    
    output reg 
        pc_write,
        ir_write,
        pc_src, 
        reg_write,
        mem_read,
        is_imm, 
        mem_write, 
        branch, // write to PC if branch is taken
        alu_input_sel, // select ALU input
        [1:0] lorD, 
        [1:0] alu_op,
        [1:0] alu_src_a,
        [1:0] alu_src_b,
        [2:0] mem_to_reg, //Memory to register selector
        [3:0] control_unit_aluop, 
    
);

    // machine states
    localparam 
        STATE_FETCH         = 6'b000000, // fetch instruction
        STATE_DECODE        = 6'b000001, // decode instruction
        STATE_MEMADR        = 6'b000010, // access memory
        STATE_MEMREAD       = 6'b000011, // read memory
        STATE_MEMWB         = 6'b000100, // write back memory
        STATE_MEMWRITE      = 6'b000101, // write memory
        STATE_EXECUTER      = 6'b000110, // execute R-type instruction
        STATE_ALUWB         = 6'b000111, // write back ALU
        STATE_EXECUTEI      = 6'b001000, // execute I-type instruction
        STATE_JAL           = 6'b001001, // jump and link
        STATE_BEQ           = 6'b001010, // branch
        STATE_JALR          = 6'b001011, // jump and link register
        STATE_AUIPC         = 6'b001100, // add upper immediate to PC
        STATE_LUI           = 6'b001101, // load upper immediate
        STATE_JALR_PC       = 6'b001110, // jump and link register to PC
  
    // instructions opcodes
    localparam 
        LW      = 7'b0000011,
        SW      = 7'b0100011,
        RTYPE   = 7'b0110011,
        ITYPE   = 7'b0010011,
        JALI    = 7'b1101111,
        BRANCHI = 7'b1100011,
        JALRI   = 7'b1100111,
        AUIPCI  = 7'b0010111,
        LUII    = 7'b0110111,
        CSR     = 7'b1110011;


    reg [5:0] state, next_state;

    initial begin
        state = STATE_FETCH;
        next_state = STATE_FETCH;
        pc_write = 1'b0;
        pc_src = 1'b0;
        reg_write = 1'b0;
        mem_read = 1'b0;
        is_imm = 1'b0;
        mem_write = 1'b0; 
        branch = 1'b0;
        alu_input_sel = 1'b0;
        lorD = 2'b00 
        alu_op = 2'b00;
        alu_src_a = 2'b00;
        alu_src_b = 2'b00;
        mem_to_reg = 3'b000;
        control_unit_aluop = 4'b0000;
    end

    always @(posedge clock) begin
        if (reset) 
            state = STATE_FETCH;
        else 
            state = next_state;
    end

    always @(*) begin
        next_state = STATE_FETCH;
        case (state)
            STATE_FETCH: begin
                next_state =  (mem_response) ? STATE_DECODE : STATE_FETCH;
            end
            STATE_DECODE: begin
                case (op) 
                    LW : next_state = STATE_MEMADR;
                    SW : next_state = STATE_MEMADR;

                    RTYPE : next_state =  STATE_EXECUTER;

                    ITYPE : next_state = STATE_EXECUTEI;
                    JALI : next_state = STATE_JAL;
                    BRANCHI : next_state = STATE_BEQ;
                    AUIPCI : next_state = STATE_AUIPC;
                    LUII : next_state = STATE_LUI;
                    JALRI : next_state = STATE_JALR;
                    default: next_state = STATE_FETCH;
                endcase

            end

            STATE_MEMADR : begin
                op == LW ? next_state = STATE_MEMREAD : next_state = STATE_MEMWRITE;
            end

            STATE_MEMREAD : begin
                next_state =  (mem_response) ? STATE_MEMWB : STATE_MEMREAD;
            end

            STATE_MEMWB: 
                next_state = STATE_FETCH;

            STATE_MEMWRITE:
                next_state = (mem_response) ? STATE_FETCH : STATE_MEMWRITE;

            STATE_EXECUTER: 
                next_state = STATE_ALUWB;
            STATE_ALUWB:   
                next_state = STATE_FETCH;
            STATE_EXECUTEI:
                next_state = STATE_ALUWB;
            STATE_JAL:
                next_state = STATE_ALUWB;
            STATE_BEQ:
                next_state = STATE_FETCH;
            STATE_JALR:
                next_state = STATE_ALUWB;
            STATE_AUIPC:
                next_state = STATE_ALUWB;
            STATE_LUI:
                next_state = STATE_ALUWB;
            
            default: next_state = STATE_FETCH;
        endcase
    end

    // definition of control signals for each state 
    always @(*) begin
        pc_write = 1'b0;
        ir_write = 1'b0;
        lorD = 2'b00;
        mem_read = 1'b0;
        mem_write = 1'b0;
        mem_to_reg = 3'b000;
        pc_src = 1'b0;
        alu_op = 2'b00;
        alu_src_a = 2'b00;
        alu_src_b = 2'b00;
        reg_write = 1'b0;
        is_imm = 1'b0;

        case (state) 
            STATE_FETCH: begin
                mem_read = 1'b1;
            end
            STATE_DECODE: begin
                alu_src_a = 3'b010;
                alu_src_b = 3'b010;
            end
            STATE_MEMADR: begin
                alu_src_a = 3'b001;
                alu_src_b = 3'b010;
            end
            STATE_MEMREAD: begin
                mem_read = 1'b1;
                lorD = 2'b01;
            end
            STATE_MEMWRITE: begin
                mem_write = 1'b1;
                lorD = 2'b01;
            end
            STATE_MEMWB: begin
                reg_write = 1'b1;
                mem_to_reg = 3'b001;
            end
            STATE_EXECUTER: begin
                alu_src_a = 3'b001;
                alu_op = 2'b10;
            end
            STATE_ALUWB: begin
                reg_write = 1'b1;
            end
            STATE_EXECUTEI: begin
                alu_src_a = 3'b001;
                alu_src_b = 3'b010;
                alu_op = 2'b10;
                is_imm = 1'b1;
            end
            STATE_JAL: begin
                alu_src_a = 3'b010;
                alu_src_b = 3'b001;
                pc_write = 1'b1;
                pc_src = 1'b1;
            end
            STATE_BEQ: begin
                alu_src_a = 3'b001;
                alu_op = 2'b01;
                branch = 1'b1;
                pc_src = 1'b1;
            end
            STATE_JALR: begin
                alu_src_a = 3'b010;
                alu_src_b = 3'b001;
                pc_write = 1'b1;
                pc_src = 1'b1;
                is_imm = 1'b1;
            end
            STATE_AUIPC: begin
                alu_src_a = 3'b010;
                alu_src_b = 3'b010;
            end
            STATE_LUI: begin
                alu_src_a = 3'b011;
                alu_src_b = 3'b010;
            end
            
        endcase
    end

endmodule