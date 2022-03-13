module SLT_signed(A,B,ovf,R);

   input [31:0] A;
   input [31:0] B;
   output ovf;
   output wire [31:0] R;
   
   wire [31:0] sub_z;
   wire sub_borrow;
   wire sub_ovf;
   wire slts_temp;
   wire slts_num;
   wire [31:0] temp;
   
   assign temp = 32'h00000000;
   assign R[31:1] = temp[30:0];
   
   SUB_32bit SUB_map(.x(A), .y(B), .cin(1'b1), .z(sub_z), .borrow(sub_borrow), .ovf(sub_ovf));
   
   xor_gate xor0_map(.x(sub_borrow), .y(sub_ovf), .z(slts_temp));
   
   xor_gate xor1_map(.x(A[31]), .y(B[31]), .z(slts_num));
   
   xor_gate xor2_map(.x(slts_temp), .y(slts_num), .z(R[0]));
   
   assign ovf = sub_ovf;
   
   endmodule
   
   
