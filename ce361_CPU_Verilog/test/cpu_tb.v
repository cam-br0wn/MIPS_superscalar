//`include "cpu/cpu.v"
module cpu_tb;

  reg clk, pc_ld;
  reg [31:0] pc_data;
  reg clockthing;

  cpu cpu_ut(.clk(clk), .pc_ld(pc_ld), .pc_data(pc_data), .clockthing(clockthing));
  defparam cpu_ut.data_file = "data/unsigned_sum.dat";
  //defparam cpu_ut.data_file = "data/bills_branch.dat";
  //defparam cpu_ut.data_file = "data/sort_corrected_branch.dat";

  initial begin
        #10
        clk = 0;
        forever begin
            #5
            clk = ~clk;
        end
    end

  initial
    begin
      pc_ld = 0;
        clockthing = 0;
        pc_data = 32'b10000000000000000100000;
        #1
        pc_ld = 1;
        #1
        pc_ld = 0;
        #8
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
