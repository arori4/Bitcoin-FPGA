/*
 * control_hash_quad.sv
 * Controls the function the hashing algorithm runs
 */
import definitions::*;
module control_hash_quad (input logic [7:0] round,
						  input logic [1:0] opcode,
						  
						  output logic [1:0] decision );

always_comb begin

	automatic logic [7:0] one, two, three;

	//set comparison numbers based on opcode
	unique case (opcode)
		MD5: begin
			one = 15;
			two = 31;
			three = 47;
		end
		
		SHA_1: begin
			one = 19;
			two = 39;
			three = 59;
		end
		
		SHA_256: begin
			one = 15;
			two = 31;
			three = 47;
		end
		
		OPCODE_RESERVE: begin
			one = 15;
			two = 31;
			three = 47;
		end
	endcase

	//set decider based on round
	if (round < one) begin
		decision = 2'd0;
	end
	else if (round < two) begin
		decision = 2'd1;		
	end
	else if (round < three) begin
		decision = 2'd2;		
	end
	else begin
		decision = 2'd3;		
	end
		
end
endmodule 