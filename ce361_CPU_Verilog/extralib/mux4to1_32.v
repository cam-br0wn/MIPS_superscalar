module mux4to1_32 (sel, s0, s1, s2, s3, out);
	input [1:0] sel;
	input [31:0] s0;
	input [31:0] s1;
	input [31:0] s2;
	input [31:0] s3;
	output [31:0] out;

	wire [31:0] muxres0;
	wire [31:0] muxres1;
	wire [31:0] muxres2;

	mux_32 mux1 (.sel(sel[0]), .src0(s0), .src1(s1), .z(muxres0));
	mux_32 mux2 (.sel(sel[0]), .src0(s2), .src1(s3), .z(muxres1));
	mux_32 mux3 (.sel(sel[1]), .src0(muxres0), .src1(muxres1), .z(muxres2));

	assign out = muxres2;
endmodule
