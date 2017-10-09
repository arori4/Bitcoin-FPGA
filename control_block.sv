/*
 * Control_Block.sv
 * Very similar in functionality to both a PC and a control unit
 */
import Definitions::*;
module Control_Block(input logic [31:0] message_addr, size, output_addr,
					 input logic [15:0] num_blocks,
					 input logic [ 1:0] opcode,
					 input logic clk, reset_en, start,

					 output logic [15:0] mem_ptr,
					 output logic [7:0] round,
					 output logic c_write,
					 output c_memory_struct c_memory,
					 output c_hash_struct c_hash,
					 output logic done );

logic [15:0] wordread, md5_mem_addr;
logic [7:0] chunk;
logic [3:0] cra_decision;
logic [1:0] chq_decision, cr_decision, cwe_decision;
logic chunk_start;
					
// MD5 S constants
parameter byte unsigned load_vals[0:63] = '{
	8'd1, 8'd2, 8'd3, 8'd4, 8'd5, 8'd6, 8'd7, 
	8'd8, 8'd9, 8'd10, 8'd11, 8'd12, 8'd13, 8'd14, 8'd15, 
	8'd1, 8'd6, 8'd11, 8'd0, 8'd5, 8'd10, 8'd15, 8'd4, 
	8'd9, 8'd14, 8'd3, 8'd8, 8'd13, 8'd2, 8'd7, 8'd12, 
	8'd5, 8'd8, 8'd11, 8'd14, 8'd1, 8'd4, 8'd7, 8'd10, 
	8'd13, 8'd0, 8'd3, 8'd6, 8'd9, 8'd12, 8'd15, 8'd2, 
	8'd0, 8'd7, 8'd14, 8'd5, 8'd12, 8'd3, 8'd10, 8'd1, 
	8'd8, 8'd15, 8'd6, 8'd13, 8'd4, 8'd11, 8'd2, 8'd9, 8'd63 };

					
Control_Read_Assign cra1(
	.size (size), 
	.num_blocks (num_blocks), 
	.wordread (wordread), 
	.mem_address ({2'b0, chunk, 6'b0} + {6'b0, load_vals[round], 2'b0}),
	.chunk (chunk), 
	.round (round), 
	.md5_log_in (load_vals[round]),
	.opcode (opcode), 
	
	.decision (cra_decision)
);

Control_Hash_Quad chq1(
	.round (round),
	.opcode (opcode),
	
	.decision (chq_decision)
);
	
Control_Round cr1(
	.round (round),
	.opcode (opcode),
	.chunk_start (chunk_start),
	
	.decision (cr_decision)
);

Control_Verify cwe1(
	.round (round),
	.opcode (opcode),
	
	.decision (cwe_decision)
);
	
always_ff @(posedge clk) begin

	if (!reset_en) begin
		mem_ptr <= 0;
		round <= 0;
		chunk <= 0;
		c_write <= 0;
		c_memory <= '{default: '0};
		c_hash <= '{default: '0};
		done <= 0;
		wordread <= 0;
		chunk_start <= 0;
		
		state <= IDLE;
	end
	
	unique case (state)
	
		IDLE: begin //when chip is doing nothing
			if (start) begin
				state <= BEGIN;
			end
			else begin
				state <= IDLE;
			end
			
			mem_ptr <= message_addr[15:0];
			round <= 0;
			chunk <= 0;
			c_write <= 0;
			c_memory <= '{default: '0};
			c_hash <= '{default: '0};
			done <= 0;
			wordread <= 0;
			chunk_start <= 'b1;
				
		end
		
		BEGIN: begin //first step of each block
			if (chunk < num_blocks) begin
				round <= 0; //for mem control to work correctly
				c_hash.enable <= 1;
				state <= COMPUTE;
			end
			//start writing. write happpens after next round, b/c we need to add result first
			else begin
				round <= -8'd1; //let signals propogate to hash block before we write. need delay of 1
				c_hash.enable <= 0;
				state <= WRITE;
			end
		
			mem_ptr <= message_addr[15:0] + {chunk, 4'b0};// + {load_vals[round]};
			chunk <= chunk;
			c_memory.enable <= 1;
			c_write <= 0;
			c_hash.chunk_done <= 0;
			done <= 0;
			wordread <= wordread + 16'd4;
			chunk_start <= 0;
		end
		
		COMPUTE: begin //main course of each block. values are subtracted by 1 to account for some accounts done in BEGIN
			//read_control
			if (round < 15) begin
				wordread <= wordread + 16'd4;
			end
			else begin
				wordread <= wordread;
			end
		
			if (cr_decision != CHUNK_DONE) begin
				round <= round + 8'd1;
				c_hash.chunk_done <= 0;
				c_hash.enable <= 1;
				chunk <= chunk;
				chunk_start <= 0;
				state <= COMPUTE;
			end
			
			else begin
				round <= 0;
				c_hash.chunk_done <= 1;
				c_hash.enable <= 0;
				chunk <= chunk + 8'd1;
				chunk_start <= 'b1; //attempt to correctly streamline
				state <= BEGIN;
			end
			
			done <= 0;
			c_write <= 0;
			mem_ptr <= message_addr[15:0] + {chunk, 4'b0} + {load_vals[round]};
		end
		
		WRITE: begin //after all blocks have been processed, write to memory
		
			unique case (cwe_decision)
				WAIT: begin
					done <= 0;
					c_write <= 0;
					state <= WRITE;
				end
				CONTINUE: begin
					done <= 0;
					c_write <= 1;
					state <= WRITE;
				end
				FINISH: begin
					done <= 1;
					c_write <= 0;
					state <= IDLE;
				end
				CWE_RESERVE: begin //default to done
					done <= 1;
					c_write <= 0;
					state <= IDLE;
				end
			endcase
			
			c_memory.enable <= 0;
			c_hash.chunk_done <= 0;
			c_hash.enable <= 0;
			round <= round + 8'd1;
			mem_ptr <= output_addr[15:0] + round[7:0];
			chunk <= chunk;
			chunk_start <= 0;
			wordread <= wordread;
		end
	
	endcase
	
	//stuff that always needs to be assigned
	c_memory.oct_funct <= cra_decision;
	c_memory.md5_new_word <= chq_decision;
	c_hash.quad_funct <= chq_decision;
	c_hash.round_type <= cr_decision;
	//md5_mem_addr <= {2'b0, chunk, 6'b0} + {6'b0, load_vals[round + 1], 2'b0};
	
end
				 
endmodule 