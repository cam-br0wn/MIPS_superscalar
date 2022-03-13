module full_adder_1bit(x,y,c,z,cout);
    input x;
    input y;
    input c;
    output z;
    output cout;
    
    
    wire xor0;
    wire and0;
    wire and1;
    
    xor_gate xor0_map(.x(x), .y(y), .z(xor0));
    xor_gate xor1_map(.x(xor0), .y(c), .z(z));
    and_gate and0_map(.x(x), .y(y), .z(and0));
    and_gate and1_map(.x(xor0), .y(c), .z(and1));
    or_gate or0_map(.x(and0), .y(and1), .z(cout));
    
endmodule
    
    
