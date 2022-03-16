// `include "cpu/reg_32.v"
// `include "lib/dff.v"
// `include "extralib/not_gate_n2.v"

module ID_EX_reg(clk, pc_in, pc_out, A_in, A_out, B_in, B_out, instr_in, instr_out,
    ExtOp_in, ALUSrc_in, ALUOp_in, RegDst_in, MemWr_in, Br_in, MemtoReg_in, RegWr_in, ExtOp_out, ALUSrc_out, ALUOp_out, RegDst_out, MemWr_out, Br_out, MemtoReg_out, RegWr_out);
    
    input clk;

    // datapath signals
    input [31:0] pc_in;
    input [31:0] A_in;
    input [31:0] B_in;
    input [31:0] instr_in;
    output [31:0] pc_out;
    output [31:0] A_out;
    output [31:0] B_out;
    output [31:0] instr_out;

    // control signals
    input ExtOp_in;
    input ALUSrc_in;
    input [2:0] ALUOp_in;
    input RegDst_in;
    input MemWr_in;
    input [1:0] Br_in;
    input MemtoReg_in;
    input RegWr_in;
    output ExtOp_out;
    output ALUSrc_out;
    output [2:0] ALUOp_out;
    output RegDst_out;
    output MemWr_out;
    output [1:0] Br_out;
    output MemtoReg_out;
    output RegWr_out;

    reg_32 pc_reg (.clk(clk), .d32(pc_in), .q32(pc_out));
    reg_32 A_reg (.clk(clk), .d32(A_in), .q32(A_out));
    reg_32 B_reg (.clk(clk), .d32(B_in), .q32(B_out));
    reg_32 instr_reg (.clk(clk), .d32(instr_in), .q32(instr_out));

    dff ALUSrc_dff(.clk(clk), .d(ALUSrc_in), .q(ALUSrc_out));
    dff ExtOp_dff(.clk(clk), .d(ExtOp_in), .q(ExtOp_out));
    dff ALUOp_dff0(.clk(clk), .d(ALUOp_in[0]), .q(ALUOp_out[0]));
    dff ALUOp_dff1(.clk(clk), .d(ALUOp_in[1]), .q(ALUOp_out[1]));
    dff ALUOp_dff2(.clk(clk), .d(ALUOp_in[2]), .q(ALUOp_out[2]));
    dff RegDst_dff(.clk(clk), .d(RegDst_in), .q(RegDst_out));
    dff MemWr_dff(.clk(clk), .d(MemWr_in), .q(MemWr_out));
    dff Br_dff0(.clk(clk), .d(Br_in[0]), .q(Br_out[0]));
    dff Br_dff1(.clk(clk), .d(Br_in[1]), .q(Br_out[1]));
    dff MemtoReg_dff(.clk(clk), .d(MemtoReg_in), .q(MemtoReg_out));
    dff RegWr_dff(.clk(clk), .d(RegWr_in), .q(RegWr_out));

endmodule