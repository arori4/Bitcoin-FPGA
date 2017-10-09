/*
 * write_block.sv
 * Manages writes to memory
 */
import definitions::*;
module write_block(input logic[31:0] hash[0:7],
				   input logic[7:0] round,
				   input logic clk,
					
				   output logic[31:0] mem_write_data);
					
always_ff @(posedge clk) begin
	mem_write_data <= hash[round];
end

endmodule 