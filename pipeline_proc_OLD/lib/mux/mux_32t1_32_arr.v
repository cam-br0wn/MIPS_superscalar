// Module for a 32-bit 32-to-1 multiplexor using a single 2D array as input

module mux_32t1_32_arr(sel, in_arr, q);

input [4:0] sel;
input [31:0] in_arr[31:0];
output wire [31:0] q;

wire [31:0] q0, q1, q2, q3, q10, q11;

// first layer
mux_8t1_32 mux_0_(.x0(in_arr[0]), .x1(in_arr[1]), .x2(in_arr[2]), .x3(in_arr[3]), .x4(in_arr[4]), .x5(in_arr[5]), .x6(in_arr[6]), .x7(in_arr[7]), .sel(sel[2:0]), .q(q0));
mux_8t1_32 mux_1_(.x0(in_arr[8]), .x1(in_arr[9]), .x2(in_arr[10]), .x3(in_arr[11]), .x4(in_arr[12]), .x5(in_arr[13]), .x6(in_arr[14]), .x7(in_arr[15]), .sel(sel[2:0]), .q(q1));
mux_8t1_32 mux_2_(.x0(in_arr[16]), .x1(in_arr[17]), .x2(in_arr[18]), .x3(in_arr[19]), .x4(in_arr[20]), .x5(in_arr[21]), .x6(in_arr[22]), .x7(in_arr[23]), .sel(sel[2:0]), .q(q2));
mux_8t1_32 mux_3_(.x0(in_arr[24]), .x1(in_arr[25]), .x2(in_arr[26]), .x3(in_arr[27]), .x4(in_arr[28]), .x5(in_arr[29]), .x6(in_arr[30]), .x7(in_arr[31]), .sel(sel[2:0]), .q(q3));

// second layer
mux_32 mux_4_(.sel(sel[3]), .src0(q0), .src1(q1), .q(q10));
mux_32 mux_5_(.sel(sel[3]), .src0(q2), .src1(q3), .q(q11));

// third layer
mux_32 mux_6_(.sel(sel[4]), .src0(q10), .src1(q11), .q(q));

endmodule