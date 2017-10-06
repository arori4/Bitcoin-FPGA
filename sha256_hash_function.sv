/*
 * sha256_hash_function.sv
 * Hash function for sha256 algorithm
 */
import definitions::*;
module sha256_hash_function (input logic [31:0] a, b, c, d, e, f, g, h, wk, t0_in, t1_in, t2_in,
							 input logic [7:0] round,
						     input logic [1:0] round_type,
						  
						     output logic [31:0] inter_out[0:7], temp_out[0:2] );	


function logic [31:0] hash_op_t1 (input logic [31:0] e, f, g );
	automatic logic[31:0] s1, ch;
	s1 = {e[5:0], e[31:6]} ^ {e[10:0], e[31:11]} ^ {e[24:0], e[31:25]};
	ch = (e & f) | ((~e) & g); //original was xor, not or
	return s1 + ch;
endfunction 			
	
	
function logic [31:0] hash_op_t2 (input logic [31:0] a, b, c );
	automatic logic [31:0] s0, maj;
	s0 = {a[1:0], a[31:2]} ^ {a[12:0], a[31:13]} ^ {a[21:0], a[31:22]};
	maj = (a & b) ^ (a & c) ^ (b & c);
	return s0 + maj;
endfunction


always_comb begin

	automatic logic [31:0] t1_sum, new_a;
	t1_sum = t0_in + t1_in;
	new_a = t1_sum + t2_in;

	unique case (round_type)
		PRECOMPUTE: begin
			inter_out[0] = new_a;
			inter_out[1] = new_a;
			inter_out[2] = b;
			inter_out[3] = c;
			inter_out[4] = d;
			inter_out[5] = e;
			inter_out[6] = f;
			inter_out[7] = g;
		end
		KERNEL: begin
			inter_out[0] = new_a;
			inter_out[1] = new_a;
			inter_out[2] = b;
			inter_out[3] = c;
			inter_out[4] = d; //intentional
			inter_out[5] = e + t1_sum;
			inter_out[6] = f;
			inter_out[7] = g;
		end
		EPILOGUE: begin
			inter_out[0] = new_a;
			inter_out[1] = b;
			inter_out[2] = c;
			inter_out[3] = d;
			inter_out[4] = e + t1_sum;
			inter_out[5] = f;
			inter_out[6] = g;
			inter_out[7] = h;
		end
		CHUNK_DONE: begin
			inter_out[0] = a;
			inter_out[1] = b;
			inter_out[2] = c;
			inter_out[3] = d;
			inter_out[4] = e;
			inter_out[5] = f;
			inter_out[6] = g;
			inter_out[7] = h;
		end
	endcase 
	
	temp_out[0] = h + wk;
	temp_out[1] = hash_op_t1 (e + t1_sum, f, g);
	temp_out[2] = hash_op_t2(new_a, b, c);
	
end

endmodule 