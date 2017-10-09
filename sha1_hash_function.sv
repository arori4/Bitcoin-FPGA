/*
 * sha1_hash_function.sv
 * Defines the hash function for sha1
 * 1 round pipelined
 */
import definitions::*;
module sha1_hash_function (input logic [31:0] a, b, c, d, e, wk, f_in, n_in,
						   input logic [1:0] quad_funct,
						   input logic [1:0] round_type,
						  
						   output logic [31:0] inter_out[0:7], temp_out[0:2] );

function logic [31:0] hash_step (input logic [31:0] b, c, d,
								 input logic [1:0] quad_funct );
	unique case(quad_funct)
		2'b00: begin
			return (b & c) | ((~b) & d);
		end
		2'b01: begin
			return b ^ c ^ d;
		end
		2'b10: begin
			return (b & c) | (b & d) | (c & d);
		end
		2'b11: begin
			return b ^ c ^ d;
		end
	endcase

endfunction

always_comb begin

	unique case (round_type)
		PRECOMPUTE: begin
			inter_out[0] = a;
			inter_out[1] = a;
			inter_out[2] = {b[1:0], b[31:2]};
			inter_out[3] = c;
			inter_out[4] = d;
		end
		KERNEL: begin
			inter_out[0] = a;
			inter_out[1] = {b[26:0], b[31:27]} + f_in + n_in;
			inter_out[2] = {b[1:0], b[31:2]};
			inter_out[3] = c;
			inter_out[4] = d;
		end
		EPILOGUE: begin
			inter_out[0] = {b[26:0], b[31:27]} + f_in + n_in;
			inter_out[1] = b;
			inter_out[2] = c;
			inter_out[3] = d;
			inter_out[4] = e;
		end
		CHUNK_DONE: begin
			inter_out[0] = {b[26:0], b[31:27]} + f_in + n_in;
			inter_out[1] = b;
			inter_out[2] = c;
			inter_out[3] = d;
			inter_out[4] = e;
		end
	endcase 
	
	inter_out[5] = 32'b0;
	inter_out[6] = 32'b0;
	inter_out[7] = 32'b0;
	temp_out[0] = hash_step (b, c, d, quad_funct);
	temp_out[1] = e + wk;
	temp_out[2] = 32'b0;
	
end

endmodule 