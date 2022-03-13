module SLT(A,B,ovf,R);
    input [31:0] A;
    input [31:0] B;
    output ovf;
    output [31:0] R;
    
    wire [31:0] sub_z;
    wire sub_borrow;
    wire sub_ovf;
    wire [31:0] temp;
    
    assign temp = 32'h00000000;
    
    assign R[31:1] = temp[30:0];
    
    SUB_32bit SUB(.x(A), .y(B), .cin(1'b1), .z(sub_z), .borrow(sub_borrow), .ovf(ovf));
    
    assign R[0] = sub_borrow;
    
endmodule
