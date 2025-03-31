module Mux(
    input [2:0] option,
    input [31:0] A,
    input [31:0] B,
    input [31:0] C,
    input [31:0] D,
    input [31:0] E,
    input [31:0] F,
    input [31:0] G,
    input [31:0] H,
    output [31:0] A,
);

always @(*) begin
    case  (option)
        3'b000: S = A;
        3'b001: S = B;
        3'b010: S = C;
        3'b011: S = D;
        3'b100: S = E;
        3'b101: S = F;
        3'b110: S = G;
        3'b111: S = H;
        default: S = A;
    endcase
end

endmodule