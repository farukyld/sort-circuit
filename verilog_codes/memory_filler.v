
module memory_filler(
 	input clk,
 	input rst_n,

	// user interface
	input [3:0] arr_size,
	output done,

	// memory interface
 	output aw_valid,
 	input aw_ready,
 	output [3:0] aw_address,

 	output w_valid,
 	input w_ready,
 	output [31:0] w_data,

 	input b_valid,
 	input b_resp,
 	output b_ready,

);
// module body here
endmodule
    