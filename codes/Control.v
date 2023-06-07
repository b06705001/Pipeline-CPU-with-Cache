
module Control 
(
	Op_i,
	NoOp_i,
	RegWrite_o,
	MemtoReg_o,
	MemRead_o,
	MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
	Branch_o
);

input [6:0] Op_i;
input NoOp_i;
output [2:0] ALUOp_o;
output RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUSrc_o, Branch_o;
reg [2:0] ALUOp;
reg RegWrite, MemtoReg, MemRead, MemWrite, ALUSrc, Branch;

/* implement here */
`define r 7'b0110011
`define i 7'b0010011
`define lw 7'b0000011
`define sw 7'b0100011
`define beq 7'b1100011

assign ALUOp_o = ALUOp[2:0];
assign RegWrite_o = RegWrite;
assign MemtoReg_o = MemtoReg;
assign MemRead_o = MemRead;
assign MemWrite_o = MemWrite;
assign ALUSrc_o = ALUSrc;
assign Branch_o = Branch;
always @ (* ) begin
	case (Op_i)
		`r:
		begin 
			ALUOp = 3'b000;
			RegWrite = 1'b1;
			MemtoReg = 1'b0;
			MemRead = 1'b0;
			MemWrite = 1'b0;
			ALUSrc = 1'b0;
			Branch = 1'b0;
		end
		`i:
		begin 
			ALUOp = 3'b001;
			RegWrite = 1'b1;
			MemtoReg = 1'b0;
			MemRead = 1'b0;
			MemWrite = 1'b0;
			ALUSrc = 1'b1;
			Branch = 1'b0;
		end
		`lw:
		begin
			ALUOp = 3'b010;
			RegWrite = 1'b1;
			MemtoReg = 1'b1;
			MemRead = 1'b1;
			MemWrite = 1'b0;
			ALUSrc = 1'b1;
			Branch = 1'b0;
		end
		`sw:
		begin
			ALUOp = 3'b011;
			RegWrite = 1'b0;
			MemtoReg = 1'b0;  // X
			MemRead = 1'b0;
			MemWrite = 1'b1;
			ALUSrc = 1'b1;
			Branch = 1'b0;
		end
		`beq:
		begin
			ALUOp = 3'b100;
			RegWrite = 1'b0;
			MemtoReg = 1'b0;  // X
			MemRead = 1'b0;
			MemWrite = 1'b0;
			ALUSrc = 1'b0;
			Branch = 1'b1;
		end
		default:begin
			ALUOp=3'b111;
			RegWrite = 1'b0;
			MemtoReg = 1'b0;  // X
			MemRead = 1'b0;
			MemWrite = 1'b0;
			ALUSrc = 1'b0;
			Branch = 1'b0;
		end
	endcase

	// Data hazard detection
	if(NoOp_i) begin
		RegWrite = 1'b0;
		MemWrite = 1'b0;
	end
end

endmodule
