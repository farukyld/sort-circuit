
module write_submodule(
 	input clk,
 	input rst_n,

	// memory interface
 	output w_valid,
	input w_ready,
	output [31:0] w_data,
 	
	input b_valid,
 	output b_ready,
 	input b_resp,
 	
 	output aw_valid,
	input aw_ready,
 	output [3:0] aw_address,
 	
	// supermodule interface
	input start,
 	input [31:0] data,
 	input [3:0] addr,
 	output done,
 	output resp,
	
);
// module body here
endmodule
    