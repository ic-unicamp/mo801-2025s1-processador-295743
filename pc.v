module PC(
    input clock, reset, pc_write,
    input [31:0] pc_in, 
    output reg [31:0] pc_out 
);

    always @(posedge clock) begin
    if (reset) 
        pc_out <= 32'h00000000;
    else if (pc_write) // Só atualiza se pc_write estiver ativo
        pc_out <= pc_in; 
    end


endmodule