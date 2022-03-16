`include "extralib/sram2.v"
module sram_tb;
  
  reg t_cs;
  reg t_oe;
  reg t_we;
  reg [31:0] t_addr;
  reg [31:0] t_din;
  wire [31:0] t_dout;
  
  
  
  sram sram_ut(.cs(t_cs) , .oe(t_oe) , .we(t_we) , .addr(t_addr) , .din(t_din) , .dout(t_dout));
  defparam sram_ut.mem_file = "data/bills_branch.dat";
  
  initial
    begin
      $monitor(t_cs , t_oe , t_we , t_addr , t_din , t_dout);
      
      t_cs = 1'b0;
      #10
      
      t_cs = 1'b1;
      t_oe = 1'b1;
      t_we = 1'b0;
      t_addr = 32'h00400050;
      t_din = 32'hFFFFFFFF;
      
      #10
      t_cs = 1'b0;
      t_oe = 1'b1;
      t_we = 1'b1;
      t_addr = 32'h0040003c;
      t_din = 32'h0000000E;
      
      #10
      t_cs = 1'b1;
      t_oe = 1'b1;
      t_we = 1'b0;
      t_addr = 32'h0040002c;
      t_din = 32'hFFFFFFFF;
      
      #10
      t_cs = 1'b1;
      t_oe = 1'b0;
      t_we = 1'b1;
      t_addr = 32'h10000024;
      t_din = 32'h00000007;

      #10 // TEST
      t_cs = 1'b1;
      t_oe = 1'b1;
      t_we = 1'b1;
      t_addr = 32'h10000024;
      t_din = 32'h00000009;
      
      #10
      t_cs = 1'b1;
      t_oe = 1'b1;
      t_we = 1'b0;
      t_addr = 32'h00400020;
      
      #10
      t_cs = 1'b1;
      t_oe = 1'b1;
      t_we = 1'b0;
      t_addr = 32'h10000024;
      
     
  end
  
endmodule

