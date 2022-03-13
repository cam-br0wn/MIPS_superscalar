module dffr_a_tb;
  
  reg t_clk;
  reg t_arst;
  reg t_aload;
  reg t_adata;
  reg t_d;
  reg t_enable;
  wire t_q;
  
  
  
  dffr_a dffr_a_ut(.clk(t_clk), .arst(t_arst), .aload(t_aload), .adata(t_adata), .d(t_d), .enable(t_enable), .q(t_q));
  
  
  initial
    begin
      $monitor(t_clk , t_arst , t_aload , t_adata , t_d , t_enable , t_q);
      
      t_clk = 1'b0;
      t_arst = 1'b0;
      t_aload = 1'b0;
      t_adata = 1'b0;
      t_d = 1'b0;
      t_enable = 1'b1;
      
      #5
      t_clk = 1'b1;
      
      #5
      t_clk = 1'b0;
      t_d = 1'b1;
      
      #5
      t_clk = 1'b1;
      
      #5
      t_clk = 1'b1;
      t_d = 1'b0;
      
      #5
      t_clk = 1'b0;
      t_d = 1'b0;
      
      #5
      t_clk = 1'b1;
      t_arst = 1'b1;
      t_aload = 1'b1;
      t_adata = 1'b1;
      t_d = 1'b1;
      t_enable = 1'b1;
      
      #5
      t_enable = 1'b0;
      
      #5
      t_clk = 1'b1;
      t_arst = 1'b0;
      
      
  end
  
endmodule
      



