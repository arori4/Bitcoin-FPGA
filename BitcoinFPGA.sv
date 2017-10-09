/*
 * sha1.sv
 * Top Level for the sha1 algorithm
 *
 * 5 stage pipeline
 * Stage 0: control
 * Stage 1: memory generation
 * Stage 2: memory saturation (not implemented)
 * Stage 3: hash function 1
 * Stage 4: hash function 2 (not implemented
 */
import Definitions::*;
module BitcoinFPGA(input logic clk, reset_n, start,
							input logic [1:0] opcode,
							input logic [31:0] message_addr, size, output_addr,
							output logic done, mem_clk, mem_we,
							output logic [15:0] mem_addr,
							output logic [31:0] mem_write_data,
							input logic [31:0] mem_read_data );

logic[31:0] next_wk, hash[0:7];
logic[15:0] num_blocks;
logic[7:0] round_0, round_1;
c_memory_struct c_memory_0, c_memory_1;
c_hash_struct c_hash_0, c_hash_1;

calc_num_blocks cnb1(
	.size (size), 
	.clk (clk),
	
	.num_blocks (num_blocks)
);

//stage 0
Control_Block cb1(
	.message_addr (message_addr), 
	.size (size), 
	.output_addr (output_addr),
	.num_blocks (num_blocks),
	.opcode (opcode),
	.clk (clk), 
	.reset_en (reset_n), 
	.start (start),

	.mem_ptr (mem_addr),
	.round (round_0), 
	.c_write (mem_we),
	.c_memory (c_memory_0),
	.c_hash (c_hash_0),
	.done (done)
);

//stage 1
Memory_Block mb1(
	.mem_read_data (mem_read_data), 
	.size (size),
	.round (round_0),
	.opcode (opcode),
	.clk (clk), 
	.reset_en (reset_n),
	.c_memory (c_memory_0),
					
	.next_wk (next_wk)
);

Delay_Block db1(
	.round_in (round_0),
	.clk (clk), 
	.reset_en (reset_n), 
	.c_memory_in (c_memory_0),
	.c_hash_in (c_hash_0),
					
	.round_out (round_1),
	.c_memory_out (c_memory_1),
	.c_hash_out (c_hash_1)
);

//stage 2
Hash_Block hb1(
	.wk (next_wk),
	.round (round_1),
	.opcode (opcode), 
	.clk (clk), 
	.start (start), 
	.c_hash (c_hash_1),
				  
	.hash(hash)
);

//stage 3
Verify_Block wb1(
	.hash (hash),
	.round (round_0),
	.clk (clk),
			   
	.mem_write_data (mem_write_data) 
);

//clock transfer generator
always_comb begin
	mem_clk <= clk; //blocking intentionally used here.
end
	
endmodule
