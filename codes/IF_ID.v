module IF_ID(
    instruction_in,
	IF_ID_Write_in,  // If 0, stall the pipeline.
	pcCurrent_in,
	isFlush_in,
	Stall,
    instruction_out,
	pcCurrent_out,
    clk,
    reset
);
	
    
    
    // 1. data content
	input [31:0] instruction_in, pcCurrent_in;
	input IF_ID_Write_in, isFlush_in, Stall, clk, reset;
	output [31:0] instruction_out, pcCurrent_out;

	reg [31:0] instruction_out, pcCurrent_out;


	always @(posedge clk or posedge reset)
	begin
		if (reset == 1'b1 || isFlush_in == 1'b1)
		begin
			instruction_out <= 32'b0;
			pcCurrent_out <= 32'b0;
		end
		else if (IF_ID_Write_in && !Stall) begin
			instruction_out <= instruction_in;
			pcCurrent_out <= pcCurrent_in;
		end

	end
	
endmodule