
module memory_filler#(
    parameter ADDR_WDTH = 4,
    parameter DATA_WDTH = 32,
    parameter RESP_WDTH = 1)

(
 	input clk,
 	input rst_n,

	// user interface
	input [ADDR_WDTH:0] arr_size,
	output done,

	// memory interface
 	output aw_valid,
 	input aw_ready,
 	output [ADDR_WDTH-1:0] aw_address,

 	output w_valid,
 	input w_ready,
 	output [DATA_WDTH-1:0] w_data,

 	input b_valid,
 	input [RESP_WDTH-1:0]b_resp,
 	output b_ready,

);
// module body here
endmodule
    