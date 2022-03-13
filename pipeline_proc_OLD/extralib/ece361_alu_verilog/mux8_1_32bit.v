module mux8_1_32bit(sel, src_in0, src_in1, src_in2,src_in3,src_in4,src_in5,src_in6,src_in7,z);
    
    input [2:0] sel;
    input [31:0] src_in0;
    input [31:0] src_in1;
    input [31:0] src_in2;
    input [31:0] src_in3;
    input [31:0] src_in4;
    input [31:0] src_in5;
    input [31:0] src_in6;
    input [31:0] src_in7;
    output wire [31:0] z;
    
    wire [31:0] s0;
    wire [31:0] s1;
    wire [31:0] s2;
    wire [31:0] s3;
    wire [31:0] s4;
    wire [31:0] s5;
    
    mux_32 mux_map0(.sel(sel[0]), .src0(src_in0), .src1(src_in1), .z(s0));
    
    mux_32 mux_map1(.sel(sel[0]), .src0(src_in2), .src1(src_in3), .z(s1));
    
    mux_32 mux_map2(.sel(sel[0]), .src0(src_in4), .src1(src_in5), .z(s2));
    
    mux_32 mux_map3(.sel(sel[0]), .src0(src_in6), .src1(src_in7), .z(s3));
    
    mux_32 mux_map4(.sel(sel[1]), .src0(s0), .src1(s1), .z(s4));
    
    mux_32 mux_map5(.sel(sel[1]), .src0(s2), .src1(s3), .z(s5));
    
    mux_32 mux_map6(.sel(sel[2]), .src0(s4), .src1(s5), .z(z));
    
    
endmodule
