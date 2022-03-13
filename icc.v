module icc (pc_9_2, ghr_7_0, out_);

    input [7:0] pc_9_2, ghr_7_0;
    output [7:0] out_;

    assign out_ = pc_9_2 ^ ghr_7_0;


endmodule 