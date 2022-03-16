module mux16to1_32 (sel, s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, out);
	input [3:0] sel;
	input [31:0] s0;
	input [31:0] s1;
	input [31:0] s2;
	input [31:0] s3;
	input [31:0] s4;
	input [31:0] s5;
	input [31:0] s6;
	input [31:0] s7;
	input [31:0] s8;
	input [31:0] s9;
	input [31:0] s10;
	input [31:0] s11;
	input [31:0] s12;
	input [31:0] s13;
	input [31:0] s14;
	input [31:0] s15;
	output [31:0] out;

	wire [31:0] muxres0;
	wire [31:0] muxres1;
	wire [31:0] muxres2;
	wire [31:0] muxres3;
	wire [31:0] muxres4;

	mux4to1_32 mux0(.sel(sel[1:0]), .s0(s0), .s1(s1), .s2(s2), .s3(s3), .out(muxres0));
	mux4to1_32 mux1(.sel(sel[1:0]), .s0(s4), .s1(s5), .s2(s6), .s3(s7), .out(muxres1));
	mux4to1_32 mux2(.sel(sel[1:0]), .s0(s8), .s1(s9), .s2(s10), .s3(s11), .out(muxres2));
	mux4to1_32 mux3(.sel(sel[1:0]), .s0(s12), .s1(s13), .s2(s14), .s3(s15), .out(muxres3));
	mux4to1_32 mux4(.sel(sel[3:2]), .s0(muxres0), .s1(muxres1), .s2(muxres2), .s3(muxres3), .out(muxres4));

	assign out = muxres4;
endmodule
