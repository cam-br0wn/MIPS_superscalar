module mux8_1_1bit(sel, src_in0, src_in1, src_in2,src_in3,src_in4,src_in5,src_in6,src_in7,z);
    
    input [2:0] sel;
    input src_in0;
    input src_in1;
    input src_in2;
    input src_in3;
    input src_in4;
    input src_in5;
    input src_in6;
    input src_in7;
    output wire z;
    
    wire s0;
    wire s1;
    wire s2;
    wire s3;
    wire s4;
    wire s5;
    
    mux mux_map0(.sel(sel[0]), .src0(src_in0), .src1(src_in1), .z(s0));
    
    mux mux_map1(.sel(sel[0]), .src0(src_in2), .src1(src_in3), .z(s1));
    
    mux mux_map2(.sel(sel[0]), .src0(src_in4), .src1(src_in5), .z(s2));
    
    mux mux_map3(.sel(sel[0]), .src0(src_in6), .src1(src_in7), .z(s3));
    
    mux mux_map4(.sel(sel[1]), .src0(s0), .src1(s1), .z(s4));
    
    mux mux_map5(.sel(sel[1]), .src0(s2), .src1(s3), .z(s5));
    
    mux mux_map6(.sel(sel[2]), .src0(s4), .src1(s5), .z(z));
    
    
endmodule
