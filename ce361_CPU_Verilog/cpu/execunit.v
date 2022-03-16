module execunit (PC, busA, busB, instr, zero, ALUout, Target, ALUop, ExtOp, ALUSrc, RegDst, Regout);
    input [31:0] PC, busA, busB, instr;
    input [2:0] ALUop;
    input ALUSrc, ExtOp;
    input RegDst;
    output [4:0] Regout;
    output [31:0] Target, ALUout;
    output zero;

    wire [31:0] sig_sign_ext, sig_sign_ext_shifted, ALU_in_B;
    wire [2:0] ALUctr;
    wire [15:0] immed;
    wire [4:0] Rt, Rd;
    assign immed = instr[15:0];
    assign Rt = instr[20:16];
    assign Rd = instr[15:11];


    // Control Unit
    ALUCU aluctrl(.ALUOp(ALUop), .func(instr[5:0]), .ALUCtr(ALUctr)); 
    // sign extends immediate value
    extender sign_extend(.x(immed), .ExtOp(ExtOp), .z(sig_sign_ext));
    assign sig_sign_ext_shifted = {sig_sign_ext[29:0], 2'b0}; // DO WE NEED A SHIFTER MADE OF MUXES???
    // adds shifted immediate to PC to get Target
    adder_32 pc_adder(.a(PC), .b(sig_sign_ext_shifted), .z(Target));
    // ALU
    ALU cpu_alu (.ctrl(ALUctr), .A(busA), .B(ALU_in_B), .shamt(instr[10:6]), .cout(alu_cout), .ovf(alu_of), .ze(zero), .R(ALUout));

    mux_32 alusrc(.sel(ALUSrc), .src0(busB), .src1(sig_sign_ext), .z(ALU_in_B));
    mux_n regsel (.sel(RegDst), .src0(Rt), .src1(Rd), .z(Regout));
    defparam regsel.n = 5;


endmodule