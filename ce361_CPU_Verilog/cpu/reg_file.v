// `include "cpu/reg_32.v"
// `include "extralib/and3to1.v"
// `include "extralib/mux32to1_32.v"
// `include "extralib/dec_n2.v"
module reg_file (clk, rw1, rw2, rw3, ra1, ra2, ra3, rb1, rb2, rb3, we1, we2, we3, outA1, outA2, outA3, outB1, outB2, outB3, inW1, inW2, inW3);
	input clk;

	input we1; // write enable for each pipeline
	input we2;
	input we3;

	input [4:0] rw1; // register to write to for each pipeline
	input [4:0] rw2;
	input [4:0] rw3;

	input [4:0] ra1; // src 1
	input [4:0] rb1; // src 2

	input [4:0] ra2; // src 1+2 for piepline 2
	input [4:0] rb2;

	input [4:0] ra3; // src 1+2 for piepline 3
	input [4:0] rb3;

	input [31:0] inW1; // input from end of pipelines
	input [31:0] inW2;
	input [31:0] inW3;

	output [31:0] outA1; // reg 1 = A
	output [31:0] outB1; // reg 2 = B

	output [31:0] outA2; // reg 1 + 2 for pipeine 2
	output [31:0] outB2;

	output [31:0] outA3; // reg 1 + 2 for pipeline 3
	output [31:0] outB3;

	// wire declaration
	wire [31:0] dec_out1; // wires coming out of decoder
	wire [31:0] dec_out2;
	wire [31:0] dec_out3;

	wire [1023:0] reg_out; // these wires are outputs coming out of each individual register

	wire [31:0] write_to_reg1; // these wires are to determine based on 3 conditions, if it should be written to (we = 1, the register is selected, and the clock)
	wire [31:0] write_to_reg2;
	wire [31:0] write_to_reg3;

	wire [31:0] mux_outA1; 
	wire [31:0] mux_outB1;

	wire [31:0] mux_outA2; 
	wire [31:0] mux_outB2;

	wire [31:0] mux_outA3; 
	wire [31:0] mux_outB3;

	// decoder to determine which register to write to
	dec_n write_decoder1 (.src(rw1), .z(dec_out1)); // decode info for pieline 1
	defparam write_decoder.n = 5;

	dec_n write_decoder2 (.src(rw2), .z(dec_out2)); // decode info for pipeline 2
	defparam write_decoder2.n = 5;

	dec_n write_decoder3 (.src(rw3), .z(dec_out3)); // decode info for pipeline 3
	defparam write_decoder3.n = 5;

	// setting values for write_to_reg(i)
	genvar i;
	generate
		for (i = 0; i < 32; i = i + 1) begin
			and3to1 we_and (.w(clk), .x(we1), .y(dec_out1[i]), .z(write_to_reg1[i]));
		end
	endgenerate

	genvar n;
	generate
		for (n = 0; n < 32; n = n + 1) begin
			and3to1 we_and (.w(clk), .x(we2), .y(dec_out2[n]), .z(write_to_reg2[n]));
		end
	endgenerate

	genvar p;
	generate
		for (p = 0; p < 32; p = p + 1) begin
			and3to1 we_and (.w(clk), .x(we3), .y(dec_out3[p]), .z(write_to_reg3[p]));
		end
	endgenerate

	// declaring 32 register files
	// input is inW, clk (control signal) is one we generated previously
	// output is onto temporary wires
	genvar j;
	generate
		for (j = 0; j < 32; j = j + 1) begin // pipeline 1 writing to shared registers
			reg_32 register (.clk(write_to_reg1[j]), .d32(inW1), .q32(reg_out[((j+1)*32-1):(j*32)]));
		end
	endgenerate

	genvar k;
	generate
		for (k = 0; k < 32; k = k + 1) begin  // pipeline 2 writing to shared registers
			reg_32 register (.clk(write_to_reg2[k]), .d32(inW2), .q32(reg_out[((k+1)*32-1):(k*32)]));
		end
	endgenerate

	genvar m;
	generate
		for (m = 0; m < 32; m = m + 1) begin // piepline 3 writing to shared registers
			reg_32 register (.clk(write_to_reg3[m]), .d32(inW3), .q32(reg_out[((m+1)*32-1):(m*32)]));
		end
	endgenerate

	// setting output for outA
	// STILL NEED TO DO
	mux32to1_32 muxA1 (.sel(ra1), .s0(32'b00000000000000000000000000000000), // bind values to reg 1 and 2 for pipeline 1
		.s1(reg_out[63:32]), .s2(reg_out[95:64]), .s3(reg_out[127:96]), .s4(reg_out[159:128]),
		.s5(reg_out[191:160]), .s6(reg_out[223:192]), .s7(reg_out[255:224]), .s8(reg_out[287:256]), .s9(reg_out[319:288]),
		.s10(reg_out[351:320]), .s11(reg_out[383:352]), .s12(reg_out[415:384]), .s13(reg_out[447:416]), .s14(reg_out[479:448]), .s15(reg_out[511:480]),
		.s16(reg_out[543:512]), .s17(reg_out[575:544]), .s18(reg_out[607:576]), .s19(reg_out[639:608]), .s20(reg_out[671:640]), .s21(reg_out[703:672]),
		.s22(reg_out[735:704]), .s23(reg_out[767:736]), .s24(reg_out[799:768]), .s25(reg_out[831:800]), .s26(reg_out[863:832]), .s27(reg_out[895:864]),
		.s28(reg_out[927:896]), .s29(reg_out[959:928]), .s30(reg_out[991:960]), .s31(reg_out[1023:992]), .out(mux_outA1));


	mux32to1_32 muxB1 (.sel(rb1), .s0(32'b00000000000000000000000000000000),
		.s1(reg_out[63:32]), .s2(reg_out[95:64]), .s3(reg_out[127:96]), .s4(reg_out[159:128]),
		.s5(reg_out[191:160]), .s6(reg_out[223:192]), .s7(reg_out[255:224]), .s8(reg_out[287:256]), .s9(reg_out[319:288]),
		.s10(reg_out[351:320]), .s11(reg_out[383:352]), .s12(reg_out[415:384]), .s13(reg_out[447:416]), .s14(reg_out[479:448]), .s15(reg_out[511:480]),
		.s16(reg_out[543:512]), .s17(reg_out[575:544]), .s18(reg_out[607:576]), .s19(reg_out[639:608]), .s20(reg_out[671:640]), .s21(reg_out[703:672]),
		.s22(reg_out[735:704]), .s23(reg_out[767:736]), .s24(reg_out[799:768]), .s25(reg_out[831:800]), .s26(reg_out[863:832]), .s27(reg_out[895:864]),
		.s28(reg_out[927:896]), .s29(reg_out[959:928]), .s30(reg_out[991:960]), .s31(reg_out[1023:992]), .out(mux_outB1));



	





	mux32to1_32 muxA2 (.sel(ra2), .s0(32'b00000000000000000000000000000000), // bind values to reg 1 and 2 for pieline 2
		.s1(reg_out[63:32]), .s2(reg_out[95:64]), .s3(reg_out[127:96]), .s4(reg_out[159:128]),
		.s5(reg_out[191:160]), .s6(reg_out[223:192]), .s7(reg_out[255:224]), .s8(reg_out[287:256]), .s9(reg_out[319:288]),
		.s10(reg_out[351:320]), .s11(reg_out[383:352]), .s12(reg_out[415:384]), .s13(reg_out[447:416]), .s14(reg_out[479:448]), .s15(reg_out[511:480]),
		.s16(reg_out[543:512]), .s17(reg_out[575:544]), .s18(reg_out[607:576]), .s19(reg_out[639:608]), .s20(reg_out[671:640]), .s21(reg_out[703:672]),
		.s22(reg_out[735:704]), .s23(reg_out[767:736]), .s24(reg_out[799:768]), .s25(reg_out[831:800]), .s26(reg_out[863:832]), .s27(reg_out[895:864]),
		.s28(reg_out[927:896]), .s29(reg_out[959:928]), .s30(reg_out[991:960]), .s31(reg_out[1023:992]), .out(mux_outA2));


	mux32to1_32 muxB2 (.sel(rb2), .s0(32'b00000000000000000000000000000000),
		.s1(reg_out[63:32]), .s2(reg_out[95:64]), .s3(reg_out[127:96]), .s4(reg_out[159:128]),
		.s5(reg_out[191:160]), .s6(reg_out[223:192]), .s7(reg_out[255:224]), .s8(reg_out[287:256]), .s9(reg_out[319:288]),
		.s10(reg_out[351:320]), .s11(reg_out[383:352]), .s12(reg_out[415:384]), .s13(reg_out[447:416]), .s14(reg_out[479:448]), .s15(reg_out[511:480]),
		.s16(reg_out[543:512]), .s17(reg_out[575:544]), .s18(reg_out[607:576]), .s19(reg_out[639:608]), .s20(reg_out[671:640]), .s21(reg_out[703:672]),
		.s22(reg_out[735:704]), .s23(reg_out[767:736]), .s24(reg_out[799:768]), .s25(reg_out[831:800]), .s26(reg_out[863:832]), .s27(reg_out[895:864]),
		.s28(reg_out[927:896]), .s29(reg_out[959:928]), .s30(reg_out[991:960]), .s31(reg_out[1023:992]), .out(mux_outB2));











	mux32to1_32 muxA3 (.sel(ra3), .s0(32'b00000000000000000000000000000000), // bind values to reg 1 and 2 for pipeline 3
		.s1(reg_out[63:32]), .s2(reg_out[95:64]), .s3(reg_out[127:96]), .s4(reg_out[159:128]),
		.s5(reg_out[191:160]), .s6(reg_out[223:192]), .s7(reg_out[255:224]), .s8(reg_out[287:256]), .s9(reg_out[319:288]),
		.s10(reg_out[351:320]), .s11(reg_out[383:352]), .s12(reg_out[415:384]), .s13(reg_out[447:416]), .s14(reg_out[479:448]), .s15(reg_out[511:480]),
		.s16(reg_out[543:512]), .s17(reg_out[575:544]), .s18(reg_out[607:576]), .s19(reg_out[639:608]), .s20(reg_out[671:640]), .s21(reg_out[703:672]),
		.s22(reg_out[735:704]), .s23(reg_out[767:736]), .s24(reg_out[799:768]), .s25(reg_out[831:800]), .s26(reg_out[863:832]), .s27(reg_out[895:864]),
		.s28(reg_out[927:896]), .s29(reg_out[959:928]), .s30(reg_out[991:960]), .s31(reg_out[1023:992]), .out(mux_outA3));


	mux32to1_32 muxB3 (.sel(rb3), .s0(32'b00000000000000000000000000000000),
		.s1(reg_out[63:32]), .s2(reg_out[95:64]), .s3(reg_out[127:96]), .s4(reg_out[159:128]),
		.s5(reg_out[191:160]), .s6(reg_out[223:192]), .s7(reg_out[255:224]), .s8(reg_out[287:256]), .s9(reg_out[319:288]),
		.s10(reg_out[351:320]), .s11(reg_out[383:352]), .s12(reg_out[415:384]), .s13(reg_out[447:416]), .s14(reg_out[479:448]), .s15(reg_out[511:480]),
		.s16(reg_out[543:512]), .s17(reg_out[575:544]), .s18(reg_out[607:576]), .s19(reg_out[639:608]), .s20(reg_out[671:640]), .s21(reg_out[703:672]),
		.s22(reg_out[735:704]), .s23(reg_out[767:736]), .s24(reg_out[799:768]), .s25(reg_out[831:800]), .s26(reg_out[863:832]), .s27(reg_out[895:864]),
		.s28(reg_out[927:896]), .s29(reg_out[959:928]), .s30(reg_out[991:960]), .s31(reg_out[1023:992]), .out(mux_outB3));


	assign outA1 = mux_outA1;
	assign outB1 = mux_outB1;

	assign outA2 = mux_outA2;
	assign outB2 = mux_outB2;

	assign outA3 = mux_outA3;
	assign outB3 = mux_outB3;
endmodule

