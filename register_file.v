module RegisterFile(
    input clk,
    input resetn,
    input [4:0] read_reg1,
    input [4:0] read_reg2,
    input [4:0] write_reg,
    input write_enable,
    input [31:0] write_data,
    output [31:0] data_out1,
    output [31:0] data_out2
);
    integer i;
    reg [31:0] registers [0:31];

    // Leitura assíncrona (combinatorial)
    assign data_out1 = (read_reg1 == 5'd0) ? 32'd0 : registers[read_reg1];
    assign data_out2 = (read_reg2 == 5'd0) ? 32'd0 : registers[read_reg2];

    // Escrita síncrona com resetn
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            for (i = 1; i < 32; i = i + 1) 
                registers[i] = 32'd0;
        end else if (write_enable && write_reg != 5'd0) begin
            registers[write_reg] = write_data;
        end
    end
endmodule