module Forwarding(
    ID_EX_RS1_i,
    ID_EX_RS2_i,
    EX_MEM_RD_i,
    EX_MEM_RegWrite_i,
    MEM_WB_RD_i,
    MEM_WB_RegWrite_i,
    ForwardingA_o,
    ForwardingB_o
);

input [4:0] ID_EX_RS1_i, ID_EX_RS2_i, EX_MEM_RD_i, MEM_WB_RD_i;
input EX_MEM_RegWrite_i, MEM_WB_RegWrite_i;
output [1:0] ForwardingA_o, ForwardingB_o;

reg [1:0] tmpA, tmpB;
assign ForwardingA_o = tmpA;
assign ForwardingB_o = tmpB;

always @(*) begin
    
    tmpA = 2'b00;
    tmpB = 2'b00;

    if (EX_MEM_RegWrite_i == 1'b1 && EX_MEM_RD_i != 5'b0) begin
        if (ID_EX_RS1_i == EX_MEM_RD_i) begin
            tmpA = 2'b10;
        end
        if (ID_EX_RS2_i == EX_MEM_RD_i) begin
            tmpB = 2'b10;
        end
    end

    if (MEM_WB_RegWrite_i == 1'b1 && MEM_WB_RD_i != 5'b0) begin
        if (ID_EX_RS1_i == MEM_WB_RD_i && tmpA == 2'b00) begin
            tmpA = 2'b01;
        end
        if (ID_EX_RS2_i == MEM_WB_RD_i && tmpB == 2'b00) begin
            tmpB = 2'b01;
        end
    end
end

endmodule