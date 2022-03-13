`timescale 1ns/10ps
module branch_unit_tb;
    reg beq_f, bne_f, bgtz_f, zf, msb;
    wire br_sel;
    reg clk;

    branch_unit test(
        beq_f,
        bne_f,
        bgtz_f,
        zf,
        msb,
        br_sel
    );

    initial begin
        clk = 0;
        beq_f = 0;
        bne_f = 0;
        bgtz_f = 0;
        zf = 1;
        msb = 0;
        #5
        //expect: br_sel = 0
        beq_f = 0;
        bne_f = 0;
        bgtz_f = 1;
        zf = 0;
        msb = 0;
        #5
        //expect: br_sel = 1
        beq_f = 0;
        bne_f = 0;
        bgtz_f = 1;
        zf = 0;
        msb = 1;
        #5
        //expect: br_sel = 0
        beq_f = 0;
        bne_f = 0;
        bgtz_f = 1;
        zf = 1;
        msb = 1;
        #5
        //expect: br_sel = 0
        beq_f = 0;
        bne_f = 1;
        bgtz_f = 0;
        zf = 1;
        msb = 0;
        #5
        //expect: br_sel = 0
        beq_f = 1;
        bne_f = 0;
        bgtz_f = 0;
        zf = 1;
        msb = 0;
        #5
        //expect: br_sel = 1
        beq_f = 1;
        bne_f = 0;
        bgtz_f = 0;
        zf = 0;
        msb = 0;
        #5
        //expect: br_sel = 0
        beq_f = 0;
        bne_f = 1;
        bgtz_f = 0;
        zf = 0;
        msb = 0;
        #5
        //expect: br_sel = 1
        

        beq_f = 0;
        bne_f = 0;
        bgtz_f = 0;
        zf = 1;
        msb = 1;
        #5
        //expect: br_sel = 0
        beq_f = 0;
        bne_f = 0;
        bgtz_f = 0;
        zf = 0;
        msb = 1;
        #5
        //expect: br_sel = 0
        beq_f = 0;
        bne_f = 1;
        bgtz_f = 0;
        zf = 0;
        msb = 1;
        #5
        //expect: br_sel = 1
        beq_f = 1;
        bne_f = 0;
        bgtz_f = 0;
        zf = 0;
        msb = 1;
        #5
        //expect: br_sel = 0
        beq_f = 1;
        bne_f = 0;
        bgtz_f = 0;
        zf = 1;
        msb = 1;
        #5
        //expect: br_sel = 1
        beq_f = 0;
        bne_f = 1;
        bgtz_f = 0;
        zf = 1;
        msb = 1;
        #5
        //expect: br_sel = 0
        beq_f = 0;
        bne_f = 1;
        bgtz_f = 0;
        zf = 0;
        msb = 1;
        #5
        //expect: br_sel = 1
        $finish;
    end

    always #5 clk = ~clk;
endmodule