`timescale 1ns/10ps

module sign_ext_tb;

    //reg clk; //not sure if clocked.  Extender not clocked. 
    reg [15:0] a; // 16-bit signal to be extended on the msb
    wire [31:0] a_ext; //output

    sign_ext test(
        a,
        a_ext
    );

    initial begin
        a = 16'h1234; // positive
        #10
        a = 16'h8765; // negative
        #10
        $finish;
    end

endmodule
