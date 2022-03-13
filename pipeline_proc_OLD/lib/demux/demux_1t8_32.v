// 32-bit 1-to-8 demux
module demux_1t8_32 (s, d, y_arr);

input [2:0] s;
input wire [31:0] d;
output wire [31:0] y_arr[7:0];

wire [31:0] dm_y0, dm_y1, dm_y00, dm_y01, dm_y02, dm_y03;

// first layer, a 1-to-2
demux_1t2_32 demux_(.s(s[2]), .d(d), .y0(dm_y0), .y1(dm_y1));

// second layer, two 1-to-2's
demux_1t2_32 demux_0_(.s(s[1]), .d(dm_y0), .y0(dm_y00), .y1(dm_y01));
demux_1t2_32 demux_1_(.s(s[1]), .d(dm_y1), .y0(dm_y02), .y1(dm_y03));

// third layer, four 1-to-2's
demux_1t2_32 demux_a_(.s(s[0]), .d(dm_y00), .y0(y_arr[0]), .y1(y_arr[1]));
demux_1t2_32 demux_b_(.s(s[0]), .d(dm_y01), .y0(y_arr[2]), .y1(y_arr[3]));
demux_1t2_32 demux_c_(.s(s[0]), .d(dm_y02), .y0(y_arr[4]), .y1(y_arr[5]));
demux_1t2_32 demux_d_(.s(s[0]), .d(dm_y03), .y0(y_arr[6]), .y1(y_arr[7]));

endmodule