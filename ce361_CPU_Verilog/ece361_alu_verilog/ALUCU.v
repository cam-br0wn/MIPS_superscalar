module ALUCU(ALUOp, func, ALUCtr);
    
    input [2:0] ALUOp;
    input [5:0] func;
    output wire [2:0] ALUCtr;
    
    wire [2:0] ALUCtr_temp;
    wire [2:0] ALUCtr_sll;
    wire [2:0] ALUCtr_adu;
    wire [2:0] ALUCtemp;
    wire [2:0] ALUCtremp;
    wire Ffunc;
    wire self;
    
    assign Ffunc = (func[5] || func[4] || func[3] || func[2] || func[1] || func[0] || (~ALUOp[2]));
    
    assign ALUCtr_sll = 3'b101;
    
    assign self = (func[5] && (~func[4]) && (~func[3]) && (~func[2]) && (~func[1]) && func[0] && ALUOp[2]);
    
    assign ALUCtr_adu = 3'b010;
    
    
    assign ALUCtr_temp[2] = (((~ALUOp[2]) && ALUOp[0]) || (ALUOp[2] && (~func[2]) && func[1] && (~func[0])));
    assign ALUCtr_temp[1] = (((~ALUOp[2]) && (~(ALUOp[1] && ALUOp[0]))) | (ALUOp[2] && (~func[2]) & (~func[0]))); 
    assign ALUCtr_temp[0] = ((ALUOp[2] && (~func[3]) && func[2] && (~func[1]) && func[0]) || (ALUOp[2] && func[3] && (~func[2]) && func[1] && (~func[0])));
    
    mux_n #(.n(3)) mux_map_0(.sel(Ffunc), .src0(ALUCtr_sll), .src1(ALUCtr_temp), .z(ALUCtremp));
    mux_n #(.n(3)) mux_map_1(.sel(self), .src0(ALUCtremp), .src1(ALUCtr_adu), .z(ALUCtr));
    
endmodule
    
    
    
