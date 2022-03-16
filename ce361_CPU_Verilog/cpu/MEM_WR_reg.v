// `include "cpu/reg_32.v"
// `include "lib/dff.v"
// `include "extralib/not_gate_n2.v"

module MEM_WR_reg(clk, mem_in, mem_out, B_in, B_out, regWrAddr_in, regWrAddr_out, MemtoReg_in, MemtoReg_out, RegWr_in, RegWr_out);
    input clk;

    // datapath signals
    input [31:0] mem_in;
    input [31:0] B_in;
    input [31:0] regWrAddr_in;
    output [31:0] mem_out;
    output [31:0] B_out;
    output [31:0] regWrAddr_out;

    // control signals
    input MemtoReg_in;
    input RegWr_in;
    output MemtoReg_out;
    output RegWr_out;

    reg_32 mem_dff (.clk(clk), .d32(mem_in), .q32(mem_out));
    reg_32 B_reg (.clk(clk), .d32(B_in), .q32(B_out));
    reg_32 rwa_reg (.clk(clk), .d32(regWrAddr_in), .q32(regWrAddr_out));

    dff MemtoReg_dff(.clk(clk), .d(MemtoReg_in), .q(MemtoReg_out));
    dff RegWr_dff(.clk(clk), .d(RegWr_in), .q(RegWr_out));
endmodule