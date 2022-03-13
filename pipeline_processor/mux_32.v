module mux_32 (in1, in2, sel, out);
  
  input sel; // MODIFIED BY CAM
  input [31:0] in1;
  input [31:0] in2;
  output reg [31:0] out;
  

  always @(sel or in1 or in2)
      begin
        if (sel == 1'b0) out <= in1;
        else out <= in2;
      end
   
endmodule