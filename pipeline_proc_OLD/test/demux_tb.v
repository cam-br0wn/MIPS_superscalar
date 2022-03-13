`timescale 1ns/10ps

module demux_tb;

reg S;
reg D;
wire Y_ARR;

demux_1t32_32 demux(.s(S), .d(D), .y_arr(Y_ARR));

initial begin
    // initialize with dummy values
            S = 5'h0;
            D = 32'h0;

            /////////////////
            ///// DEMUX /////
            /////////////////
            S = 5'b11111;

            #1
            D = 32'h1;
            
            #5
            S = 5'b00001;
            D = 32'hffffffff;
            #5
            $finish;
            
end

endmodule