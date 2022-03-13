module program_counter (in, hazard_detected_signal, out);
  
  input [31:0] in;
  input hazard_detected_signal;
  output reg [31:0] out;
  

  always @ in
      begin
        if (~hazard_detected_signal) out <= in;
        else out <= out;
      end
   
endmodule