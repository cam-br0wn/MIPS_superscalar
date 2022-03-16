// `include "cpu/reg_32.v"
// `include "extralib/not_gate_n2.v"

module IF_ID_reg(clk, pc_in, instr_in, pc_out, instr_out);
    input clk;

    // datapath signals
    input [31:0] pc_in;
    input [31:0] instr_in;
    output [31:0] pc_out;
    output [31:0] instr_out;


    reg_32 pc_reg (.clk(clk), .d32(pc_in), .q32(pc_out));
    reg_32 instr_reg (.clk(clk), .d32(instr_in), .q32(instr_out));

endmodule


