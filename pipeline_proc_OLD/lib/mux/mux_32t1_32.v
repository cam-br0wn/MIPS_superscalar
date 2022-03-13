// 32-to-1 32-bit mux
`timescale 1ns/10ps

module mux_32t1_32(sel, x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, xA, xB, xC, xD, xE, xF, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x1A, x1B, x1C, x1D, x1E, x1F, q);

input [31:0] x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, xA, xB, xC, xD, xE, xF, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x1A, x1B, x1C, x1D, x1E, x1F;
input [4:0] sel;
output wire [31:0] q;

wire [31:0] q0, q1, q2, q3, q10, q11;

// first layer
mux_8t1_32 mux_0_(.x0(x0), .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7), .sel(sel[2:0]), .q(q0));
mux_8t1_32 mux_1_(.x0(x8), .x1(x9), .x2(xA), .x3(xB), .x4(xC), .x5(xD), .x6(xE), .x7(xF), .sel(sel[2:0]), .q(q1));
mux_8t1_32 mux_2_(.x0(x10), .x1(x11), .x2(x12), .x3(x13), .x4(x14), .x5(x15), .x6(x16), .x7(x17), .sel(sel[2:0]), .q(q2));
mux_8t1_32 mux_3_(.x0(x18), .x1(x19), .x2(x1A), .x3(x1B), .x4(x1C), .x5(x1D), .x6(x1E), .x7(x1F), .sel(sel[2:0]), .q(q3));

// second layer
mux_32 mux_4_(.sel(sel[3]), .src0(q0), .src1(q1), .z(q10));
mux_32 mux_5_(.sel(sel[3]), .src0(q2), .src1(q3), .z(q11));

// third layer
mux_32 mux_6_(.sel(sel[4]), .src0(q10), .src1(q11), .z(q));

endmodule
