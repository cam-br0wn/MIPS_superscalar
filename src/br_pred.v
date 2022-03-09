//Written by Kate Li
//CE 362 Northwestern University
//Global Branch History Register (GHR)

/* Implements L/R logical shifting */

module shift_register #(parameter REG_DEPTH = 8) 
(
  input clk,       //clock signal
  input ena,       //enable signal
  input rst,       //reset signal
  input data_in,   //input bit
  output data_out[7:0]  //output bit
);

  reg [REG_DEPTH-1:0] data_reg;

  always @(posedge clk or posedge rst) begin  //asynchronous reset
    if (rst) begin
      data_reg <= {REG_DEPTH{1'b0}}; //load REG_DEPTH zeros
    end 
    else if (enable) begin
      data_reg <= {data_reg[REG_DEPTH-2:0], data_in}; //load input data as LSB and shift (left) all other bits 
    end
  end

  assign data_out = data_reg[REG_DEPTH-1]; //MSB is an output bit

endmodule

shift_register GHR(clk, en, 1'b0, out)