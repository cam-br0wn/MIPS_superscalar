module and6to1 (a, b, c, d, e, f, g);
    input a, b, c, d, e, f;
    output g;

    wire andres0, andres1, andres2;

    and3to1 and0 (.w(a), .x(b), .y(c), .z(andres0));
    and3to1 and1 (.w(d), .x(e), .y(f), .z(andres1));
    and_gate and2 (.x(andres0), .y(andres1), .z(andres2));

    assign g = andres2;
endmodule