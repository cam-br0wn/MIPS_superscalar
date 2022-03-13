// AD first attempt at sign extender.  Needs to take the sign of the msb and extend to 32 bits from 16.

`timescale 1ns/10ps

module sign_ext(a, a_ext);
   input [15:0] a;
   output wire [31:0] a_ext; // need wire?

   assign a_ext[15:0] = a[15:0];
   assign a_ext[31:16] = {16{a[15]}}; // I think this is it...too simple?  Clocking?

endmodule // sign_ext

   
   

   
