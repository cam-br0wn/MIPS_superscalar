`timescale 1ns/10ps
module gac_and_gate (x, y, z);
  input x;
  input y;
  output z;
  
  assign z = (x&y) ;
  
  
endmodule
  


