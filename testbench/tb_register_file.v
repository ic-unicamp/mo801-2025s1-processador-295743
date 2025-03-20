module RegisterFileTB();
    integer i;
    reg clock;
    reg reset;
    reg [4:0] read_reg1;
    reg [4:0] read_reg2;
    reg [4:0] write_reg;
    reg write_enable;
    reg [31:0] write_data;
    wire [31:0] read_data1;
    wire [31:0] read_data2;


    always #1 clock = ~clock;


    RegisterFile reg_file(
        .clk(clock),
        .reset(reset),
        .read_reg1(read_reg1),
        .read_reg2(read_reg2),
        .write_reg(write_reg),
        .write_enable(write_enable),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    initial begin
        $dumpfile("tb_register_file.vcd");
        $dumpvars(0, RegisterFileTB);
        
        clock = 0;
        reset = 1; 
        #2;       
        reset = 0; 

        read_reg1 = 32'h0;
        read_reg2 = 32'h1;

        #1

        $display("Read the initial state of the registers\n");
        if(read_data1 == 32'h0) begin
            $display("Register 0 is correct\n");
        end else begin
            $display("Register 0 is not correct\n");
        end

        if(read_data2 == 32'h0) begin
            $display("Register 1 is correct\n");
        end else begin
            $display("Register 1 is not correct\n");
        end

        $display("Write on the registers\n");
        for(i = 0; i < 32; i = i + 1) begin
            write_reg = i;
            write_data = i;
            write_enable = 1'b1; // Habilita a escrita
            #2; // Garante que a escrita ocorra corretamente no clock
            write_enable = 1'b0; // Desabilita a escrita
            #1;
        end


        $display("Read the state of the registers after writing\n");
        for(i = 0; i < 32; i = i + 1) begin
            read_reg1 = i;
            #1
            if(read_data1 == i) begin
                $display("Register %d is correct\n", i);
            end else begin
                $display("Register %d is not correct\n", i);
            end
        end
        $finish;
    end



endmodule