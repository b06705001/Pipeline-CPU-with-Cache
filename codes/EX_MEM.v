module EX_MEM(
    RegWrite_in, 
    MemtoReg_in, 
    MemRead_in,
    MemWrite_in,
    ALU_result_in,
    ALU_zero_in,
    reg_read_data_2_in,
    RDaddr_in,
	Stall,  // If 0, stall the pipeline.
    clk, 
    reset,
    RegWrite_out, 
    MemtoReg_out, 
    MemRead_out,
    MemWrite_out,
    ALU_result_out,
    ALU_zero_out,
    reg_read_data_2_out,
    RDaddr_out
);
	// 2. WB control signal
	input RegWrite_in, MemtoReg_in;
	output RegWrite_out, MemtoReg_out;
	// 3. MEM control signal
	input MemRead_in, MemWrite_in;
	output MemRead_out, MemWrite_out;
	// 5. data content
	input ALU_zero_in;
	output ALU_zero_out;
	input [31:0] ALU_result_in, reg_read_data_2_in;
	output [31:0] ALU_result_out, reg_read_data_2_out;
    input [4:0] RDaddr_in;
    output [4:0] RDaddr_out;
	// general signal
	// reset: async; set all register content to 0
	input Stall, clk, reset;

	reg RegWrite_out, MemtoReg_out;
	reg MemRead_out, MemWrite_out;
	reg ALU_zero_out;
	reg [31:0] ALU_result_out, reg_read_data_2_out;
	reg [4:0] RDaddr_out;

	always @(posedge clk or posedge reset)
	begin
		if (reset == 1'b1)
		begin
		  RegWrite_out <= 1'b0;
		  MemtoReg_out <= 1'b0;
		  MemRead_out <= 1'b0;
		  MemWrite_out <= 1'b0;
		  ALU_zero_out <= 1'b0;
		  ALU_result_out <= 32'b0;
		  reg_read_data_2_out <= 32'b0;
		  RDaddr_out <= 5'b0; 
		end
		else if (!Stall) begin
		  RegWrite_out <= RegWrite_in;
		  MemtoReg_out <= MemtoReg_in;
		  MemRead_out <= MemRead_in;
		  MemWrite_out <= MemWrite_in;
		  ALU_zero_out <= ALU_zero_in;
		  ALU_result_out <= ALU_result_in;
		  reg_read_data_2_out <= reg_read_data_2_in;
		  RDaddr_out <= RDaddr_in;
		end

	end

endmodule
