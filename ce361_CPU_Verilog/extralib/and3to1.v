module and3to1 (w,x,y,z);
    input w;
    input x;
    input y;
    output z;

    wire andres0;
    wire andres1;

    and_gate and0 (.x(w), .y(x), .z(andres0));
    and_gate and1 (.x(andres0), .y(y), .z(andres1));

    assign z = andres1;
endmodule