`timescale 1ns/10ps
module branch_unit(beq_f, bne_f, bgtz_f, zf, msb, br_sel);

    input beq_f, bne_f, bgtz_f, zf, msb;
    output wire br_sel;

    wire beq_out;
    gac_and_gate beq_(.x(zf), .y(beq_f), .z(beq_out));

    wire not_zero_;
    gac_not_gate not_zero(
        .x(zf),
        .z(not_zero_)
    );

    wire bne_out;
    gac_and_gate bne_and(
        .x(bne_f),
        .y(not_zero_),
        .z(bne_out)
    );

    wire or_zf_msb;
    gac_or_gate or_zf_msb_(
        .x(zf),
        .y(msb),
        .z(or_zf_msb)
    );

    wire bgtz_out;
    gac_not_gate not_or_zf_msb(
        .x(or_zf_msb),
        .z(bgtz_out)
    );

    wire or_beq_bne;
    gac_or_gate or_bne_(
        .x(beq_out),
        .y(bne_out),
        .z(or_beq_bne)
    );

    wire bgtz_flag;
    gac_and_gate and_bgtz(
        .x(bgtz_f),
        .y(bgtz_out),
        .z(bgtz_flag)
    );

    gac_or_gate branch_sel_bit(
        .x(or_beq_bne),
        .y(bgtz_flag),
        .z(br_sel)
    );

endmodule