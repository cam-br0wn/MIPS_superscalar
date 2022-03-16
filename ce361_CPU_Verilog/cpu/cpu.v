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

// need to check the next four instructions, if there is any
// register dependency, delay for. Keep this in a register
// 
// must stall 3 cycles on any branch

module cpu(clk, pc_ld, pc_data, clockthing);
    // Inputs
    parameter data_file = "data/bills_branch.dat";
    input pc_ld;
    input clk, clockthing;
    input [31:0] pc_data;

    // Wires

    //Ifetch stage
    wire [31:0] nextpc;
    wire [31:0] currpc;
    wire [31:0] IFpc, IFpctemp;
    wire [31:0] IFinstruction, IFinstructiontemp;
    wire [31:0] pin1, pin2, pin3, pin1a, pin2a, pin3a;
    wire stall0, stall00, stall1, stall2, stall3, stalled, stalled2, invertedstall;
    // Control (happens during reg/dec stage)
    wire RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, ExtOp;
    wire [1:0] Branch;
    wire [2:0] ALUOp;
    // Reg/Dec Stage
    wire [31:0] IDpc, IDinstruction;
    wire [31:0] regbusA, regbusB;
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
    wire [31:0] MEMpc, MEMres, MEMbusB, MEMDataOut;
    wire MEMRegWr, MEMMemWr, MEMMemtoReg, MEMzero;
    wire [1:0] MEMBranch;
    wire [31:0] MEMRegAddr;
    // Branch logic
    wire branch_ctrl;
    wire gtzoneout, gtztwoout, gtzfinal, nb0, nb1, beqyn, bneqyn;
    wire bctrl;

    // WR stage
    wire [31:0] busW, busW2;
    wire [31:0] regmuxout;
    wire [31:0] WRbusB, WRDataOut;
    wire WRRegWr, WRMemtoReg;

    // Organize this into the stages
    wire not_ld, not_clk;

    not_gate flip_clock (.x(clk), .z(not_clk));
    not_gate flip_ld (.x(pc_ld), .z(not_ld));


//Ifetch stage
    // wire [31:0] nextpc;
    // wire [31:0] currpc;
    // wire [31:0] nextipc; // from IUnit
    // wire [31:0] IFpc;
    // wire [31:0] IFinstruction;

    // to add stalling, must get the next 3 instructions, compare them
    // with result choose between NO OP 0x00000020 or fetched instruction
    // if NO OP set the PC back 4

    // MUX to decide between ipc and epc
    mux_32 nexpcmux (.src0(IFpc), .src1(MEMpc), .sel(branch_ctrl), .z(nextpc));
    // This is PC
    genvar i;
	generate
		for (i = 0; i < 32; i = i+1) begin
			dffr_a pc_dff (.clk(not_clk), .arst(1'b0), .aload(pc_ld), .adata(pc_data[i]), .enable(not_ld), .d(nextpc[i]), .q(currpc[i]));
		end
	endgenerate
    // This is the iunit
    iunit ifetch (.clk(clk), .curr_pc(currpc), .pc_plus_4(IFpctemp), .instr(IFinstructiontemp));
    defparam ifetch.dat_file = data_file;
    // STALLING CODE
    reg_32 Pinstruction1 (.d32(IFinstruction), .q32(pin1), .clk(clk));
    reg_32 Pinstruction2 (.d32(pin1), .q32(pin2), .clk(clk));
    reg_32 Pinstruction3 (.d32(pin2), .q32(pin3), .clk(clk));
    stallcheck2 stallchecker (.curr(IFinstructiontemp), .prev1(pin1), .prev2(pin2), .prev3(pin3), .stall(stall0));
    mux firstinversion (.sel(invertedstall), .src0(1'b1), .src1(1'b0), .z(stalled2));
    not_gate fixstall (.x(stall0), .z(invertedstall));
    mux_32 nexpcstall (.src1(currpc), .src0(IFpctemp), .sel(stalled2), .z(IFpc));
    mux_32 nexinstrstall (.src1(32'h00410020), .src0(IFinstructiontemp), .sel(stalled2), .z(IFinstruction));
    // END OF STALLING CODE
    // This is the register in between
    IF_ID_reg iunit_reg (.clk(clk), .pc_in(IFpc), .instr_in(IFinstruction), .pc_out(IDpc), .instr_out(IDinstruction));

// Control (happens during reg/dec stage)
    // wire RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, ExtOp;
    // wire [1:0] Branch;
    // wire [2:0] ALUop;
    // // Reg/Dec Stage
    // wire [31:0] IDpc, IDinstruction;
    // wire [31:0] regbusA, regbusB;
    // // Rs
    // wire [4:0] temp_Rs; 
    // // Rt
    // wire [4:0] temp_Rt;
    // // Rd
    // wire [4:0] temp_Rd;
    control cpucontrol (.op(IDinstruction[31:26]), .RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .RegWrite(RegWrite), .MemWrite(MemWrite), .Branch(Branch), .ExtOp(ExtOp), .ALUop(ALUOp));
// Reg/Dec Stage
    //wire [31:0] IDpc, IDinstruction;
    //swire [31:0] regbusA, regbusB;


    //// CHANGED instr to IDinstruction
    // Rs
    //wire [4:0] temp_Rs; 
    assign temp_Rs = IDinstruction[25:21];
    // Rt
    //wire [4:0] temp_Rt;
    assign temp_Rt = IDinstruction[20:16];
    // Rd
    //wire [4:0] temp_Rd;
    assign temp_Rd = IDinstruction[15:11];

    // More
    //and_gate hacky2 (busW, clockthing2, busW2);
    
    // Reg file
    reg_file registers(.clk(clk), .rw(regmuxout[4:0]), .ra(temp_Rs), .rb(temp_Rt), .we(WRRegWr), .outA(regbusA), .outB(regbusB), .inW(busW));
    // Register in between
    ID_EX_reg reg_reg(.clk(clk), .pc_in(IDpc), .pc_out(EXpc), .A_in(regbusA), .A_out(execbusA), .B_in(regbusB), .B_out(execbusB), .instr_in(IDinstruction), .instr_out(EXinstruction),
    .ExtOp_in(ExtOp), .ALUSrc_in(ALUSrc), .ALUOp_in(ALUOp), .RegDst_in(RegDst), .MemWr_in(MemWrite), .Br_in(Branch), .MemtoReg_in(MemtoReg), .RegWr_in(RegWrite), .ExtOp_out(EXExtOp), .ALUSrc_out(EXALUSrc), .ALUOp_out(EXALUOp), .RegDst_out(EXRegDst), .MemWr_out(EXMemWr), .Br_out(EXBranch), .MemtoReg_out(EXMemtoReg), .RegWr_out(EXRegWr));

// Exec Stage
    // wire [31:0] EXpc, EXinstruction, EXres, EXTarget;
    // wire EXRegWr, EXExtOp, EXALUSrc, EXALUOp, EXRegDst, EXMemWr, EXMemtoReg;
    // wire [1:0] EXBranch;
    // wire EXzero;
    // wire [4:0] EXRegAddr;

    // Exec Unit
    execunit eunit (.PC(EXpc), .busA(execbusA), .busB(execbusB), .instr(EXinstruction), .zero(EXzero), .ALUout(EXres), .Target(EXTarget), .ALUop(EXALUOp), .ExtOp(EXExtOp), .ALUSrc(EXALUSrc), .RegDst(EXRegDst), .Regout(EXRegAddr[4:0]));
    // Register
    EX_MEM_reg ememreg (.clk(clk), .zero_in(EXzero), .zero_out(MEMzero), .res_in(EXres), .res_out(MEMres), .B_in(execbusB), .B_out(MEMbusB), .target_in(EXTarget), .target_out(MEMpc),
    .MemWr_in(EXMemWr), .Br_in(EXBranch), .MemtoReg_in(EXMemtoReg), .RegWr_in(EXRegWr), .MemWr_out(MEMMemWr), .Br_out(MEMBranch), .MemtoReg_out(MEMMemtoReg), .RegWr_out(MEMRegWr), .regAddr_in(EXRegAddr), .regAddr_out(MEMRegAddr));

// Mem Stage
    // wire [31:0] MEMpc, MEMinstruction, MEMres, MEMbusB, MEMDataOut;
    // wire MEMRegWr, MEMMemWr, MEMMemtoReg, MEMzero;
    // wire [1:0] MEMBranch;
    // wire [4:0] MEMRegAddr;
    // // Branch logic
    // wire branch_ctrl;
    // wire gtzoneout, gtztwoout, gtzfinal, nb0, nb1, beqyn, bneqyn;
    // Data Memory
    sram2 datamem(.cs(1'b1) , .oe(1'b1) , .we(MEMMemWr) , .addr(MEMres) , .din(MEMbusB) , .dout(MEMDataOut));
    defparam datamem.mem_file = data_file;
    // Branch logic
    //wire branch_ctrl, msb;
    assign msb = MEMres[31];
    //wire gtzoneout, gtztwoout, gtzfinal, nb0, nb1, beqyn, bneqyn;

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

    // Register
    MEM_WR_reg mwreg (.clk(clk), .mem_in(MEMDataOut), .mem_out(WRDataOut), .B_in(MEMres), .B_out(WRbusB), .regWrAddr_in(MEMRegAddr), .regWrAddr_out(regmuxout), .MemtoReg_in(MEMMemtoReg), .MemtoReg_out(WRMemtoReg), .RegWr_in(MEMRegWr), .RegWr_out(WRRegWr));

// WR stage
    //wire [31:0] busW, WRbusB;
    //wire [4:0] regmuxout;
    //wire [31:0] WRbusB, WRDataOut;
    //wire WRMemWr, WRMemtoReg;
    // MUX
    mux_322 memreg(.sel(WRMemtoReg), .src0(WRbusB), .src1(WRDataOut), .z(busW)); // double check these inputs
endmodule