module mux_32to1(sel, src,z);

input [4:0] sel;
input [31:0]src;
output wire z;




wire [15:0] B;
wire [15:0] s1;
wire [7:0] s2;
wire [7:0] s3;
wire [3:0] s4;
wire [3:0] s5;
wire [1:0] s6;
wire [1:0] s7;



genvar i;
assign B[15:0] = src[31:16];
for (i=0;i<16;i=i+1) begin
   mux mux_map0(.sel(sel[4]), .src0(src[i]), .src1(B[i]), .z(s1[i]));
end

assign s2[7:0] = s1[15:8];
for (i=0;i<8;i=i+1) begin
   mux mux_map1(.sel(sel[3]), .src0(s1[i]), .src1(s2[i]), .z(s3[i]));
end
   
assign s4[3:0] = s3[7:4];
for (i=0;i<4;i=i+1) begin
   mux mux_map2(.sel(sel[2]), .src0(s3[i]), .src1(s4[i]), .z(s5[i]));
end

assign s6[1:0] = s5[3:2];
for (i=0;i<2;i=i+1) begin
   mux mux_map3(.sel(sel[1]), .src0(s5[i]), .src1(s6[i]), .z(s7[i]));
end


mux mux_map4(.sel(sel[0]), .src0(s7[0]), .src1(s7[1]), .z(z));

endmodule

