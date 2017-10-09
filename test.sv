module test(input logic[3:0] chooser, input logic[31:0] in,
			input logic clk,
			output logic[31:0] out);
		
logic[31:0] w[0:15];

always_ff @(posedge clk) begin

	w[chooser] <= in;
	out <= w[chooser];

end
	
endmodule
