// 32-bit 1-to-4 demux
module demux_1t4_32 (s, d, y_arr);

input [1:0] s;
input wire [31:0] d;
output wire [31:0] y_arr[3:0];

wire [31:0] dm_y0, dm_y1;

// first layer, a 1-to-2
demux_1t2_32 demux_(.s(s[1]), .d(d), .y0(dm_y0), .y1(dm_y1));

// second layer, two 1-to-2's
demux_1t2_32 demux_0(.s(s[0]), .d(dm_y0), .y0(y_arr[0]), .y1(y_arr[1]));
demux_1t2_32 demux_1(.s(s[0]), .d(dm_y1), .y0(y_arr[2]), .y1(y_arr[3]));


endmodule