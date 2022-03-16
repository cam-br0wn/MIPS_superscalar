//`include "cpu/control.v"
module control_tb;

  reg [5:0] t_op;
  wire t_RegDst, t_ALUSrc, t_MemtoReg, t_RegWrite, t_MemWrite, t_ExtOp;
  wire [1:0] t_Branch;
  wire [2:0] t_ALUop;

  control control_ut(.op(t_op), .RegDst(t_RegDst), .ALUSrc(t_ALUSrc), .MemtoReg(t_MemtoReg), .RegWrite(t_RegWrite), .MemWrite(t_MemWrite), .Branch(t_Branch), .ExtOp(t_ExtOp), .ALUop(t_ALUop));
  
  initial
    begin
      $monitor(t_op, t_RegDst, t_ALUSrc, t_MemtoReg, t_RegWrite, t_MemWrite, t_ExtOp, t_Branch, t_ALUop);
      
      t_op = 6'b000000;
      
      #5
      t_op = 6'b001000;
      
      #5
      t_op = 6'b100011;
      
      #5
      t_op = 6'b101011;
      
      #5
      t_op = 6'b000100;
            
      #5
      t_op = 6'b000101;
            
      #5
      t_op = 6'b000111;

      #5
      t_op = 6'b000000;
  end
  
endmodule
