// `include "lib/not_gate.v"
// `include "extralib/and6to1.v"
// `include "lib/or_gate.v"
// `include "extralib/or3to1.v"
module control (op, RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, Branch, ExtOp, ALUop);
    input [5:0] op;
    output RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, ExtOp;
    output [1:0] Branch;
    output [2:0] ALUop;

    wire [5:0] notop;
    wire andrtype, andaddi, andlw, andsw, andbeq, andbne, andbgtz;
    wire orALUSrc, orRegWrite, orBranch1, orBranch0, orExtOp, orALUop0, doesBranch;

    not_gate opnot5 (.x(op[5]), .z(notop[5]));
    not_gate opnot4 (.x(op[4]), .z(notop[4]));
    not_gate opnot3 (.x(op[3]), .z(notop[3]));
    not_gate opnot2 (.x(op[2]), .z(notop[2]));
    not_gate opnot1 (.x(op[1]), .z(notop[1]));
    not_gate opnot0 (.x(op[0]), .z(notop[0]));

    // rtype 00 0000
    and6to1 andgatertype (.a(notop[5]), .b(notop[4]), .c(notop[3]), .d(notop[2]), .e(notop[1]), .f(notop[0]), .g(andrtype));
    // addi 00 1000
    and6to1 andgateaddi (.a(notop[5]), .b(notop[4]), .c(op[3]), .d(notop[2]), .e(notop[1]), .f(notop[0]), .g(andaddi));
    // lw 10 0011
    and6to1 andgatelw (.a(op[5]), .b(notop[4]), .c(notop[3]), .d(notop[2]), .e(op[1]), .f(op[0]), .g(andlw));
    // sw 10 1011
    and6to1 andgatesw (.a(op[5]), .b(notop[4]), .c(op[3]), .d(notop[2]), .e(op[1]), .f(op[0]), .g(andsw));
    // beq 00 0100
    and6to1 andgatebeq (.a(notop[5]), .b(notop[4]), .c(notop[3]), .d(op[2]), .e(notop[1]), .f(notop[0]), .g(andbeq));
    // bne 00 0101
    and6to1 andgatebne (.a(notop[5]), .b(notop[4]), .c(notop[3]), .d(op[2]), .e(notop[1]), .f(op[0]), .g(andbne));
    // bgtz 00 0111
    and6to1 andgatebgtz (.a(notop[5]), .b(notop[4]), .c(notop[3]), .d(op[2]), .e(op[1]), .f(op[0]), .g(andbgtz));

    or3to1 orgateALUSrc (.w(andaddi), .x(andlw), .y(andsw), .z(orALUSrc));
    or3to1 orgateRegWrite (.w(andrtype), .x(andaddi), .y(andlw), .z(orRegWrite));
    or_gate orgateBranch1 (.x(andbne), .y(andbgtz), .z(orBranch1));
    or_gate orgateBranch0 (.x(andbeq), .y(andbgtz), .z(orBranch0));
    or_gate orgateBranchAtAll (.x(orBranch0), .y(orBranch1), .z(doesBranch));
    or3to1 orgateExtOp (.w(doesBranch), .x(andlw), .y(andsw), .z(orExtOp));
    or_gate orgateLUop0 (.x(andbeq), .y(andbne), .z(orALUop0));

    assign RegDst = andrtype;
    assign ALUSrc = orALUSrc;
    assign MemtoReg = andlw;
    assign RegWrite = orRegWrite;
    assign MemWrite = andsw;
    assign Branch[1] = orBranch1;
    assign Branch[0]  = orBranch0;
    assign ExtOp = orExtOp;
    assign ALUop[2] = andrtype;
    assign ALUop[1] = 1'b0;
    assign ALUop[0] = orALUop0;

endmodule