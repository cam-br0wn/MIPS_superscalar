// `include "lib/dff.v"
module reg_32 (d32, q32, clk);
	input [31:0] d32;
	input clk;
	output [31:0] q32;

	genvar i;
	generate
		for (i = 0; i < 32; i = i+1) begin
			dff reg_dff (.clk(clk), .d(d32[i]), .q(q32[i]));
		end
	endgenerate
endmodule
