module Beq(
    RS1_data_i,
    RS2_data_i,
    isEqual_o
);

input [31:0] RS1_data_i, RS2_data_i;
output isEqual_o;

assign isEqual_o = (RS1_data_i == RS2_data_i)? 1 : 0;

endmodule