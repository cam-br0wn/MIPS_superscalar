module or3to1 (w, x, y, z);
    input w, x, y;
    output z;

    wire orres0, orres1;

    or_gate or0 (.x(w), .y(x), .z(orres0));
    or_gate or1 (.x(orres0), .y(y), .z(orres1));

    assign z = orres1;
endmodule
