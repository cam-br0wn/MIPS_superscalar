module full_adder_32bit(x,y,cin,z,cout,ovf);
    
    input [31:0] x;
    input [31:0] y;
    input cin;
    output wire [31:0] z;
    output wire cout;
    output wire ovf;
    
    
    wire [31:1] t;
    wire t_out;
    
    full_adder_1bit fa0_map(.x(x[0]), .y(y[0]), .c(cin), .z(z[0]), .cout(t[1]));
    
    genvar i;
    for (i=1; i<31;i=i+1) begin
        full_adder_1bit fa1_map(.x(x[i]), .y(y[i]), .c(t[i]), .z(z[i]), .cout(t[i+1]));
    end
    
      full_adder_1bit fa2_map(.x(x[31]), .y(y[31]), .c(t[31]), .z(z[31]), .cout(t_out));
      
      xor_gate xor_map(.x(t[31]), .y(t_out), .z(ovf));
      
      assign cout = t_out;
      
  endmodule