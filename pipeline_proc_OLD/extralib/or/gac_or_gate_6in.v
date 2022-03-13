`timescale 1ns/10ps
// 6 input AND gate for the PLA
module gac_or_gate_6in(a, b, c, d, e, f, z);

    input a, b, c, d, e, f;
    output wire z;

    wire ab;
    wire cd;
    wire ef;
    wire abcd;

    gac_or_gate ab_(.x(a), .y(b), .z(ab));
    gac_or_gate cd_(.x(c), .y(d), .z(cd));
    gac_or_gate ef_(.x(e), .y(f), .z(ef));
    gac_or_gate abcd_(.x(ab), .y(cd), .z(abcd));
    gac_or_gate res_(.x(abcd), .y(ef), .z(z));

endmodule