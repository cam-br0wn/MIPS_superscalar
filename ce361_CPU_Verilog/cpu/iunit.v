// `include "extralib/sram2.v"
// `include "ece361_alu_verilog/adder_32.v"
// `include "cpu/reg_32.v"
// `include "cpu/IF_ID_reg.v"
// `include "extralib/mux_n2.v"

module iunit (clk, curr_pc, instr, pc_plus_4);
    parameter dat_file = "data/bills_branch.dat";
    input [31:0] curr_pc;
    //input [31:0] target;
    output [31:0] pc_plus_4;
    output [31:0] instr;
    input clk;

    // program counter (already in CPU)
   //  reg_32 prog_counter (.clk(clk), .d(next_pc), .q(curr_pc));

    // loads instructions into sram
    sram2 instr_mem(.cs(1'b1) , .oe(1'b1) , .we(1'b0) , .addr(curr_pc) , .din(0) , .dout(instr));
    defparam instr_mem.mem_file = dat_file;

    // adds "1" to PC
    adder_32 pc_adder(.a(curr_pc), .b(32'b00000000000000000000000000000100), .z(pc_plus_4));

    // mux to determine next instruction (0: PC +=4, 1: PC = jump to next instr) already in CPU
    //mux_n next_instr_mux(.sel(branch_ctrl), .src0(pc4_wire), .src1(target), .z(next_pc));
    //defparam next_instr_mux.n = 32;

    // stores values in register
    //IF_ID_reg iunit_reg (.clk(clk), .pc_in(pc4_wire), .instr_in(instr_wire), .pc_out(pc_plus_4), .instr_out(instr));

endmodule