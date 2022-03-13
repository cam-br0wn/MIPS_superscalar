`timescale 1ns/10ps
module adder_32(a, b, z);
    input [31:0] a;
    input [31:0] b;
    output wire [31:0] z;
    
    genvar i;
    wire [31:0] cout;


      for (i = 0; i < 32;  i = i+1) begin
          if (i == 0) begin
              Full_adder lsb(.A(a[i]) , .B(b[i]) , .CIN(1'b0) , .COUT(cout[i]) , .SUM(z[i]));
          end
          
          if ((i > 0) && (i < 31)) begin
              Full_adder mid(.A(a[i]) , .B(b[i]) , .CIN(cout[i-1]) , .COUT(cout[i]) , .SUM(z[i]));
          end
          
          if (i == 31) begin
              Full_adder msb(.A(a[i]) , .B(b[i]) , .CIN(cout[i-1]) , .COUT(cout[i]), .SUM(z[i]));
          end
          
    
      end
   endmodule
    
