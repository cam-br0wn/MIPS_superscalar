`timescale 1ns/10ps

module alu_control_unit_tb;
    reg [5:0] inst;
    reg [1:0] alu_op;
    wire [2:0] sel;

    alu_control_unit tester(
        inst,
        alu_op,
        sel
    );

    initial begin
        // ADD
        inst = 6'b100000;
        alu_op = 2'b10;
        // Expected:
        // sel = 3'b010
        #5
        // ADDU
        inst = 6'b100001;
        alu_op = 2'b10;
        // Expected:
        // sel = 3'b100
        #5
        // SUB
        inst = 6'b100010;
        alu_op = 2'b10;
        // Expected:
        // sel = 3'b110
        #5
        // SUBU
        inst = 6'b100011;
        alu_op = 2'b10;
        // Expected:
        // sel = 3'b110
        #5
        // AND
        inst = 6'b100100;
        alu_op = 2'b10;
        // Expected:
        // sel = 3'b000
        #5
        // OR
        inst = 6'b100101;
        alu_op = 2'b10;
        // Expected:
        // sel = 3'b001
        #5
        // SLL
        inst = 6'b000000;
        alu_op = 2'b10;
        // Expected:
        // sel = 3'b101
        #5
        // SLT
        inst = 6'b101010;
        alu_op = 2'b10;
        // Expected:
        // sel = 3'b011
        #5
        // SLTU
        inst = 6'b101011;
        alu_op = 2'b10;
        // Expected:
        // sel = 3'b111
        #5
        // ADDI
        alu_op = 2'b00;
        // Expected:
        // sel = 3'b010
        #5
        // BRANCH
        alu_op = 2'b01;
        // Expected:
        // sel = 3'b110
        #5
        $finish;
    end

endmodule