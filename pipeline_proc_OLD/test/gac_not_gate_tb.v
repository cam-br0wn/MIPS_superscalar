`timescale 1ns/10ps

module gac_not_gate_tb;
    reg [5:0] x;
    wire [5:0] z;

    gac_not_gate_6_BHV test(
        x,
        z
    );
    
    initial begin
        x = 6'b101010;
        #5
        x = 6'b111111;
        #5
        x = 6'b000000;
        #5
        x = 6'b000111;
        #5
        x = 6'b111000;
        #5
        $finish;
    end
endmodule