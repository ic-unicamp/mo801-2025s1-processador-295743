module PC(
    input clk, resetn, pc_load,
    input [31:0] pc_in, 
    output reg [31:0] pc_out 
);

    always @(posedge clk or negedge resetn) begin
    if (resetn == 1'b0) 
        pc_out = 32'h00000000;
    else if (pc_load)
        pc_out = pc_in;
        // $display("PC atualizado: %h", pc_in); 
    end


endmodule