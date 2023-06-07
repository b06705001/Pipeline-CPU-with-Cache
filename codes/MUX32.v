module MUX32(
    data1_i,
    data2_i,
    select_i,
    data_o     
);

input signed[31:0] data1_i, data2_i;
input select_i;
output signed [31:0] data_o;
reg signed [31:0] tmp;
assign data_o = tmp[31:0];

always @(data1_i or  data2_i or select_i) begin
	if (select_i) begin
		tmp = data2_i;		
	end
	else begin
		tmp = data1_i;
	end
end
endmodule