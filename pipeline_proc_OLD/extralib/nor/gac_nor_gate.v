module gac_nor_gate (x, y, z);
  input x;
  input y;
  output z;
  
  assign z = ~(x|y) ;
  
  
endmodule
  


