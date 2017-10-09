/*
 * SHA256_New_W.sv
 * Creates the new block for the next sha256 cycle
 * a = w-15
 * b = w-2
 * c = w-16
 * d = w-7
 */

import Definitions::*;
module SHA256_New_W (input logic[31:0] a, b, c, d,
	
						 output logic [31:0] out );

always_comb begin

	automatic logic [31:0] s0, s1, s2;
	
	s0 = {a[6:0], a[31:7]} ^ {a[17:0], a[31:18]} ^ {3'b0, a[31:3]};
	s1 = {b[16:0], b[31:17]} ^ {b[18:0], b[31:19]} ^ {10'b0, b[31:10]};
	s2 = c + d;
	
	out = s0 + s1 + s2;

end

endmodule 