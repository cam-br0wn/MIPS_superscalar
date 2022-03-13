module dec_n_tb; 
  
  reg [3:0] t_src;
  wire [31:0] t_z;
  
  dec_n dec_n_ut(.src(t_src) , .z(t_z));
  defparam dec_n_ut.n = 4;
  
  initial
    begin
      $monitor(t_src , t_z);
      #5
      t_src = 4'b0000;
      
      #5
      t_src = 4'b0011;
      
      #5
      t_src = 4'b0101;
      
      #5
      t_src = 4'b1111;
      
  end
  
endmodule

