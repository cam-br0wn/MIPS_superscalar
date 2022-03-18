`timescale 1ns/10ps

module SS_HazDet (
    alpha_inst, alpha_seq_num, alpha_pc_in,
    beta_inst, beta_seq_num, beta_pc_in,
    gamma_inst, gamma_seq_num, gamma_pc_in,
    pipeA_dest, pipeA_src1, pipeA_src2,
    pipeB_dest, pipeB_src1, pipeB_src2,
    pipeC_dest, pipeC_src1,
    inst1_pc_out,
    inst2_pc_out,
    inst3_pc_out,
    pipeA_op_in, pipeA_dest_in, pipeA_src1_in, pipeA_src2_in, pipeA_func_in, pipeA_shamt_in, pipeA_imm_in,
    pipeB_op_in, pipeB_dest_in, pipeB_src1_in, pipeB_src2_in, pipeB_func_in, pipeB_shamt_in, pipeB_imm_in,
    pipeC_op_in, pipeC_dest_in, pipeC_src1_in, pipeC_imm_in,
    );

    // alpha, beta && gamma are labels from instructions being fed into hazard detection
    input [31:0] alpha_inst;
    input [15:0] alpha_seq_num;
    input [31:0] alpha_pc_in;
    
    input [31:0] beta_inst;
    input [15:0] beta_seq_num; 
    input [31:0] beta_pc_in;

    input [31:0] gamma_inst;
    input [15:0] gamma_seq_num;
    input [31:0] gamma_pc_in;

    // Current registers of 1st ALU pipeline
    input [4:0] pipeA_dest;
    input [4:0] pipeA_src1;
    input [4:0] pipeA_src2;

    // Current registers of 2nd ALU pipeline
    input [4:0] pipeB_dest;
    input [4:0] pipeB_src1;
    input [4:0] pipeB_src2;

    // Current registers of Memory pipeline
    input [4:0] pipeC_dest;
    input [4:0] pipeC_src1;

    // local variables that are just booleans to mark for stalling
    integer inst1_stall;
    integer inst2_stall;
    integer inst3_stall;

    // registers to hold sorted instructions by sequence number
    reg [31:0] first_inst;
    reg [31:0] second_inst;
    reg [31:0] third_inst;

    // instruction output of each instruction after ordering
    reg [31:0] inst1_inst_out;
    reg [31:0] inst2_inst_out;
    reg [31:0] inst3_inst_out;

    // corresponding pipeline wires
    // Pipeline A -- ALU 1
    output wire [5:0] pipeA_op_in;
    output wire [4:0] pipeA_dest_in;
    output wire [4:0] pipeA_src1_in;
    output wire [4:0] pipeA_src2_in;
    output wire [5:0] pipeA_func_in;
    output wire [4:0] pipeA_shamt_in;
    output wire [15:0] pipeA_imm_in;

    // Pipeline B -- ALU 2
    output wire [6:0] pipeB_op_in;
    output wire [4:0] pipeB_dest_in;
    output wire [4:0] pipeB_src1_in;
    output wire [4:0] pipeB_src2_in;
    output wire [5:0] pipeB_func_in;
    output wire [4:0] pipeB_shamt_in;
    output wire [15:0] pipeB_imm_in;

    // Pipeline C -- Memory Ops
    output wire [5:0] pipeC_op_in;
    output wire [4:0] pipeC_dest_in;
    output wire [4:0] pipeC_src1_in;
    output wire [15:0] pipeC_imm_in;

    // program counter output of each instruction after ordering (to be passed to pipelines/instruction fetch)
    output reg [31:0] inst1_pc_out;
    output reg [31:0] inst2_pc_out;
    output reg [31:0] inst3_pc_out;

    // registers to store the program counter of the instructions after ordering (necessary for stalling)
    reg [31:0] first_pc;
    reg [31:0] second_pc;
    reg [31:0] third_pc;

    // Decode registers for instruction 1
    reg [4:0] inst1_dest;
    reg [4:0] inst1_src1;
    reg [4:0] inst1_src2;
    reg [15:0] inst1_immediate;
    reg [5:0] inst1_op;
    reg [5:0] inst1_func;
    reg [4:0] inst1_shift_amt;

    // Decode registers for instruction 2
    reg [4:0] inst2_dest;
    reg [4:0] inst2_src1;
    reg [4:0] inst2_src2;
    reg [15:0] inst2_immediate;
    reg [5:0] inst2_op;
    reg [5:0] inst2_func;
    reg [4:0] inst2_shift_amt;

    // Decode registers for instruction 3
    reg [4:0] inst3_dest;
    reg [4:0] inst3_src1;
    reg [4:0] inst3_src2;
    reg [15:0] inst3_immediate;
    reg [5:0] inst3_op;
    reg [5:0] inst3_func;
    reg [4:0] inst3_shift_amt;

    // We want to proceed by sequence number
    // First, check the lowest sequence number
    // NOPs will not pass through this stage, since stalls will be issued by issuing a NOP (32'h00000000) on alpha/beta/gamma_inst_out
    // Essentially, this module will pass instructions along to each pipeline
    // In order to perform hazard detection, we have to decode the instructions in the first place
    // Kill 2'b10 birds with 2'b01 stone.

    // In the event of a stall:
    // NOP is issued to the x_inst_out
    // x_pc_in is issued to x_pc_out, which runs back to the instruction fetcher so that it doesn't try to issue a new instruction the next time
    // ----> The above is also useful since the PC in the instruction fetch needs to be on par with what's being handled in hazard detection
    // We don't need to worry about passing the sequence number back, since the instruction fetcher will have it on hand

    // In the event of non-stall:
    // x_inst is issued to the x_inst_out
    // 32'h00000000 is issued to x_pc_out, which is passing a null value to the instruction fetch module, telling it that it can increment PC safely

    // In the event that the instruction fetcher passes less than 3 instructions at once (because it has been notified by a pipeline of completion of an instruction):
    // The other instruction(s) && data will all be null values, && as such can be ignored
    // should probably issue 16'h7FFF for sequence numbers of null passes, so the comparisons don't get wonky

    // We want to act anytime a new instruction comes into the hazard detector
    always @ ((alpha_inst) || (beta_inst) || (gamma_inst)) begin
        
        // default to not stalling any instructions
        inst1_stall = 0;
        inst2_stall = 0;
        inst3_stall = 0;
        // in order to proceed by sequence number, let's just assign the instructions to 1st, 2nd && 3rd vars based on seq num
        // START Execution order determination logic:
        // Note the use of <= && >= so that null entries will order properly
        if ((alpha_seq_num >= beta_seq_num) && (alpha_seq_num >= gamma_seq_num)) begin
            
            third_inst = alpha_inst;

            // B <= G <= A
            if ((beta_seq_num) <= (gamma_seq_num)) begin
                second_inst = gamma_inst;
                first_inst = beta_inst;

                third_pc = alpha_pc_in;
                second_pc = gamma_pc_in;
                first_pc = beta_pc_in;
            end
            // G <= B <= A
            else begin
                second_inst = beta_inst;
                first_inst = gamma_inst;

                third_pc = alpha_pc_in;
                second_pc = beta_pc_in;
                first_pc = gamma_pc_in;
            end

        end
        else if ((alpha_seq_num <= beta_seq_num) && (alpha_seq_num <= gamma_seq_num)) begin
            
            first_inst = alpha_inst;
            // A <= B <= G 
            if (beta_seq_num <= gamma_seq_num) begin
                second_inst = beta_inst;
                third_inst = gamma_inst;

                third_pc = gamma_pc_in;
                second_pc = beta_pc_in;
                first_pc = alpha_pc_in;
            end
            // A <= G <= B
            else begin
                second_inst = gamma_inst;
                third_inst = beta_inst;

                third_pc = beta_pc_in;
                second_pc = gamma_pc_in;
                first_pc = alpha_pc_in;
            end
        end
        // B <= A <= G
        else if (beta_seq_num <= gamma_seq_num) begin
            
            first_inst = beta_inst;
            second_inst = alpha_inst;
            third_inst = gamma_inst;

            third_pc = gamma_pc_in;
            second_pc = alpha_pc_in;
            first_pc = beta_pc_in;

        end
        // G <= A <= B
        else if (beta_seq_num >= gamma_seq_num) begin
            
            first_inst = gamma_inst;
            second_inst = alpha_inst;
            third_inst = beta_inst;

            third_pc = beta_pc_in;
            second_pc = alpha_pc_in;
            first_pc = gamma_pc_in;

        end
        // END Execution Order Logic

        // START: Decode each instruction
        // First instruction
        inst1_op = first_inst[31:26];
        if(inst1_op == 6'b000000) begin
            inst1_func = first_inst[5:0];

            // if the instruction is not SLL/NOP
            if (inst1_func != 6'b000000) begin
                inst1_dest = first_inst[15:11];
                inst1_src1 = first_inst[25:21];
                inst1_src2 = first_inst[20:16];
            end
            // SLL/NOP case
            else begin
                inst1_dest = first_inst[15:11];
                inst1_src1 = first_inst[20:16];
                inst1_shift_amt = first_inst[10:6];
            end

        end
        else begin
            inst1_dest = first_inst[20:16];
            inst1_src1 = first_inst[25:21];
            inst1_immediate = first_inst[15:0];
        end

        // Second instruction
        inst2_op = second_inst[31:26];
        if(inst2_op == 6'b000000) begin
            inst2_func = second_inst[5:0];

            // if the instruction is not SLL/NOP
            if (inst2_func != 6'b000000) begin
                inst2_dest = second_inst[15:11];
                inst2_src1 = second_inst[25:21];
                inst2_src2 = second_inst[20:16];
            end
            // SLL/NOP case
            else begin
                inst2_dest = second_inst[15:11];
                inst2_src1 = second_inst[20:16];
                inst2_shift_amt = second_inst[10:6];
            end

        end
        else begin
            inst2_dest = second_inst[20:16];
            inst2_src1 = second_inst[25:21];
            inst2_immediate = second_inst[15:0];
        end

        // Third instruction
        inst3_op = third_inst[31:26];
        if(inst3_op == 6'b000000) begin
            inst3_func = third_inst[5:0];

            // if the instruction is not SLL
            if (inst3_func != 6'b000000) begin
                inst3_dest = third_inst[15:11];
                inst3_src1 = third_inst[25:21];
                inst3_src2 = third_inst[20:16];
            end
            // SLL case
            else begin
                inst3_dest = third_inst[15:11];
                inst3_src1 = third_inst[20:16];
                inst3_shift_amt = third_inst[10:6];
            end

        end
        else begin
            inst3_dest = third_inst[20:16];
            inst3_src1 = third_inst[25:21];
            inst3_immediate = third_inst[15:0];
        end
        //END: Decode each instruction

        // Now that each is decoded, we can start to check dependencies in pipelines
        // Check the first instruction for dependencies on what's currently running in pipelines
        // Step 1: if it's a SW, LW, BEQ, BNE || ADDI, check dest && src against dest of pipelines
        // Check instruction 1 dependencies:
        // if inst1 is a memory op
        if ((inst1_op == 6'b101011) || (inst1_op == 6'b100011) || (inst1_op == 6'b000100) || (inst1_op == 6'b000101) || (inst1_op == 6'b001000)) begin

            // if there's a dependency in any of the 3 pipelines && both dest && src are not zero reg
            if ( (((inst1_dest == pipeA_dest) || (inst1_dest == pipeB_dest) || (inst1_dest == pipeC_dest)) && (inst1_dest != 5'b00000)) || (((inst1_src1 == pipeA_dest) || (inst1_src1 == pipeB_dest) || (inst1_src1 == pipeC_dest)) && (inst1_src1 != 5'b00000))) begin
                
                // outcome: stall all instructions
                inst1_stall = 1;
                inst2_stall = 1;
                inst3_stall = 1;

                // issue NOPs for all 3 pipelines (as to retain order)
                inst1_inst_out = 32'h00000000;
                inst2_inst_out = 32'h00000000;
                inst3_inst_out = 32'h00000000;

                // these PC values are to be kept the same since they're getting passed back to instruction fetch
                inst1_pc_out = first_pc;
                inst2_pc_out = second_pc;
                inst3_pc_out = third_pc;

            end

            // Since this is the first instruction, we are not worried at all about conflict with the other two instructions
            else begin
                
                inst1_stall = 0;
                inst1_inst_out = first_inst;
                // issue a 0 PC to tell the instruction fetch that it can overwrite
                inst1_pc_out = 32'h00000000;

            end
        end
        // if inst1 is an ALU op
        else begin
            
            // if there's a dependency in any of the 3 pipelines && both dest && src are not zero reg
            if ( (((inst1_dest == pipeA_dest) || (inst1_dest == pipeB_dest) || (inst1_dest == pipeC_dest)) && (inst1_dest != 5'b00000)) || (((inst1_src1 == pipeA_dest) || (inst1_src1 == pipeB_dest) || (inst1_src1 == pipeC_dest)) && (inst1_src1 != 5'b00000)) || (((inst1_src2 == pipeA_dest) || (inst1_src2 == pipeB_dest) || (inst1_src2 == pipeC_dest)) && (inst1_src2 != 5'b00000))) begin
                
                // outcome: stall all instructions
                inst1_stall = 1;
                inst2_stall = 1;
                inst3_stall = 1;

                // issue NOPs for all 3 pipelines (as to retain order)
                inst1_inst_out = 32'h00000000;
                inst2_inst_out = 32'h00000000;
                inst3_inst_out = 32'h00000000;

                // these PC values are to be kept the same since they're getting passed back to instruction fetch
                inst1_pc_out = first_pc;
                inst2_pc_out = second_pc;
                inst3_pc_out = third_pc;

            end

            // Since this is the first instruction, we are not worried at all about conflict with the other two instructions
            else begin
                
                inst1_stall = 0;
                inst1_inst_out = first_inst;
                // issue a 0 PC to tell the instruction fetch that it can overwrite
                inst1_pc_out = 32'h00000000;

            end

        end

        // instruction 2 adds a layer of complexity, since it also depends on the previous instruction
        // we want to stall instruction 2 for the same reasons as instruction 1 PLUS if it:
        // a) has register dependencies on instruction 1
        // b) instruction 1 is stalled

        // Check instruction 2 dependencies:
        // if inst2 is a memory op
        if ((inst2_op == 6'b101011) || (inst2_op == 6'b100011) || (inst2_op == 6'b000100) || (inst2_op == 6'b000101) || (inst2_op == 6'b001000)) begin
        
            // if there's a dependency in any of the 3 pipelines, on the 1st instruction, && not zero regs
            // need to check if inst1 is a memory op, because then it will only have dest, src1
            if ((inst1_op == 6'b101011) || (inst1_op == 6'b100011) || (inst1_op == 6'b000100) || (inst1_op == 6'b000101) || (inst1_op == 6'b001000)) begin
                
                // inst1: memory op
                // inst2: memory op

                // from here, compare to pipelines, dest && src1 of inst1 && make sure inst1 is not stalling
                if (   (((inst2_dest == pipeA_dest) || (inst2_dest == pipeB_dest) || (inst2_dest == pipeC_dest)) && (inst2_dest != 5'b00000))  // dest to pipes
                    || (((inst2_src1 == pipeA_dest) || (inst2_src1 == pipeB_dest) || (inst2_src1 == pipeC_dest)) && (inst2_src1 != 5'b00000)) // src1 to pipes
                    || (((inst2_dest == inst1_dest) || (inst2_dest == inst1_src1)) && (inst2_dest != 5'b00000)) // dest to inst1
                    || (((inst2_src1 == inst1_dest)) && (inst2_src1 != 5'b00000)) // src1 to inst1
                    || (inst1_stall == 1)) begin
                
                    // outcome: stall instructions 2 && 3
                    inst2_stall = 1;
                    inst3_stall = 1;

                    // issue NOPs for all 3 pipelines (as to retain order)
                    inst2_inst_out = 32'h00000000;
                    inst3_inst_out = 32'h00000000;

                    // these PC values are to be kept the same since they're getting passed back to instruction fetch
                    inst2_pc_out = second_pc;
                    inst3_pc_out = third_pc;

                end
                else begin
                
                    inst2_stall = 0;
                    inst2_inst_out = second_inst;
                    // issue a 0 PC to tell the instruction fetch that it can overwrite
                    inst2_pc_out = 32'h00000000;

                end

            end
            else begin
                
                // inst1: ALU OP
                // inst2: memory OP

                if (   (((inst2_dest == pipeA_dest) || (inst2_dest == pipeB_dest) || (inst2_dest == pipeC_dest)) && (inst2_dest != 5'b00000))  // dest to pipes
                    || (((inst2_src1 == pipeA_dest) || (inst2_src1 == pipeB_dest) || (inst2_src1 == pipeC_dest)) && (inst2_src1 != 5'b00000)) // src1 to pipes
                    || (((inst2_dest == inst1_dest) || (inst2_dest == inst1_src1) || (inst2_dest == inst1_src2)) && (inst2_dest != 5'b00000)) // dest to inst1
                    || (((inst2_src1 == inst1_dest)) && (inst2_src1 != 5'b00000)) // src1 to inst1
                    || (inst1_stall == 1)) begin

                    // outcome: stall instructions 2 && 3
                    inst2_stall = 1;
                    inst3_stall = 1;

                    // issue NOPs for all 3 pipelines (as to retain order)
                    inst2_inst_out = 32'h00000000;
                    inst3_inst_out = 32'h00000000;

                    // these PC values are to be kept the same since they're getting passed back to instruction fetch
                    inst2_pc_out = second_pc;
                    inst3_pc_out = third_pc;

                end
                else begin
                
                    inst2_stall = 0;
                    inst2_inst_out = second_inst;
                    // issue a 0 PC to tell the instruction fetch that it can overwrite
                    inst2_pc_out = 32'h00000000;

                end
            end

        end
        // if inst2 is an ALU op
        else begin

            // if there's a dependency in any of the 3 pipelines, on the 1st instruction, && not zero regs
            // need to check if inst1 is a memory op, because then it will only have dest, src1
            if ((inst1_op == 6'b101011) || (inst1_op == 6'b100011) || (inst1_op == 6'b000100) || (inst1_op == 6'b000101) || (inst1_op == 6'b001000)) begin
                
                // inst1: memory op
                // inst2: ALU op

                // from here, compare to pipelines, dest && src1 of inst1 && make sure inst1 is not stalling
                if (   (((inst2_dest == pipeA_dest) || (inst2_dest == pipeB_dest) || (inst2_dest == pipeC_dest)) && (inst2_dest != 5'b00000))  // dest to pipes
                    || (((inst2_src1 == pipeA_dest) || (inst2_src1 == pipeB_dest) || (inst2_src1 == pipeC_dest)) && (inst2_src1 != 5'b00000)) // src1 to pipes
                    || (((inst2_src2 == pipeA_dest) || (inst2_src2 == pipeB_dest) || (inst2_src2 == pipeC_dest)) && (inst2_src2 != 5'b00000)) // src2 to pipes
                    || (((inst2_dest == inst1_dest) || (inst2_dest == inst1_src1)) && (inst2_dest != 5'b00000)) // dest to inst1
                    || (((inst2_src1 == inst1_dest)) && (inst2_src1 != 5'b00000)) // src1 to inst1
                    || (((inst2_src2 == inst1_dest)) && (inst2_src2 != 5'b00000)) // src2 to inst1
                    || (inst1_stall == 1)) begin
                
                    // outcome: stall instructions 2 && 3
                    inst2_stall = 1;
                    inst3_stall = 1;

                    // issue NOPs for all 3 pipelines (as to retain order)
                    inst2_inst_out = 32'h00000000;
                    inst3_inst_out = 32'h00000000;

                    // these PC values are to be kept the same since they're getting passed back to instruction fetch
                    inst2_pc_out = second_pc;
                    inst3_pc_out = third_pc;

                end
                else begin
                
                    inst2_stall = 0;
                    inst2_inst_out = second_inst;
                    // issue a 0 PC to tell the instruction fetch that it can overwrite
                    inst2_pc_out = 32'h00000000;

                end

            end
            else begin
                
                // inst1: ALU OP
                // inst2: ALU OP

                if (   (((inst2_dest == pipeA_dest) || (inst2_dest == pipeB_dest) || (inst2_dest == pipeC_dest)) && (inst2_dest != 5'b00000))  // dest to pipes
                    || (((inst2_src1 == pipeA_dest) || (inst2_src1 == pipeB_dest) || (inst2_src1 == pipeC_dest)) && (inst2_src1 != 5'b00000)) // src1 to pipes
                    || (((inst2_src2 == pipeA_dest) || (inst2_src2 == pipeB_dest) || (inst2_src2 == pipeC_dest)) && (inst2_src2 != 5'b00000)) // src2 to pipes
                    || (((inst2_dest == inst1_dest) || (inst2_dest == inst1_src1) || (inst2_dest == inst1_src2)) && (inst2_dest != 5'b00000)) // dest to inst1
                    || (((inst2_src1 == inst1_dest)) && (inst2_src1 != 5'b00000)) // src1 to inst1
                    || (((inst2_src2 == inst1_dest)) && (inst2_src2 != 5'b00000)) // src2 to inst1
                    || (inst1_stall == 1)) begin

                    // outcome: stall instructions 2 && 3
                    inst2_stall = 1;
                    inst3_stall = 1;

                    // issue NOPs for all 3 pipelines (as to retain order)
                    inst2_inst_out = 32'h00000000;
                    inst3_inst_out = 32'h00000000;

                    // these PC values are to be kept the same since they're getting passed back to instruction fetch
                    inst2_pc_out = second_pc;
                    inst3_pc_out = third_pc;

                end
                else begin
                
                    inst2_stall = 0;
                    inst2_inst_out = second_inst;
                    // issue a 0 PC to tell the instruction fetch that it can overwrite
                    inst2_pc_out = 32'h00000000;

                end
            end

        end
        
        // instruction 3 adds a fuckload of layers of complexity

        // Check instruction 3 dependencies:
        // if inst3 is a memory op
        if ((inst2_op == 6'b101011) || (inst2_op == 6'b100011) || (inst2_op == 6'b000100) || (inst2_op == 6'b000101) || (inst2_op == 6'b001000)) begin
            
            // if inst2 is a memory op
            if ((inst2_op == 6'b101011) || (inst2_op == 6'b100011) || (inst2_op == 6'b000100) || (inst2_op == 6'b000101) || (inst2_op == 6'b001000)) begin

                // if inst1 is a memory op
                if ((inst1_op == 6'b101011) || (inst1_op == 6'b100011) || (inst1_op == 6'b000100) || (inst1_op == 6'b000101) || (inst1_op == 6'b001000)) begin

                    // inst1: memory op
                    // inst2: memory op
                    // inst3: memory op
                    if (   (((inst3_dest == pipeA_dest) || (inst3_dest == pipeB_dest) || (inst3_dest == pipeC_dest)) && (inst3_dest != 5'b00000))  // dest to pipes
                        || (((inst3_src1 == pipeA_dest) || (inst3_src1 == pipeB_dest) || (inst3_src1 == pipeC_dest)) && (inst3_src1 != 5'b00000)) // src1 to pipes
                        // inst1
                        || (((inst3_dest == inst1_dest) || (inst3_dest == inst1_src1)) && (inst3_dest != 5'b00000)) // dest to inst1
                        || (((inst3_src1 == inst1_dest)) && (inst3_src1 != 5'b00000)) // src1 to inst1
                        // inst2
                        || (((inst3_dest == inst2_dest) || (inst3_dest == inst2_src1)) && (inst3_dest != 5'b00000)) // dest to inst2
                        || (((inst3_src1 == inst2_src1)) && (inst3_src1 != 5'b00000)) // src1 to inst2
                        // previous stalls
                        || (inst1_stall == 1) || (inst2_stall == 1)) begin

                        // outcome: stall instruction 3
                        inst3_stall = 1;

                        // issue NOP for instruction 3
                        inst3_inst_out = 32'h00000000;

                        // this PC values are to be kept the same since they're getting passed back to instruction fetch
                        inst3_pc_out = third_pc;

                    end
                    else begin
                    
                        inst3_stall = 0;
                        inst3_inst_out = second_inst;
                        // issue a 0 PC to tell the instruction fetch that it can overwrite
                        inst3_pc_out = 32'h00000000;

                    end
                    
                end
                // inst1 is an ALU op
                else begin
                    
                    // inst1: ALU op
                    // inst2: memory op
                    // inst3: memory op
                    if (   (((inst3_dest == pipeA_dest) || (inst3_dest == pipeB_dest) || (inst3_dest == pipeC_dest)) && (inst3_dest != 5'b00000))  // dest to pipes
                        || (((inst3_src1 == pipeA_dest) || (inst3_src1 == pipeB_dest) || (inst3_src1 == pipeC_dest)) && (inst3_src1 != 5'b00000)) // src1 to pipes
                        || (((inst3_dest == inst1_dest) || (inst3_dest == inst1_src1) || (inst3_dest == inst1_src2)) && (inst3_dest != 5'b00000)) // dest to inst1
                        || (((inst3_src1 == inst1_dest)) && (inst3_src1 != 5'b00000)) // src1 to inst1
                        || (((inst3_dest == inst2_dest) || (inst3_dest == inst2_src1)) && (inst3_dest != 5'b00000)) // dest to inst2
                        || (((inst3_src1 == inst2_src1)) && (inst3_src1 != 5'b00000)) // src1 to inst2
                        || (inst1_stall == 1) || (inst2_stall == 1)) begin

                        // outcome: stall instruction 3
                        inst3_stall = 1;

                        // issue NOP for instruction 3
                        inst3_inst_out = 32'h00000000;

                        // this PC values are to be kept the same since they're getting passed back to instruction fetch
                        inst3_pc_out = third_pc;

                    end
                    else begin
                    
                        inst3_stall = 0;
                        inst3_inst_out = second_inst;
                        // issue a 0 PC to tell the instruction fetch that it can overwrite
                        inst3_pc_out = 32'h00000000;

                    end

                end
                
            end
            // if inst2 is an ALU op
            else begin

                // if inst1 is a memory op
                if ((inst1_op == 6'b101011) || (inst1_op == 6'b100011) || (inst1_op == 6'b000100) || (inst1_op == 6'b000101) || (inst1_op == 6'b001000)) begin

                    // inst1: memory op
                    // inst2: ALU op
                    // inst3: memory op
                    if (   (((inst3_dest == pipeA_dest) || (inst3_dest == pipeB_dest) || (inst3_dest == pipeC_dest)) && (inst3_dest != 5'b00000))  // dest to pipes
                        || (((inst3_src1 == pipeA_dest) || (inst3_src1 == pipeB_dest) || (inst3_src1 == pipeC_dest)) && (inst3_src1 != 5'b00000)) // src1 to pipes
                        || (((inst3_dest == inst1_dest) || (inst3_dest == inst1_src1)) && (inst3_dest != 5'b00000)) // dest to inst1
                        || (((inst3_src1 == inst1_dest)) && (inst3_src1 != 5'b00000)) // src1 to inst1
                        || (((inst3_dest == inst2_dest) || (inst3_dest == inst2_src1) || (inst3_dest == inst2_src2)) && (inst3_dest != 5'b00000)) // dest to inst2
                        || (((inst3_src1 == inst2_src1)) && (inst3_src1 != 5'b00000)) // src1 to inst2
                        || (inst1_stall == 1) || (inst2_stall == 1)) begin

                        // outcome: stall instruction 3
                        inst3_stall = 1;

                        // issue NOP for instruction 3
                        inst3_inst_out = 32'h00000000;

                        // this PC values are to be kept the same since they're getting passed back to instruction fetch
                        inst3_pc_out = third_pc;

                    end
                    else begin
                    
                        inst3_stall = 0;
                        inst3_inst_out = second_inst;
                        // issue a 0 PC to tell the instruction fetch that it can overwrite
                        inst3_pc_out = 32'h00000000;

                    end
                    
                end
                // inst1 is an ALU op
                else begin

                    // inst1: ALU op
                    // inst2: ALU op
                    // inst3: memory op
                    if (   (((inst3_dest == pipeA_dest) || (inst3_dest == pipeB_dest) || (inst3_dest == pipeC_dest)) && (inst3_dest != 5'b00000))  // dest to pipes
                        || (((inst3_src1 == pipeA_dest) || (inst3_src1 == pipeB_dest) || (inst3_src1 == pipeC_dest)) && (inst3_src1 != 5'b00000)) // src1 to pipes
                        || (((inst3_dest == inst1_dest) || (inst3_dest == inst1_src1) || (inst3_dest == inst1_src2)) && (inst3_dest != 5'b00000)) // dest to inst1
                        || (((inst3_src1 == inst1_dest)) && (inst3_src1 != 5'b00000)) // src1 to inst1
                        || (((inst3_dest == inst2_dest) || (inst3_dest == inst2_src1) || (inst3_dest == inst2_src2)) && (inst3_dest != 5'b00000)) // dest to inst2
                        || (((inst3_src1 == inst2_src1)) && (inst3_src1 != 5'b00000)) // src1 to inst2
                        || (inst1_stall == 1) || (inst2_stall == 1)) begin

                        // outcome: stall instruction 3
                        inst3_stall = 1;

                        // issue NOP for instruction 3
                        inst3_inst_out = 32'h00000000;

                        // this PC values are to be kept the same since they're getting passed back to instruction fetch
                        inst3_pc_out = third_pc;

                    end
                    else begin
                    
                        inst3_stall = 0;
                        inst3_inst_out = second_inst;
                        // issue a 0 PC to tell the instruction fetch that it can overwrite
                        inst3_pc_out = 32'h00000000;

                    end
                    
                    
                end
                
            end

        end
        // if inst3 is an ALU op
        else begin
            // if inst2 is a memory op
            if ((inst2_op == 6'b101011) || (inst2_op == 6'b100011) || (inst2_op == 6'b000100) || (inst2_op == 6'b000101) || (inst2_op == 6'b001000)) begin
                
                // if inst1 is a memory op
                if ((inst1_op == 6'b101011) || (inst1_op == 6'b100011) || (inst1_op == 6'b000100) || (inst1_op == 6'b000101) || (inst1_op == 6'b001000)) begin

                    // inst1: memory op
                    // inst2: memory op
                    // inst3: ALU op
                    if (   (((inst3_dest == pipeA_dest) || (inst3_dest == pipeB_dest) || (inst3_dest == pipeC_dest)) && (inst3_dest != 5'b00000))  // dest to pipes
                        || (((inst3_src1 == pipeA_dest) || (inst3_src1 == pipeB_dest) || (inst3_src1 == pipeC_dest)) && (inst3_src1 != 5'b00000)) // src1 to pipes
                        || (((inst3_src2 == pipeA_dest) || (inst3_src2 == pipeB_dest) || (inst3_src2 == pipeC_dest)) && (inst3_src2 != 5'b00000)) // src2 to pipes
                        // inst1
                        || (((inst3_dest == inst1_dest) || (inst3_dest == inst1_src1)) && (inst3_dest != 5'b00000)) // dest to inst1
                        || (((inst3_src1 == inst1_dest)) && (inst3_src1 != 5'b00000)) // src1 to inst1
                        || (((inst3_src2 == inst1_dest)) && (inst3_src2 != 5'b00000)) // src2 to inst1
                        // inst2
                        || (((inst3_dest == inst2_dest) || (inst3_dest == inst2_src1)) && (inst3_dest != 5'b00000)) // dest to inst2
                        || (((inst3_src1 == inst2_src1)) && (inst3_src1 != 5'b00000)) // src1 to inst2
                        || (((inst3_src2 == inst2_dest)) && (inst3_src2 != 5'b00000)) // src2 to inst2
                        // stall
                        || (inst1_stall == 1) || (inst2_stall == 1)) begin

                        // outcome: stall instruction 3
                        inst3_stall = 1;

                        // issue NOP for instruction 3
                        inst3_inst_out = 32'h00000000;

                        // this PC values are to be kept the same since they're getting passed back to instruction fetch
                        inst3_pc_out = third_pc;

                    end
                    else begin
                    
                        inst3_stall = 0;
                        inst3_inst_out = second_inst;
                        // issue a 0 PC to tell the instruction fetch that it can overwrite
                        inst3_pc_out = 32'h00000000;

                    end
                    
                end
                // inst1 is an ALU op
                else begin

                    // inst1: ALU op
                    // inst2: memory op
                    // inst3: ALU op
                    if (   (((inst3_dest == pipeA_dest) || (inst3_dest == pipeB_dest) || (inst3_dest == pipeC_dest)) && (inst3_dest != 5'b00000))  // dest to pipes
                        || (((inst3_src1 == pipeA_dest) || (inst3_src1 == pipeB_dest) || (inst3_src1 == pipeC_dest)) && (inst3_src1 != 5'b00000)) // src1 to pipes
                        || (((inst3_src2 == pipeA_dest) || (inst3_src2 == pipeB_dest) || (inst3_src2 == pipeC_dest)) && (inst3_src2 != 5'b00000)) // src2 to pipes
                        // inst1
                        || (((inst3_dest == inst1_dest) || (inst3_dest == inst1_src1) || (inst3_dest == inst1_src2)) && (inst3_dest != 5'b00000)) // dest to inst1
                        || (((inst3_src1 == inst1_dest)) && (inst3_src1 != 5'b00000)) // src1 to inst1
                        || (((inst3_src2 == inst1_dest)) && (inst3_src2 != 5'b00000)) // src2 to inst1
                        // inst2
                        || (((inst3_dest == inst2_dest) || (inst3_dest == inst2_src1)) && (inst3_dest != 5'b00000)) // dest to inst2
                        || (((inst3_src1 == inst2_src1)) && (inst3_src1 != 5'b00000)) // src1 to inst2
                        || (((inst3_src2 == inst2_dest)) && (inst3_src2 != 5'b00000)) // src2 to inst2
                        // stall
                        || (inst1_stall == 1) || (inst2_stall == 1)) begin

                        // outcome: stall instruction 3
                        inst3_stall = 1;

                        // issue NOP for instruction 3
                        inst3_inst_out = 32'h00000000;

                        // this PC values are to be kept the same since they're getting passed back to instruction fetch
                        inst3_pc_out = third_pc;

                    end
                    else begin
                    
                        inst3_stall = 0;
                        inst3_inst_out = second_inst;
                        // issue a 0 PC to tell the instruction fetch that it can overwrite
                        inst3_pc_out = 32'h00000000;

                    end
                    
                end
            end
            // if inst2 is an ALU op
            else begin

                // if inst1 is a memory op
                if ((inst1_op == 6'b101011) || (inst1_op == 6'b100011) || (inst1_op == 6'b000100) || (inst1_op == 6'b000101) || (inst1_op == 6'b001000)) begin

                    // inst1: memory op
                    // inst2: ALU op
                    // inst3: ALU op
                    if (   (((inst3_dest == pipeA_dest) || (inst3_dest == pipeB_dest) || (inst3_dest == pipeC_dest)) && (inst3_dest != 5'b00000))  // dest to pipes
                        || (((inst3_src1 == pipeA_dest) || (inst3_src1 == pipeB_dest) || (inst3_src1 == pipeC_dest)) && (inst3_src1 != 5'b00000)) // src1 to pipes
                        || (((inst3_src2 == pipeA_dest) || (inst3_src2 == pipeB_dest) || (inst3_src2 == pipeC_dest)) && (inst3_src2 != 5'b00000)) // src2 to pipes
                        // inst1
                        || (((inst3_dest == inst1_dest) || (inst3_dest == inst1_src1)) && (inst3_dest != 5'b00000)) // dest to inst1
                        || (((inst3_src1 == inst1_dest)) && (inst3_src1 != 5'b00000)) // src1 to inst1
                        || (((inst3_src2 == inst1_dest)) && (inst3_src2 != 5'b00000)) // src2 to inst1
                        // inst2
                        || (((inst3_dest == inst2_dest) || (inst3_dest == inst2_src1) || (inst3_dest == inst2_src2)) && (inst3_dest != 5'b00000)) // dest to inst2
                        || (((inst3_src1 == inst2_src1)) && (inst3_src1 != 5'b00000)) // src1 to inst2
                        || (((inst3_src2 == inst2_dest)) && (inst3_src2 != 5'b00000)) // src2 to inst2
                        // stall
                        || (inst1_stall == 1) || (inst2_stall == 1)) begin

                        // outcome: stall instruction 3
                        inst3_stall = 1;

                        // issue NOP for instruction 3
                        inst3_inst_out = 32'h00000000;

                        // this PC values are to be kept the same since they're getting passed back to instruction fetch
                        inst3_pc_out = third_pc;

                    end
                    else begin
                    
                        inst3_stall = 0;
                        inst3_inst_out = second_inst;
                        // issue a 0 PC to tell the instruction fetch that it can overwrite
                        inst3_pc_out = 32'h00000000;

                    end
                    
                end
                // inst1 is an ALU op
                else begin

                    // inst1: ALU op
                    // inst2: ALU op
                    // inst3: ALU op
                    if (   (((inst3_dest == pipeA_dest) || (inst3_dest == pipeB_dest) || (inst3_dest == pipeC_dest)) && (inst3_dest != 5'b00000))  // dest to pipes
                        || (((inst3_src1 == pipeA_dest) || (inst3_src1 == pipeB_dest) || (inst3_src1 == pipeC_dest)) && (inst3_src1 != 5'b00000)) // src1 to pipes
                        || (((inst3_src2 == pipeA_dest) || (inst3_src2 == pipeB_dest) || (inst3_src2 == pipeC_dest)) && (inst3_src2 != 5'b00000)) // src2 to pipes
                        // inst1
                        || (((inst3_dest == inst1_dest) || (inst3_dest == inst1_src1) || (inst3_dest == inst1_src2)) && (inst3_dest != 5'b00000)) // dest to inst1
                        || (((inst3_src1 == inst1_dest)) && (inst3_src1 != 5'b00000)) // src1 to inst1
                        || (((inst3_src2 == inst1_dest)) && (inst3_src2 != 5'b00000)) // src2 to inst1
                        // inst2
                        || (((inst3_dest == inst2_dest) || (inst3_dest == inst2_src1) || (inst3_dest == inst2_src2)) && (inst3_dest != 5'b00000)) // dest to inst2
                        || (((inst3_src1 == inst2_src1)) && (inst3_src1 != 5'b00000)) // src1 to inst2
                        || (((inst3_src2 == inst2_dest)) && (inst3_src2 != 5'b00000)) // src2 to inst2
                        // stall
                        || (inst1_stall == 1) || (inst2_stall == 1)) begin

                        // outcome: stall instruction 3
                        inst3_stall = 1;

                        // issue NOP for instruction 3
                        inst3_inst_out = 32'h00000000;

                        // this PC values are to be kept the same since they're getting passed back to instruction fetch
                        inst3_pc_out = third_pc;

                    end
                    else begin
                    
                        inst3_stall = 0;
                        inst3_inst_out = second_inst;
                        // issue a 0 PC to tell the instruction fetch that it can overwrite
                        inst3_pc_out = 32'h00000000;

                    end
                    
                end
                
            end
        end
        // Hallelujah, we have established who is stalling and all that crap

        // flag for if pipelines have been occupied by an instruction this cycle
        integer A_busy;
        integer B_busy;
        integer C_busy;
        A_busy = 0;
        B_busy = 0;
        C_busy = 0;

        // Now onward to sending instructions to pipelines as necessary
        if(!inst1_stall) begin
            
            // if instruction 1 is a memory op
            if ((inst1_op == 6'b101011) || (inst1_op == 6'b100011)) begin
                // send inst1 to pipeline C
                pipeC_op_in = inst1_op;
                pipeC_dest_in = inst1_dest;
                pipeC_src1_in = inst1_src1;
                pipeC_imm_in = inst1_immediate;

                C_busy = 1;
            end
            // otherwise send it to an ALU pipeline
            else begin

                // default sending to A because this is the first instruction
                pipeA_op_in = inst1_op;
                pipeA_dest_in = inst1_dest;
                pipeA_src1_in = inst1_src1;
                pipeA_src2_in = inst1_src2;
                pipeA_func_in = inst1_func;
                pipeA_shamt_in = inst1_shift_amt;
                pipeA_imm_in = inst1_immediate;

                A_busy = 1;
                
            end

            // instruction 2
            if(!inst2_stall) begin
                
                // if instruction 2 is a memory op and instruction 1 did not already occupy pipe C this cycle
                if (((inst2_op == 6'b101011) || (inst2_op == 6'b100011)) && (!C_busy)) begin
                    // send inst1 to pipeline C
                    pipeC_op_in = inst2_op;
                    pipeC_dest_in = inst2_dest;
                    pipeC_src1_in = inst2_src1;
                    pipeC_imm_in = inst2_immediate;

                    C_busy = 1;
                end

                // if instruction 2 is a ALU operation and either pipe A or pipe B are available
                else if (!A_busy && !((inst2_op == 6'b101011) || (inst2_op == 6'b100011))) begin
                    pipeA_op_in = inst2_op;
                    pipeA_dest_in = inst2_dest;
                    pipeA_src1_in = inst2_src1;
                    pipeA_src2_in = inst2_src2;
                    pipeA_func_in = inst2_func;
                    pipeA_shamt_in = inst2_shift_amt;
                    pipeA_imm_in = inst2_immediate;

                    A_busy = 1;
                end
                
                // if instruction 2 is an ALU op and only pipeline B is available
                else if (!((inst2_op == 6'b101011) || (inst2_op == 6'b100011))) begin
                    pipeB_op_in = inst2_op;
                    pipeB_dest_in = inst2_dest;
                    pipeB_src1_in = inst2_src1;
                    pipeB_src2_in = inst2_src2;
                    pipeB_func_in = inst2_func;
                    pipeB_shamt_in = inst2_shift_amt;
                    pipeB_imm_in = inst2_immediate;

                    B_busy = 1;
                end

                else begin
                    
                    // send signals to stall instruction 2 and 3
                    // this one is necessary, because it could be that inst's 1 and 2 are both memory ops, in which case, not enough piplines for both
                    inst2_pc_out = second_pc;
                    inst3_pc_out = third_pc;

                    // Pipeline A -- ALU 1
                    pipeA_op_in = 6'b000000;
                    pipeA_dest_in = 5'b00000;
                    pipeA_src1_in = 5'b00000;
                    pipeA_src2_in = 5'b00000;
                    pipeA_func_in = 6'b000000;
                    pipeA_shamt_in = 5'b00000;
                    pipeA_imm_in = 16'h0000;

                    // Pipeline B -- ALU 2
                    pipeB_op_in = 6'b000000;
                    pipeB_dest_in = 5'b00000;
                    pipeB_src1_in = 5'b00000;
                    pipeB_src2_in = 5'b00000;
                    pipeB_func_in = 6'b000000;
                    pipeB_shamt_in = 5'b00000;
                    pipeB_imm_in = 6'h0000;


                end

                if (!inst3_stall) begin
                    
                    // if instruction 2 is a memory op and instruction 1 did not already occupy pipe C this cycle
                    if (((inst3_op == 6'b101011) || (inst3_op == 6'b100011)) && (!C_busy)) begin
                        // send inst1 to pipeline C
                        pipeC_op_in = inst3_op;
                        pipeC_dest_in = inst3_dest;
                        pipeC_src1_in = inst3_src1;
                        pipeC_imm_in = inst3_immediate;

                        C_busy = 1;
                    end

                    // if instruction 2 is a ALU operation and either pipe A or pipe B are available
                    else if (!A_busy && !((inst3_op == 6'b101011) || (inst3_op == 6'b100011))) begin
                        pipeA_op_in = inst3_op;
                        pipeA_dest_in = inst3_dest;
                        pipeA_src1_in = inst3_src1;
                        pipeA_src2_in = inst3_src2;
                        pipeA_func_in = inst3_func;
                        pipeA_shamt_in = inst3_shift_amt;
                        pipeA_imm_in = inst3_immediate;

                        A_busy = 1;
                    end
                    
                    // if instruction 2 is an ALU op and only pipeline B is available
                    else if (!B_busy && !((inst3_op == 6'b101011) || (inst3_op == 6'b100011))) begin
                        pipeB_op_in = inst3_op;
                        pipeB_dest_in = inst3_dest;
                        pipeB_src1_in = inst3_src1;
                        pipeB_src2_in = inst3_src2;
                        pipeB_func_in = inst3_func;
                        pipeB_shamt_in = inst3_shift_amt;
                        pipeB_imm_in = inst3_immediate;

                        B_busy = 1;
                    end

                    else begin
                        // send signals to stall instruction 3
                        // this one is necessary, because it could be that all 3 are ALU ops, or just one of the others is 
                    end

                end
            end

            // else begin
            //     // send signals to stall instruction 2 and 3
            //     // this one is necessary, because it could be that inst's 1 and 2 are both memory ops, in which case, not enough piplines for both
                
            // end

        end
        else begin
            // output stall signals for:
            // all 3 PCs
            // all 3 inst outputs
            inst1_pc_out = first_pc
            inst2_pc_out = second_pc;
            inst3_pc_out = third_pc;

            // Pipeline A -- ALU 1
            pipeA_op_in = 6'b000000;
            pipeA_dest_in = 5'b00000;
            pipeA_src1_in = 5'b00000;
            pipeA_src2_in = 5'b00000;
            pipeA_func_in = 6'b000000;
            pipeA_shamt_in = 5'b00000;
            pipeA_imm_in = 16'h0000;

            // Pipeline B -- ALU 2
            pipeB_op_in = 6'b000000;
            pipeB_dest_in = 5'b00000;
            pipeB_src1_in = 5'b00000;
            pipeB_src2_in = 5'b00000;
            pipeB_func_in = 6'b000000;
            pipeB_shamt_in = 5'b00000;
            pipeB_imm_in = 6'h0000;

            // Pipeline C -- Memory Ops
            pipeC_op_in = 6'b000000;
            pipeC_dest_in = 5'b00000;
            pipeC_src1_in = 5'b00000;
            pipeC_imm_in = 16'h0000;

        end
        // && that should be all she wrote
        

    end

endmodule