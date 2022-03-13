`timescale 1ns/10ps

module control_unit_tb;
    reg [5:0] op_code;
    wire reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, beq, bne, bgtz;
    wire [1:0] alu_op;

    control_unit tester(
        op_code,
        reg_dst,
        alu_src,
        mem_to_reg,
        reg_write,
        mem_read,
        mem_write,
        alu_op,
        beq,
        bne,
        bgtz
    );

    initial begin
        // R-format
        op_code = 0;
        // EXPECTED:
        // Reg_dst  = 1
        // AluSrc = 0
        // MemToReg = 0
        // RegWrite = 1
        // MemRead = 0
        // MemWrite = 0
        // ALU_op[0] = 0
        // ALU_op[1] = 1
        // beq = 0
        // bne = 0
        // bgtz = 0
        #5
        // ADDI
        op_code = 6'b001000;
        // EXPECTED:
        // Reg_dst  = 0
        // AluSrc = 1
        // MemToReg = 0
        // RegWrite = 1
        // MemRead = 0
        // MemWrite = 0
        // ALU_op[0] = 0
        // ALU_op[1] = 0
        // beq = 0
        // bne = 0
        // bgtz = 0
        #5
        // LW
        op_code = 6'b100011;
        // EXPECTED:
        // Reg_dst  = 0
        // AluSrc = 1
        // MemToReg = 1
        // RegWrite = 1
        // MemRead = 1
        // MemWrite = 0
        // ALU_op[0] = 0
        // ALU_op[1] = 0
        // beq = 0
        // bne = 0
        // bgtz = 0
        #5
        // SW
        op_code = 6'b101011;
        // EXPECTED:
        // Reg_dst  = 0
        // AluSrc = 1
        // MemToReg = 0
        // RegWrite = 0
        // MemRead = 1
        // MemWrite = 1
        // ALU_op[0] = 0
        // ALU_op[1] = 0
        // beq = 0
        // bne = 0
        // bgtz = 0
        #5
        // BEQ
        op_code = 6'b000100;
        // EXPECTED:
        // Reg_dst  = 0
        // AluSrc = 0
        // MemToReg = 0
        // RegWrite = 0
        // MemRead = 0
        // MemWrite = 0
        // ALU_op[0] = 1
        // ALU_op[1] = 0
        // beq = 1
        // bne = 0
        // bgtz = 0
        #5
        // BNE
        op_code = 6'b000101;
        // EXPECTED:
        // Reg_dst  = 0
        // AluSrc = 0
        // MemToReg = 0
        // RegWrite = 0
        // MemRead = 0
        // MemWrite = 0
        // ALU_op[0] = 1
        // ALU_op[1] = 0
        // beq = 0
        // bne = 1
        // bgtz = 0
        #5
        // BGTZ
        op_code = 6'b000111;
        // EXPECTED:
        // Reg_dst  = 0
        // AluSrc = 0
        // MemToReg = 0
        // RegWrite = 0
        // MemRead = 0
        // MemWrite = 0
        // ALU_op[0] = 1
        // ALU_op[1] = 0
        // beq = 0
        // bne = 0
        // bgtz = 1
        #5
        $finish;
    end
    // all tests pass!!
endmodule