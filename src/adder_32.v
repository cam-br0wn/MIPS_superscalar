`timescale 1ns/10ps
module adder_32(a, b, q);
    input   [31:0]  a, b;
    output  [31:0]  q;
    wire            carry_out;
    wire    [31:0]  carry;
   
    genvar i;
    generate 
        for(i = 0; i < 32; i = i + 1)
            begin: gen_32_bit_Adder
                if(i==0) 
                    half_adder f(a[0],b[0],q[0],carry[0]);
                else
                    full_adder f(a[i],b[i],carry[i-1],b[i],carry[i]);
            end
        assign carry_out = carry[31];
    endgenerate
endmodule 

module half_adder(x,y,s,c);
    input x,y;
    output s,c;
    assign s=x^y;
    assign c=x&y;
endmodule // half adder

module full_adder(x,y,c_in,s,c_out);
    input x,y,c_in;
    output s,c_out;
    assign s = (x^y) ^ c_in;
    assign c_out = (y&c_in)| (x&y) | (x&c_in);
endmodule // full_adder