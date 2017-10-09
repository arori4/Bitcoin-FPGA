
import definitions::*;
module control_read_assign (input logic [31:0] size,
							input logic [15:0] num_blocks, wordread, mem_address,
							input logic [7:0] chunk, round, md5_log_in, 
							input logic [1:0] opcode,
							
							output logic[3:0] decision );
always_comb begin

	automatic logic[15:0] difference = 32'b0;
	
	if (opcode == MD5) begin
		difference = size[15:0] - mem_address;
	end
	else begin
		difference = size[15:0] - wordread;
	end
	
	unique case(difference)
		
		16'd3: begin
			decision = 4'd0;
		end
		16'd2: begin
			decision = 4'd1;
		end
		16'd1: begin
			decision = 4'd2;
		end
		16'd0: begin
			decision = 4'd3;
		end
		default: begin
			//final condition
			if (( (chunk == num_blocks[7:0] - 1) && (round == 8'd14))) begin
				decision = 4'd4;
			end
			else if (opcode == MD5 && chunk == num_blocks[7:0] - 1 && md5_log_in == 8'd15) begin
				decision = 4'd4;
			end
			//sha1 new block result
			else if (opcode != MD5 && round > 14) begin
				decision = {2'b11, opcode};
			end
			//padding. compare to a size in the negatives
			else if (difference >= 16'h8000) begin
				decision = 4'd5;
			end
			//read
			else begin
				decision = 4'd6;
			end
		end
	endcase
	
end

endmodule 