module ControlUnit(
    input clk, resetn,
    input [2:0] funct3,
    input [6:0] op,
   
    output reg PCWrite,   
    output reg IRWrite,  
    output reg PCSrc,  
    output reg RegWrite,  
    output reg Imm, 
    output reg MemWrite,   
    output reg Branch,

    output reg [1:0] AdrSrc,   
    output reg [1:0] ALUOp,

    output reg [2:0] ALUSrcA,    // operando ALU A
    output reg [2:0] ALUSrcB,   // operando da ALU
    output reg [2:0] ResultSrc

);
    // Estados da máquina de estados
    localparam [3:0]
        FETCH       = 4'b0000, 
        DECODE      = 4'b0001, 
        MEMADR      = 4'b0010, 
        MEMREAD     = 4'b0011,
        MEMWB       = 4'b0100, 
        MEMWR       = 4'b0101, 
        EXECUTER    = 4'b0110, 
        ALUWB       = 4'b0111, 
        EXECUTEI    = 4'b1000, 
        JAL         = 4'b1001,
        BRANCH      = 4'b1010, 
        JALR        = 4'b1011, 
        AUIPC       = 4'b1100, 
        LUI         = 4'b1101,
        EXCEPTION   = 4'b1110; 

    // Instruções opcodes
    // verificar os opcodes
    localparam [6:0]
        LW      = 7'b0000011,
        SW      = 7'b0100011,
        RTYPE   = 7'b0110011, // 0110011 
        ITYPE   = 7'b0010011,
        JAL_OP  = 7'b1101111,
        BRANCHI = 7'b1100011,
        JALRI   = 7'b1100111,
        AUIPCI  = 7'b0010111, // 0010111
        LUII    = 7'b0110111, // 0110111
        OP_EBREAK  = 7'b1110011; // 1110011

    reg [3:0] state, next_state; 

    always @(posedge clk) begin
        // $display("=== Time=%0t State=%b Opcode=%b PCWrite=%b PCSrc=%b MemWrite=%b", $time,  state, op,  PCWrite, PCSrc, MemWrite);
        if (resetn == 1'b0) 
            state = FETCH;
        else
            state = next_state;
    end

    always @(*) begin
        case (state)
            FETCH: next_state = DECODE;
            DECODE: begin
            if (op == 7'b1110011) begin
                next_state = EXCEPTION; // Transição para o estado EXCEPTION
            end else begin
            case (op)
                LW: next_state = MEMADR;
                SW: next_state = MEMADR;
                RTYPE: next_state = EXECUTER;
                ITYPE: next_state = EXECUTEI;
                JAL_OP: next_state = JAL;
                BRANCHI: next_state = BRANCH;
                AUIPCI: next_state = AUIPC;
                LUII: next_state = LUI;
                JALRI: next_state = JALR;
                default: next_state = FETCH;
                    endcase
                end
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

    always @(*) begin
        PCWrite = 1'b0;
        IRWrite = 1'b0;
        RegWrite = 1'b0;
        MemWrite = 1'b0;
        PCSrc = 1'b0;
        Imm = 1'b0;
        Branch = 1'b0;
        AdrSrc = 2'b00;
        ALUOp = 2'b00;
        ResultSrc = 3'b000;
        ALUSrcA = 3'b000;
        ALUSrcB = 3'b000;

        case (state) 
            FETCH: begin
                IRWrite = 1'b1;    
                PCWrite = 1'b1;  
                ALUSrcB = 3'b001;
            end

            DECODE: begin 
                ALUSrcA = 3'b010;  
                ALUSrcB = 3'b010; 
            end

            MEMADR: begin
                ALUSrcA = 3'b001; 
                ALUSrcB = 3'b010; 
            end

            MEMREAD: begin
                AdrSrc = 2'b01;  
            end

            MEMWR: begin
                MemWrite = 1'b1;
                AdrSrc = 2'b01;  
            end

            MEMWB: begin
                RegWrite = 1'b1;
                ResultSrc = 3'b001; 
            end

            EXECUTER: begin
                ALUSrcA = 3'b001; 
                ALUOp = 2'b10;     
            end

            ALUWB: begin
                RegWrite = 1'b1;
            end

            EXECUTEI: begin
                ALUSrcA = 3'b001;
                ALUSrcB = 3'b010;
                ALUOp = 2'b10;    
                Imm = 1'b1;
            end

        
                        
            JAL: begin
                ALUSrcA = 3'b010; // old_pc
                ALUSrcB = 3'b001; // 4
                PCWrite = 1'b1;
                PCSrc = 1'b1;
            end



            BRANCH: begin
                ALUSrcA = 3'b001; 
                ALUOp = 2'b01;     
                Branch = 1'b1;
                PCSrc = 1'b1;     
            end

            JALR: begin
                ALUSrcA = 3'b010; 
                ALUSrcB = 3'b001; 
                PCWrite = 1'b1; 
                PCSrc = 1'b1;
                Imm = 1'b1;
            end

            AUIPC: begin
                ALUSrcA = 3'b010; 
                ALUSrcB = 3'b010; 
            end

            LUI: begin
                ALUSrcA = 3'b011; 
                ALUSrcB = 3'b010; 
            end
            EXCEPTION: begin
                $finish;
            end
        endcase
    end
endmodule