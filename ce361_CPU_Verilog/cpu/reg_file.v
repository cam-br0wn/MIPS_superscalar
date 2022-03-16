// `include "cpu/reg_32.v"
// `include "extralib/and3to1.v"
// `include "extralib/mux32to1_32.v"
// `include "extralib/dec_n2.v"
module reg_file (clk, rw, ra, rb, we, outA, outB, inW);
	input clk;
	input we;
	input [4:0] rw;
	input [4:0] ra;
	input [4:0] rb;
	input [31:0] inW;
	output [31:0] outA;
	output [31:0] outB;

	// wire declaration
	wire [31:0] dec_out; // wires coming out of decoder
	wire [1023:0] reg_out; // these wires are outputs coming out of each individual register
	wire [31:0] write_to_reg; // these wires are to determine based on 3 conditions, if it should be written to (we = 1, the register is selected, and the clock)
	wire [31:0] mux_outA;
	wire [31:0] mux_outB;

	// decoder to determine which register to write to
	dec_n write_decoder (.src(rw), .z(dec_out));
	defparam write_decoder.n = 5;

	// setting values for write_to_reg(i)
	genvar i;
	generate
		for (i = 0; i < 32; i = i + 1) begin
			and3to1 we_and (.w(clk), .x(we), .y(dec_out[i]), .z(write_to_reg[i]));
		end
	endgenerate

	// declaring 32 register files
	// input is inW, clk (control signal) is one we generated previously
	// output is onto temporary wires
	genvar j;
	generate
		for (j = 0; j < 32; j = j + 1) begin
			reg_32 register (.clk(write_to_reg[j]), .d32(inW), .q32(reg_out[((j+1)*32-1):(j*32)]));
		end
	endgenerate

	// setting output for outA
	// STILL NEED TO DO
	mux32to1_32 muxA (.sel(ra), .s0(32'b00000000000000000000000000000000),
		.s1(reg_out[63:32]), .s2(reg_out[95:64]), .s3(reg_out[127:96]), .s4(reg_out[159:128]),
		.s5(reg_out[191:160]), .s6(reg_out[223:192]), .s7(reg_out[255:224]), .s8(reg_out[287:256]), .s9(reg_out[319:288]),
		.s10(reg_out[351:320]), .s11(reg_out[383:352]), .s12(reg_out[415:384]), .s13(reg_out[447:416]), .s14(reg_out[479:448]), .s15(reg_out[511:480]),
		.s16(reg_out[543:512]), .s17(reg_out[575:544]), .s18(reg_out[607:576]), .s19(reg_out[639:608]), .s20(reg_out[671:640]), .s21(reg_out[703:672]),
		.s22(reg_out[735:704]), .s23(reg_out[767:736]), .s24(reg_out[799:768]), .s25(reg_out[831:800]), .s26(reg_out[863:832]), .s27(reg_out[895:864]),
		.s28(reg_out[927:896]), .s29(reg_out[959:928]), .s30(reg_out[991:960]), .s31(reg_out[1023:992]), .out(mux_outA));

	mux32to1_32 muxB (.sel(rb), .s0(32'b00000000000000000000000000000000),
		.s1(reg_out[63:32]), .s2(reg_out[95:64]), .s3(reg_out[127:96]), .s4(reg_out[159:128]),
		.s5(reg_out[191:160]), .s6(reg_out[223:192]), .s7(reg_out[255:224]), .s8(reg_out[287:256]), .s9(reg_out[319:288]),
		.s10(reg_out[351:320]), .s11(reg_out[383:352]), .s12(reg_out[415:384]), .s13(reg_out[447:416]), .s14(reg_out[479:448]), .s15(reg_out[511:480]),
		.s16(reg_out[543:512]), .s17(reg_out[575:544]), .s18(reg_out[607:576]), .s19(reg_out[639:608]), .s20(reg_out[671:640]), .s21(reg_out[703:672]),
		.s22(reg_out[735:704]), .s23(reg_out[767:736]), .s24(reg_out[799:768]), .s25(reg_out[831:800]), .s26(reg_out[863:832]), .s27(reg_out[895:864]),
		.s28(reg_out[927:896]), .s29(reg_out[959:928]), .s30(reg_out[991:960]), .s31(reg_out[1023:992]), .out(mux_outB));

	assign outA = mux_outA;
	assign outB = mux_outB;
endmodule
