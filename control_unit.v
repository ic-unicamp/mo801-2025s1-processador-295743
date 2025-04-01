module ControlUnit(
    input 
        clock,
        reset,
        // mem_res,
        [2:0] funct3,
        [6:0] op,
    
    output reg 
        pc_write,      // atualiza o pc (após fetch ou salto)
        ir_write,     // habilita escrita no registrador de intrução
        pc_src,      // 00: PC+4, 01: branch, 10: jump
        reg_write,  // habilita we no banco de registradores
        mem_read, 
        is_imm,     // ativo se a instrução for de imediato
        mem_write, // habilita we da memória
        pc_upd,  // pc write cond
        alu_inp_selector, 
        [1:0] load_or_data, // load or data
        [1:0] alu_op, // 
        [2:0] alu_src_a, // operando da alu
        [2:0] alu_src_b, // operando da alu
        [2:0] reg_src,    // 0: ALU, 1: Memória mem to reg
        [3:0] cu_aluop
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

    always @(posedge clock) begin
        if (reset) 
            state = FETCH;
        else
            state = next_state;
    end

    // determinação do próximo estado
    always @(*) begin
        pc_write = 1'b0;
        ir_write = 1'b0;
        pc_src = 1'b0;
        reg_write = 1'b0;
        mem_read = 1'b0;
        is_imm = 1'b0;
        mem_write = 1'b0;
        pc_upd = 1'b0;
        alu_inp_selector = 1'b0;
        load_or_data = 2'b00;
        alu_op = 2'b00;
        alu_src_a = 3'b000;
        alu_src_b = 3'b000;
        reg_src = 3'b000;
        cu_aluop = = 4'b0000;

        next_state = FETCH;

        case (state)
            FETCH: 
                next_state = DECODE;
            DECODE: begin
                case (op)
                    LW: next_state = MEMADR;
                    SW: next_state = MEMADR;
                    RTYPE: next_state = EXECUTER;
                    ITYPE: next_state = EXECUTEI;
                    JALI: next_state = JAL;
                    BRANCHI: next_state = BRANCH;
                    AUIPCI: next_state = AUIPC;
                    LUII: next_state = LUI;
                    JALRI: next_state = JALR;
                    default: next_state = FETCH;
                endcase
            end

            MEMADR: next_state = (op == LW) ? MEMREAD : MEMWR;
            MEMREAD: next_state = MEMWB;
            MEMWB: next_state = FETCH;
            MEMWR: next_state = FETCH;
            EXECUTER: next_state = ALUWB;
            ALUWB: next_state = FETCH;
            EXECUTEI: next_state = ALUWB;
            JAL: next_state = ALUWB;
            BRANCH: next_state = FETCH;
            JALR: next_state = ALUWB;
            AUIPC: next_state = ALUWB;
            LUI: next_state = ALUWB;
            default: next_state = FETCH;
        endcase
    end

    // configuração dos sinais de controle
    always @(*) begin
        pc_write = 1'b0;
        ir_write = 1'b0;
        pc_src = 1'b0;
        reg_write = 1'b0;
        mem_read = 1'b0;
        is_imm = 1'b0;
        mem_write = 1'b0;
        pc_upd = 1'b0;
        alu_inp_selector = 1'b0;
        load_or_data = 2'b00;
        alu_op = 2'b00;
        alu_src_a = 3'b000;
        alu_src_b = 3'b000;
        reg_src = 3'b000;
        cu_aluop = = 4'b0000;
        
        case (state) 
            FETCH: begin
                mem_read = 1'b1;  // lê a memoria p pegar a instrução
                ir_write = 1'b1;
                pc_write = 1'b1; // atualiza pc
                alu_src_b = 3'b001; 
            end
            DECODE: begin
                alu_src_a = 3'b010; 
                alu_src_b = 3'b010;
            end
            MEMADR: begin
                alu_src_a = 3'b001;
                alu_src_b = 3'b010;
            end

            MEMREAD: begin
                mem_read = 1'b1;
                load_or_data = 2'b01;
            end

            MEMWR: begin
                mem_write = 1'b1;
                load_or_data = 2'b01;
            end   

            MEMWB: begin
                reg_write = 1'b1;
                reg_src = 3'b001; // memória
            end
            
            EXECUTER: begin
                alu_src_a = 3'b001;
                alu_op = 2'b10; // operação r-type
            end

            ALUWB: begin
                reg_write = 1'b1;
            end

            EXECUTEI: begin
                alu_src_a = 3'b001; //rs1
                alu_src_b = 3'b010; //immediate
                alu_op = 2'b10; // operação i-type
                is_imm = 1'b1;
            end

            JAL: begin
                alu_src_a = 3'b010;
                alu_src_b = 3'b001; 
                pc_write = 1'b1;
                pc_src = 1'b1;
            end

            BRANCH: begin
                alu_src_a = 3'b001;
                alu_op = 2'b01; //comparação
                pc_upd = 1'b1;
                pc_src = 1'b1; //desvio
            end

            JALR: begin
                alu_src_a = 3'b010;
                alu_src_b = 3'b001;
                pc_write = 1'b1;
                pc_src = 1'b1; // pc = rs1 + pffset
                is_imm = 1'b1;
            end

            AUIPC: begin
                alu_src_a = 3'b010; // pc
                alu_src_b = 3'b010; // imm << 12
            end

            LUI: begin
                alu_src_a = 3'b011; // zero
                alu_src_b = 3'b010; // imm << 12
            end
        endcase
    end

endmodule