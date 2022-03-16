module mux32to1_32 (sel, s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31, out);
	input [4:0] sel;
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
	input [31:0] s16;
	input [31:0] s17;
	input [31:0] s18;
	input [31:0] s19;
	input [31:0] s20;
	input [31:0] s21;
	input [31:0] s22;
	input [31:0] s23;
	input [31:0] s24;
	input [31:0] s25;
	input [31:0] s26;
	input [31:0] s27;
	input [31:0] s28;
	input [31:0] s29;
	input [31:0] s30;
	input [31:0] s31;
	output [31:0] out;

	wire [31:0] muxres0;
	wire [31:0] muxres1;
	wire [31:0] muxres2;

	mux16to1_32 mux0(.sel(sel[3:0]), .s0(s0), .s1(s1), .s2(s2), .s3(s3), .s4(s4), .s5(s5), .s6(s6), .s7(s7), .s8(s8), .s9(s9), .s10(s10), .s11(s11), .s12(s12), .s13(s13), .s14(s14), .s15(s15), .out(muxres0));
	mux16to1_32 mux1 (.sel(sel[3:0]), .s0(s16), .s1(s17), .s2(s18), .s3(s19), .s4(s20), .s5(s21), .s6(s22), .s7(s23), .s8(s24), .s9(s25), .s10(s26), .s11(s27), .s12(s28), .s13(s29), .s14(s30), .s15(s31), .out(muxres1));
	mux_32 mux2 (.sel(sel[4]), .src0(muxres0), .src1(muxres1), .z(muxres2));

	assign out = muxres2;

endmodule
