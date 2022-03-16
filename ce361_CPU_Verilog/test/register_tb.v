`include "cpu/reg_file.v"
module register_tb();
    reg clk;
    reg we;
    reg [4:0] rw;
    reg [4:0] ra;
    reg [4:0] rb;
    reg [31:0] W;
    wire [31:0] A;
    wire [31:0] B;

    reg_file myReg (.clk(clk), .we(we), .rw(rw), .ra(ra), .rb(rb), .inW(W), .outA(A), .outB(B));

    initial begin
        clk = 0;
        forever begin
            #5
            clk = ~clk;
        end
    end

    initial begin
        #10
        ra = 5'b01010;
        rw = 5'b01010;
        W = 32'b00000000000000000000000000000010;
        we = 0;
        #10
        we = 1;
        #10
        we = 0;
        #10
        W = 32'b00000000000000000000000000000100;
        we = 1;
        #10
        we = 0;
        rb = 5'b01011;
        rw = 5'b01011;
        #10
        W = 32'b00000000000000000000000000010000;
        we = 1;
        #10
        we = 0;
        ra = 5'b00000;
        #10
        $stop;
    end
endmodule