// FAKE CONTROL until real one is wired up

`timescale 1ns/10ps

module fake_control(in, ALUOp, RegDst, BranchCtrl, 
      MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,
      Bne, Bgtz);
   input [5:0] in;
   output wire [2:0] ALUOp;
   output wire RegDst, BranchCtrl, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, Bne, Bgtz;

   assign RegDst = 1'b0;
   assign BranchCtrl = 1'b0;
   assign MemRead = 1'b1;
   assign MemtoReg = 1'b0;
   assign MemWrite = 1'b0;
   assign ALUSrc = 1'b0;
   assign RegWrite = 1'b0;
   assign ALUOP = 3'b111;
   assign Bne = 1'b0;
   assign Bgtz = 1'b0;

endmodule 
