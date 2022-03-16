module exec_tb;

    reg t_ALUSrc, t_ExtOp, t_RegDst;
    reg [2:0] t_ALUop;
    reg [31:0] t_A, t_B, t_PC, t_instr;
    wire t_zero;
    wire [4:0] t_Regout;
    wire [31:0] t_Target, t_ALUout;
  
  execunit execunit (.PC(t_PC), .busA(t_A), .busB(t_B), .instr(t_instr), .zero(t_zero), .ALUout(t_ALUout), .Target(t_Target), .ALUop(t_ALUop), .ExtOp(t_ExtOp), .ALUSrc(t_ALUSrc), .RegDst(t_RegDst), .Regout(t_Regout));
  
  initial
    begin
      $monitor(t_PC, t_A, t_B, t_instr, t_zero, t_ALUout, t_Target, t_ALUop, t_ExtOp, t_ALUSrc, t_RegDst, t_Regout);
      
      t_ALUSrc = 1'b0;
      t_ExtOp = 1'b0;
      t_RegDst = 1'b0;
      t_ALUop = 3'b000;
      t_A = 32'b00000000000000000000000000000010;
      t_B = 32'b00000000000000000000000000001000;
      t_PC = 32'b00000000000000000000000000000100;
      // add, 000000 00001 00010 00100 00000 100000
      //         0     rs=1   rt=2  rd=4 0     0x20 for add
      t_instr = 32'b00000000001000100010000000101000;
      
      #5
      t_ALUop = 3'b001;
      
      #5
      t_ALUop = 3'b010;
      
      #5
      t_ALUop = 3'b011;
      
      #5
      t_ALUop = 3'b100;
  end
  
endmodule