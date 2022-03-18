// `include "extralib/sram2.v"
// `include "ece361_alu_verilog/adder_32.v"
// `include "cpu/reg_32.v"
// `include "cpu/IF_ID_reg.v"
// `include "extralib/mux_n2.v"

module iunit (clk, curr_pc0, curr_pc1, curr_pc2, instr0, instr1, instr2, pc_plus_4);
    parameter dat_file = "data/bills_branch.dat";
    input [31:0] curr_pc0;
    input [31:0] curr_pc1;
    input [31:0] curr_pc2;
    //input [31:0] target;
    output [31:0] pc_plus_4;
    output [31:0] instr0;
    output [31:0] instr1;
    output [31:0] instr2;
    input clk;



    // program counter (already in CPU)
   //  reg_32 prog_counter (.clk(clk), .d(next_pc), .q(curr_pc));

    // loads instructions into sram
    // sram_3 instr_mem(.cs(1'b1) , .oe_1(1'b1) , .oe_2(), .oe_3(), .we(1'b0), .addr_0(curr_pc1) , .din(0) , .dout(instr));

    sram_3 instr_mem(.cs(1'b1), .oe_0(1'b1), .oe_1(1'b1), oe_2(1'b1), we_0(1'b0), we_1(1'b0), we_2(1'b0), addr_0(curr_pc0), addr_1(curr_pc1), addr_2(curr_pc_2), din_0(0), din_1(0), din_2(0), dout_0(instr0), dout_1(instr1), dout_2(instr2));
    defparam instr_mem.mem_file = dat_file;

    // adds "1" to PC
    adder_32 pc_adder(.a(curr_pc), .b(32'b00000000000000000000000000000100), .z(pc_plus_4));

    // mux to determine next instruction (0: PC +=4, 1: PC = jump to next instr) already in CPU
    //mux_n next_instr_mux(.sel(branch_ctrl), .src0(pc4_wire), .src1(target), .z(next_pc));
    //defparam next_instr_mux.n = 32;

    // stores values in register
    //IF_ID_reg iunit_reg (.clk(clk), .pc_in(pc4_wire), .instr_in(instr_wire), .pc_out(pc_plus_4), .instr_out(instr));

endmodule
