// 32 of the 32-bit registers

module register_file(clk, reset, read_reg1, read_reg2, write_reg, write_data, write_enable, read_data1, read_data2);

input [4:0] read_reg1, read_reg2, write_reg;
input [31:0] write_data;
input clk, reset, write_enable;
output wire [31:0] read_data1, read_data2;

// Wires coming out of each register, to be passed to the mux
// wire [31:0] $zero, $v0, $v1, $a0, $a1, $a2, $a3, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $s0, $s1, $s2, $s3, $s4, $s5, $s6, $s7, $t8, $t9, $gp, $sp, $fp, $ra;

// Actually just make wire arrays for input and output into the registers
// wire [31:0] input_wires[31:0];
wire [31:0] output_wires[31:0];

// Note: registers 1, 26 and 27 are reserved for assembler/operating system, but I don't think that means we don't access them in hardware

// In order to make sure writing is valid, just mux_32 with write_enable as the selector

// I think this actually needs to be a decoder?
// We need to figure out how to map this to the proper input wire index...
// Essentially just do input_wires[write_reg] = write_data

wire [31:0] decoder_out;
wire [31:0] decoder_and_we;
gac_dec_5 dec_(.src(write_reg), .z(decoder_out));
genvar k;
generate
    for (k = 0; k < 32; k = k + 1) begin
        gac_and_gate and_dec_we_(.x(write_enable), .y(decoder_out[k]), .z(decoder_and_we[k]));
    end
endgenerate

// generate the bank of registers
// setting async reset, load and data to GND/0 until we want to implement that functionality
genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin
        register reg_(.clk(clk), .areset(reset), .aload(1'b0), .adata(32'b0), .data_in(write_data), .write_enable(decoder_and_we[i]), .data_out(output_wires[i]));
    end
endgenerate


// These two muxes handle selecting which registers we are reading from

gac_mux_32t1_32 read_sel_mux_1_(.sel(read_reg1), 
.x0(32'h0), 
.x1(output_wires[1]), 
.x2(output_wires[2]), 
.x3(output_wires[3]), 
.x4(output_wires[4]), 
.x5(output_wires[5]), 
.x6(output_wires[6]), 
.x7(output_wires[7]), 
.x8(output_wires[8]), 
.x9(output_wires[9]), 
.xA(output_wires[10]), 
.xB(output_wires[11]), 
.xC(output_wires[12]), 
.xD(output_wires[13]), 
.xE(output_wires[14]), 
.xF(output_wires[15]), 
.x10(output_wires[16]), 
.x11(output_wires[17]), 
.x12(output_wires[18]), 
.x13(output_wires[19]), 
.x14(output_wires[20]), 
.x15(output_wires[21]), 
.x16(output_wires[22]), 
.x17(output_wires[23]), 
.x18(output_wires[24]), 
.x19(output_wires[25]), 
.x1A(output_wires[26]), 
.x1B(output_wires[27]), 
.x1C(output_wires[28]), 
.x1D(output_wires[29]), 
.x1E(output_wires[30]), 
.x1F(output_wires[31]), 
.q(read_data1));
gac_mux_32t1_32 read_sel_mux_2_(.sel(read_reg2), 
.x0(32'h0), 
.x1(output_wires[1]), 
.x2(output_wires[2]), 
.x3(output_wires[3]), 
.x4(output_wires[4]), 
.x5(output_wires[5]), 
.x6(output_wires[6]), 
.x7(output_wires[7]), 
.x8(output_wires[8]), 
.x9(output_wires[9]), 
.xA(output_wires[10]), 
.xB(output_wires[11]), 
.xC(output_wires[12]), 
.xD(output_wires[13]), 
.xE(output_wires[14]), 
.xF(output_wires[15]), 
.x10(output_wires[16]), 
.x11(output_wires[17]), 
.x12(output_wires[18]), 
.x13(output_wires[19]), 
.x14(output_wires[20]), 
.x15(output_wires[21]), 
.x16(output_wires[22]), 
.x17(output_wires[23]), 
.x18(output_wires[24]), 
.x19(output_wires[25]), 
.x1A(output_wires[26]), 
.x1B(output_wires[27]), 
.x1C(output_wires[28]), 
.x1D(output_wires[29]), 
.x1E(output_wires[30]), 
.x1F(output_wires[31]), 
.q(read_data2));


endmodule

