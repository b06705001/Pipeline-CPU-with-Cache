
module Sign_Extend(
    data_i,
    data_o     
);

input[31:0] data_i;
output[31:0] data_o;
wire [6:0] opcode;
assign opcode = data_i[6:0];
`define sw 7'b0100011
`define beq 7'b1100011
reg [31:0] out;
assign data_o = out;
always @(*) begin
	case (opcode)
	    `sw:  out <= {{20{data_i[31]}}, data_i[31:25], data_i[11:7]};
	    `beq:  out <= {{21{data_i[31]}}, data_i[7], data_i[30:25], data_i[11:8]};
	    default:  out <= {{20{data_i[31]}}, data_i[31:20]};

	endcase
end

endmodule
