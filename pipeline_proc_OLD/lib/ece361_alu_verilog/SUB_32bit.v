module SUB_32bit(x,y,cin,z,borrow,ovf);
    
    input [31:0] x;
    input [31:0] y;
    input cin;
    output wire [31:0] z;
    output borrow;
    output ovf;
    
    wire [31:0] noty;
    wire [31:0] t;
    
    xor_gate xor0_map(.x(1'b1), .y(y[0]), .z(noty[0]));
    
    full_adder_1bit sub0(.x(x[0]), .y(noty[0]), .c(1'b1), .z(z[0]), .cout(t[0]));
    
    genvar i;
    for (i=1;i<32;i=i+1) begin
        xor_gate xor0_map(.x(1'b1), .y(y[i]), .z(noty[i]));
        full_adder_1bit sub0(.x(x[i]), .y(noty[i]), .c(t[i-1]), .z(z[i]), .cout(t[i]));
    end
    
    xor_gate xor32_map(.x(1'b1), .y(t[31]), .z(borrow));
    xor_gate xor33_map(.x(t[31]), .y(t[30]), .z(ovf));
    
endmodule
        
