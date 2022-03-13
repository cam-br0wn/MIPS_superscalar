`timescale 1ns/10ps
// Control unit PLA
module control_unit(op_code, reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, alu_op, beq, bne, bgtz);

    input [5:0] op_code;

    output wire reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, beq, bne, bgtz;
    output wire [1:0] alu_op;

    wire r_format, addi, lw, sw;
    wire [5:0] not_op_code;

    gac_not_gate_6_BHV not_op_code_(.x(op_code), .z(not_op_code));


    ///////////////////
    //// AND LAYER ////
    ///////////////////

    // r_format AND gate
    gac_and_gate_6in r_format_(.a(not_op_code[0]), .b(not_op_code[1]), .c(not_op_code[2]), .d(not_op_code[3]), .e(not_op_code[4]), .f(not_op_code[5]), .z(r_format));

    // addi AND gate
    gac_and_gate_6in addi_(.a(not_op_code[0]), .b(not_op_code[1]), .c(not_op_code[2]), .d(op_code[3]), .e(not_op_code[4]), .f(not_op_code[5]), .z(addi));

    // lw AND gate
    gac_and_gate_6in lw_(.a(op_code[0]), .b(op_code[1]), .c(not_op_code[2]), .d(not_op_code[3]), .e(not_op_code[4]), .f(op_code[5]), .z(lw));

    // sw AND gate
    gac_and_gate_6in sw_(.a(op_code[0]), .b(op_code[1]), .c(not_op_code[2]), .d(op_code[3]), .e(not_op_code[4]), .f(op_code[5]), .z(sw));

    // beq AND gate
    gac_and_gate_6in beq_(.a(not_op_code[0]), .b(not_op_code[1]), .c(op_code[2]), .d(not_op_code[3]), .e(not_op_code[4]), .f(not_op_code[5]), .z(beq));

    // bne AND gate
    gac_and_gate_6in bne_(.a(op_code[0]), .b(not_op_code[1]), .c(op_code[2]), .d(not_op_code[3]), .e(not_op_code[4]), .f(not_op_code[5]), .z(bne));

    // bgtz AND gate
    gac_and_gate_6in bgtz_(.a(op_code[0]), .b(op_code[1]), .c(op_code[2]), .d(not_op_code[3]), .e(not_op_code[4]), .f(not_op_code[5]), .z(bgtz));


    //////////////////
    //// OR LAYER ////
    //////////////////

    // reg_dst = r_format
    assign reg_dst = r_format;

    // alu_src = addi | lw | sw
    wire addi_lw;
    gac_or_gate addi_lw_(.x(addi), .y(lw), .z(addi_lw));
    gac_or_gate addi_lw_sw_(.x(addi_lw), .y(sw), .z(alu_src));

    // mem_to_reg = lw
    assign mem_to_reg = lw;

    // reg_write = r_format | addi | lw
    gac_or_gate addi_lw_r_format_(.x(addi_lw), .y(r_format), .z(reg_write));

    // mem_read = sw | lw
    gac_or_gate sw_lw_(.x(sw), .y(lw), .z(mem_read));

    // mem_write = sw
    assign mem_write = sw;

    // alu_op[0] = beq | bne | bgtz
    wire beq_bne;
    gac_or_gate beq_bne_(.x(beq), .y(bne), .z(beq_bne));
    gac_or_gate beq_bne_bgtz_(.x(beq_bne), .y(bgtz), .z(alu_op[0]));

    // alu_op[1] = r_format
    assign alu_op[1] = r_format;

    // We don't need to assign the breaks since they are just the results of their respective ANDs


endmodule