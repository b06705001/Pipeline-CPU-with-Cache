module ID_EX(
    RegWrite_i, 
    MemtoReg_i, 
    MemRead_i, 
    MemWrite_i, 
    ALUOp_i,
    ALUSrc_i,
    RS1data_i,
    RS2data_i,
    ex_imm_i,
    func10_i,
    RDaddr_i,
	RS1addr_i,
	RS2addr_i,
	Stall,  // If 0, stall the pipeline.
    clk,
    reset,
    RegWrite_o, 
    MemtoReg_o,
    MemRead_o, 
    MemWrite_o,   
    ALUOp_o, 
    ALUSrc_o, 
    RS1data_o, 
    RS2data_o, 
    ex_imm_o,   
    func10_o,
    RDaddr_o,
	RS1addr_o,
	RS2addr_o
);
	// 2. WB control signal
	input RegWrite_i, MemtoReg_i;
	output RegWrite_o, MemtoReg_o;
	// 3. MEM control signal
	input  MemRead_i, MemWrite_i;
	output  MemRead_o, MemWrite_o;
	// 4. EX control signal
	input ALUSrc_i;
	input [4:0] RDaddr_i, RS1addr_i, RS2addr_i;
	input [2:0] ALUOp_i;
	output ALUSrc_o;
	output [4:0] RDaddr_o, RS1addr_o, RS2addr_o;
	output [2:0] ALUOp_o;
	// 6. data content
	input [31:0] RS1data_i, RS2data_i, ex_imm_i;
	output [31:0] RS1data_o, RS2data_o, ex_imm_o;
	// 7. reg content
	input [9:0] func10_i;
	output [9:0] func10_o;
	// general signal
	// reset: async; set all register content to 0
	input clk, reset, Stall;
	
	reg RegWrite_o, MemtoReg_o;
	reg MemRead_o, MemWrite_o;
	reg ALUSrc_o;
	reg [4:0] RDaddr_o, RS1addr_o, RS2addr_o;
	reg [2:0] ALUOp_o;
	reg [31:0] RS1data_o, RS2data_o, ex_imm_o;
	reg [9:0] func10_o;
	
	always @(posedge clk or posedge reset)
	begin
		if (reset == 1'b1)
		begin
			RegWrite_o <= 1'b0;
			MemtoReg_o <= 1'b0;
			MemRead_o <= 1'b0;
			MemWrite_o <= 1'b0;
			ALUSrc_o <= 1'b0;
			ALUOp_o <= 3'b0;
			RS1data_o <= 32'b0;
			RS2data_o <= 32'b0;
			ex_imm_o <= 32'b0;
			func10_o <= 10'b0;
			RDaddr_o <= 5'b0;
			RS1addr_o <= 5'b0;
			RS1addr_o <= 5'b0;		
		end
		else if (!Stall) begin
			RegWrite_o <= RegWrite_i;
			MemtoReg_o <= MemtoReg_i;
			MemRead_o <= MemRead_i;
			MemWrite_o <= MemWrite_i;
			ALUSrc_o <= ALUSrc_i;
			ALUOp_o <= ALUOp_i;
			RS1data_o <= RS1data_i;
			RS2data_o <= RS2data_i;
			ex_imm_o <= ex_imm_i;
			func10_o <= func10_i;
			RDaddr_o <= RDaddr_i;
			RS1addr_o <= RS1addr_i;
			RS2addr_o <= RS2addr_i;
		end	
		
	end	
	
endmodule