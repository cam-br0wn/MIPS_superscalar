// `include "extralib/sram_3.v"
`timescale 1ns/10ps
module sram_3_tb;
  
  reg t_cs;
  reg t_oe_0;
  reg t_oe_1;
  reg t_oe_2;
  reg t_we_0;
  reg t_we_1;
  reg t_we_2;
  reg [31:0] t_addr_0;
  reg [31:0] t_addr_1;
  reg [31:0] t_addr_2;
  reg [31:0] t_din_0;
  reg [31:0] t_din_1;
  reg [31:0] t_din_2;
  wire [31:0] t_dout_0;
  wire [31:0] t_dout_1;
  wire [31:0] t_dout_2;
  
  
  sram_3 sram3_ut(.cs(t_cs) , .oe_0(t_oe_0) , .oe_1(t_oe_1) , .oe_2(t_oe_2) , .we_0(t_we_0) , .we_1(t_we_1) , .we_2(t_we_2) , .addr_0(t_addr_0) , .addr_1(t_addr_1) , .addr_2(t_addr_2) , .din_0(t_din_0) , .din_1(t_din_1) , .din_2(t_din_2) , .dout_0(t_dout_0), .dout_1(t_dout_1), .dout_2(t_dout_2));
  defparam sram3_ut.mem_file = "./data/bills_branch.dat";
  
  initial
    begin
      $monitor(t_cs , t_oe_0, t_oe_1, t_oe_2, t_we_0, t_we_1, t_we_2, t_addr_0, t_addr_1, t_addr_2, t_din_0, t_din_1, t_din_2, t_dout_0, t_dout_1, t_dout_2);
      
      t_cs = 1'b0;
      #10
      
      // write all 1s to reg file via port 0
      t_cs = 1'b1;
      t_oe_0 = 1'b0;
      t_we_0 = 1'b1;
      t_addr_0 = 32'h00400050;
      t_din_0 = 32'hFFFFFFFF;
      
      t_cs = 1'b1;
      t_oe_1 = 1'b1;
      t_we_1 = 1'b1;
      t_addr_1 = 32'h0040003c;
      t_din_1 = 32'h0000000E;
      
      t_cs = 1'b1;
      t_oe_2 = 1'b1;
      t_we_2 = 1'b0;
      t_addr_2 = 32'h0040002c;
      t_din_2 = 32'hFFFFFFFF;
      
      #10
      t_cs = 1'b1;
      t_oe_0 = 1'b0;
      t_we_0 = 1'b1;
      t_addr_0 = 32'h10000024;
      t_din_0 = 32'h00000007;

      #10 // TEST
      t_cs = 1'b1;
      t_oe_1 = 1'b1;
      t_we_1 = 1'b1;
      t_addr_1 = 32'h10000024;
      t_din_1 = 32'h00000009;
      
      t_cs = 1'b1;
      t_oe_2 = 1'b1;
      t_we_2 = 1'b0;
      t_addr_2 = 32'h00400020;
      
      #10
      t_cs = 1'b1;
      t_oe_0 = 1'b1;
      t_we_0 = 1'b0;
      t_addr_0 = 32'h10000024;
      

      #100
     $finish;
  end
  
endmodule

