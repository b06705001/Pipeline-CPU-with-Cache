module ALU_Control 
(
    funct_i    ,
    ALUOp_i    ,
    ALUCtrl_o  
);

input [9:0] funct_i;
input [2:0] ALUOp_i;
output [3:0] ALUCtrl_o;
reg   [3:0] ALUCtrl;
assign ALUCtrl_o = ALUCtrl[3:0];

`define AND 10'b0000000111
`define XOR 10'b0000000100
`define SLL 10'b0000000001
`define ADD 10'b0000000000
`define SUB 10'b0100000000
`define MUL 10'b0000001000
`define R 3'b000
`define I 3'b001
`define LW 3'b010
`define SW 3'b011
`define BEQ 3'b100

always @(funct_i or  ALUOp_i)
begin
	case(ALUOp_i)
		`R:
		begin
			case (funct_i) 
				`AND: ALUCtrl = 4'b0000;
				`XOR: ALUCtrl = 4'b0001;
				`SLL: ALUCtrl = 4'b0010;
				`ADD: ALUCtrl = 4'b0011;
				`SUB: ALUCtrl = 4'b0100;
				`MUL: ALUCtrl = 4'b0101;
			endcase
		end

		`I:
		begin
			case (funct_i[2:0])
				3'b000: ALUCtrl = 4'b0110;		//addi
				3'b101: ALUCtrl = 4'b0111;		//srai
			endcase
		end
		
		`LW: ALUCtrl = 4'b1000;
		`SW: ALUCtrl = 4'b1001;
		`BEQ: ALUCtrl = 4'b1010;
		default: ALUCtrl = 4'b1111;
	endcase
end

endmodule
