`timescale 1ns/10ps
module hazard_detection(IDEXMemRead, IDEXRegisterRt, IFIDRegisterRs, IFIDRegisterRt, PCWrite, IFIDWrite, ControlMuxSel);
    input IDEXMemRead;
    input [4:0] IDEXRegisterRt, IFIDRegisterRs, IFIDRegisterRt;
    output wire PCWrite, IFIDWrite, ControlMuxSel;

    wire [4:0] RTRS, RTRT;
    wire RTRS_AND, RTRT_AND, equivalence;

    genvar i;
    generate
        for (i = 0; i < 5; i = i + 1) begin
            gac_xnor_gate rtrs_xnor(.x(IDEXRegisterRt[i]), .y(IFIDRegisterRs[i]), .z(RTRS[i]));
            gac_xnor_gate rtrt_xnor(.x(IDEXRegisterRt[i]), .y(IFIDRegisterRt[i]), .z(RTRT[i]));
        end
    endgenerate 
    
    gac_and_gate_6in and_6in_rtrs(.a(RTRS[0]), .b(RTRS[1]), .c(RTRS[2]), .d(RTRS[3]), .e(RTRS[4]), .f(1'b1), .z(RTRS_AND));
    gac_and_gate_6in and_6in_rtrt(.a(RTRT[0]), .b(RTRT[1]), .c(RTRT[2]), .d(RTRT[3]), .e(RTRT[4]), .f(1'b1), .z(RTRT_AND));

    gac_or_gate or_(.x(RTRS_AND), .y(RTRT_AND), .z(equivalence));

    gac_and_gate and_(.x(equivalence), .y(IDEXMemRead), .z(ControlMuxSel));
    
    gac_not_gate pcw(.x(ControlMuxSel), .z(PCWrite));
    gac_not_gate ifid(.x(ControlMuxSel), .z(IFIDWrite));

endmodule