// 8 to 1 1-bit mux
// Cam Brown
`timescale 1ns/10ps

module mux_8t1 (b0, b1, b2, b3, b4, b5, b6, b7, sel, q);

    input b0, b1, b2, b3, b4, b5, b6, b7;
    input [2:0] sel;
    output wire q;

    wire w0_00;
    wire w1_00;
    wire w2_01;
    wire w3_01;
    wire w00_000;
    wire w01_000;
    wire out;

    mux mux_0(.sel(sel[0]), .src0(b0), .src1(b1), .z(w0_00));
    mux mux_1(.sel(sel[0]), .src0(b2), .src1(b3), .z(w1_00));
    mux mux_2(.sel(sel[0]), .src0(b4), .src1(b5), .z(w2_01));
    mux mux_3(.sel(sel[0]), .src0(b6), .src1(b7), .z(w3_01));
    mux mux_00(.sel(sel[1]), .src0(w0_00), .src1(w1_00), .z(w00_000));
    mux mux_01(.sel(sel[1]), .src0(w2_01), .src1(w3_01), .z(w01_000));
    mux mux_000(.sel(sel[2]), .src0(w00_000), .src1(w01_000), .z(out));

    assign q = out;


endmodule