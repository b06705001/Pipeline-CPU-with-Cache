module CPU
(
    clk_i, 
    rst_i,
    start_i,
    mem_data_i, 
    mem_ack_i,     
    mem_data_o, 
    mem_addr_o,     
    mem_enable_o, 
    mem_write_o
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;
input [255:0]       mem_data_i;
input               mem_ack_i;
output [255:0]      mem_data_o;
output [31:0]       mem_addr_o;
output              mem_enable_o, mem_write_o;


wire [31:0] pc_current;  
wire signed[31:0] pc_next, pc4, pc_nextOrBranch;  
wire [31:0] instr;  
wire [31:0] num_4;
wire PCWrite, stall;
wire [31:0] Forwarding_data1, Forwarding_data2;
assign num_4 =  32'd4;



Adder Add_PC(
    .data1_in   (pc_current),
    .data2_in   (num_4),
    .data_o     (pc_next)
);


PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .stall_i    (stall),
    .PCWrite_i	(PCWrite),
    .pc_i       (pc_nextOrBranch),
    .pc_o       (pc_current)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (pc_current), 
    .instr_o    (instr)
);


wire [31:0] IF_ID_instr_o, IF_ID_pc_o;
wire IF_ID_Write, BeqCtrl;
IF_ID IF_ID(
    .instruction_in(instr),
    .IF_ID_Write_in(IF_ID_Write),
    .pcCurrent_in(pc_current),
    .isFlush_in(BeqCtrl),
    .Stall(stall),
    .instruction_out(IF_ID_instr_o),
    .pcCurrent_out(IF_ID_pc_o),
    .clk(clk_i),
    .reset(rst_i)
);



wire[6:0] opcode;
assign opcode = IF_ID_instr_o[6:0];
wire[2:0] ALUOP;
wire ALUSRC, RegWrite, MemtoReg, MemRead, MemWrite, Branch;
wire NoOp;
Control Control(
    .Op_i(opcode),
    .NoOp_i(NoOp),
    .ALUOp_o(ALUOP),
    .ALUSrc_o(ALUSRC),
    .RegWrite_o(RegWrite),
	.MemtoReg_o(MemtoReg),
	.MemRead_o(MemRead),
	.MemWrite_o(MemWrite),
	.Branch_o(Branch)
);
wire[9:0] funct;
assign funct = {IF_ID_instr_o[31:25], IF_ID_instr_o[14:12]}; 
wire[4:0] RS1addr;
assign  RS1addr = IF_ID_instr_o[19:15] ;
wire[4:0] RS2addr;
wire[4:0] RDaddr, MEM_WB_RDaddr;
wire[31:0] RDdata, MEM_WB_RDdata;
wire[31:0] data1;
wire[31:0] data2;
wire MEM_WB_RegWrite_o;
assign  RS2addr = IF_ID_instr_o[24:20] ;
assign  RDaddr = IF_ID_instr_o[11:7] ;

Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i   (RS1addr),
    .RS2addr_i   (RS2addr),
    .RDaddr_i   (MEM_WB_RDaddr), 
    .RDdata_i   (MEM_WB_RDdata),
    .RegWrite_i (MEM_WB_RegWrite_o), 
    .RS1data_o   (data1), 
    .RS2data_o   (data2) 
);

wire [31:0] imm;
wire [31:0] ex_imm;

assign imm = IF_ID_instr_o[31:0] ;
Sign_Extend Sign_Extend(
    .data_i     (imm),
    .data_o     (ex_imm)
);

wire[9:0] ID_EX_funct_o;
wire[4:0] ID_EX_RDaddr_o, ID_EX_RS1addr_o, ID_EX_RS2addr_o;
wire[31:0] ID_EX_RDdata_o;
wire[31:0] ID_EX_data1_o;
wire[31:0] ID_EX_data2_o;
wire[2:0] ID_EX_ALUOP_o;

wire [31:0] ID_EX_ex_imm_o;
wire ID_EX_ALUSRC_o, ID_EX_RegWrite_o, ID_EX_MemtoReg_o, ID_EX_MemRead_o, ID_EX_MemWrite_o, ID_EX_Branch_o;
ID_EX ID_EX(
    .RegWrite_i(RegWrite), 
    .MemtoReg_i(MemtoReg), 
    .MemRead_i(MemRead),
    .MemWrite_i(MemWrite), 
    .ALUOp_i(ALUOP),
    .ALUSrc_i(ALUSRC),
    .RS1data_i(data1),
    .RS2data_i(data2),
    .ex_imm_i(ex_imm),
    .func10_i(funct),
    .RDaddr_i(RDaddr),
    .RS1addr_i(RS1addr),
    .RS2addr_i(RS2addr),
    .Stall(stall),
    .clk(clk_i),
    .reset(rst_i),
    .RegWrite_o(ID_EX_RegWrite_o), 
    .MemtoReg_o(ID_EX_MemtoReg_o),
    .MemRead_o(ID_EX_MemRead_o), 
    .MemWrite_o(ID_EX_MemWrite_o),   
    .ALUOp_o(ID_EX_ALUOP_o), 
    .ALUSrc_o(ID_EX_ALUSRC_o), 
    .RS1data_o(ID_EX_data1_o), 
    .RS2data_o(ID_EX_data2_o), 
    .ex_imm_o(ID_EX_ex_imm_o),   
    .func10_o(ID_EX_funct_o),
    .RDaddr_o(ID_EX_RDaddr_o),
    .RS1addr_o(ID_EX_RS1addr_o),
    .RS2addr_o(ID_EX_RS2addr_o)
);


wire[3:0] ALUCtrl;
ALU_Control ALU_Control(
    .funct_i    (ID_EX_funct_o),
    .ALUOp_i    (ID_EX_ALUOP_o),
    .ALUCtrl_o  (ALUCtrl)
);
wire [31:0] real_data2;
MUX32 MUX_ALUSrc(
    .data1_i    (Forwarding_data2),
    .data2_i    (ID_EX_ex_imm_o),
    .select_i   (ID_EX_ALUSRC_o),
    .data_o     (real_data2)
);

wire Zero;
wire [31:0] ALU_result;

ALU ALU(
    .data1_i    (Forwarding_data1),
    .data2_i    (real_data2),
    .ALUCtrl_i  (ALUCtrl),
    .data_o     (ALU_result),
    .Zero_o     (Zero)
);

wire EX_MEM_RegWrite_o, EX_MEM_MemtoReg_o, EX_MEM_MemRead_o, EX_MEM_MemWrite_o, EX_MEM_Zero_o;
wire [31:0] EX_MEM_ALU_result_o, EX_MEM_data2_o;
wire [4:0] EX_MEM_RDaddr_o;
EX_MEM EX_MEM(
    .RegWrite_in(ID_EX_RegWrite_o), 
    .MemtoReg_in(ID_EX_MemtoReg_o), 
    .MemRead_in(ID_EX_MemRead_o),
    .MemWrite_in(ID_EX_MemWrite_o),
    .ALU_result_in(ALU_result),
    .ALU_zero_in(Zero),
    .reg_read_data_2_in(Forwarding_data2),   //***
    .RDaddr_in(ID_EX_RDaddr_o),
    .Stall(stall),
    .clk(clk_i), 
    .reset(rst_i),
    .RegWrite_out(EX_MEM_RegWrite_o), 
    .MemtoReg_out(EX_MEM_MemtoReg_o), 
    .MemRead_out(EX_MEM_MemRead_o),
    .MemWrite_out(EX_MEM_MemWrite_o),
    .ALU_result_out(EX_MEM_ALU_result_o),
    .ALU_zero_out(EX_MEM_Zero_o),
    .reg_read_data_2_out(EX_MEM_data2_o),
    .RDaddr_out(EX_MEM_RDaddr_o)
);

wire [31:0] MemReadData;
wire MEM_WB_MemtoReg_o;
wire [31:0] MEM_WB_MemReadData_o;
wire [31:0] MEM_WB_Readaddr_o;

MEM_WB MEM_WB(
    .RegWrite_in(EX_MEM_RegWrite_o), 
    .MemtoReg_in(EX_MEM_MemtoReg_o),
    .RegWrite_out(MEM_WB_RegWrite_o),
    .MemtoReg_out(MEM_WB_MemtoReg_o),
    .D_MEM_read_data_in(MemReadData),
    .D_MEM_read_addr_in(EX_MEM_ALU_result_o),
    .D_MEM_read_data_out(MEM_WB_MemReadData_o),
    .D_MEM_read_addr_out(MEM_WB_Readaddr_o),
    .RDaddr_in(EX_MEM_RDaddr_o),
    .RDaddr_out(MEM_WB_RDaddr),
    .Stall(stall),
    .clk(clk_i),
    .reset(rst_i)
);

MUX32 MUX_MemtoReg(
    .data1_i(MEM_WB_Readaddr_o),
    .data2_i(MEM_WB_MemReadData_o),
    .select_i(MEM_WB_MemtoReg_o),
    .data_o(MEM_WB_RDdata)
);


// Forwarding ------------------------------------------------------------
wire [1:0] ForwardingA_ctr, ForwardingB_ctr;
Forwarding Forwading(
    .ID_EX_RS1_i(ID_EX_RS1addr_o),
    .ID_EX_RS2_i(ID_EX_RS2addr_o),
    .EX_MEM_RD_i(EX_MEM_RDaddr_o),
    .EX_MEM_RegWrite_i(EX_MEM_RegWrite_o),
    .MEM_WB_RD_i(MEM_WB_RDaddr),
    .MEM_WB_RegWrite_i(MEM_WB_RegWrite_o),
    .ForwardingA_o(ForwardingA_ctr),
    .ForwardingB_o(ForwardingB_ctr)
);

MUX3 MUX_RS1(
    .data1_i(ID_EX_data1_o),
    .data2_i(MEM_WB_RDdata),
    .data3_i(EX_MEM_ALU_result_o),
    .select_i(ForwardingA_ctr),
    .data_o(Forwarding_data1)   
);

MUX3 MUX_RS2(
    .data1_i(ID_EX_data2_o),
    .data2_i(MEM_WB_RDdata),
    .data3_i(EX_MEM_ALU_result_o),
    .select_i(ForwardingB_ctr),
    .data_o(Forwarding_data2)   //***
);
// -----------------------------------------------------------------------

// Stall and Flush -------------------------------------------------------
HazardDetect HazardDetect(
    .ID_EX_RDaddr_i(ID_EX_RDaddr_o),
    .ID_EX_MemRead_i(ID_EX_MemRead_o),
    .IF_ID_RS1addr_i(RS1addr),
    .IF_ID_RS2addr_i(RS2addr),
    .IF_ID_Write_o(IF_ID_Write),
    .NoOp_o(NoOp),
    .PCWrite_o(PCWrite)
);

wire isEqual;
wire [31:0] Branch_imm, pc_branch;
Beq Beq(
    .RS1_data_i(data1),
    .RS2_data_i(data2),
    .isEqual_o(isEqual)
);

BeqCtrl BeqCtrlGate(
    .isEqual_i(isEqual),
    .isBranch_i(Branch),
    .BeqCtrl_o(BeqCtrl)
);

ShiftLeftOneBit ShiftLeftOneBit(
    .data_i(ex_imm),
    .data_o(Branch_imm)
);

Adder ADD_Branch(
    .data1_in(Branch_imm),
    .data2_in(IF_ID_pc_o),
    .data_o(pc_branch)    
);

MUX32 MUX_PC(
    .data1_i(pc_next),
    .data2_i(pc_branch),
    .select_i(BeqCtrl),
    .data_o(pc_nextOrBranch)
);
// -----------------------------------------------------------------------

// L1 cache --------------------------------------------------------------
dcache_controller dcache(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .mem_data_i(mem_data_i),
    .mem_ack_i(mem_ack_i),
    .mem_data_o(mem_data_o),
    .mem_addr_o(mem_addr_o),
    .mem_enable_o(mem_enable_o),
    .mem_write_o(mem_write_o),
    .cpu_data_i(EX_MEM_data2_o),
    .cpu_addr_i(EX_MEM_ALU_result_o),
    .cpu_MemRead_i(EX_MEM_MemRead_o),
    .cpu_MemWrite_i(EX_MEM_MemWrite_o),
    .cpu_data_o(MemReadData),
    .cpu_stall_o(stall)
);

    

endmodule

