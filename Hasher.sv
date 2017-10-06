
module Hasher(
  input [15:0] version;
  input [255:0] previousBlock;
  input [255:0] mrkl_root;
  input [63:0] time_;
  input [63:0] bits;
  input clk;
					
  output logic [7:0] out,		  // or:  output reg [7:0] out,
  output logic [7:0] out_overflow,	  // shift out/carry out to register 13
  output logic branch_decision
  );
	  
logic [255:0] nonce;
logic [63:0] exp_;
logic [63:0] mant;
logic [63:0] target_hexstr;
logic [31:0] intermediate_vals[0:7], 
logic [31:0] temporary_vals[0:2]; //real registers
logic [31:0] sha256_hash_result[0:7];
logic [31:0] sha256_temp_result[0:2];

parameter int sha256_k[0:63] = '{
	32'h428a2f98, 32'h71374491, 32'hb5c0fbcf, 32'he9b5dba5, 32'h3956c25b, 32'h59f111f1, 32'h923f82a4, 32'hab1c5ed5,
	32'hd807aa98, 32'h12835b01, 32'h243185be, 32'h550c7dc3, 32'h72be5d74, 32'h80deb1fe, 32'h9bdc06a7, 32'hc19bf174,
	32'he49b69c1, 32'hefbe4786, 32'h0fc19dc6, 32'h240ca1cc, 32'h2de92c6f, 32'h4a7484aa, 32'h5cb0a9dc, 32'h76f988da,
	32'h983e5152, 32'ha831c66d, 32'hb00327c8, 32'hbf597fc7, 32'hc6e00bf3, 32'hd5a79147, 32'h06ca6351, 32'h14292967,
	32'h27b70a85, 32'h2e1b2138, 32'h4d2c6dfc, 32'h53380d13, 32'h650a7354, 32'h766a0abb, 32'h81c2c92e, 32'h92722c85,
	32'ha2bfe8a1, 32'ha81a664b, 32'hc24b8b70, 32'hc76c51a3, 32'hd192e819, 32'hd6990624, 32'hf40e3585, 32'h106aa070,
	32'h19a4c116, 32'h1e376c08, 32'h2748774c, 32'h34b0bcb5, 32'h391c0cb3, 32'h4ed8aa4a, 32'h5b9cca4f, 32'h682e6ff3,
	32'h748f82ee, 32'h78a5636f, 32'h84c87814, 32'h8cc70208, 32'h90befffa, 32'ha4506ceb, 32'hbef9a3f7, 32'hc67178f2
};

sha256_hash_function s256hf1(
	.a (intermediate_vals[0]),
	.b (intermediate_vals[1]),
	.c (intermediate_vals[2]),
	.d (intermediate_vals[3]),
	.e (intermediate_vals[4]),
	.f (intermediate_vals[5]),
	.g (intermediate_vals[6]),
	.h (intermediate_vals[7]),
	.wk (wk),
	.t0_in (temporary_vals[0]),
	.t1_in (temporary_vals[1]),
	.t2_in (temporary_vals[2]),
	.round (round),
	.round_type (c_hash.round_type),
						  
	.inter_out (sha256_hash_result),
	.temp_out (sha256_temp_result)
);

	  
always_ff(@posedge clk) begin
	
	
	
	//end
	nonce = nonce + 255'b1;
	intermediate_vals <= sha256_hash_result;
	temporary_vals <= sha256_temp_result;
	
end



  
endmodule