module ControlUnit(
    input 
        clock,
        reset,
        mem_res,
        [2:0] funct3,
        [6:0] op,
    
    output reg 
        pc_write, 
        ir_write,
        pc_src, // 00: PC+4, 01: branch, 10: jump
        reg_write, // habilita we do rf
        mem_read,
        mem_write, // habilita we da mem
        pc_upd, 
        // alu_in_sel, // seleciona a fonte do segundo operando da ALU
        [1:0] adr_src,
        [1:0] alu_op,
        [2:0] alu_src_a,
        [2:0] alu_src_b,
        [2:0] reg_src    // 0: ALU, 1: Memória
);
    // machine states1
    localparam [7:0]
        FETCH       = 6'b000000, // fetch instruction
        DECODE      = 6'b000001, // decode instruction
        MEMADR      = 6'b000010, // access memory
        MEMREAD     = 6'b000011, // read memory
        MEMWB       = 6'b000100, // write back memory
        MEMWR       = 6'b000101, // write memory
        EXECUTER    = 6'b000110, // execute R-type instruction
        ALUWB       = 6'b000111, // write back ALU
        EXECUTEI    = 6'b001000, // execute I-type instruction
        JAL         = 6'b001001, // jump and link
        BRANCH      = 6'b001010, // branch
        JALR        = 6'b001011, // jump and link register
        AUIPC       = 6'b001100, // add upper immediate to PC
        LUI         = 6'b001101; // load upper immediate

    // instructions opcodes
    localparam [8:0]
        LW      = 7'b0000011, // 0000011
        SW      = 7'b0100011, // 0100011
        RTYPE   = 7'b0110011, // 0110011
        ITYPE   = 7'b0010011, // 0010011
        JALI    = 7'b1101111, // 1101111
        BRANCHI = 7'b1100011, // 1100011
        JALRI   = 7'b1100111,
        AUIPCI  = 7'b0010111,
        LUII    = 7'b0110111;


    reg [5:0] state, next_state;

    // initial begin
    //     state = FETCH;
    //     next_state = FETCH;
    //     pc_write = 1'b0;
    //     pc_src = 1'b0;
    //     reg_write = 1'b0;
    //     adr_src = 1'b0;
    //     mem_write = 1'b0; 
    //     branch = 1'b0;
    //     result_src = 2'b00;
    //     alu_control = 3'b00;
    //     alu_src_a = 2'b00;
    //     alu_src_b = 2'b00;
    //     reg_src = 3'b000;
    //     control_unit_aluop = 4'b0000;
    // end

    always @(posedge clock or posedge reset) begin
        if (reset) 
            state = FETCH;
        else
            state = next_state;
    end

    always @(*) begin
        case (state)
            FETCH: begin
                // adr_src = 1'b0;
                // alu_src_a = 2'b00;
                // alu_src_b = 2'b10;
                // alu_control = 2'b00; // eq alu_op
                // result_src = 2'b00;
                // ir_write = 1'b1;
                // pc_upd = 1'b1; // eq pc_write

                ir_write = 1'b1;
                pc_upd = 1'b1;
                alu_src_a = 2'b00;  // PC
                alu_src_b = 2'b01;   // +4
                alu_control = 4'b0010; // ADD
                next_state = STATE_DECODE;

                // op = mem[pc]; pc = pc + 4;
            end

            STATE_DECODE: begin
                alu_src_a = 2'b01; // pc
                alu_src_b = 2'b10; // imm -- offset 
                alu_control = 4'b0010; // add -- calcular branch target

                case (op) 
                    LW : next_state = STATE_MEMADR;
                    SW : next_state = STATE_MEMADR;
                    RTYPE : next_state =  STATE_EXECUTER;
                    ITYPE : next_state = STATE_EXECUTEI;
                    JAL : next_state = STATE_JAL;
                    BEQ : next_state = STATE_BEQ;
                    // AUIPCI : next_state = STATE_AUIPC;
                    // LUII : next_state = STATE_LUI;
                    // JALRI : next_state = STATE_JALR;
                    default: next_state = FETCH;
                endcase

                // alu_out = pc_target;
            end

            STATE_MEMADR : begin
                alu_src_a = 2'b001;
                alu_src_b = 2'b010;
                alu_control = 2'b00;
                case (op)
                    LW: next_state = STATE_MEMREAD;
                    SW: next_state = STATE_MEMWRITE;
                endcase
                // alu_out = rs1 + imm;
            end

            STATE_MEMREAD : begin
                result_src = 2'b00;
                adr_src = 1'b1;
                state = STATE_MEMWB;
                // data = mem[alu_out];
            end

            STATE_MEMWB: begin
                result_src = 2'b01;
                reg_write = 1'b1;
                state = FETCH;
                // rd = data;
            end

            STATE_MEMWRITE: begin
                result_src = 2'b00;
                adr_src = 1'b1;
                mem_write = 1'b1;
                next_state = FETCH;
                // mem[alu_out] = rd;
            end

            STATE_EXECUTER: begin
                alu_src_a = 2'b10;
                alu_src_b = 2'b00;
                alu_control = 2'b10;
                next_state = STATE_ALUWB;
                // alu_out = rs1oprs2;
            end

            STATE_EXECUTEI: begin
                alu_src_a = 2'b10;
                alu_src_b = 2'b01;
                alu_control = 2'b10;
                next_state = STATE_ALUWB;
                // alu_out = rs1opimm;
            end

            STATE_JAL: begin
                alu_src_a = 2'b10;
                alu_src_b = 2'b01;
                alu_control = 2'b10;
                next_state = FETCH;
                // pc = alu_out; alu_out = pc + 4;
            end

            STATE_ALUWB: begin 
                result_src = 2'b00;
                reg_write = 1'b1; 
                next_state = FETCH;
                // rd = alu_out;
            end
            
            STATE_BEQ: begin
                alu_src_a = 2'b10;
                alu_src_b = 2'b00;
                alu_control = 2'b01;
                result_src = 2'b00;
                branch = 1'b1;
                next_state =  FETCH;
                // alu_result = rs1 - rs2; pc = (zero) ? alu_out;
            end
            default: 
                next_state = FETCH;
        endcase
    end

    always @(*) begin
        pc_write = 1'b0; 
        ir_write = 1'b0;
        pc_src = 1'b0;
        reg_write = 1'b0;
        mem_read = 1'b0; 
        mem_write = 1'b0;
        pc_upd = 1'b0;
        // alu_in_sel, // seleciona a fonte do segundo operando da ALU
        adr_src = 2'b00;
        alu_op = 2'b00;
        alu_src_a = 3'b000;
        alu_src_b = 3'b000;
        reg_src   = 3'b000;
        

        case (state) 
            FETCH: begin
                mem_read = 1'b1;
                adr_src = 2'b00;
                ir_write = 1'b1;
                pc_write = 1'b1;
                alu_src_b = 3'b001; //pc = pc+4
            end
            DECODE: begin
                alu_src_a = 3'b001; // rs1
                alu_src_b = 3'b100; // immediate
            end
            MEMADR: begin
                mem_read = 1'b1;
                adr_src = 2'b01;
            end
            MEMWR: begin
                mem_write = 1'b1;
                adr_src = 2'b01;
            end   
            MEMWB: begin
                reg_write = 1'b1;
                reg_src = 3'b001; // memória
            end
            EXECUTER: begin
                alu_src_a = 3'b001; //rs1
                alu_src_b = 3'b000; //rs2 
                alu_op = 2'b10; // operação r-type
            end
            ALUWB: begin
                reg_write = 1'b1;
                reg_src = 3'b000; // ALU
            end
            EXECUTEI: begin
                alu_src_a = 3'b001; //rs1
                alu_src_b = 3'b010; //immediate
                alu_op = 2'b10; // operação i-type
            end
            JAL: begin
                pc_write = 1'b1;
                pc_src = 1'b1; // pc = pc + offset
                reg_write = 1'b1;
                reg_src = 3'b010; // p+4
            end
            BRANCH: begin
                alu_op = 2'b01; //comparação
                pc_upd = 1'b1;
                pc_src = 1'b1; //desvio
            end
            JALR: begin
                pc_write = 1'b1;
                pc_src = 1'b1; // pc = rs1 + pffset
                reg_write = 1'b1;
                reg_src = 3'b010; // pc+4
            end
            AUIPC: begin
                alu_src_a = 3'b010; // pc
                alu_src_b = 3'b011; // imm << 12
                reg_write = 1'b1;
            end

            LUI: begin
                alu_src_a = 3'b100; // zero
                alu_src_b = 3'b011; // imm << 12
                reg_write = 1'b1;
            end
        endcase
    end
endmodule