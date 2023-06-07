module BeqCtrl(
    isEqual_i,
    isBranch_i,
    BeqCtrl_o
);

input isEqual_i, isBranch_i;
output BeqCtrl_o;

assign BeqCtrl_o = (isEqual_i == 1 && isBranch_i == 1)? 1 : 0;

endmodule
