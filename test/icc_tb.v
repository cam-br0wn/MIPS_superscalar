module icc_tb;

    reg [7:0] pc_9_2, ghr_7_0;
    wire [7:0] out_;

    icc Instance0 (pc_9_2, ghr_7_0, out_);

    initial begin

        pc_9_2 = 8'b0000000; ghr_7_0 = 8'b0000000;
        #1 pc_9_2 = 8'b0000000; ghr_7_0 = 8'b0000001;
        #1 pc_9_2 = 8'b0000001; ghr_7_0 = 8'b0000001;
        #1 pc_9_2 = 8'b0001111; ghr_7_0 = 8'b0001010;
        
    end 

endmodule