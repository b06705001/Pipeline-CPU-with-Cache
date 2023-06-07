module HazardDetect(
    ID_EX_RDaddr_i,
    ID_EX_MemRead_i,
    IF_ID_RS1addr_i,
    IF_ID_RS2addr_i,
    IF_ID_Write_o,
    NoOp_o,
    PCWrite_o
);

input [4:0] ID_EX_RDaddr_i, IF_ID_RS1addr_i, IF_ID_RS2addr_i;
input ID_EX_MemRead_i;
output IF_ID_Write_o, NoOp_o, PCWrite_o;

reg IF_ID_Write, NoOp, PCWrite;
assign IF_ID_Write_o = IF_ID_Write;
assign NoOp_o = NoOp;
assign PCWrite_o = PCWrite;

always @(*) begin
    IF_ID_Write = 1'b1;
    NoOp = 1'b0;
    PCWrite = 1'b1;

    if(ID_EX_MemRead_i && 
      (ID_EX_RDaddr_i == IF_ID_RS1addr_i || ID_EX_RDaddr_i == IF_ID_RS2addr_i)) begin
          IF_ID_Write = 1'b0;
          NoOp = 1'b1;
          PCWrite = 1'b0;
      end
end

endmodule