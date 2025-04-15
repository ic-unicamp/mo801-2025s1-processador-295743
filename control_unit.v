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
    output reg [2:0] ALUSrcA,
    output reg [2:0] ALUSrcB,
    output reg [2:0] ResultSrc
);

    localparam [4:0]
        FETCH          = 5'b00000,
        VALIDATE_FETCH = 5'b00001,
        DECODE         = 5'b00010,
        MEMADR         = 5'b00011,
        MEMREAD        = 5'b00100,
        MEMWB          = 5'b00101,
        MEMWR          = 5'b00110,
        EXECUTER       = 5'b00111,
        ALUWB          = 5'b01000,
        EXECUTEI       = 5'b01001,
        JAL            = 5'b01010,
        BRANCH         = 5'b01011,
        JALR           = 5'b01100,
        AUIPC          = 5'b01101,
        LUI            = 5'b01110,
        EXCEPTION      = 5'b01111;

    localparam [6:0]
        LW      = 7'b0000011,
        SW      = 7'b0100011,
        RTYPE   = 7'b0110011,
        ITYPE   = 7'b0010011,
        JAL_OP  = 7'b1101111,
        BRANCHI = 7'b1100011,
        JALRI   = 7'b1100111,
        AUIPCI  = 7'b0010111,
        LUII    = 7'b0110111,
        OP_EBREAK = 7'b1110011;

    reg [4:0] state, next_state;

    always @(posedge clk) begin
        if (!resetn)
            state = FETCH;
        else
            state = next_state;
    end

    always @(*) begin
        case (state)
            FETCH:          next_state = VALIDATE_FETCH;
            VALIDATE_FETCH: next_state = DECODE;
            DECODE: begin
                if (op == OP_EBREAK) next_state = EXCEPTION;
                else case (op)
                    LW:       next_state = MEMADR;
                    SW:       next_state = MEMADR;
                    RTYPE:    next_state = EXECUTER;
                    ITYPE:    next_state = EXECUTEI;
                    JAL_OP:   next_state = JAL;
                    BRANCHI:  next_state = BRANCH;
                    AUIPCI:   next_state = AUIPC;
                    LUII:     next_state = LUI;
                    JALRI:    next_state = JALR;
                    default:  next_state = FETCH;
                endcase
            end
            MEMADR:      next_state = (op == LW) ? MEMREAD : MEMWR;
            MEMREAD:     next_state = MEMWB;
            MEMWB:       next_state = FETCH;
            MEMWR:       next_state = FETCH;
            EXECUTER:    next_state = ALUWB;
            ALUWB:       next_state = FETCH;
            EXECUTEI:    next_state = ALUWB;
            JAL:         next_state = FETCH;
            BRANCH:      next_state = FETCH;
            JALR:        next_state = ALUWB;
            AUIPC:       next_state = ALUWB;
            LUI:         next_state = ALUWB;
            EXCEPTION:   next_state = FETCH;
            default:     next_state = FETCH;
        endcase
    end

    always @(*) begin
        // defaults
        PCWrite = 0; IRWrite = 0; RegWrite = 0; MemWrite = 0;
        PCSrc = 0; Imm = 0; Branch = 0;
        AdrSrc = 2'b00; ALUOp = 2'b00;
        ResultSrc = 3'b000; ALUSrcA = 3'b000; ALUSrcB = 3'b000;

        case (state)
            FETCH: begin
                ALUSrcB = 3'b001; // PC + 4
            end

            VALIDATE_FETCH: begin
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
                ALUSrcA = 3'b010;
                ALUSrcB = 3'b001;
                PCWrite = 1'b1;
                PCSrc = 1'b0;
                RegWrite = 1'b1;
                ResultSrc = 3'b010;
            end

            BRANCH: begin
                ALUSrcA = 3'b001;
                ALUSrcB = 3'b000;
                ALUOp   = 2'b01;
                Branch  = 1'b1;
                PCSrc   = 1'b1;
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
