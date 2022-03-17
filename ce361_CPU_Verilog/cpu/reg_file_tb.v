`include "../cpu/reg_file.v"

// CE361: Single-Cycle Processor Project
// Testbench for register file

module reg_file_tb;
  
    reg t_RegWr1;
    reg t_RegWr2;
    reg t_RegWr3;

    reg [4:0] t_Rw1;
    reg [4:0] t_Ra1;
    reg [4:0] t_Rb1;

    reg [4:0] t_Rw2;
    reg [4:0] t_Ra2;
    reg [4:0] t_Rb2;

    reg [4:0] t_Rw3;
    reg [4:0] t_Ra3;
    reg [4:0] t_Rb3;

    reg t_clk;

    reg [31:0] t_busW1;
    reg [31:0] t_busW2;
    reg [31:0] t_busW3;

    wire [31:0] t_busA1;
    wire [31:0] t_busB1;

    wire [31:0] t_busA2;
    wire [31:0] t_busB2;

    wire [31:0] t_busA3;
    wire [31:0] t_busB3;

    reg [5:0] i;
  
    reg_file DUT(t_clk,
    t_Rw1, t_Rw2, t_Rw3,
    t_Ra1, t_Ra2, t_Ra3,
    t_Rb1, t_Rb2, t_Rb3,
    t_RegWr1, t_RegWr2, t_RegWr3,
    t_busA1, t_busA2, t_busA3,
    t_busB1, t_busB2, t_busB3,
    t_busW1, t_busW2, t_busW3);
  
    initial
        begin
            /*$monitor("we1=%1b, we2=%1b, we3=%1b,
            rw1=%d, rw2=%d, rw3=%d,
            ra1=%d, ra2=%d, ra3=%d,
            rb1=%d, rb2=%d, rb3=%d,
            clk=%1b,
            inW1=%d, inW2=%d, inW3=%d,
            outA1=%d, outA2=%d, outA3=%d,
            outB1=%d, outB2=%d, outB3=%d",
            t_RegWr1, t_RegWr2, t_RegWr3,
            t_Rw1, t_Rw2, t_Rw3,
            t_Ra1, t_Ra2, t_Ra3,
            t_Rb1, t_Rb2, t_Rb3,
            t_clk,
            t_busW1, t_busW2, t_busW3,
            t_busA1, t_busA2, t_busA3,
            t_busB1, t_busB2, t_busB3);
            $dumpvars();
            $dumpfile("reg_test_dump.vcd");*/

            $display("\nWriting 0-31 to registers");
            for(i = 0; i < 32; i = i + 1) begin
                #5
                t_RegWr1 = 1'b1;
                t_Rw1 = i;
                t_Ra1 = i;
                t_Rb1 = i;
                t_clk = 1'b0;
                t_busW1 = i;

                #5
                t_clk = 1'b1;

                #5
                t_RegWr2 = 1'b1;
                t_Rw2 = i;
                t_Ra2 = i;
                t_Rb2 = i;
                t_clk = 1'b0;
                t_busW2 = i;

                #5
                t_clk = 1'b1;

                #5
                t_RegWr3 = 1'b1;
                t_Rw3 = i;
                t_Ra3 = i;
                t_Rb3 = i;
                t_clk = 1'b0;
                t_busW3 = i;

                #5
                t_clk = 1'b1;


            end

            #5
            $display("Registers written\n");


            $display("Testing random read cases");

            #5
            t_RegWr1 = 1'b0;
            t_Rw1 = 5'd0;
            t_Ra1 = 5'd17;
            t_Rb1 = 5'd21;
            t_clk = 1'b0;
            t_busW1 = 32'd255;

            #5
            t_clk = 1'b1;

            #5
            t_Ra1 = 5'd3;
            t_Rb1 = 5'd14;
            t_clk = 1'b0;

            #5
            t_clk = 1'b1;

            #5
            t_Ra1 = 5'd29;
            t_Rb1 = 5'd1;
            t_clk = 1'b0;

            #5
            t_clk = 1'b1;





            #5
            t_RegWr2 = 1'b0;
            t_Rw2 = 5'd0;
            t_Ra2 = 5'd17;
            t_Rb2 = 5'd21;
            t_clk = 1'b0;
            t_busW2 = 32'd255;

            #5
            t_clk = 1'b1;

            #5
            t_Ra2 = 5'd3;
            t_Rb2 = 5'd14;
            t_clk = 1'b0;

            #5
            t_clk = 1'b1;

            #5
            t_Ra2 = 5'd29;
            t_Rb2 = 5'd1;
            t_clk = 1'b0;

            #5
            t_clk = 1'b1;




            #5
            t_RegWr3 = 1'b0;
            t_Rw3 = 5'd0;
            t_Ra3 = 5'd17;
            t_Rb3 = 5'd21;
            t_clk = 1'b0;
            t_busW3 = 32'd255;

            #5
            t_clk = 1'b1;

            #5
            t_Ra3 = 5'd3;
            t_Rb3 = 5'd14;
            t_clk = 1'b0;

            #5
            t_clk = 1'b1;

            #5
            t_Ra3 = 5'd29;
            t_Rb3 = 5'd1;
            t_clk = 1'b0;

            #5
            t_clk = 1'b1;






            #5
            $display("Done\n");

            $display("Testing arbitrary writes");

            #5
            t_RegWr1 = 1'b1;
            t_Rw1 = 5'd17;
            t_Ra1 = 5'd17;
            t_Rb1 = 5'd21;
            t_clk = 1'b0;
            t_busW1 = 32'd255;

            #5
            t_clk = 1'b1;

            #5
            t_Rw1 = 5'd21;
            t_clk = 1'b0;
            t_busW1 = 32'd189;

            #5
            t_clk = 1'b1;

            #5
            t_Rw1 = 5'd3;
            t_Ra1 = 5'd3;
            t_Rb1 = 5'd14;
            t_clk = 1'b0;
            t_busW1 = 32'd56;

            #5
            t_clk = 1'b1;

            #5
            t_Rw1 = 5'd14;
            t_clk = 1'b0;
            t_busW1 = 32'd96;

            #5
            t_clk = 1'b1;

            #5
            t_Rw1 = 5'd29;
            t_Ra1 = 5'd29;
            t_Rb1 = 5'd1;
            t_clk = 1'b0;
            t_busW1 = 32'd120;

            #5
            t_clk = 1'b1;

            #5
            t_Rw1 = 5'd1;
            t_clk = 1'b0;
            t_busW1 = 32'd210;

            #5
            t_clk = 1'b1;


            #5
            t_RegWr2 = 1'b1;
            t_Rw2 = 5'd29;
            t_Ra2 = 5'd29;
            t_Rb2 = 5'd1;
            t_clk = 1'b0;
            t_busW2 = 32'd120;

            #5
            t_clk = 1'b1;

            #5
            t_Rw2 = 5'd3;
            t_Ra2 = 5'd3;
            t_Rb2 = 5'd14;
            t_clk = 1'b0;
            t_busW2 = 32'd56;

            #5
            t_RegWr3 = 1'b1;
            t_Rw3 = 5'd29;
            t_Ra3 = 5'd29;
            t_Rb3 = 5'd1;
            t_clk = 1'b0;
            t_busW3 = 32'd120;

            #5
            t_clk = 1'b1;

            #5
            t_Rw3 = 5'd3;
            t_Ra3 = 5'd3;
            t_Rb3 = 5'd14;
            t_clk = 1'b0;
            t_busW3 = 32'd56;

            


            $display("\nReading all registers");
            for(i = 0; i < 32; i = i + 2) begin
                #5
                t_RegWr1 = 1'b0;
                t_Rw1 = 0;
                t_Ra1 = i;
                t_Rb1 = i+1;
                t_clk = 1'b1;
                t_busW1 = 32'd255;

                #5
                t_RegWr2 = 1'b0;
                t_Rw2 = 0;
                t_Ra2 = i;
                t_Rb2 = i+1;
                t_clk = 1'b1;
                t_busW2 = 32'd255;

                #5
                t_RegWr3 = 1'b0;
                t_Rw3 = 0;
                t_Ra3 = i;
                t_Rb3 = i+1;
                t_clk = 1'b1;
                t_busW3 = 32'd255;


            end

            #5
            $display("Done\n");

        end
  
endmodule
