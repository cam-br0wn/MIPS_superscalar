module extender (x,ExtOp, z);
	input [15:0] x;
	input ExtOp;
	output [31:0] z;

	wire msb;
	wire [31:0] zero_ext;
	wire [31:0] one_ext;
	wire [31:0] sign_ext;
	wire [31:0] temp_out;

	assign msb = x[15];
	assign zero_ext[31:16] = 16'b0000000000000000;
	assign zero_ext[15:0] = x;
	assign one_ext[31:16] = 16'b1111111111111111;
	assign one_ext[15:0] = x;

	//selects 0 or 1 extended based on msb
	mux_32 msb_mux (.sel(msb), .src0(zero_ext), .src1(one_ext), .z(sign_ext));

	//selects zero or sign extend based on input arg
	mux_32 ext_mux (.sel(ExtOp), .src0(zero_ext), .src1(sign_ext), .z(temp_out));

	assign z = temp_out;
endmodule
