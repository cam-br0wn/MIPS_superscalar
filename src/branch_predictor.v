module branch_predictor(PC, result, prediction);
    input [31:0] PC;
    input result;
    output prediction;

    reg [1:0] PHT [0:256] = b'01;
    reg [7:0] GHR = b'00000000;
    wire [7:0] index = PC[9:2] ^ GHR[7:0];

    always (@posedge clk) begin
        GHR <= {GHR[6:0], branch_taken}

        /// when there is a branch command going through the processor, the branch poredictor reads this and makes a prediction as to wether or not
        /// that conditional branch will actually succeed. Then, the next cycle we will necessarily have the previous instruction being
        /// a branch and now we have our prediction from last time and the new results to test against eachother, adn then updare our state from there

        /// padv_decode_i = is the decode stage stalled? this means that 