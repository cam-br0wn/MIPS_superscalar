//`include "../cpu/alu_subpipeline.v"

module subpipeline_tb;
  
    reg clk, clockthing, RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, ExtOp, EXzero;
    reg [31:0] IDpc, IDinstruction, regbusA, regbusB;
    reg [1:0] Branch;
    reg [2:0] ALUOp;

    
    alu_subpipeline DUT(clk, clockthing,
                        IDpc, 
                        //srcA,
                        //srcB,
                        regbusA,  
                        regbusB, 
                        IDinstruction, 
                        ExtOp, 
                        ALUSrc, 
                        ALUOp, 
                        RegDst, 
                        MemWrite, 
                        Branch, 
                        MemtoReg, 
                        RegWrite,

                        BusW,        //data to be written back into reg file
                        MEMpc,       //PC to be used as input to branch mux (src1)
                        branch_ctrl, //result from AND gate of branch bit and zero bit. Use this as the sel bit for branch mux.
                        regmuxout); //Rw
  
    initial
        begin

            $dumpvars(); 
            $dumpfile("waves.vcd"); 

            //$monitor(BusW, MEMpc, branch_ctrl, regmuxout);

            regbusA = 32'b00000000000000000000000000001100;
            regbusB = 32'b00000000000000000000000000000110;
            IDinstruction = 32'b00000000001000100010000000101000; 
            ExtOp = 1'b0; 
            ALUSrc = 1'b0;
            ALUOp = 3'b000; 
            RegDst = 1'b0; 
            MemWrite = 1'b0;
            Branch = 2'b00;
            MemtoReg = 1'b1;
            RegWrite = 1'b1;

            #10
            clk = 0;
            $display("BUSW: ", BusW);
            $display("MEMpc: ", MEMpc);
            $display("regmuxout: ", regmuxout);
            $display("branch_ctrl: ", branch_ctrl);
            #5
            clk = ~clk;
            $display("BUSW: ", BusW);
            $display("MEMpc: ", MEMpc);
            $display("regmuxout: ", regmuxout);
            $display("branch_ctrl: ", branch_ctrl);

            #10

            clk = ~clk;
        end

  initial
    begin
        clockthing = 0;
        IDpc = 32'b10000000000000000100000;
        #8
        $display("BUSW: ", BusW);
        $display("MEMpc: ", MEMpc);
        $display("regmuxout: ", regmuxout);
        $display("branch_ctrl: ", branch_ctrl);
        #20
        clockthing = 1;
      // Unsigned Sum
      #1600
      // Bills Branch
      //#2350
      // Sort Corrected Branch
      //#12500
      #10
      $stop;
  end
endmodule