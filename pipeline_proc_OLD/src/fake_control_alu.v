// FAKE ALU CONTROL until real one is wired up - replaces old alu control

`timescale 1ns/10ps

module fake_control_alu(in, fakeALUout);
   input [3:0] in;
   output wire [2:0] fakeALUout;
   assign fakeALUout = 1'b00;

endmodule 
