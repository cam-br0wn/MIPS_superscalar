 `timescale 1ns/10ps
module pc_inc_tb;
  
  reg [31:0] pc_in_tb;
  reg clk_tb, reset_tb, load_pc_tb;
  wire [31:0] z_tb;
  
  pc_inc #(.pc_start(32'h00400020)) test( // pass parameter we are given in spec.
      .clk(clk_tb),
      .reset(reset_tb),
      .load_pc(load_pc_tb),
      .pc_in(pc_in_tb),
      .ins_out(z_tb)
  );
  
  initial
    begin
       //clk_tb = 1'b0;
       //#5 //10
       clk_tb=1'b1;
       reset_tb = 1'b1; // this needs to be 1 to start
       load_pc_tb = 1'b1;       
       pc_in_tb = 32'h00400020;
       #10
       reset_tb = 1'b0; // this needs to be 1 to start
       load_pc_tb = 1'b1;       
       pc_in_tb = 32'h00400020;
       #10 
       reset_tb = 1'b0;
       load_pc_tb = 1'b0;
       //pc_in_tb = 32'h0040020;
       #10 
       reset_tb = 1'b1;
       load_pc_tb = 1'b0;
       //pc_in_tb = 32'h0040020;
       #10 
       reset_tb = 1'b0;
       load_pc_tb = 1'b0;
       //pc_in_tb = 32'h0040020;
       #10 
       reset_tb = 1'b0;
       load_pc_tb = 1'b0;
       //pc_in_tb = 32'h0040020;
       #10 
       reset_tb = 1'b1;
       load_pc_tb = 1'b0;
       //pc_in_tb = 32'h0040020;       
       #10 
       reset_tb = 1'b0;
       load_pc_tb = 1'b1;
       #10
       reset_tb = 1'b0;
       load_pc_tb = 1'b0;
       #10
       reset_tb = 1'b0;
       load_pc_tb = 1'b0;
       #10
       reset_tb = 1'b1;
       load_pc_tb = 1'b0;
       #10
       reset_tb = 1'b0;
       load_pc_tb = 1'b0;
       #10
      $finish;
  end

   always #5 clk_tb = ~clk_tb;
endmodule





