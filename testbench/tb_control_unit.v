`timescale 1ns / 1ps

module ControlUnit_tb;
    reg clock;
    reg reset;
    reg [2:0] funct3;
    reg [6:0] op;
    reg funct7_5;
    
    wire PCWrite;     // atualiza o PC (após fetch ou salto)
    wire IRWrite;     // habilita escrita no registrador de instrução
    wire PCSrc;       // Seleção da origem do PC
    wire RegWrite;    // habilita WE no banco de registradores
    wire Imm;         // habilita uso de imediato
    wire MemWrite;    // habilita WE da memória
    wire Branch;      // sinal de branch
    wire [1:0] AdrSrc; // Seleção da origem do endereço
    wire [1:0] ALUOp;  // Operação da ALU
    wire [2:0] ALUSrcA; // seleção de operando ALU A
    wire [2:0] ALUSrcB; // seleção de operando ALU B
    wire [2:0] ResultSrc; // Seleciona fonte do resultado

    ControlUnit uut (
        .clock(clock),
        .reset(reset),
        .funct3(funct3),
        .op(op),
        .funct7_5(funct7_5),
        .PCWrite(PCWrite),
        .IRWrite(IRWrite),
        .PCSrc(PCSrc),
        .RegWrite(RegWrite),
        .Imm(Imm),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .AdrSrc(AdrSrc),
        .ALUOp(ALUOp),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ResultSrc(ResultSrc)
    );

    always begin
        #5 clock = ~clock;
    end

    // Test procedure
    initial begin
        // Initialize Inputs
        clock = 0;
        reset = 1;
        funct3 = 0;
        op = 0;
        funct7_5 = 0;
        
        // Wait for global reset
        #10;
        reset = 0;
        
        // Monitor changes
        $monitor("Time=%0t State=%b Op=%b PCWrite=%b RegWrite=%b MemWrite=%b",
                 $time, uut.state, op, PCWrite, RegWrite, MemWrite);
        
        // Test sequence
        $display("=== TEST 1: LW Instruction ===");
        op = 7'b0000011; // LW
        #20;
        
        $display("=== TEST 2: SW Instruction ===");
        op = 7'b0100011; // SW
        #20;
        
        $display("=== TEST 3: R-type Instruction ===");
        op = 7'b0110011; // RTYPE
        funct3 = 3'b000; // ADD
        #20;
        
        $display("=== TEST 4: I-type Instruction ===");
        op = 7'b0010011; // ITYPE
        funct3 = 3'b000; // ADDI
        #20;
        
        $display("=== TEST 5: JAL Instruction ===");
        op = 7'b1101111; // JAL
        #20;
        
        $display("=== TEST 6: BRANCH Instruction ===");
        op = 7'b1100011; // BRANCH
        funct3 = 3'b000; // BEQ
        #20;
        
        $display("=== TEST 7: JALR Instruction ===");
        op = 7'b1100111; // JALR
        #20;
        
        $display("=== TEST 8: AUIPC Instruction ===");
        op = 7'b0010111; // AUIPC
        #20;
        
        $display("=== TEST 9: LUI Instruction ===");
        op = 7'b0110111; // LUI
        #20;
        
        $display("=== All tests completed ===");
        $finish;
    end

    // Additional checks
    always @(posedge clock) begin
        if (reset) begin
            #1;
            if (uut.state !== uut.FETCH) begin
                $display("Error: Reset failed to set state to FETCH");
                $finish;
            end
        end
    end

endmodule