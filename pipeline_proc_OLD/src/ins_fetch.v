`timescale 1ns/10ps

// AD first attempt at instruction fetch module.  P. 253 in text.

module ins_fetch(clk, reset, load_pc, z); //input: pc counter value; output: instruction

    // define a clock here

    parameter pc_start = 32'h00400020; //this is what we are given for init
    //input [31:0] pc_in;
    input clk, reset, load_pc;
    output wire [31:0] z;
    wire [31:0] pc_in, pc_out; // need a wire for the pc result

    register pc( // add a register to be the pc.
        .clk(clk), 
        .areset(reset), 
        .aload(load_pc), 
        .adata(pc_start), //reloads initial value when aload asserted
        .data_in(pc_in), // debug; final output is pc_in
        .write_enable(1'b1), // want to be able to write at end, always
        .data_out(pc_out) // debug; final value is pc_out
    );

    gac_sram #(.mem_file("data/bills_branch.dat")) ins_mem( // the instruction mem will be sram, no clock.
            .cs(1'b1), // always enable ops
            .oe(1'b1), // always read the ins mem
            .we(1'b0), // never write the ins mem 
            .addr(pc_out), // the address comes from pc
            .din(32'h00000000), // never write the ins mem
            .dout(z) // read out the instruction
    );

    adder_32 adder ( // this adder just increments the pc +4 every time
        .a(pc_out), 
        .b(32'h00000004), // constant 4 for incrementing
        .z(pc_in) // debug - final is pc_in
        );

endmodule //ins_fetch
