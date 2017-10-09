/*
 * memory_block.sv
 * Controlls the w array
 * 220.75 MHz
 * 545 ALUTS (93 here, 452 shanb1)
 * 544 registers (512 W, 32 next_w);
 */

import definitions::*;
module memory_block(input logic [31:0] mem_read_data, size,
					input logic [7:0] round,
					input logic [1:0] opcode,
					input logic clk, reset_en,
					input c_memory_struct c_memory,
					
					output logic [31:0] next_wk );

logic [31:0] w[0:15], next_k, sha1_new, sha256_new;
		
sha1_new_block snb1(
	.a(w[13]), //i - 16 = 16.
	.b(w[8]), 
	.c(w[2]), 
	.d(w[0]),
	
	.out (sha1_new) );

sha256_new_block s256nb1( //ORDER IS IMPORTANT
	.a(w[1]), 
	.b(w[14]), 
	.c(w[0]), 
	.d(w[9]),
	
	.out (sha256_new) );

memory_k_chooser mkc1(
	.round (round),
	.opcode (opcode),
	.quad_funct (c_memory.md5_new_word),
	
	.k_val (next_k) );


function logic[31:0] assign_memory(logic[31:0] mrd, siz,
								   logic[3:0] ctrl);
								   
	unique case(ctrl)	
		4'd0: begin
			assign_memory = {mrd[31:8], 8'h80};
		end
		4'd1: begin
			assign_memory = {mrd[31:16], 16'h8000};
		end
		4'd2: begin
			assign_memory = {mrd[31:24], 24'h800000};
		end
		4'd3: begin
			assign_memory = 32'h80000000;
		end
		4'd4: begin
			assign_memory = (siz << 3);
		end
		4'd5: begin
			assign_memory = 32'h00000000;
		end
		4'd6: begin
			assign_memory = mrd;
		end
		4'd7: begin
			assign_memory = 32'h00000000;
		end
		4'd8: begin
			assign_memory = 32'h00000000;	
		end
		4'd9: begin
			assign_memory = 32'h00000000;	
		end
		4'd10: begin
			assign_memory = 32'h00000000;
		end
		4'd11: begin
			assign_memory = 32'h00000000;
		end
		4'd12: begin //1100
			assign_memory = mrd; //md5 read
		end
		4'd13: begin
			assign_memory = sha1_new;
		end
		4'd14: begin
			assign_memory = sha256_new;
		end
		4'd15: begin
			assign_memory = 32'h00000000;
		end
	endcase
	
endfunction 		
	
always_ff @(posedge clk) begin
	
	automatic logic[31:0] w_res; 
	
	//reset_enable
//	if (!reset_en) begin
//		w <= '{default:0};
//	end
	w_res = assign_memory(mem_read_data, size, c_memory.oct_funct);
	next_wk <= w_res + next_k;
	w[0] <= w[1];
	w[1] <= w[2];
	w[2] <= w[3];
	w[3] <= w[4];
	w[4] <= w[5];
	w[5] <= w[6];
	w[6] <= w[7];
	w[7] <= w[8];
	w[8] <= w[9];
	w[9] <= w[10];
	w[10] <= w[11];
	w[11] <= w[12];
	w[12] <= w[13];
	w[13] <= w[14];
	w[14] <= w[15];
	w[15] <= w_res;
	
end

endmodule
