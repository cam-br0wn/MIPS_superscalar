module Full_adder(A, B, CIN, COUT, SUM);
    
    input A;
    input B;
    input CIN;
    output COUT;
    output SUM;
    
    wire XOR2_0_OUT;
    wire AND2_0_OUT;
    wire AND2_1_OUT;
    
 
        xor_gate XOR2_0_map(.x(A), .y(B), .z(XOR2_0_OUT));
        xor_gate XOR2_1_map(.x(XOR2_0_OUT), .y(CIN), .z(SUM));
        and_gate AND2_0_map(.x(XOR2_0_OUT), .y(CIN), .z(AND2_0_OUT));
        and_gate AND2_1_map(.x(A), .y(B), .z(AND2_1_OUT));
        or_gate OR2_map(.x(AND2_0_OUT), .y(AND2_1_OUT), .z(COUT));
    
endmodule
