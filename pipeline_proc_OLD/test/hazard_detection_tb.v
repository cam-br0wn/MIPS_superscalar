`timescale 1ns/10ps
module hazard_detection_tb;
    reg IDEXMemRead;
    reg [4:0] IDEXRegisterRt, IFIDRegisterRs, IFIDRegisterRt;
    wire PCWrite, IFIDWrite, ControlMuxSel;

    hazard_detection test(
        IDEXMemRead,
        IDEXRegisterRt,
        IFIDRegisterRs,
        IFIDRegisterRt,
        PCWrite,
        IFIDWrite,
        ControlMuxSel
    );

    initial begin
        IDEXMemRead = 1;
        IDEXRegisterRt = 0;
        IFIDRegisterRs = 0;
        IFIDRegisterRt = 0;
        #5
        IDEXRegisterRt = 1;
        IFIDRegisterRs = 0;
        IFIDRegisterRt = 0;
        #5
        IDEXRegisterRt = 0;
        IFIDRegisterRs = 1;
        IFIDRegisterRt = 0;
        #5
        IDEXRegisterRt = 0;
        IFIDRegisterRs = 0;
        IFIDRegisterRt = 1;
        #5
        IDEXRegisterRt = 0;
        IFIDRegisterRs = 13;
        IFIDRegisterRt = 1;
        #5
        IDEXRegisterRt = 30;
        IFIDRegisterRs = 4;
        IFIDRegisterRt = 30;
        #5
        IDEXRegisterRt = 8;
        IFIDRegisterRs = 8;
        IFIDRegisterRt = 5;
        #5
        IDEXMemRead = 0;
        IDEXRegisterRt = 0;
        IFIDRegisterRs = 0;
        IFIDRegisterRt = 0;
        #5
        IDEXRegisterRt = 1;
        IFIDRegisterRs = 0;
        IFIDRegisterRt = 0;
        #5
        IDEXRegisterRt = 0;
        IFIDRegisterRs = 1;
        IFIDRegisterRt = 0;
        #5
        IDEXRegisterRt = 0;
        IFIDRegisterRs = 0;
        IFIDRegisterRt = 1;
        #5
        IDEXRegisterRt = 0;
        IFIDRegisterRs = 13;
        IFIDRegisterRt = 1;
        #5
        IDEXRegisterRt = 30;
        IFIDRegisterRs = 4;
        IFIDRegisterRt = 30;
        #5
        IDEXRegisterRt = 8;
        IFIDRegisterRs = 8;
        IFIDRegisterRt = 5;
        #5
        $finish;
    end
endmodule