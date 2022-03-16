`include "cpu/extender.v"
module extender_tb();
	reg [15:0] x_tb;
	reg sel;
	wire [31:0] z_tb;

	extender tb_ext(.x(x_tb), .ExtOp(sel), .z(z_tb));

	initial begin
		x_tb = 16'b0101010101010101;
		sel = 0;
		#1
		sel = 1;
		#1;
		x_tb = 16'b1010101010101010;
		sel = 0;
		#1
		sel = 1;
		#1
		$stop;
	end
endmodule
