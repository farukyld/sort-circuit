
module memory #(
    parameter ADDR_WDTH = 4,
    parameter DATA_WDTH = ADDR_WDTH-12,
    parameter RESP_WDTH = 1)

(
 	input clk,
 	input rst_n,

    // for testing purposes
	input always_success,
 	input always_error,
 	
    // AXI-Lite interface
    input ar_valid,
 	output ar_ready,
 	input [ADDR_WDTH-1:0] ar_address,

 	output r_valid,
 	input r_ready,
 	output [DATA_WDTH-1:0] r_data,
 	output [RESP_WDTH-1:0] r_resp,
    
    input aw_valid,
	output aw_ready,
 	input [ADDR_WDTH-1:0] aw_address,
 	
    input w_valid,
 	output w_ready,
 	input [DATA_WDTH-1:0] w_data,

 	output b_valid,
 	input b_ready,
 	output [RESP_WDTH-1:0] b_resp,
 	
);
// module body here
endmodule
    