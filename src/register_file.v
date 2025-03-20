module RegisterFile(

    input clk,
    input reset,

    input wire [4:0] read_reg1,     // endereço do reg da porta 1
    input wire [4:0] read_reg2,     // endereco do reg da porta 2
    input wire [4:0] write_reg,     // endereco do reg de escrita

    input wire write_enable,        // habilita escrita 
    
    input wire [31:0] write_data,   // dado a ser escrito
    output wire [31:0] read_data1,  // dado lido da porta 1
    output wire [31:0] read_data2   // dado lido da porta 2
);
    integer i;

    reg [31:0] registers [0:31]; // 32 registradores de 32 bits

    // registrador x0 deve ser zero
    initial begin
        registers[0] = 32'd0;
    end

    // leitura sincrona dos registradores via endereco
    assign read_data1 = registers[read_reg1];
    assign read_data2 = registers[read_reg2];

    // escrita sincrona no registrador via endereco
    always @(posedge clk) begin
        if(reset) begin
            for(i = 0; i < 32; i = i + 1) 
                registers[i] = 32'd0;
        end else if(write_enable && write_reg != 5'd0) begin
            registers[write_reg] = write_data;
        end
    end



endmodule