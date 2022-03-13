// 1-bit 1-to-2 demux
module demux_1t2(s, d, y0, y1);

input s;
input d;
output wire y0, y1;

wire not_s;

not_gate not_s_(.x(s), .z(not_s));
and_gate nsAd_(.x(not_s), .y(d), .z(y0));
and_gate sAd_(.x(s), .y(d), .z(y1));

endmodule