
module write_submodule#(
    parameter ADDR_WDTH = 4,
    parameter DATA_WDTH = 32,
    parameter RESP_WDTH = 1)

(
 	input clk,
 	input rst_n,

	// memory interface
 	output w_valid,
	input w_ready,
	output [DATA_WDTH-1:0] w_data,
 	
	input b_valid,
 	output b_ready,
 	input [RESP_WDTH-1:0] b_resp,
 	
 	output aw_valid,
	input aw_ready,
 	output [ADDR_WDTH-1:0] aw_address,
 	
	// supermodule interface
	input start,
 	input [DATA_WDTH-1:0] data,
 	input [ADDR_WDTH-1:0] addr,
 	output done,
 	output [RESP_WDTH-1:0] resp,
	
);
// module body here
endmodule
    