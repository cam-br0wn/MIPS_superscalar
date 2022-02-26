`timescale 1ns/10ps
module basic_and_tb(a, b, y);

    reg a, b;
    wire y;

    basic_and basic_and_(
        .a(a),
        .b(b),
        .y(y)
    );

    initial begin
        $dumpfile("basic_and.vcd");
        $dumpvars(0,basic_and_tb);
        // $monitor(a, b, y);

        #10
        a = 0;
        b = 0;

        #10
        a = 0;
        b = 1;

        #10
        a = 1;
        b = 0;

        #10
        a = 1;
        b = 1;

        $finish

        

    end
endmodule