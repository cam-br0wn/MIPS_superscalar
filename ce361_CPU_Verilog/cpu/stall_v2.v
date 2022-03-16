module stallcheck2 (curr, prev1, prev2, prev3, stall);
    input [31:0] curr, prev1, prev2, prev3;
    output stall;
    
    // stall will tell us if there is a hazard (1 means yes, 0 means no)

    wire [4:0] checka, checkb, dest1, dest2, dest3; 
    wire stall1, stall2, stallf;
    wire b1, b2, b3, b1a, b2a, b3a, b1b, b2b, b3b;
    wire a, aa, ab;
    wire i, l, s, b, c1, c2;
    wire z1a, z1b, z1c, z1, z2a, z2b, z2c, z2, z3a, z3b, z3c, z3;
    wire c1a, c1b, c1c, c1d, c1e, c2a, c2b, c2c, c2d, c2e, c3a, c3b, c3c, c3d, c3e;
    wire c1d1, c2d1, c3d1, c1c1, c2c1, c3c1, c1c2, c2c2, c3c2;

    // check if branch and get rd/rt
    //if curr[31:26] == 4, 5 or 7, branch and set stall to 1
    // if nextx[31:26] == 7, 8, 0x23 or 0x2b reg check <25:21>, else <20:16> and <25:21>
    ALU alu1(.ctrl(3'b110), .A({26'b0, prev1[31:26]}),.B(32'b00000000000000000000000000000100),.shamt(5'b0),.cout(),.ovf(),.ze(b1),.R());
    ALU alu2(.ctrl(3'b110), .A({26'b0, prev1[31:26]}),.B(32'b00000000000000000000000000000101),.shamt(5'b0),.cout(),.ovf(),.ze(b2),.R());
    ALU alu3(.ctrl(3'b110), .A({26'b0, prev1[31:26]}),.B(32'b00000000000000000000000000000111),.shamt(5'b0),.cout(),.ovf(),.ze(b3),.R());
    ALU alu1a(.ctrl(3'b110), .A({26'b0, prev2[31:26]}),.B(32'b00000000000000000000000000000100),.shamt(5'b0),.cout(),.ovf(),.ze(b1a),.R());
    ALU alu2a(.ctrl(3'b110), .A({26'b0, prev2[31:26]}),.B(32'b00000000000000000000000000000101),.shamt(5'b0),.cout(),.ovf(),.ze(b2a),.R());
    ALU alu3a(.ctrl(3'b110), .A({26'b0, prev2[31:26]}),.B(32'b00000000000000000000000000000111),.shamt(5'b0),.cout(),.ovf(),.ze(b3a),.R());
    ALU alu1bb(.ctrl(3'b110), .A({26'b0, prev3[31:26]}),.B(32'b00000000000000000000000000000100),.shamt(5'b0),.cout(),.ovf(),.ze(b1b),.R());
    ALU alu2bb(.ctrl(3'b110), .A({26'b0, prev3[31:26]}),.B(32'b00000000000000000000000000000101),.shamt(5'b0),.cout(),.ovf(),.ze(b2b),.R());
    ALU alu3bb(.ctrl(3'b110), .A({26'b0, prev3[31:26]}),.B(32'b00000000000000000000000000000111),.shamt(5'b0),.cout(),.ovf(),.ze(b3b),.R());
    or3to1 or1(.w(b1), .x(b2), .y(b3), .z(a));
    or3to1 or1a(.w(b1a), .x(b2a), .y(b3a), .z(aa));
    or3to1 or1b(.w(b1b), .x(b2b), .y(b3b), .z(ab));
    or3to1 stallingsucks(.w(a), .x(aa), .y(ab), .z(stall1));
    

    ALU alu4(.ctrl(3'b110), .A({26'b0, curr[31:26]}),.B(32'b00000000000000000000000000000111),.shamt(5'b0),.cout(),.ovf(),.ze(b),.R());
    ALU alu5(.ctrl(3'b110), .A({26'b0, curr[31:26]}),.B(32'b00000000000000000000000000001000),.shamt(5'b0),.cout(),.ovf(),.ze(i),.R());
    ALU alu6(.ctrl(3'b110), .A({26'b0, curr[31:26]}),.B(32'b00000000000000000000000000101011),.shamt(5'b0),.cout(),.ovf(),.ze(l),.R());
    ALU alu7(.ctrl(3'b110), .A({26'b0, curr[31:26]}),.B(32'b00000000000000000000000000100011),.shamt(5'b0),.cout(),.ovf(),.ze(s),.R());
    or3to1 or2(.w(i), .x(l), .y(s), .z(c1));
    or_gate or0(.x(c1), .y(b), .z(c2));

    mux_5 reg_c1(.sel(c2), .src0(curr[20:16]), .src1(curr[25:21]), .z(checka));
    mux_5 reg_c2(.sel(c2), .src0(curr[25:21]), .src1(curr[25:21]), .z(checkb));

    // check for data dependencies, if so delay by that many
    //if curr[31:26] == 8, 0x23 or 0x2b reg dest is <20:16> else <15:11>
    ALU alu1b(.ctrl(3'b110), .A({26'b0, prev1[31:26]}),.B(32'b00000000000000000000000000001000),.shamt(5'b0),.cout(),.ovf(),.ze(z1a),.R());
    ALU alu1c(.ctrl(3'b110), .A({26'b0, prev1[31:26]}),.B(32'b00000000000000000000000000100011),.shamt(5'b0),.cout(),.ovf(),.ze(z1b),.R());
    ALU alu1d(.ctrl(3'b110), .A({26'b0, prev1[31:26]}),.B(32'b00000000000000000000000000101011),.shamt(5'b0),.cout(),.ovf(),.ze(z1c),.R());
    or3to1 ora(.w(z1a), .x(z1b), .y(z1c), .z(z1));

    mux_5 desta(.sel(z1), .src0(prev1[15:11]), .src1(prev1[20:16]), .z(dest1));

    ALU alu2d(.ctrl(3'b110), .A({26'b0, prev2[31:26]}),.B(32'b00000000000000000000000000001000),.shamt(5'b0),.cout(),.ovf(),.ze(z2a),.R());
    ALU alu2c(.ctrl(3'b110), .A({26'b0, prev2[31:26]}),.B(32'b00000000000000000000000000100011),.shamt(5'b0),.cout(),.ovf(),.ze(z2b),.R());
    ALU alu2b(.ctrl(3'b110), .A({26'b0, prev2[31:26]}),.B(32'b00000000000000000000000000101011),.shamt(5'b0),.cout(),.ovf(),.ze(z2c),.R());
    or3to1 orb(.w(z2a), .x(z2b), .y(z2c), .z(z2));

    mux_5 destb(.sel(z2), .src0(prev2[15:11]), .src1(prev2[20:16]), .z(dest2));

    ALU alu3b(.ctrl(3'b110), .A({26'b0, prev3[31:26]}),.B(32'b00000000000000000000000000001000),.shamt(5'b0),.cout(),.ovf(),.ze(z3a),.R());
    ALU alu3c(.ctrl(3'b110), .A({26'b0, prev3[31:26]}),.B(32'b00000000000000000000000000100011),.shamt(5'b0),.cout(),.ovf(),.ze(z3b),.R());
    ALU alu3d(.ctrl(3'b110), .A({26'b0, prev3[31:26]}),.B(32'b00000000000000000000000000101011),.shamt(5'b0),.cout(),.ovf(),.ze(z3c),.R());
    or3to1 orc(.w(z3a), .x(z3b), .y(z3c), .z(z3));

    mux_5 destc(.sel(z3), .src0(prev3[15:11]), .src1(prev3[20:16]), .z(dest3));

    // if any of the checks match a dest, set stall to 1
    ALU aluf1(.ctrl(3'b110), .A({27'b0, dest1}),.B({27'b0, checka}),.shamt(5'b0),.cout(),.ovf(),.ze(c1a),.R());
    ALU aluf2(.ctrl(3'b110), .A({27'b0, dest1}),.B({27'b0, checkb}),.shamt(5'b0),.cout(),.ovf(),.ze(c1b),.R());
    ALU aluf3(.ctrl(3'b110), .A({27'b0, dest2}),.B({27'b0, checka}),.shamt(5'b0),.cout(),.ovf(),.ze(c2a),.R());
    ALU aluf4(.ctrl(3'b110), .A({27'b0, dest2}),.B({27'b0, checkb}),.shamt(5'b0),.cout(),.ovf(),.ze(c2b),.R());
    ALU aluf5(.ctrl(3'b110), .A({27'b0, dest3}),.B({27'b0, checka}),.shamt(5'b0),.cout(),.ovf(),.ze(c3a),.R());
    ALU aluf7(.ctrl(3'b110), .A({27'b0, dest3}),.B({27'b0, checkb}),.shamt(5'b0),.cout(),.ovf(),.ze(c3b),.R());

    ALU alue1(.ctrl(3'b110), .A(prev1),.B(32'h00410020),.shamt(5'b0),.cout(),.ovf(),.ze(c1d1),.R());
    ALU alue2(.ctrl(3'b110), .A(prev2),.B(32'h00410020),.shamt(5'b0),.cout(),.ovf(),.ze(c2d1),.R());
    ALU alue3(.ctrl(3'b110), .A(prev3),.B(32'h00410020),.shamt(5'b0),.cout(),.ovf(),.ze(c3d1),.R());

    mux aha1(.sel(c1d1), .src0(1'b1), .src1(1'b0), .z(c1d));
    mux aha2(.sel(c2d1), .src0(1'b1), .src1(1'b0), .z(c2d));
    mux aha3(.sel(c3d1), .src0(1'b1), .src1(1'b0), .z(c3d));


    not_gate aha7(.x(c1c1), .z(c1c2));
    not_gate aha8(.x(c2c1), .z(c2c2));
    not_gate aha9(.x(c3c1), .z(c3c2));

    mux aha6(.sel(c1c2), .src0(1'b1), .src1(1'b0), .z(c1c));
    mux aha4(.sel(c2c2), .src0(1'b1), .src1(1'b0), .z(c2c));
    mux aha5(.sel(c3c2), .src0(1'b1), .src1(1'b0), .z(c3c));

    or_gate orf1(.x(c1a), .y(c1b), .z(c1c1));
    or_gate orf2(.x(c2a), .y(c2b), .z(c2c1));
    or_gate orf3(.x(c3a), .y(c3b), .z(c3c1));
    and_gate orf4(.x(c1c), .y(c1d), .z(c1e));
    and_gate orf5(.x(c2c), .y(c2d), .z(c2e));
    and_gate orf6(.x(c3c), .y(c3d), .z(c3e));

    or3to1 orf7(.w(c1e), .x(c2e), .y(c3e), .z(stall2));

    // set the stall to the ored stalls
    or_gate orlast(.x(stall1), .y(stall2), .z(stallf));

    assign stall = stallf;

endmodule