/*
 * definitions.sv
 * Contains all definitions for the entire program
 */
package definitions;
    
	enum logic [1:0] {MD5 = 2'b00, 
					  SHA_1 = 2'b01, 
					  SHA_256 = 2'b10, 
					  OPCODE_RESERVE = 2'b11} opcode_def;		
	enum logic [1:0] {IDLE = 2'b00, 
					  BEGIN = 2'b01, 
					  COMPUTE = 2'b10, 
					  WRITE = 2'b11} state;
	enum logic [1:0] {WAIT = 2'b00, 
					  CONTINUE = 2'b01, 
					  FINISH = 2'b10, 
					  CWE_RESERVE = 2'b11} cwe_end_def;
	enum logic [1:0] {PRECOMPUTE = 2'b00, 
					  KERNEL = 2'b01, 
					  EPILOGUE = 2'b10, 
					  CHUNK_DONE = 2'b11} cr_def;
	
	
	typedef struct {
		logic [3:0] oct_funct;
		logic [1:0] md5_new_word;
		logic		enable;
	} c_memory_struct;
	 
	typedef struct {
		logic [1:0] quad_funct;
		logic [1:0] round_type;
		logic		chunk_done;
		logic		enable;
	} c_hash_struct;
	
endpackage
