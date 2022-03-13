`timescale 1ns/10ps

module ALUCU_tb;
    reg [2:0] ALUOp;
    reg [5:0] func;
    wire [2:0] ALUCtr;

    ALUCU test(
        ALUOp,
        func,
        ALUCtr
    );

    initial begin
        ALUOp = 3'b000;
        func = 0;
        #5
        ALUOp = 3'b001;
        #5
        ALUOp = 3'b010;
        #5
        ALUOp = 3'b011;
        #5
        ALUOp = 3'b111;
        func = 0;
        #5
        func = 1;
        #5
        func = 2;
        #5
        func = 3;
        #5
        func = 4;
        #5
        func = 5;
        #5
        func = 6;
        #5
        func = 7;
        #5
        func = 8;
        #5
        func = 9;
        #5
        func = 10;
        #5
        func = 11;
        #5
        func = 12;
        #5
        func = 13;
        #5
        func = 14;
        #5
        func = 15;
        #5
        func = 16;
        #5
        func = 17;
        #5
        func = 18;
        #5
        func = 19;
        #5
        func = 20;
        #5
        func = 21;
        #5
        func = 22;
        #5
        func = 23;
        #5
        func = 24;
        #5
        func = 25;
        #5
        func = 26;
        #5
        func = 27;
        #5
        func = 28;
        #5
        func = 29;
        #5
        func = 30;
        #5
        func = 31;
        #5
        func = 32;
        #5
        func = 33;
        #5
        func = 34;
        #5
        func = 35;
        #5
        func = 36;
        #5
        func = 37;
        #5
        func = 38;
        #5
        func = 39;
        #5
        func = 40;
        #5
        func = 41;
        #5
        func = 42;
        #5
        func = 43;
        #5
        func = 44;
        #5
        func = 45;
        #5
        func = 46;
        #5
        func = 47;
        #5
        func = 48;
        #5
        func = 49;
        #5
        func = 50;
        #5
        func = 51;
        #5
        func = 52;
        #5
        func = 53;
        #5
        func = 54;
        #5
        func = 55;
        #5
        func = 56;
        #5
        func = 57;
        #5
        func = 58;
        #5
        func = 59;
        #5
        func = 60;
        #5
        func = 61;
        #5
        func = 62;
        #5
        func = 63;
        #5
        ALUOp = 3'b101;
        #5
        ALUOp = 3'b110;
        #5
        ALUOp = 3'b111;
        #5
        $finish;

    end

endmodule
