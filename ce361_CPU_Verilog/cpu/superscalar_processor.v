// Master module for superscalar processor
`timescale 1ns/10ps

module superscalar_processor(clock, reset, alu_1_out, alu_2_out, data_mem_out);

    input clock;
    input reset;

    output [31:0] alu_1_out;
    output [31:0] alu_2_out;
    output [31:0] data_mem_out;

    parameter data_file = "data/bills_branch.dat";
    
    //// wires to connect instruction fetch to hazard detector ////
    // instruction bits from IF to hazdet
    wire [31:0] alpha_inst;
    wire [31:0] beta_inst;
    wire [31:0] gamma_inst;

    // sequence numbers from IF to hazdet
    wire [15:0] alpha_seq_num;
    wire [15:0] beta_seq_num;
    wire [15:0] gamma_seq_num;

    // program counters from IF to hazdet (aka mem addr of each inst)
    wire [31:0] alpha_pc;
    wire [31:0] beta_pc;
    wire [31:0] gamma_pc;

    // program counters from hazdet back into IF
    wire [31:0] inst1_pc;
    wire [31:0] inst2_pc;
    wire [31:0] inst3_pc;


    //// wires to connect register info from pipelines in hazdet ////
    // ALU 1
    wire [4:0] pipeA_dest;
    wire [4:0] pipeA_src1;
    wire [4:0] pipeA_src2;

    // ALU 2
    wire [4:0] pipeB_dest;
    wire [4:0] pipeB_src1;
    wire [4:0] pipeB_src2;

    // Memory Ops
    wire [4:0] pipeC_dest;
    wire [4:0] pipeC_src1;


    //// wires from hazdet/decode out to the pipelines ins ////
    // Pipeline A -- ALU 1
    wire [5:0] pipeA_op_in;
    wire [4:0] pipeA_dest_in;
    wire [4:0] pipeA_src1_in;
    wire [4:0] pipeA_src2_in;
    wire [5:0] pipeA_func_in;
    wire [4:0] pipeA_shamt_in;
    wire [15:0] pipeA_imm_in;

    // Pipeline B -- ALU 2
    wire [6:0] pipeB_op_in;
    wire [4:0] pipeB_dest_in;
    wire [4:0] pipeB_src1_in;
    wire [4:0] pipeB_src2_in;
    wire [5:0] pipeB_func_in;
    wire [4:0] pipeB_shamt_in;
    wire [15:0] pipeB_imm_in;

    // Pipeline C -- Memory Ops
    wire [5:0] pipeC_op_in;
    wire [4:0] pipeC_dest_in;
    wire [4:0] pipeC_src1_in;
    wire [15:0] pipeC_imm_in;

    
    iunit instruction_mem_fetch();

    hazard_detect_decode haz_det_dec(
        .alpha_inst(alpha_inst), .alpha_seq_num(alpha_seq_num), .alpha_pc_in(alpha_pc),
        .beta_inst(beta_inst), .beta_seq_num(beta_seq_num), .beta_pc_in(beta_pc),
        .gamma_inst(gamma_inst), .gamma_seq_num(gamma_seq_num), .gamma_pc_in(gamma_pc),

        .pipeA_dest(pipeA_dest), .pipeA_src1(pipeA_src1), .pipeA_src2(pipeA_src2),
        .pipeB_dest(pipeB_dest), .pipeB_src1(pipeB_src1), .pipeB_src2(pipeB_src2),
        .pipeC_dest(pipeC_dest), .pipeC_src1(pipeC_src1),

        .inst1_pc_out(inst1_pc),
        .inst2_pc_out(inst2_pc),
        .inst3_pc_out(inst3_pc),
        
        .pipeA_op_in(pipeA_op_in), .pipeA_dest_in(pipeA_dest_in), .pipeA_src1_in(pipeA_src1_in), .pipeA_src2_in(pipeA_src2_in), .pipeA_func_in(pipeA_func_in), .pipeA_shamt_in(pipeA_shamt_in), .pipeA_imm_in(pipeA_imm_in),
        .pipeB_op_in(pipeB_op_in), .pipeB_dest_in(pipeB_dest_in), .pipeB_src1_in(pipeB_src1_in), .pipeB_src2_in(pipeB_src2_in), .pipeB_func_in(pipeB_func_in), .pipeB_shamt_in(pipeB_shamt_in), .pipeB_imm_in(pipeB_imm_in),
        .pipeC_op_in(pipeC_op_in), .pipeC_dest_in(pipeC_dest_in), .pipeC_src1_in(pipeC_src1_in), .pipeC_imm_in(pipeC_imm_in)
    );

    alu_subpipeline pipeA();

    alu_subpipeline pipeB();

    mem_subpipeline pipeC();


endmodule;