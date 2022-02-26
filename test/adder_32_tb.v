module adder_32_tb;

    // Inputs
    reg [31:0] a;
    reg [31:0] b;

    // Outputs
    wire [31:0] q;

    // Instantiate the Unit Under Test (UUT)
    adder_32 uut (
        .a(a), 
        .b(b), 
        .q(q)
    );

    initial begin
        $dumpfile("adder_32_tb.vcd");
        $dumpvars(0,adder_32_tb);
        // Initialize Inputs
        #5
        a = 1209;
        b = 4565;
        #5;
        // Add stimulus here
    end
      
endmodule