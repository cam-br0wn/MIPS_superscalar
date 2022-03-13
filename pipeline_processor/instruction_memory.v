module instruction_memory (in, src1, src2, dest, op, func, imm);
  
    input [31:0] in;
    output reg [4:0] src1;
    output reg [4:0] src2;
    output reg [4:0] dest;
    output reg [5:0] op;
    output reg [5:0] func;
    output reg [15:0] imm;
  

    always @ in
        begin

            // the opcode is the top 6 bits
            assign op = in[31:26];
            // func is bottom 5
            assign func = in[5:0];
            

            // ADD, SUB, AND, OR, SLL, SLT
            if (op == 000000) begin

                // SLL
                if (func == 000000) begin
                    assign src1 = in[20:16];
                    assign src2 = in[10:6];
                    assign dest = in[15:11];
                end

                // ADD, SUB, AND, OR, SLT
                else begin
                    assign src1 = in[25:21];
                    assign src2 = in[20:16];
                    assign dest = in[15:11];
                end 
                
                assign src1 = in[25:21];
                assign dest = in[20:16];
                assign imm = in[15:0];

            end

            // LW, SW, ADDI, BNE, BEQ
            else begin
                
                assign src1 = in[25:21];
                assign dest = in[20:16];
                assign imm = in[15:0];
                
            end
        end
   
endmodule