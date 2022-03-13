module sll_32bit(x,shift,z);
    
    input [31:0] x;
    input [31:0] shift;
    output wire [31:0] z;
    
    wire [31:0] xin;
    wire [0:31] test;
    wire [31:0] t;
    
    wire [31:0] temp;
    
    assign xin = 32'h00000000;
    
   assign test[0:31] = x[31:0];
   

   // I guess i am lazy
    assign z = x << shift;
    
    // an alternative way below. However it is not checked!
   // assign temp[0] = x[0];
   // assign temp[31:1] = xin[31:1];
   // mux_32to1 mux_map0(.sel(shift[4:0]), .src(temp), .z(z[0]));
    
   // genvar i;
   // genvar j;
   // for (i=1; i<31; i=i+1) begin
   //     for (j=0;j<=i;j=j+1) begin
   //         assign temp[j] = x[i-j];
   //   end
   //   assign temp[31:i+1] = xin[31:i+1];
   //    mux_32to1 mux_map(.sel(shift[4:0]), .src(temp), .z(z[i]));
   // end

   // mux_32to1 mux_map1(.sel(shift[4:0]), .src(x), .z(z[31]));
    

    
endmodule
    


