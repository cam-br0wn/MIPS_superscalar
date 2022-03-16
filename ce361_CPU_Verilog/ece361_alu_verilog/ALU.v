module ALU(ctrl, A,B,shamt,cout,ovf,ze,R);
    input [2:0] ctrl;
    input [31:0] A;
    input [31:0] B;
    input [4:0] shamt;
    output cout;
    output ovf;
    output ze;
    output wire [31:0] R;
    
    
    wire [31:0] fa_z;
    wire [31:0] fa_uz;
    wire fa_cout;
    wire fa_ucout;
    wire fa_ovf;
    wire fa_uovf;
    wire [31:0] sub_z;
    wire sub_borrow;
    wire sub_ovf;
    wire [31:0] and_z;
    wire [31:0] or_z;
    wire [31:0] temp;
    wire temp_cout;
    wire fa_ze;
    wire fa_uze;
    wire sub_ze;
    wire and_ze;
    wire or_ze;
    wire temp_ze;
    wire [31:0] slt_R;
    wire slt_ovf;
    wire slt_ze;
    wire [31:0] slt_signed_R;
    wire slt_signed_ovf;
    wire slt_signed_ze;
    wire [31:0] sll_R;
    wire sll_ze;
    wire [31:0] shiftL;
    
    
    assign temp = 32'h0000003A;
    assign temp_ze = 1'b0;
    assign temp_cout = 1'b0;
    assign shiftL[4:0] = shamt;
    assign shiftL[31:5] = 27'b000000000000000000000000000;
    
    full_adder_32bit FA(.x(A), .y(B), .cin(1'b0), .z(fa_z), .cout(fa_cout), .ovf(fa_ovf));
    
    nor_32bit nor_map0(.or_in(fa_z),.nor_out(fa_ze));
    
    full_adder_32bit FA_u(.x(A), .y(B), .cin(1'b0), .z(fa_uz), .cout(fa_ucout), .ovf(fa_uovf)); 
    
    nor_32bit nor_umap0(.or_in(fa_uz),.nor_out(fa_uze));
    
    SUB_32bit SUB(.x(A), .y(B), .cin(1'b1), .z(sub_z), .borrow(sub_borrow), .ovf(sub_ovf));
    
    nor_32bit nor_map1(.or_in(sub_z),.nor_out(sub_ze));
    
    and_gate_32 and0(.x(A), .y(B), .z(and_z));
    
    nor_32bit nor_map2(.or_in(and_z),.nor_out(and_ze));
    
    or_gate_32 or0(.x(A), .y(B), .z(or_z));
    
    nor_32bit nor_map3(.or_in(or_z) , .nor_out(or_ze));
    
    SLT slt_map(.A(A), .B(B), .ovf(slt_ovf), .R(slt_R) );
    
    SLT_signed SLT_signed_map(.A(A), .B(B), .ovf(slt_signed_ovf), .R(slt_signed_R));
    
    sll_32bit sll_map(.x(A), .shift(shiftL), .z(sll_R));
    
    nor_32bit nor_map4(.or_in(sll_R) , .nor_out(sll_ze));
    
    nor_32bit nor_map5(.or_in(slt_R) , .nor_out(slt_ze));
    
    nor_32bit nor_map6(.or_in(slt_signed_R) , .nor_out(slt_signed_ze));
    
    mux8_1_32bit mux_map32(.sel(ctrl), .src_in0(and_z), .src_in1(or_z), .src_in2(fa_z), .src_in3(slt_signed_R), .src_in4(fa_uz), .src_in5(sll_R), .src_in6(sub_z), .src_in7(slt_R), .z(R));
    
    mux8_1_1bit mux_map_cout(.sel(ctrl), .src_in0(1'b0), .src_in1(1'b0), .src_in2(fa_cout), .src_in3(1'b0), .src_in4(fa_ucout), .src_in5(1'b0), .src_in6(sub_borrow), .src_in7(temp_cout), .z(cout));
    
    mux8_1_1bit mux_map_ze(.sel(ctrl), .src_in0(and_ze), .src_in1(or_ze), .src_in2(fa_ze), .src_in3(slt_signed_ze), .src_in4(fa_uze), .src_in5(sll_ze), .src_in6(sub_ze), .src_in7(slt_ze), .z(ze));
    
    mux8_1_1bit mux_map_ovf(.sel(ctrl), .src_in0(1'b0), .src_in1(1'b0), .src_in2(fa_ovf), .src_in3(slt_signed_ovf), .src_in4(fa_uovf), .src_in5(1'b0), .src_in6(sub_ovf), .src_in7(slt_ovf), .z(ovf));
    
  // always @(ctrl,A,B,R) begin
 // $display("------ALU-------");
 // $display("ALU ctrl: %b", ctrl);
 // $display("ALU busA: %b", A);
 // $display("ALU busB: %b", B);
 // $display("ALU_out: %b", R);
 // $display("-------------");
 //  end


endmodule
    
    
    
    
    
    
    
    
    
    