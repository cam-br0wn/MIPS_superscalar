module mux_n_tb;
  
  reg t_sel;
  reg t_src0;
  reg t_src1;
  wire t_z;
  
  
  
  mux_n mux_n_ut(.sel(t_sel) , .src0(t_src0) , .src1(t_src1) , .z(t_z));
  defparam mux_n_ut.n = 1;
  
  initial
    begin
      $monitor(t_sel , t_src0 , t_src1 , t_z);
      
      #5
      t_sel = 1'b0;
      t_src0 = 1'b0;
      t_src1 = 1'b1;
      
      #5
      t_src0 = 1'b1;
      t_src1 = 1'b0;
      
      #5
      t_sel = 1'b1;
      t_src0 = 1'b0;
      t_src1 = 1'b1;
      
      #5
      t_src0 = 1'b1;
      t_src1 = 1'b1;
      
      #5
      t_sel = 1'b0;
      t_src0 = 1'b0;
      t_src1 = 1'b1;
  end
  
endmodule
