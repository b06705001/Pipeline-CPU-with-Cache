module ALU(
    data1_i    ,
    data2_i    ,
    ALUCtrl_i  ,
    data_o     ,
    Zero_o     
);
input signed [31:0] data1_i, data2_i;
input [3:0] ALUCtrl_i;
output signed [31:0] data_o;
output Zero_o;
reg signed [31:0] tmp;
reg b;
assign Zero_o = b;
assign data_o = tmp;

`define AND 4'b0000
`define XOR 4'b0001
`define SLL 4'b0010
`define ADD 4'b0011
`define SUB 4'b0100
`define MUL 4'b0101
`define addi 4'b0110
`define srai 4'b0111
`define lw 4'b1000
`define sw  4'b1001
`define beq  4'b1010


always @(*) begin
	case (ALUCtrl_i) 
		`AND: tmp = data1_i & data2_i;
		`XOR: tmp = data1_i ^ data2_i;
		`SLL: tmp = data1_i << data2_i;
		`ADD: tmp = data1_i + data2_i;
		`SUB: tmp = data1_i - data2_i;
		`MUL: tmp = data1_i * data2_i;
		`addi: tmp = data1_i + data2_i;
		`srai: tmp = data1_i >>> data2_i[4:0];
		`lw: tmp = data1_i + data2_i;
		`sw: tmp = data1_i + data2_i;
		`beq: tmp = data1_i - data2_i;
	endcase

	if(tmp == 0)
	begin
		b=1'b1;
	end
	else begin
		b=1'b0;
	end
end
endmodule