// 8 to 1 32-bit mux
// Cam Brown
`timescale 1ns/10ps

module mux_8t1_32 (x0, x1, x2, x3, x4, x5, x6, x7, sel, q);

    input [31:0] x0, x1, x2, x3, x4, x5, x6, x7;
    input [2:0] sel;
    output wire [31:0] q;

    wire [31:0] out;

    genvar i;

    generate
        for(i = 0; i < 32; i = i + 1) begin
            mux_8t1 mux_(.b0(x0[i]), .b1(x1[i]), .b2(x2[i]), .b3(x3[i]), .b4(x4[i]), .b5(x5[i]), .b6(x6[i]), .b7(x7[i]), .sel(sel), .q(out[i]));
        end
    endgenerate

    assign q = out;

endmodule