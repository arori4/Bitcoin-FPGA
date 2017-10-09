/*
 * control_write_end.sv
 * Controls the end of the round.
 */
import definitions::*;
module control_write_end (input logic [7:0] round,
						  input logic [1:0] opcode,
						  
						  output logic [1:0] decision );

always_comb begin

	if (round > 127) begin //negative safe comparison
		decision = WAIT;
	end
	else begin
		unique case (opcode)
		
			MD5: begin
				if (round == 4) begin
					decision = FINISH;
				end
				else begin
					decision = CONTINUE;
				end
			end
		
			SHA_1: begin
				if (round == 5) begin
					decision = FINISH;
				end
				else begin
					decision = CONTINUE;
				end
			end
		
			SHA_256: begin
				if (round == 8) begin
					decision = FINISH;
				end
				else begin
					decision = CONTINUE;
				end
			end
		
			2'b11: begin
				if (round == 8) begin
					decision = FINISH;
				end
				else begin
					decision = CONTINUE;
				end
			end
		endcase
	end
end

endmodule 