// ALU complete testbench
`timescale 1ns/10ps

module alu_tb;
  
    reg [2:0] ctrl;
    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] SELECT;

    wire CARRY_OUT;
    wire OVERFLOW;
    wire ZERO_FLAG;
    wire [31:0] RESULT;
  
    ALU test(ctrl, A, B, SELECT, CARRY_OUT, OVERFLOW, ZERO_FLAG, RESULT);
  
    initial
        begin

            // comments below input are expected result

            // initialize with dummy values
            A = 32'h0;
            B = 32'h0;

            /////////////////
            ////// ADD //////
            /////////////////
            SELECT = 4'b0000;

            #1
            A = 32'h4;
            B = 32'h4;
            // 8

            #5
            A = 32'hffffffff;
            B = 32'h1;
            // 0

            #5
            A = 32'h1;
            B = 32'hfffffffe;
            // ffffffff
            
            #5
            A = 32'h32;
            B = 32'h64;
            // 0x96

            // begin buffer
            #5
            A = 32'h0;
            B = 32'h0;
            // end buffer


            /////////////////
            ////// SUB //////
            /////////////////
            SELECT = 4'b0001;

            #1
            A = 32'h4;
            B = 32'h4;
            // 0

            #5
            A = 32'hffffffff;
            B = 32'h1;
            // 0

            #5
            A = 32'h1;
            B = 32'hfffffffe;
            // fffffffd
            
            #5
            A = 32'h80000000;
            B = 32'h80000000;
            // 0x7fffffff

            // begin buffer
            #5
            A = 32'h0;
            B = 32'h0;
            // end buffer


            /////////////////
            ////// AND //////
            /////////////////
            SELECT = 4'b0010;

            #1
            A = 32'h4;
            B = 32'h4;
            // 4

            #5
            A = 32'hffffffff;
            B = 32'h0;
            // 0

            #5
            A = 32'h55555555;
            B = 32'hAAAAAAAA;
            // ffffffff
            
            #5
            A = 32'hf0f0f0f0;
            B = 32'h0f0f0f0f;
            // 0x0

            // begin buffer
            #5
            A = 32'h0;
            B = 32'h0;
            // end buffer


            /////////////////
            ////// OR  //////
            /////////////////
            SELECT = 4'b0100;

            #1
            A = 32'h4;
            B = 32'h4;
            // 4

            #5
            A = 32'hffffffff;
            B = 32'h0;
            // 0

            #5
            A = 32'h55555555;
            B = 32'hAAAAAAAA;
            // 0
            
            #5
            A = 32'hf0f0f0f0;
            B = 32'h0f0f0f0f;
            // 0xffffffff 

            // begin buffer
            #5
            A = 32'h0;
            B = 32'h0;
            // end buffer


            /////////////////
            ////// XOR //////
            /////////////////
            SELECT = 4'b0110;

            #1
            A = 32'h4;
            B = 32'h4;
            // 4

            #5
            A = 32'hffffffff;
            B = 32'h0;
            // 0

            #5
            A = 32'h55555555;
            B = 32'hAAAAAAAA;
            // ffffffff
            
            #5
            A = 32'hf0f0f0f0;
            B = 32'h0f0f0f0f;
            // 0x0 

            // begin buffer
            #5
            A = 32'h0;
            B = 32'h0;
            // end buffer


            /////////////////
            ////// SLL //////
            /////////////////
            SELECT = 4'b1000;

            #1
            A = 32'h1;
            B = 32'h1;
            // 2

            #5
            A = 32'h1;
            B = 32'h4;
            // 0x10

            #5
            A = 32'hffffffff;
            B = 32'h20;
            // 0
            
            #5
            A = 32'h1;
            B = 32'h21;
            // 0x0

            // begin buffer
            #5
            A = 32'h0;
            B = 32'h0;
            // end buffer


            /////////////////
            ////// SRL //////
            /////////////////
            SELECT = 4'b1010;

            #1
            A = 32'h1;
            B = 32'h1;
            // 0

            #5
            A = 32'h10;
            B = 32'h4;
            // 1

            #5
            A = 32'hffffffff;
            B = 32'h20;
            // 0
            
            #5
            A = 32'h7fffffff;
            B = 32'h1e;
            // 1 

            // begin buffer
            #5
            A = 32'h0;
            B = 32'h0;
            // end buffer


            /////////////////
            ////// SLT //////
            /////////////////
            SELECT = 4'b1100;

            #1
            A = 32'h1;
            B = 32'h0;
            // 0

            #5
            A = 32'h0;
            B = 32'h1;
            // 1

            #5
            A = 32'hffffffff;
            B = 32'h1;
            // 1
            
            #5
            A = 32'hffffffff;
            B = 32'hfffffffe;
            // 0x0

            // begin buffer
            #5
            A = 32'h0;
            B = 32'h0;
            // end buffer


            /////////////////
            ////// SLTU //////
            /////////////////
            SELECT = 4'b1110;

            #1
            A = 32'h1;
            B = 32'h0;
            // 0

            #5
            A = 32'h0;
            B = 32'h1;
            // 1

            #5
            A = 32'hffffffff;
            B = 32'h1;
            // 0
            
            #5
            A = 32'h7fffffff;
            B = 32'hffffffff;
            // 0x1 

            // begin buffer
            #1
            A = 32'h0;
            B = 32'h0;
            // end buffer

        end


endmodule