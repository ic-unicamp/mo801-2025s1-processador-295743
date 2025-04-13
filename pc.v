module PC(
    input clk, resetn, enable_pc_update,
    input [31:0] next_pc_value, 
    output reg [31:0] current_pc 
);

    always @(posedge clk) begin
    if (resetn == 1'b0) 
        current_pc = 32'h00000000;
    else if (enable_pc_update)
        current_pc = next_pc_value;
        // $display("pc out: %h <- pc in: %h", current_pc, next_pc_value);
    end


endmodule