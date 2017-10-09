/* control_block.sv
 *
 * Plan:
 * 	Round 0 - Prep
 *		Round 1 to 64 - Hash Step 1
 *		Round 65 - Write Step 1
 * 	Round 66 to 130 - Hash Step 2
 *		Round 131 - Verify
 */

module control_block(
	input 
	input start;
	input clk;
	
	output c_read;
	output [2:0] c_hash_function;
);


always_ff@(posedge clk) begin

	// round check
	if (round > 64) begin
		round = 8'b1;
		start = 1;
	end
	else begin
		round = round + 8'b1;
		start = 0;
	end
	
	// hash function commands
	if (round < 16) begin
		decision = 2'd0;
	end
	else if (round < 32) begin
		decision = 2'd1;		
	end
	else if (round < 48) begin
		decision = 2'd2;		
	end
	else begin
		decision = 2'd3;		
	end
	


end



endmodule 