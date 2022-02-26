// testing out GTKWave
`timescale 1ns/10ps
module basic_and(a, b, y);

    input a, b;
    output y;

    initial begin
        assign y = a & b;
    end
endmodule