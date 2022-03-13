// 32-bit 1-to-2 demux
module demux_1t2_32(s, d, y0, y1);

input s;
input wire [31:0] d;
output wire [31:0] y0, y1;

genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin
        demux_1t2 demux_(.s(s), .d(d[i]), .y0(y0[i]), .y1(y1[i]));
    end
endgenerate

endmodule