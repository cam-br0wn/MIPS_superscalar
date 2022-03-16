//`include "cpu/ifu.v"

module ifu_tb;
    reg clk;
    reg [1:0] branch;
    reg zero, msb;
    reg pc_ld;
    reg [31:0] pc_data;
    wire [31:0] instr_tb;

    ifu ifu_t(.clk(clk), .branch(branch), .zero(zero), .msb(msb), .pc_ld(pc_ld), .pc_data(pc_data), .instr(instr_tb));

    initial begin
        clk = 0;
        forever begin
            #5
            clk = ~clk;
        end
    end

    initial begin
        pc_ld = 0;
        pc_data = 30'b100000000000000001000;
        branch = 1'b0;
        zero = 1'b0;
        #1
        pc_ld = 1;
        #4
        pc_ld = 0;
        #5
        #10
        #10
        #10
        #10
        #10
        #10
        branch = 1;
        zero = 1;
        #10
        branch = 0;
        zero = 0;
        #10
        branch = 1;
        zero = 1;
        #10
        branch = 0;
        zero = 0;
        #10
        #10
        $stop;
    end
endmodule