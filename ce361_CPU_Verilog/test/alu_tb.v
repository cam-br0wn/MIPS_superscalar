//`include "ece361_alu_verilog/ALU.v"
`timescale 1ns/10ps
module alu_tb;

  reg [2:0] t_ctrl;
  reg [31:0] t_A;
  reg [31:0] t_B;
  reg [4:0] t_shamt;
  wire t_cout;
  wire t_ovf;
  wire t_ze;
  wire [31:0] t_R;
  
  ALU alu_ut(.ctrl(t_ctrl), .A(t_A), .B(t_B), .shamt(t_shamt), .cout(t_cout), .ovf(t_ovf), .ze(t_ze), .R(t_R));
  
  initial
    begin
      $monitor(t_ctrl, t_A, t_B, t_shamt, t_cout, t_ovf, t_ze, t_R);
      
      t_ctrl = 3'b000;
      t_A = 32'b00000000000000000000000000001100;
      t_B = 32'b00000000000000000000000000000110;
      t_shamt = 5'b00000;
      
      #5
      t_ctrl = 3'b001;
      
      #5
      t_ctrl = 3'b010;
      
      #5
      t_ctrl = 3'b011;
      
      #5
      t_ctrl = 3'b100;
  end
  
endmodule
