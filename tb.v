module tb();

reg clk, resetn;
wire we;
wire [31:0] address, data_out, data_in;

core dut(
  .clk(clk),
  .resetn(resetn),
  .address(address),
  .data_out(data_out),
  .data_in(data_in),
  .we(we)
);

memory m(
  .clk(clk),
  .address(address),
  .data_in(data_out),
  .data_out(data_in),
  .we(we) 
);

// Clock generator
always #1 clk = (clk===1'b0);

// Inicia a simulação e executa até 2000 unidades de tempo após o reset
initial begin
  $dumpfile("saida.vcd");
  $dumpvars(0, tb);
  resetn = 1'b0;
  #11 resetn = 1'b1;
  // $monitor("=== Time=%0t: address=%h pc:%h ir:%h imm:%h alu result:%h", $time, dut.address, dut.current_pc, dut.ir, dut.immediate, dut.alu_result);
  // $monitor("=== Time=%0t: address=%d pc:%d  old_pc:%d ir:%h ", $time, dut.address, dut.current_pc, dut.old_pc, dut.ir);
  // $monitor("=== x4 = %h", tb.dut.RegisterBank.registers[4]);
  // $monitor("=== Time=%0t: pc=%h ir=%h x2=%h x3=%h alu_out=%h alu_result=%h pc_src=%h zero:%h", 
  // $time, dut.current_pc, dut.ir, dut.RegisterBank.registers[2], dut.RegisterBank.registers[3], dut.alu_out, dut.alu_result, dut.pc_src, dut.zero);
  // $monitor("=== Time=%0t pc=%h ir=%h alu_src_b=%b immediate=%h alu_in_b=%h", 
  // $time, dut.current_pc, dut.ir, dut.alu_src_b, dut.immediate, dut.alu_in_b);

  $display("*** Starting simulation. ***");
  #4000 $finish;
end

// Verifica se o endereço atingiu 4092 (0xFFC) e encerra a simulação
always @(posedge clk) begin
  if (address == 'hFFC ) begin
    $display("Address reached 4092 (0xFFC). Stopping simulation.");
    $finish;
  end
  else if (address[11] == 1)
    if (we == 1)
      $display("=== M[0x%h] <- 0x%h", address, data_out);
    // else
    //   $display("=== M[0x%h] -> 0x%h", address, data_in);
end

endmodule
