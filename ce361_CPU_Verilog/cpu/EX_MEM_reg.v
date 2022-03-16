// `include "cpu/reg_32.v"
// `include "lib/dff.v"
// `include "extralib/not_gate_n2.v"

module EX_MEM_reg(clk, zero_in, zero_out, res_in, res_out, B_in, B_out, target_in, target_out,
    MemWr_in, Br_in, MemtoReg_in, RegWr_in, MemWr_out, Br_out, MemtoReg_out, RegWr_out, regAddr_in, regAddr_out);
    
    input clk;

    // datapath signals
    input [31:0] target_in;
    input zero_in;
    input [31:0] res_in;
    input [31:0] B_in;
    input [31:0] regAddr_in; 
    output [31:0] target_out;
    output [31:0] res_out;
    output [31:0] B_out;
    output [31:0] regAddr_out;
    output zero_out;

    // control signals
    input MemWr_in;
    input [1:0] Br_in;
    input MemtoReg_in;
    input RegWr_in;
    output MemWr_out;
    output [1:0] Br_out;
    output MemtoReg_out;
    output RegWr_out;

    reg_32 targetAddr_reg (.clk(clk), .d32(target_in), .q32(target_out));
    reg_32 B_reg (.clk(clk), .d32(B_in), .q32(B_out));
    reg_32 res_reg (.clk(clk), .d32(res_in), .q32(res_out));
    reg_32 regAddr_reg0(.clk(clk), .d32(regAddr_in), .q32(regAddr_out));
    dff zero_dff (.clk(clk), .d(zero_in), .q(zero_out));

    dff MemWr_dff(.clk(clk), .d(MemWr_in), .q(MemWr_out));
    dff Br_dff0(.clk(clk), .d(Br_in[0]), .q(Br_out[0]));
    dff Br_dff1(.clk(clk), .d(Br_in[1]), .q(Br_out[1]));
    dff MemtoReg_dff(.clk(clk), .d(MemtoReg_in), .q(MemtoReg_out));
    dff RegWr_dff(.clk(clk), .d(RegWr_in), .q(RegWr_out));

endmodule