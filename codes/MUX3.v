module MUX3(
    data1_i,
    data2_i,
    data3_i,
    select_i,
    data_o     
);

input signed[31:0] data1_i, data2_i, data3_i;
input [1:0] select_i;
output signed [31:0] data_o;
reg signed [31:0] tmp;
assign data_o = tmp[31:0];

always @(*) begin
    case (select_i) 
        2'b00: tmp = data1_i;
        2'b01: tmp = data2_i;
        2'b10: tmp = data3_i;
    endcase
end

endmodule