`timescale 1ns/10ps
module forward_unit_tb;
    reg EXMEM_RegWrite, MEMWB_RegWrite;
    reg [4:0] EXMEM_Rd, IDEX_Rs, IDEX_Rt, MEMWB_Rd;
    wire [1:0] ForwardA, ForwardB;

    forward_unit test(
        .EXMEM_RegWrite(EXMEM_RegWrite),
        .MEMWB_RegWrite(MEMWB_RegWrite),
        .EXMEM_Rd(EXMEM_Rd),
        .IDEX_Rs(IDEX_Rs),
        .IDEX_Rt(IDEX_Rt),
        .MEMWB_Rd(MEMWB_Rd),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );

    initial begin
        EXMEM_RegWrite = 0;
        EXMEM_Rd = 0;
        IDEX_Rs = 0;
        IDEX_Rt = 0;
        MEMWB_Rd = 0;
        MEMWB_RegWrite = 0;
        // initializing everything, expect:
        // ForwardA = 00
        // ForwardB = 00
        #5
        EXMEM_RegWrite = 1;
        EXMEM_Rd = 3;
        IDEX_Rs = 3;
        IDEX_Rt = 0;
        MEMWB_Rd = 0;
        MEMWB_RegWrite = 0;
        // expect:
        // ForwardA = 10
        // ForwardB = 00
        #5
        EXMEM_RegWrite = 1;
        EXMEM_Rd = 3;
        IDEX_Rs = 3;
        IDEX_Rt = 3;
        MEMWB_Rd = 0;
        MEMWB_RegWrite = 0;
        // expect:
        // ForwardA = 10
        // ForwardB = 10
        #5
        EXMEM_RegWrite = 0;
        EXMEM_Rd = 3;
        IDEX_Rs = 3;
        IDEX_Rt = 3;
        MEMWB_Rd = 0;
        MEMWB_RegWrite = 0;
        // expect:
        // ForwardA = 00
        // ForwardB = 00
        #5
        EXMEM_RegWrite = 1;
        EXMEM_Rd = 3;
        IDEX_Rs = 3;
        IDEX_Rt = 1;
        MEMWB_Rd = 1;
        MEMWB_RegWrite = 1;
        // expect:
        // ForwardA = 10
        // ForwardB = 01
        #5
        EXMEM_RegWrite = 1;
        EXMEM_Rd = 3;
        IDEX_Rs = 3;
        IDEX_Rt = 3;
        MEMWB_Rd = 3;
        MEMWB_RegWrite = 1;
        // expect:
        // ForwardA = 10
        // ForwardB = 10
        #5
        $finish;
    end

endmodule