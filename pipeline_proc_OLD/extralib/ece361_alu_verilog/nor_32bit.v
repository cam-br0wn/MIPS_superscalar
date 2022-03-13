module nor_32bit(or_in, nor_out);
    input [31:0] or_in;
    output nor_out;
    
    
    assign nor_out = ~(or_in[0] | or_in[1] | or_in[2] | or_in[3] | or_in[4] | or_in[5] | or_in[6] | or_in[7] | or_in[8] | or_in[9] | or_in[10] | 
                or_in[11] | or_in[12] | or_in[13] | or_in[14] | or_in[15] | or_in[16] | or_in[17] | or_in[18] | or_in[19] | or_in[20] |
                or_in[21] | or_in[22] | or_in[23] | or_in[24] | or_in[25] | or_in[26] | or_in[27] | or_in[28] | or_in[29] | or_in[30] | or_in[31]);
                
endmodule
    
