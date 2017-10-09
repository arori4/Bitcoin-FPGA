/**
 * sha1_new_block.sv
 * Creates a new 32 bit word after the initial 16 blocks.
 * RTL Viewer suggests that this is the most optimized this block can get, unless we clk it in parallel
 */

import definitions::*;
module sha1_new_block(input logic [31:0] a, b, c, d,
					  
                      output logic [31:0] out );
			
function logic[31:0] generate_new(input logic[31:0] n1, n2, n3, n4);

	automatic logic[31:0] ne = n1 ^ n2 ^ n3 ^ n4;
	generate_new = {ne[30:0], ne[31]};
	
endfunction

assign out = generate_new(a, b, c, d);
		 
endmodule 