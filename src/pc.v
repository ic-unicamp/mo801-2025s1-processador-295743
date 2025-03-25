module PC(
    input clock,
    input load, 
    input reset,
    input [31:0] next_pc, // próximo valor do PC
    output reg [31:0] current_pc // valor atual do PC
);

    initial begin
        current_pc = 32'h00000000;
    end


    always @(posedge clock) begin
        if (reset) begin
            current_pc = 32'h00000000;
        end
        else if (load == 1'b1) begin
            current_pc = next_pc; // Atualiza o PC
        end
    end


endmodule