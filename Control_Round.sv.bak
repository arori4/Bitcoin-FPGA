/*
 * control_block_end.sv
 * Controls what to do during the round
 */
import definitions::*;
module control_round (input logic [7:0] round,
					  input logic [1:0] opcode,
					  input logic chunk_start,
						  
					  output logic [1:0] decision );

always_comb begin

	automatic logic[7:0] threshold;

	unique case (opcode)
		MD5: begin
			threshold = 63;
		end
		
		SHA_1: begin
			threshold = 79;
		end
		
		SHA_256: begin
			threshold = 63;
		end
		
		OPCODE_RESERVE: begin
			threshold = 63;
		end
	endcase
		
	if (chunk_start) begin
		decision = PRECOMPUTE;
	end
	else if (round < threshold) begin
		decision = KERNEL;
	end
	else if  (round < threshold + 8'd1) begin
		decision = EPILOGUE;
	end
	else begin
		decision = CHUNK_DONE;
	end
	
end

endmodule 