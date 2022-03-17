`timescale 1ns/10ps

module superscalar_decode_hazard (global_seq_num, alpha_in, beta_in, gamma_in, A_reg_arr, B_reg_arr, C_reg_arr, A_stall, B_stall, C_stall);

    input [15:0] global_seq_num;

    input A_reg_arr [14:0]; // {dest} {src1} {src2}
    input B_reg_arr [14:0]; // {dest} {src1} {src2}
    input C_reg_arr [9:0];  // {dest} {base}

    wire [4:0] A_dest = A_reg_arr[14:10];
    wire [4:0] A_src1 = A_reg_arr[9:5];
    wire [4:0] A_src2 = A_reg_arr[4:0];

    wire [4:0] B_dest = B_reg_arr[14:10];
    wire [4:0] B_src1 = B_reg_arr[9:5];
    wire [4:0] B_src2 = B_reg_arr[4:0];

    wire [4:0] C_dest = C_reg_arr[9:5];
    wire [4:0] C_base = C_reg_arr[4:0];

    // input from IF/ID register for each pipeline
    // note that any of these can be any instruction
    input [31:0] alpha_in;
    input [31:0] beta_in;
    input [31:0] gamma_in;

    // ALU pipeline
    wire [4:0] A_src1;
    wire [4:0] A_src2;
    wire [4:0] A_dest;

    // ALU pipeline
    wire [4:0] B_src1;
    wire [4:0] B_src2;
    wire [4:0] B_dest;

    // Memory pipeline (lw, sw)
    wire [4:0] C_base;
    wire [4:0] C_dest;
    wire [4:0] C_offset;

    // stall = 1: stall otherwise do not stall
    // effect of stall is to send NOP (0x0000) to pipeline
    output A_stall;
    output B_stall;
    output C_stall;

    integer A_seq_num;
    integer B_seq_num;
    integer C_seq_num;

    // tgt_1 depends on tgt_0, src1_0, src2_0
    // src1_1 depends on tgt_0
    // src2_1 depends on tgt_0

    // tgt_2 depends on tgt_0, src1_0, src2_0, tgt_1, src1_1, src2_1
    // src1_2 depends on tgt_0, tgt_1
    // src2_2 depends on tgt_0, tgt_1

    always @ ((alpha_in) or (beta_in) or (gamma_in)) begin
        (C_seq_num > B_seq_num and C_seq_num < A_seq_num) ALU operations
        // Pipeline C handles memory operations

        // if the input is from port alpha
        if (alpha_in) begin
            
            // if the opcode of alpha_in is a load or store opcode
            if ((alpha_in[31:27] == 5'b100011) or (alpha_in[31:27] == 5'101011)) begin

                wire alpha_base = alpha_in[25:21];
                wire alpha_dest = alpha_in[20:16];

                // assign a sequence number to the incoming instruction
                global_seq_num = global_seq_num + 1;
                C_seq_num = global_seq_num;
                
                // first check to see if there's collision within the current instructions loaded in the decoder itself
                // handle if it's the second instruction first
                if((C_seq_num < B_seq_num) and (C_seq_num > A_seq_num)) begin
                    
                    if ((alpha_dest == A_dest) or (alpha_dest == A_src1) or (alpha_dest == A_src2) or (alpha_base == A_dest)) begin
                        
                        // issue a 2 cycle stall
                        C_stall = 2;

                    end

                end 
                else if ((C_seq_num > B_seq_num) and (C_seq_num < A_seq_num)) begin
                    
                end

                // now check to see if there's conflicts with anything currently in the other pipelines
                // need to check against A_reg_arr and B_reg_arr since those are the ALU pipelines
                if () begin
                    ;
                end

            end

            else begin
                
            end

        end

    end

endmodule