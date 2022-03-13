`timescale 1ns/10ps
module ALU_tb;
    reg [2:0] ctrl;
    reg [31:0] A, B;
    reg [4:0] shamt;
    wire cout, ovf, ze;
    wire [31:0] R;

    ALU tester(
        ctrl,
        A,
        B,
        shamt,
        cout,
        ovf,
        ze,
        R
    );

    initial begin
        shamt = 5'b00100;
        // AND!
        ctrl = 0;
        A = 32'hAAAAAAAA;
        B = 32'hFFFFFFFF;
        shamt = 0;
        #5
        A = 32'h24624702;
        #5
        A = 32'hFA0693D7;
        B = 32'h01100011;
        #5
        A = 32'h00000000;
        B = 32'hFFFFFF0;
        #5
        // OR!
        ctrl = 1;
        A = 32'h59871359;
        B = 0;
        #5
        B = 32'h6137FFFF;
        #5
        B = 32'hBADF00DE;
        #5
        B = 100;
        #5
        A = 0;
        B = 0;
        #5
        A = 1;
        B = 1;
        #5
        // ADD!
        A = -1;
        B = 1;
        ctrl = 2;
        #5
        A = 32'h139876AD;
        B = 1;
        #5
        A = 24;
        B = 20984;
        #5
        A = 1;
        B = 1;
        #5
        A = 32'hFFFFFFFF;
        B = 32'hFFFFFFFF;
        #5
        A = 32'b01000000000000000000000000000000;
        B = 32'b01000000000000000000000000000000;
        #5
        A = 32'b10000000000000000000000000000000;
        B = 32'b10000000000000000000000000000000;
        #5
        // slt_signed
        ctrl = 3;
        A = 1;
        B = 32'h00010200;
        #5
        A = 32'h00010000;
        #5
        B = 32'h60982375;
        #5
        A = 32'h80956829;
        #5
        shamt = 5;
        #5
        A = 32'hFFFFFFFF;
        B = 32'h00000000;
        #5
        B = 32'h00FF00F0;
        #5
        // add_unsigned
        ctrl = 4;
        A = -1;
        B = 1;
        #5
        A = 32'h139876AD;
        B = 1;
        #5
        A = 24;
        B = 20984;
        #5
        A = 1;
        B = 1;
        #5
        A = 32'hFFFFFFFF;
        B = 32'hFFFFFFFF;
        #5
        A = 32'b01000000000000000000000000000000;
        B = 32'b01000000000000000000000000000000;
        #5
        A = 32'b10000000000000000000000000000000;
        B = 32'b10000000000000000000000000000000;
        #5
        #5
        A = 32'hF0F0F0F0;
        // sll
        ctrl = 5;
        #5
        shamt = 1;
        #5
        shamt = 2;
        #5
        shamt = 6;
        #5
        // SUB
        ctrl = 6;
        A = -1;
        B = -1;
        #5
        A = 236;
        B = 13698;
        #5
        A = 1309786;
        B = 5;
        // SLT
        ctrl = 7;
        #5
        A = 5;
        B = 1309786;
        #5
        A = 5236;
        #5
        A = 252462347;
        #5
        $finish;
    end

endmodule