module mux_32 (in1, in2, out);
  
  input [31:0] in1;
  input [31:0] in2;
  output reg [31:0] out;
  

  always @(in1 or in2)
      begin
        out <= in1 + in2;
      end
   
endmodule