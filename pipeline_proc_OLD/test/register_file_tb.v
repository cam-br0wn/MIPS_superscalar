// Register file testbench
`timescale 1ns/10ps

module register_file_tb;

reg [4:0] read_reg1, read_reg2, write_reg;
reg [31:0] write_data;
reg clk, write_enable;
wire [31:0] read_data1, read_data2;

register_file test(
        clk,
        read_reg1,
        read_reg2,
        write_reg,
        write_data,
        write_enable,
        read_data1,
        read_data2
    );

initial begin
    clk = 0;
    read_reg1 = 5'h3;
    read_reg2 = 5'h2;
    write_reg = 5'h2;
    write_data = 32'hFFFFFFFF;
    write_enable = 1'b1;

    #10
    write_reg = 5'h3;
    write_data = 32'hA;

    #10
    write_reg = 5'h2;
    write_enable = 1'b0;
    write_data = 32'h03;

    #10
    read_reg1 = 5'h0;
    write_enable = 1'b0;
    write_data = 32'h03;
    #30
    $finish;
end

always #5 clk = ~clk;

endmodule // register_file_tb
