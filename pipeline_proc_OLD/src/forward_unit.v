`timescale 1ns/10ps
module forward_unit(EXMEM_RegWrite, MEMWB_RegWrite, EXMEM_Rd, IDEX_Rs, IDEX_Rt, MEMWB_Rd, ForwardA, ForwardB);
    input EXMEM_RegWrite, MEMWB_RegWrite;
    input [4:0] EXMEM_Rd, IDEX_Rs, IDEX_Rt, MEMWB_Rd;
    output wire [1:0] ForwardA, ForwardB;

    wire [4:0] EXMEM_RDRS, EXMEM_RDRT, MEMWB_RDRS, MEMWB_RDRT;

    genvar i;
    generate
        for(i = 0; i < 5; i = i + 1) begin
            gac_xnor_gate exmemrdrs_(.x(EXMEM_Rd[i]), .y(IDEX_Rs[i]), .z(EXMEM_RDRS[i]));
            gac_xnor_gate exmemrdrt_(.x(EXMEM_Rd[i]), .y(IDEX_Rt[i]), .z(EXMEM_RDRT[i]));
            
            gac_xnor_gate memwbrdrs_(.x(MEMWB_Rd[i]), .y(IDEX_Rs[i]), .z(MEMWB_RDRS[i]));
            gac_xnor_gate membwrdrt_(.x(MEMWB_Rd[i]), .y(IDEX_Rt[i]), .z(MEMWB_RDRT[i]));
        end
    endgenerate

    // REG EQUIVALENCE
    wire exmemrdrs_and_wire;
    gac_and_gate_6in exmemrdrs_and(.a(EXMEM_RDRS[0]), .b(EXMEM_RDRS[1]), .c(EXMEM_RDRS[2]), .d(EXMEM_RDRS[3]), .e(EXMEM_RDRS[4]), .f(1'b1), .z(exmemrdrs_and_wire));

    wire exmemrdrt_and_wire;
    gac_and_gate_6in exmemrdrt_and(.a(EXMEM_RDRT[0]), .b(EXMEM_RDRT[1]), .c(EXMEM_RDRT[2]), .d(EXMEM_RDRT[3]), .e(EXMEM_RDRT[4]), .f(1'b1), .z(exmemrdrt_and_wire));

    wire memwbrdrs_and_wire;
    gac_and_gate_6in memwbrdrs_and(.a(MEMWB_RDRS[0]), .b(MEMWB_RDRS[1]), .c(MEMWB_RDRS[2]), .d(MEMWB_RDRS[3]), .e(MEMWB_RDRS[4]), .f(1'b1), .z(memwbrdrs_and_wire));

    wire memwbrdrt_and_wire;
    gac_and_gate_6in memwbrdrt_and(.a(MEMWB_RDRT[0]), .b(MEMWB_RDRT[1]), .c(MEMWB_RDRT[2]), .d(MEMWB_RDRT[3]), .e(MEMWB_RDRT[4]), .f(1'b1), .z(memwbrdrt_and_wire));

    //!= 0
    wire exmemrdnot_0_wire;
    gac_or_gate_6in exmemrd_not_0(.a(EXMEM_Rd[0]), .b(EXMEM_Rd[1]), .c(EXMEM_Rd[2]), .d(EXMEM_Rd[3]), .e(EXMEM_Rd[4]), .f(1'b0), .z(exmemrdnot_0_wire));

    wire memwbrdnot_0_wire;
    gac_or_gate_6in memwbrd_not_0(.a(MEMWB_Rd[0]), .b(MEMWB_Rd[1]), .c(MEMWB_Rd[2]), .d(MEMWB_Rd[3]), .e(MEMWB_Rd[4]), .f(1'b0), .z(memwbrdnot_0_wire));


    // NOT SURE AFTER THIS POINT
    gac_and_gate_6in a1(.a(exmemrdnot_0_wire), .b(exmemrdrs_and_wire), .c(EXMEM_RegWrite), .d(1'b1), .e(1'b1), .f(1'b1), .z(ForwardA[1]));

    wire not_a1;
    gac_not_gate nota1(.x(ForwardA[1]), .z(not_a1));
    gac_and_gate_6in a0(.a(memwbrdrs_and_wire), .b(memwbrdnot_0_wire), .c(not_a1), .d(MEMWB_RegWrite), .e(1'b1), .f(1'b1), .z(ForwardA[0]));

    gac_and_gate_6in b1(.a(exmemrdnot_0_wire), .b(exmemrdrt_and_wire), .c(EXMEM_RegWrite), .d(1'b1), .e(1'b1), .f(1'b1), .z(ForwardB[1]));

    wire not_b1;
    gac_not_gate notb1(.x(ForwardB[1]), .z(not_b1));
    gac_and_gate_6in b0(.a(memwbrdrt_and_wire), .b(memwbrdnot_0_wire), .c(not_b1), .d(MEMWB_RegWrite), .e(1'b1), .f(1'b1), .z(ForwardB[0]));

    

endmodule