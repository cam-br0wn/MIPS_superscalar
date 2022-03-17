// `include "extralib/mux_n2.v"
// `include "extralib/mux_322.v"
// `include "extralib/sram2.v"
// `include "extralib/syncram2.v"
// `include "cpu/control.v"
// `include "cpu/extender.v"
// `include "cpu/ifu.v"
// `include "cpu/reg_file.v"
// `include "ece361_alu_verilog/ALU.v"
// `include "ece361_alu_verilog/ALUCU.v"

module alu_subpipeline( clk, clockthing,
                        IDpc, 
                        //srcA,
                        //srcB,
                        regbusA,  
                        regbusB, 
                        IDinstruction, 
                        ExtOp, 
                        ALUSrc, 
                        ALUOp, 
                        RegDst, 
                        MemWrite, 
                        Branch, 
                        MemtoReg, 
                        RegWrite,

                        //srcA,
                        //srcB,        
                        BusW,        //data to be written back into reg file
                        MEMpc,       //PC to be used as input to branch mux (src1)
                        branch_ctrl, //result from AND gate of branch bit and zero bit. Use this as the sel bit for branch mux.
                        regmuxout); //Rw
    

//Contains ID_EX_reg, EX stage, EX_MEM_reg (which pretty much acts as EX_WB_reg), WB stage, Branch and gate usually in MEM stage

// Inputs:
/*
    clk, pc_ld, pc_data, clockthing
    pc_in, 
    pc_out, 
    A_in, 
    A_out, 
    B_in, 
    B_out, 
    instr_in, 
    instr_out,
    ExtOp_in, 
    ALUSrc_in, 
    ALUOp_in, 
    RegDst_in, 
    MemWr_in, 
    Br_in, 
    MemtoReg_in, 
    RegWr_in, 
    ExtOp_out, 
    ALUSrc_out, 
    ALUOp_out, 
    RegDst_out, 
    MemWr_out, 
    Br_out, 
    MemtoReg_out, 
    RegWr_out,

    BusW,
    MEMpc,
    branch_ctrl,
    regmuxout
    */

//Outputs:
    //BusW
    //regmuxout
    //MEMpc
    //branch_ctrl


    // Inputs
    parameter data_file = "data/bills_branch.dat";
    input clk, clockthing;

    // Wires

    // Control (happens during reg/dec stage)
    input RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, ExtOp;
    input [1:0] Branch;
    input [2:0] ALUOp;
    // Reg/Dec Stage
    input [31:0] IDpc, IDinstruction;
    input [31:0] regbusA, regbusB;
    // Rs
    wire [4:0] temp_Rs; 
    // Rt
    wire [4:0] temp_Rt;
    // Rd
    wire [4:0] temp_Rd;

    // Exec Stage
    wire [31:0] EXpc, EXinstruction, EXres, EXTarget, execbusA, execbusB;
    wire EXRegWr, EXExtOp, EXALUSrc, EXRegDst, EXMemWr, EXMemtoReg;
    wire [2:0] EXALUOp;
    wire [1:0] EXBranch;
    wire EXzero;
    wire [31:0] EXRegAddr;

    // Mem Stage
    output [31:0] MEMpc;
    wire [31:0] MEMres, MEMbusB, MEMDataOut;
    wire MEMRegWr, MEMMemWr, MEMMemtoReg, MEMzero;
    wire [1:0] MEMBranch;
    wire [31:0] MEMRegAddr;
    // Branch logic
    output branch_ctrl;
    wire gtzoneout, gtztwoout, gtzfinal, nb0, nb1, beqyn, bneqyn;
    wire bctrl;

    // WR stage
    output [31:0] busW;
    output [31:0] regmuxout;
    wire [31:0] WRbusB, WRDataOut;
    wire WRRegWr, WRMemtoReg;

    // Organize this into the stages
    wire not_ld, not_clk;

    not_gate flip_clock (.x(clk), .z(not_clk));
    not_gate flip_ld (.x(pc_ld), .z(not_ld));

   // Register in between
    ID_EX_reg reg_reg(.clk(clk), 
                      .pc_in(IDpc), 
                      .pc_out(EXpc), 
                      .A_in(regbusA), 
                      .A_out(execbusA), 
                      .B_in(regbusB), 
                      .B_out(execbusB), 
                      .instr_in(IDinstruction), 
                      .instr_out(EXinstruction),
                      .ExtOp_in(ExtOp), 
                      .ALUSrc_in(ALUSrc), 
                      .ALUOp_in(ALUOp), 
                      .RegDst_in(RegDst), 
                      .MemWr_in(MemWrite), 
                      .Br_in(Branch), 
                      .MemtoReg_in(MemtoReg), 
                      .RegWr_in(RegWrite), 
                      .ExtOp_out(EXExtOp), 
                      .ALUSrc_out(EXALUSrc), 
                      .ALUOp_out(EXALUOp), 
                      .RegDst_out(EXRegDst), 
                      .MemWr_out(EXMemWr), 
                      .Br_out(EXBranch), 
                      .MemtoReg_out(EXMemtoReg), 
                      .RegWr_out(EXRegWr));

// Exec Stage
    // wire [31:0] EXpc, EXinstruction, EXres, EXTarget;
    // wire EXRegWr, EXExtOp, EXALUSrc, EXALUOp, EXRegDst, EXMemWr, EXMemtoReg;
    // wire [1:0] EXBranch;
    // wire EXzero;
    // wire [4:0] EXRegAddr;

    // wire [31:0] MEMpc, MEMinstruction, MEMres, MEMbusB, MEMDataOut;
    // wire MEMRegWr, MEMMemWr, MEMMemtoReg, MEMzero;
    // wire [1:0] MEMBranch;
    // wire [4:0] MEMRegAddr;
    // // Branch logic
    // wire branch_ctrl;
    // wire gtzoneout, gtztwoout, gtzfinal, nb0, nb1, beqyn, bneqyn;

    // Exec Unit
    execunit eunit (.PC(EXpc), 
                    .busA(execbusA), 
                    .busB(execbusB), 
                    .instr(EXinstruction), 
                    .zero(EXzero), 
                    .ALUout(EXres), 
                    .Target(EXTarget), 
                    .ALUop(EXALUOp), 
                    .ExtOp(EXExtOp), 
                    .ALUSrc(EXALUSrc), 
                    .RegDst(EXRegDst), 
                    .Regout(EXRegAddr[4:0]));
    // Register
    EX_MEM_reg ememreg (.clk(clk), 
                        .zero_in(EXzero), 
                        .zero_out(MEMzero), 
                        .res_in(EXres), 
                        .res_out(busW), //changed from MEMRes
                        .target_in(EXTarget), 
                        .target_out(MEMpc),
                        .Br_in(EXBranch), 
                        .Br_out(MEMBranch),
                        .MemtoReg_in(EXMemtoReg), 
                        .MemtoReg_out(MEMMemtoReg), 
                        .RegWr_in(EXRegWr),
                        .RegWr_out(MEMRegWr),
                        .regAddr_in(EXRegAddr), 
                        .regAddr_out(regmuxout), //changed from MEMRegAddr
                        
                        //not needed for ALU-specific pipeline. Keeping just cuz I don't wanna make a new reg file
                        .MemWr_in(EXMemWr), 
                        .MemWr_out(MEMMemWr),  
                        .B_in(execbusB), 
                        .B_out(MEMbusB));

    //wire branch_ctrl, msb;
    assign msb = MEMres[31];

    and_gate gtzone (.x(MEMBranch[0]), .y(MEMBranch[1]), .z(gtzoneout));
    nor_gate gtztwo (.x(msb), .y(MEMzero), .z(gtztwoout));
    and_gate gtzfin (.x(gtzoneout), .y(gtztwoout), .z(gtzfinal));
    and3to1 brancheqand (.w(MEMBranch[0]), .x(nb1), .y(MEMzero), .z(beqyn));
    and3to1 branchneqand (.w(MEMBranch[1]), .x(nb0), .y(not_zero), .z(bneqyn));
    or3to1 branch_yn (.w(gtzfinal), .x(beqyn), .y(bneqyn), .z(bctrl));
    // testing sketchy stuff
    and_gate hacky (bctrl, clockthing, branch_ctrl);

    not_gate nzero (.x(MEMzero), .z(not_zero));
    not_gate nbzero (.x(MEMBranch[0]), .z(nb0));
    not_gate nbone (.x(MEMBranch[1]), .z(nb1));

endmodule