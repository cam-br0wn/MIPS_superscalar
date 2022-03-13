`timescale 1ns/10ps

module register_tb;

    reg clk, areset, aload; 
    reg [31:0] adata, data_in;
    reg write_enable;
    wire [31:0] data_out;

    register test(
        clk,
        areset,
        aload,
        adata,
        data_in,
        write_enable,
        data_out
    );

    initial begin
        clk = 0;
        areset = 0;
        aload = 0;
        adata = 32'h246B780F;
        data_in = 32'hDAAB4620;
        write_enable = 1;
        #11
        data_in = 32'h12345678;
        #10
        write_enable = 0;
        data_in = 32'h87654321;
        #10;
        areset = 1;        
        #10
        areset = 0;
        write_enable = 1;
        #10
        aload = 1;
        #30
        $finish;


    end

    always #5 clk = ~clk;
endmodule
