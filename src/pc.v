module PC(
    input clock,
    input reset,
    input pc_write, // ativo quando o PC deve ser atualizado
    input [31:0] next_pc, // próximo valor do PC
    output reg [31:0] current_pc // valor atual do PC
);

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            current_pc = 32'h00000000;
        end
        else if (pc_write) begin
            current_pc = next_pc; // Atualiza o PC
        end
    end


endmodule