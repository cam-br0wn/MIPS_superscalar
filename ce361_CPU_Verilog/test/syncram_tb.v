`include "extralib/syncram2.v"
module syncram_tb;
  
  reg t_clk;
  reg t_cs;
  reg t_oe;
  reg t_we;
  reg [31:0] t_addr;
  reg [31:0] t_din;
  wire [31:0] t_dout;
  
  
  
  syncram syncram_ut(.clk(t_clk) , .cs(t_cs) , .oe(t_oe) , .we(t_we) , .addr(t_addr) , .din(t_din) , .dout(t_dout));
  defparam syncram_ut.mem_file = "data/bills_branch.dat";
  
  initial
    begin
      $monitor(t_clk , t_cs , t_oe , t_we , t_addr , t_din , t_dout);
      
      t_clk = 1'b0;
      t_cs = 1'b0;
      #10
      t_clk = 1'b1;
      t_cs = 1'b1;
      t_oe = 1'b1;
      t_we = 1'b0;
      t_addr = 32'h00400050;
      
      #10
      t_clk = 1'b1;
      t_cs = 1'b0;
      t_oe = 1'b1;
      t_we = 1'b1;
      t_addr = 32'h0040003c;
      t_din = 32'h0000000E;
      
      #10
      t_clk = 1'b0;
      
      #10
      t_clk = 1'b1;
      t_cs = 1'b1;
      t_oe = 1'b1;
      t_we = 1'b0;
      t_addr = 32'h0040002c;
      t_din = 32'hFFFFFFFF;
      
      #10
      t_clk = 1'b0;
      t_cs = 1'b1;
      t_oe = 1'b1;
      t_we = 1'b0;
      t_addr = 32'h0040002c;
      t_din = 32'hFFFFFFFF;
      
      #10
      t_clk = 1'b1;
      t_cs = 1'b1;
      t_oe = 1'b0;
      t_we = 1'b1;
      t_addr = 32'h10000024;
      t_din = 32'h00000007;
      
      #10
      t_clk = 1'b0;
      t_cs = 1'b1;
      t_oe = 1'b1;
      t_we = 1'b1;
      t_addr = 32'h10000024;
      t_din = 32'h00000007;
      
      #10
      t_clk = 1'b1;
      t_cs = 1'b1;
      t_oe = 1'b1;
      t_we = 1'b0;
      t_addr = 32'h00400020;
      
      #10
      t_clk = 1'b0;
      
      #10
      t_clk = 1'b1;
      t_cs = 1'b1;
      t_oe = 1'b1;
      t_we = 1'b0;
      t_addr = 32'h10000024;
      
     
  end
  
endmodule

