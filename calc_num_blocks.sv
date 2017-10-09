
import definitions::*;
module calc_num_blocks(input logic [31:0] size,
					   input logic clk,
                      output logic [15:0] num_blocks);
							 
							 
function logic [15:0] determine_num_blocks(input logic [31:0] size);

	automatic logic[31:0] rem;
	automatic logic[31:0] num;
	num = size >> 6;
	rem = size & 32'b111111;
	if (rem < 32'd56) begin
		num = num + 32'd1;
	end
	else begin
		num = num + 32'd2;
	end
	 
	determine_num_blocks = num[15:0];
endfunction

always_ff @(posedge clk) begin
	num_blocks <= determine_num_blocks(size);
end
				 
endmodule