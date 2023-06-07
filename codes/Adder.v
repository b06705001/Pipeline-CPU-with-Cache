module Adder(
    data1_in   ,
    data2_in   ,
    data_o     
);
input signed [31:0] data1_in;
input signed [31:0] data2_in;
output [31:0] data_o;
reg [31:0] sum;
assign data_o = sum[31:0];

always @(*) begin
	sum=data1_in+data2_in;
end
endmodule