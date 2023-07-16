
module sort_circuit #(
    parameter ADDR_WDTH = 4,
    parameter DATA_WDTH = 32,
    parameter RESP_WDTH = 1
	)

(

 	input clk,
 	input rst_n,

	input [ADDR_WDTH:0] arr_size,
 	input start,
 	output done,
 	output err,

 	input ar_ready,
	output [ADDR_WDTH-1:0] ar_address,
 	output ar_valid,

 	input [DATA_WDTH-1:0] r_data,
 	output r_ready,
 	input [RESP_WDTH-1:0] r_resp,
 	input r_valid,

 	input aw_ready,
 	output aw_valid,
 	output [ADDR_WDTH-1:0] aw_address,

 	output [DATA_WDTH-1:0] w_data,
 	output w_valid,
 	input w_ready,

 	input b_valid,
 	input [RESP_WDTH-1:0] b_resp,
 	output b_ready,
);
// module body here
endmodule
    