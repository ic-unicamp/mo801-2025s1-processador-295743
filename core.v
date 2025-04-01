module core( // modulo de um core
  input clk, // clock
  input resetn, // reset que ativa em zero
  output reg [31:0] address, // endereço de saída
  output reg [31:0] data_out, // dado de saída
  input [31:0] data_in, // dado de entrada
  output reg we // write enable

  // control signal
  input clock, reset;

  // memory bus
  input mem_response,
  input [31:0] read_data,
  output mem_read, mem_write,
  output [2:0] option,
  output [31:0] address,
  output  [31:0] write_data,
);

wire 
  IRWrite, zero, reg_write, pc_load, and_zero_out, pc_write_cond, pc_write, is_imm,
  alu_in_sel, save_addr, control_mem_op, save_value1, save_value2, write_data_in, 
  save_write_value;

wire 
  [1:0] alu_op, load_or_data;
wire
  [2:0] alu_src_a, alu_src_b, reg_src, cu_memory_op;
wire
  [3:0] aluop_out, cu_aluop;
wire
  [31:0] pc_out, pc_inp, reg_inp, alu_inp_a, alu_inp_b, alu_out, immediate,
  reg_data1_out, reg_data2_out;

reg 
  [31:0] reg_instruction, reg_memory, reg_aluout, reg_data1, reg_data2, pc_old;

assign write_data = reg_data2;
assign option = (load_or_data == 2'b00 | control_mem_op == 1'b1) ? cu_memory_op : reg_instruction[14:12];

PC Pc(
  .clock(clock), 
  .reset(reset), 
  .pc_write(pc_load),
  .pc_in(pc_inp), 
  .pc_out(pc_out) 
);

Mux MemAddrMux(
  .option({1'b0, load_or_data}),
  .A(pc_out),
  .B(reg_aluout),
  .S(address)
);

Mux MemDataMux(
  .option(reg_src),
  .A(reg_aluout),
  .B(reg_memory),
  .D({16'h0000, alu_out_register[15:0]}),
  .E({24'h000000, alu_out_register[7:0]}),
  .F({{16{alu_out_register[15]}}, alu_out_register[15:0]}),
  .G({{24{alu_out_register[7]}}, alu_out_register[7:0]}),
  .S(reg_inp)
);

Mux AluInputAMux(
  .option(alu_src_a),
  .A(pc_out),
  .B(reg_data1),
  .C(pc_old),
  .D(32'd0),
  .E(reg_memory),
  .F(reg_aluout),
  .S(alu_inp_a)
);

Mux AluInputBMux(
  .option(alu_src_b),
  .A(reg_data2),
  .B(32'd4),
  .C(immediate),
  .S(alu_inp_b)
);

// PC Mux
assign pc_inp = (pc_out == 1'b1) ? reg_aluout : alu_out; 
and(and_zero_out, zero, pc_write_cond);
or(pc_load, pc_write, and_zero_out);

RegisterFile RegisterBank(
  .clk(clock),
  .reset(reset),
  .read_reg1(reg_instruction[19:15]),
  .read_reg2(reg_instruction[24:20]),
  .write_reg(reg_instruction[11:7]),
  .write_enable(write_enable),
  .write_data(reg_inp),
  .read_data1(reg_data1_out),
  .read_data2(reg_data2_out)
);

ControlUnit ControlUnit( 
  .clock(clock),
  .reset(clock),
  .mem_res(mem_response),
  .funct3(reg_instruction[14:12]),
  .op(reg_instruction[6:0]),
  .pc_write(pc_write), 
  .ir_write(IRWrite),
  .pc_src(pc_src), 
  .reg_write(reg_write), 
  .mem_read(mem_read),
  .mem_write(mem_write), 
  .pc_upd(pc_write_cond), 
  .load_or_data(load_or_data),
  .alu_op(alu_op),
  .alu_src_a(alu_src_a),
  .alu_src_b(alu_src_b),
  .reg_src(reg_src),
  .cu_aluop(cu_aluop)
);

ALUDecoder AluDecoder(
  .is_imm(is_imm),   
  .alu_op(alu_op),        
  .funct7(reg_instruction[31:25]),  
  .funct3(reg_instruction[14:12]),         
  .alu_out(alu_out)
);

ALU Alu(
  .src_a(alu_inp_a),
  .src_b(alu_inp_b),
  .alu_control(aluop_out), 
  .result(alu_out),
  .zero(zero)
);

ImmExt ImmExt (
    .instruction(reg_instruction),
    .imm_ext(immediate)
);


always @(posedge clk) begin
  if (resetn == 1'b0) begin
    address <= 32'h00000000;
  end else begin
    address <= address + 4;
  end
  we = 0;
  data_out = 32'h00000000;
end

endmodule
