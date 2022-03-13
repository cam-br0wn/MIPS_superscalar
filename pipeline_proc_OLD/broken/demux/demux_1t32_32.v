// 32-bit 1-to-32 demux
module demux_1t32_32(s, d, y_arr);

input [4:0] s;
input wire [31:0] d;
output wire [31:0] y_arr[31:0];

wire [31:0] dm_x0[3:0], dm_y0a[7:0], dm_y0b[7:0], dm_y0c[7:0];
wire [31:0] dm_y0d[7:0];

// first layer, a 1-to-4
demux_1t4_32 demux_(.s(s[4:3]), .d(d), .y_arr(dm_x0[3:0][31:0]));

// second layer, four 1-to-8's
demux_1t8_32 demux_0(.s(s[2:0]), .d(dm_x0[0]), .y_arr(dm_y0a[7:0][31:0]));
demux_1t8_32 demux_1(.s(s[2:0]), .d(dm_x0[1]), .y_arr(dm_y0b[7:0][31:0]));
demux_1t8_32 demux_2(.s(s[2:0]), .d(dm_x0[2]), .y_arr(dm_y0c[7:0][31:0]));
demux_1t8_32 demux_3(.s(s[2:0]), .d(dm_x0[3]), .y_arr(dm_y0d[7:0][31:0]));

genvar i, j;
generate
    for (i = 0; i < 32; i = i + 1) begin
        if (i < 8) begin
            assign y_arr[i] = dm_y0a[i];
        end
        else if (i < 16) begin
            assign y_arr[i] = dm_y0b[i % 8];
        end
        else if (i < 24) begin
            assign y_arr[i] = dm_y0c[i % 8];
        end
        else begin
            assign y_arr[i] = dm_y0d[i % 8];
        end
    end
endgenerate

endmodule