module core( // modulo de um core
  input clk, // clk
  input resetn, // resetn que ativa em zero
  output wire [31:0] address, // endereço de saída
  output wire [31:0] data_out, // dado de saída
  input [31:0] data_in, // dado de entrada
  output wire we // write enable  
);

// sinais de controle
wire ir_write, zero, reg_write, pc_load, pc_src, pc_write, is_imm, branch_signal;
wire [1:0] alu_op, adr_src;
wire [2:0] alu_src_a, alu_src_b, reg_src;
wire [3:0] alu_control;


// sinais de dados
wire [31:0] pc_out, pc_in, reg_in, alu_in_a, alu_in_b, alu_out, immediate;
wire [31:0] reg_data1, reg_data2, rd;
reg [31:0]  ir, mdr, alu_result, a_reg, b_reg, old_pc;
// rs1 rs2 rd 

// // sinais da alu
// wire [31:0] alu_in_a, alu_in_b;

assign data_out = b_reg;

PC Pc(
  .clk(clk), 
  .resetn(resetn), 
  .pc_load(pc_load),
  .pc_in(pc_in), 
  .pc_out(pc_out) 
);

Mux MemAddrMux(
  .option({1'b0, adr_src}),
  .A(pc_out),
  .B(alu_result),
  .S(address)
);

Mux MemDataMux(
  .option(reg_src),
  .A(alu_result),
  .B(mdr),
  .C(0),
  .D({16'h0000, alu_result[15:0]}),
  .E({24'h000000, alu_result[7:0]}),
  .F({{16{alu_result[15]}}, alu_result[15:0]}),
  .G({{24{alu_result[7]}}, alu_result[7:0]}),
  .H(0),
  .S(reg_in)
);

// mux para entrada a da alu
Mux AluAMux(
  .option(alu_src_a),
  .A(pc_out),
  .B(a_reg),
  .C(old_pc),
  .D(32'd0),
  .E(mdr),
  .F(alu_result),
  .S(alu_in_a)
);

// mux para entrada b da alu
Mux AluBMux(
  .option(alu_src_b),
  .A(b_reg),
  .B(32'd4),
  .C(immediate),
  .D(0),
  .E(0),
  .F(0),
  .G(0),
  .H(0),
  .S(alu_in_b)
);

assign pc_in = (pc_out == 32'b1) ? alu_result : alu_out;
assign pc_load = (zero & pc_src) | pc_write;



RegisterFile RegisterBank(
  .clk(clk),
  .resetn(resetn),
  .read_reg1(ir[19:15]),
  .read_reg2(ir[24:20]),
  .write_reg(ir[11:7]),
  .write_enable(reg_write),
  .write_data(reg_in),
  .data_out1(reg_data1),
  .data_out2(reg_data2)
);

ControlUnit ControlUnit(
  .clk(clk), 
  .resetn(resetn),
  .funct3(ir[14:12]),
  .op(ir[6:0]),
  .PCWrite(pc_write),   
  .IRWrite(ir_write),  
  .PCSrc(pc_src),  
  .RegWrite(reg_write),  
  .Imm(is_imm), 
  .MemWrite(we),   
  .Branch(branch_signal),
  .AdrSrc(adr_src),   
  .ALUOp(alu_op),
  .ALUSrcA(alu_src_a),    
  .ALUSrcB(alu_src_b),  
  .ResultSrc(reg_src)
);

ImmExt ImmExt (
  .instruction(ir),
  .imm_ext(immediate)
);


ALUDecoder AluDecoder(
  .is_imm(is_imm),   
  .alu_op(alu_op),        
  .funct7(ir[31:25]),  
  .funct3(ir[14:12]),         
  .alu_out(alu_control)
);

ALU Alu(
  .src_a(alu_in_a),
  .src_b(alu_in_b),
  .alu_control(alu_control), 
  .result(alu_out),
  .zero(zero)
);


always @(posedge clk) begin
  // $display("Time=%0t PC out: 0x%h, old pc: 0x%h, ir: 0x%h, ir_write: %b", $time, pc_out, old_pc, ir, ir_write);
  if (resetn == 1'b0) begin
    ir = 32'h00000000;
    mdr = 32'h00000000;
    alu_result = 32'h00000000;
    a_reg = 32'h00000000;
    b_reg = 32'h00000000;
    old_pc = 32'h00000000;
  end else begin
    if (ir_write) begin
      ir = data_in;
      old_pc = pc_out;
    end
    mdr = data_in;
    a_reg = reg_data1;
    b_reg = reg_data2;
    alu_result = alu_out;
  end
end

endmodule
