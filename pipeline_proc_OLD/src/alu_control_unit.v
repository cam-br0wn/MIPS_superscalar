// Control PLA for the ALU
`timescale 1ns/10ps
module alu_control_unit(inst, alu_op, sel);

    input [5:0] inst;
    input [1:0] alu_op;
    output wire [2:0] sel;

    wire [5:0] not_inst;
    wire [1:0] not_alu_op;

    // create inverted versions of the inputs
    gac_not_gate_6_BHV not_inst_(.x(inst), .z(not_inst));
    gac_not_gate not_inst_0(.x(alu_op[0]), .z(not_alu_op[0]));
    gac_not_gate not_inst_1(.x(alu_op[1]), .z(not_alu_op[1]));

    ///////////////////
    //// AND LAYER ////
    ///////////////////

    // first, make an and-gate output checking for r-type
    wire r_type;
    gac_and_gate r_type_(.x(not_alu_op[0]), .y(alu_op[1]), .z(r_type));

    // ADD
    wire add_, add_r;
    gac_and_gate_6in add__(.a(not_inst[0]), .b(not_inst[1]), .c(not_inst[2]), .d(not_inst[3]), .e(not_inst[4]), .f(inst[5]), .z(add_));
    gac_and_gate add_r_(.x(add_), .y(r_type), .z(add_r));

    // ADDU
    wire addu_, addu_r;
    gac_and_gate_6in addu__(.a(inst[0]), .b(not_inst[1]), .c(not_inst[2]), .d(not_inst[3]), .e(not_inst[4]), .f(inst[5]), .z(addu_));
    gac_and_gate addu_r_(.x(addu_), .y(r_type), .z(addu_r));

    // SUB
    wire sub_, sub_r;
    gac_and_gate_6in sub__(.a(not_inst[0]), .b(inst[1]), .c(not_inst[2]), .d(not_inst[3]), .e(not_inst[4]), .f(inst[5]), .z(sub_));
    gac_and_gate sub_r_(.x(sub_), .y(r_type), .z(sub_r));

    // SUBU
    wire subu_, subu_r;
    gac_and_gate_6in subu__(.a(inst[0]), .b(inst[1]), .c(not_inst[2]), .d(not_inst[3]), .e(not_inst[4]), .f(inst[5]), .z(subu_));
    gac_and_gate subu_r_(.x(subu_), .y(r_type), .z(subu_r));

    // AND
    wire and_, and_r;
    gac_and_gate_6in and__(.a(not_inst[0]), .b(not_inst[1]), .c(inst[2]), .d(not_inst[3]), .e(not_inst[4]), .f(inst[5]), .z(and_));
    gac_and_gate and_r_(.x(and_), .y(r_type), .z(and_r));

    // OR
    wire or_, or_r;
    gac_and_gate_6in or__(.a(inst[0]), .b(not_inst[1]), .c(inst[2]), .d(not_inst[3]), .e(not_inst[4]), .f(inst[5]), .z(or_));
    gac_and_gate or_r_(.x(or_), .y(r_type), .z(or_r));

    // SLL
    wire sll_, sll_r;
    gac_and_gate_6in sll__(.a(not_inst[0]), .b(not_inst[1]), .c(not_inst[2]), .d(not_inst[3]), .e(not_inst[4]), .f(not_inst[5]), .z(sll_));
    gac_and_gate sll_r_(.x(sll_), .y(r_type), .z(sll_r));

    // SLT
    wire slt_, slt_r;
    gac_and_gate_6in slt__(.a(not_inst[0]), .b(inst[1]), .c(not_inst[2]), .d(inst[3]), .e(not_inst[4]), .f(inst[5]), .z(slt_));
    gac_and_gate slt_r_(.x(slt_), .y(r_type), .z(slt_r));

    // SLTU
    wire sltu_, sltu_r;
    gac_and_gate_6in sltu__(.a(inst[0]), .b(inst[1]), .c(not_inst[2]), .d(inst[3]), .e(not_inst[4]), .f(inst[5]), .z(sltu_));
    gac_and_gate sltu_r_(.x(sltu_), .y(r_type), .z(sltu_r));

    // ADDI
    wire addi_;
    gac_and_gate addi__(.x(not_alu_op[0]), .y(not_alu_op[1]), .z(addi_));

    // BRANCH
    wire branch_;
    gac_and_gate branch__(.x(alu_op[0]), .y(not_alu_op[1]), .z(branch_));


    //////////////////
    //// OR LAYER ////
    //////////////////


    // sel[0]
    wire or_sll;
    wire slt_sltu;
    gac_or_gate or_sll_(.x(or_r), .y(sll_r), .z(or_sll));
    gac_or_gate slt_sltu_(.x(slt_r), .y(sltu_r), .z(slt_sltu));
    gac_or_gate sel_0_(.x(or_sll), .y(slt_sltu), .z(sel[0]));


    // sel[1]
    wire sub_subu;
    wire add_addi;
    wire add_addi_br;
    wire add_br_sub;
    gac_or_gate sub_subu_(.x(sub_r), .y(subu_r), .z(sub_subu));
    gac_or_gate add_addi_(.x(add_r), .y(addi_), .z(add_addi));
    gac_or_gate add_addi_br_(.x(add_addi), .y(branch_), .z(add_addi_br));
    gac_or_gate add_br_sub_(.x(sub_subu), .y(add_addi_br), .z(add_br_sub));
    gac_or_gate sel_1_(.x(add_br_sub), .y(slt_sltu), .z(sel[1]));


    // sel[2]
    wire addu_sll;
    wire sltu_br;
    wire addu_sll_sltu_br;
    gac_or_gate addu_sll_(.x(addu_r), .y(sll_r), .z(addu_sll));
    gac_or_gate sltu_br_(.x(sltu_r), .y(branch_), .z(sltu_br));
    gac_or_gate addu_sll_sltu_br_(.x(addu_sll), .y(sltu_br), .z(addu_sll_sltu_br));
    gac_or_gate sel_2_(.x(addu_sll_sltu_br), .y(sub_subu), .z(sel[2]));


endmodule