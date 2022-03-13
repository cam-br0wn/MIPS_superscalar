`timescale 1ns/10ps

module pipeline_processor(clk, reset, load_pc, result);

input clk, reset;
input [31:0] load_pc;

output result;



//// Instruction Fetch stage ////

// fed into inst_fetch_mux
wire branch_taken;
wire [31:0] offset;
wire [31:0] four;
// comes out of instruction fetch mux
wire [31:0] inst_fetch_mux_out;

mux_32 inst_fetch_mux(.in1(offset), .in2(four), .sel(branch_taken), .out(inst_fetch_mux_out));

// fed into adder before program counter
wire [31:0] pc_out;
// comes out of adder before program counter
wire [31:0] incremented_pc;

add_32 pc_adder(.in1(inst_fetch_mux_out), .in2(pc_out), .out(incremented_pc));

// fed into program counter
wire hazard_detected_signal;
// output of program counter is pc_out (defined above)

program_counter pc(.in(incremented_pc), .hazard_detected_signal(hazard_detected_signal), .out(pc_out));

// the output wire of the instruction memory
wire [4:0] inst_mem_src1;
wire [4:0] inst_mem_src2;
wire [4:0] inst_mem_dest;
wire [5:0] inst_mem_op;
wire [5:0] inst_mem_func;
wire [15:0] inst_mem_immediate;

// instruction memory module only takes in the pc, unless reset is high, in which case, it takes load_pc (can be handled behaviorally?)
instruction_memory ins_mem(.in(pc_out), .src1(inst_mem_src1), .src2(inst_mem_src2), .dest(inst_mem_dest), .op(inst_mem_op), .func(inst_mem_func), .imm(inst_mem_immediate));

//// End of Instruction Fetch stage ////



//// IF/ID register ////

// wire for flush input to IF/ID register
wire flush;
// output wires for PC from IF/ID register, src1, src2, dest, immediate, operand
wire [31:0] if_id_pc;
wire [4:0] src_1;
wire [4:0] src_2;
wire [4:0] dest;
wire [15:0] immediate;
wire [5:0] operand;

if_id_register if_id_reg(.pc_in(pc_out), .pc_out(if_id_pc),
                         .if_id_src1_in(inst_mem_src1), if_id_src1_out(src_1),
                         .if_id_src2_in(inst_mem_src2), if_id_src2_out(src_2),
                         .if_id_dest_in(inst_mem_dest), if_id_dest_out(dest),
                         .if_id_imm_in(inst_mem_immediate), .if_id_imm_out(immediate),
                         .if_id_op_in(inst_mem_op), .if_id_op_out(operand));

//// End of IF/ID register ////



//// Instruction Decode Stage ////

// store_or_bne is from Control Unit -> mux going into register file
wire store_or_bne;
// output of mux going into regfile
wire [4:0] mux_src2;

mux_5 mux_to_reg_file(.in1(src_2), .in2(dest), .sel(store_or_bne), .out(mux_src2));


// register file inputs
wire [4:0] dest_wb;
wire [4:0] result_wb;
wire wb_en;
// register file outputs
wire [31:0] reg_1;
wire [31:0] reg_2;

register_file reg_file(.src1(src_1), .src2_dest(mux_src2), .dest_wb(dest_wb), .result_wb(result_wb), .wb_enable(wb_en), .reg1(reg_1), .reg2(reg_2));


// sign extender output wire
wire [31:0] sign_ext_out;

sign_extender sign_ext(.in(immediate), .out(sign_ext_out));


// control unit output wires
wire is_immediate;
wire is_branch;
wire cond_check_in;
wire control_unit_wb_en;
wire control_unit_mem_r_en;
wire control_unit_mem_w_en;
wire [2:0] control_unit_exe_cmd;

control_unit control_unit_(.op(operand), .is_imm(is_immediate), .is_br(is_branch), .cond_check(cond_check_in), .wb_en(control_unit_wb_en), .mem_r(control_unit_mem_r_en), .mem_w(control_unit_mem_w_en), .exe_cmd(control_unit_exe_cmd));


// condition check output wire
wire cond_check_out;

condition_check cond_check(.reg1(reg_1), .reg2(reg_2), .control_unit_signal(cond_check_in), .out(cond_check_out));


// AND between control unit and condition check output wire
wire br_taken;

and_1 branch_taken_AND(.in1(is_branch), .in2(cond_check_out), .out(br_taken));


// is immediate mux output wire
wire [4:0] imm_mux_out;

mux_5 imm_mux(.in1(src_2), .in2(5'b00000), .sel(is_immediate));


// sign extender mux output wire
wire [31:0] sign_ext_mux_out;

mux_32 sign_ext_mux(.in1(reg_2), .in2(sign_ext_out), .sel(is_immediate), .out(sign_ext_mux_out));

//// END instruction decode phase ////



//// ID/EX register ////

// output wires for ID/EX register
wire id_ex_wb_en;
wire id_ex_mem_r_en;
wire id_ex_mem_w_en;
wire [2:0] id_ex_exe_cmd;
wire [31:0] id_ex_pc;
wire [31:0] val_1;
wire [31:0] val_2;
wire [31:0] id_ex_reg_2;
wire [4:0] id_ex_src_1;
wire [4:0] id_ex_src_2;
wire [4:0] id_ex_dest;

id_ex_register id_ex(.wb_en_in(control_unit_wb_en), .wb_en_out(id_ex_wb_en),
                     .mem_r_in(control_unit_mem_r_en), .mem_r_out(id_ex_mem_r_en),
                     .mem_w_in(control_unit_mem_w_en), .mem_w_out(id_ex_mem_w_en),
                     .exe_cmd_in(control_unit_exe_cmd), .exe_cmd_out(id_ex_exe_cmd),
                     .pc_in(if_id_pc), .pc_out(id_ex_pc),
                     .val1_in(reg_1), .val1_out(val_1),
                     .val2_in(sign_ext_mux_out), .val2_out(val_2),
                     .reg2_in(reg_2), .reg2_out(id_ex_reg_2),
                     .src1_in(src_1), .src1_out(id_ex_src1),
                     .src2_in(imm_mux_out), .src2_out(id_ex_src_2),
                     .dest_in(dest), .dest_out(id_ex_dest));

//// END ID/EX register ////



//// Execute Stage ////

// ALU output wire
wire [31:0] alu_result;

ALU alu(.in1(val_1), .in2(val_2), .control(id_ex_exe_cmd), .out(alu_result));

//// END Execute Stage ////



//// EX/MEM register ////

// output wires from EX/MEM register
wire ex_mem_wb_en;
wire ex_mem_r_en;
wire ex_mem_w_en;
wire [31:0] ex_mem_pc;
wire [31:0] ex_mem_alu_result;
wire [31:0] ex_mem_st_value;
wire [4:0] ex_mem_dest;

ex_mem_register ex_mem_reg(.wb_in(id_ex_wb_en), .wb_out(ex_mem_wb_en),
                           .mem_r_in(id_ex_mem_r_en), .mem_r_out(ex_mem_r_en),
                           .mem_w_in(id_ex_mem_w_en), .mem_w_out(ex_mem_w_en),
                           .pc_in(id_ex_pc), .pc_out(ex_mem_pc),
                           .alu_res_in(alu_result), .alu_res_out(ex_mem_alu_result),
                           .st_in(id_ex_reg_2), .st_out(ex_mem_st_value),
                           .dest_in(id_ex_dest), .dest_out(ex_mem_dest));

//// END EX/MEM register ////



//// Memory Stage ////

// output wire from data memory
wire [31:0] data_mem_out;

data_memory data_mem(.alu_res_in(ex_mem_alu_result), .st_val_in(ex_mem_st_value), .mem_r_in(ex_mem_r_en), .mem_w_in(ex_mem_w_en), .out(data_mem_out));

//// END Memory Stage ////



//// Hazard Detection ////

hazard_detection_unit haz_detect(.src1(src_1), .src2(src_2), .is_br(is_branch) .exe_dest(id_ex_dest), .id_ex_mem_r_en(id_ex_mem_r_en), .ex_mem_r_en(ex_mem_r_en), .ex_mem_dest(ex_mem_dest), .out(hazard_detected_signal));

//// END Hazard Detection ////



//// MEM/WB Register ////

wire mem_wb_wb_en;
wire mem_wb_mem_r_en;
wire [31:0] mem_wb_data_mem;
wire [31:0] mem_wb_alu_res;

mem_wb_register mem_wb_reg(.wb_en_in(ex_mem_wb_en), .wb_en_out(mem_wb_wb_en),
                           .mem_r_in(ex_mem_r_en), .mem_r_out(mem_wb_mem_r_en),
                           .data_mem_in(data_mem_out), .data_mem_out(mem_wb_data_mem),
                           .alu_res_in(ex_mem_alu_result), .alu_res_out(mem_wb_alu_res));

//// END MEM/WB Register ////



//// Write-back stage ////

assign wb_en = mem_wb_wb_en;

mux_32 wb_mux(.in1(mem_wb_data_mem), .in2(mem_wb_alu_res), .sel(mem_wb_mem_r_en), .out(result_wb));

//// END Write-back stage ////

endmodule