/*
 * delay_block.sv
 * Delays provided signals by 1 clock cycle.
 * Multiple can be chained at the top level for multiple cycles of delay.
 */
import definitions::*;
module delay_block (input logic [7:0] round_in,
					input logic clk, reset_en, 
					input c_memory_struct c_memory_in,
					input c_hash_struct c_hash_in,
					
					output logic [7:0] round_out,
					output c_hash_struct c_hash_out,
					output c_memory_struct c_memory_out );
					
always_ff @(posedge clk) begin

	if (!reset_en) begin
		round_out <= 0;
		c_memory_out <= '{default: '0};
		c_hash_out <= '{default: '0};
	end
	
	round_out <= round_in;
	c_memory_out <= c_memory_in;
	c_hash_out <= c_hash_in;

end

endmodule 