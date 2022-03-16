module dffr_a (clk, arst, aload, adata, d, enable, q);
    input clk;
    input arst;
    input aload;
    input adata;
    input d;
    input enable;
    output reg q;
    
    always @(clk or arst or aload)
      begin
        if (arst == 1'b1) q <= 1'b0;
        else if (aload == 1'b1) q <= adata; 
        else if ((clk == 1'b1) && (enable == 1'b1)) q <= d;
      end
      
endmodule 
          
    
    
