/*
 * md5_hash_function.sv
 * Hash function for md5
 */
 
import definitions::*;
module md5_hash_function (input logic [31:0] a, b, c, d, wk, f_in, n_in, s_in,
						  input logic [7:0] round,
						  input logic [1:0] quad_funct,
						  input logic [1:0] round_type,
						  
						  output logic [31:0] inter_out[0:7], temp_out[0:2] );


function logic [31:0] rotate (input logic [31:0] in,
							  input logic [31:0] index );
			
	unique case (index[3:0])
		4'd0: begin
			return {in[24:0], in[31:25]};
		end
		4'd1: begin
			return {in[19:0], in[31:20]};
		end
		4'd2: begin
			return {in[14:0], in[31:15]};		
		end
		4'd3: begin
			return {in[9:0], in[31:10]};		
		end
		
		4'd4: begin
			return {in[26:0], in[31:27]};		
		end
		4'd5: begin
			return {in[22:0], in[31:23]};		
		end
		4'd6: begin
			return {in[17:0], in[31:18]};		
		end
		4'd7: begin
			return {in[11:0], in[31:12]};		
		end
		
		4'd8: begin
			return {in[27:0], in[31:28]};		
		end
		4'd9: begin
			return {in[20:0], in[31:21]};		
		end
		4'd10: begin
			return {in[15:0], in[31:16]};		
		end
		4'd11: begin
			return {in[8:0], in[31:9]};		
		end
		
		4'd12: begin
			return {in[25:0], in[31:26]};		
		end
		4'd13: begin
			return {in[21:0], in[31:22]};		
		end
		4'd14: begin
			return {in[16:0], in[31:17]};		
		end
		4'd15: begin
			return {in[10:0], in[31:11]};		
		end
	endcase
endfunction 


function logic [31:0] hash_step (input logic [31:0] b, c, d,
								 input logic [1:0] quad_funct );
	unique case(quad_funct)
		2'b00: begin
			return (b & c) | ((~b) & d);
		end
		2'b01: begin
			return (d & b) | ((~d) & c);
		end
		2'b10: begin
			return b ^ c ^ d;
		end
		2'b11: begin
			return c ^ (b | (~d));
		end
	endcase
endfunction


always_comb begin

	//f_in, n_in, are 0 to begin with in round 0. BIG simplification
	automatic logic [31:0] x = b + rotate(f_in + n_in, s_in);

	unique case (round_type)
		PRECOMPUTE: begin
			inter_out[0] = d;
			inter_out[1] = x;
			inter_out[2] = x;
			inter_out[3] = c;
		end
		KERNEL: begin
			inter_out[0] = d;
			inter_out[1] = x;
			inter_out[2] = x;
			inter_out[3] = c;
		end
		EPILOGUE: begin
			inter_out[0] = a;
			inter_out[1] = x;
			inter_out[2] = c;
			inter_out[3] = d;
		end
		CHUNK_DONE: begin
			inter_out[0] = a;
			inter_out[1] = b;
			inter_out[2] = c;
			inter_out[3] = d;
		end
	endcase 
			
	inter_out[4] = 32'b0;
	inter_out[5] = 32'b0;
	inter_out[6] = 32'b0;
	inter_out[7] = 32'b0;
	temp_out[0] = hash_step (x, c, d, quad_funct);
	temp_out[1] = a + wk;
	temp_out[2] = {28'd0, round[5:4], round[1:0]};
end

endmodule 