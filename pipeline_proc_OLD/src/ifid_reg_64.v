`timescale 1ns/10ps
// A single 32-bit register

module ifid_reg_64(clk, areset, aload, adata, data_in, write_enable, data_out);

input clk;
input areset;
input aload;
input [63:0] adata;
input [63:0] data_in;
input write_enable;
output wire [63:0] data_out;

genvar i;
generate
    for(i = 0; i < 64; i = i + 1) begin
        gac_dffr_a flipflop_(.clk(clk), 
                        .arst(areset), 
                        .aload(aload), 
                        .adata(adata[i]), 
                        .d(data_in[i]), 
                        .enable(write_enable), 
                        .q(data_out[i]));
    end
endgenerate

endmodule