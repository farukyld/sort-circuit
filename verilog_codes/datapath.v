
module datapath#(
    parameter ADDR_WDTH = 4,
    parameter DATA_WDTH = 32,
    parameter RESP_WDTH = 1)

(
 	input clk,
 	input rst_n,
 	
	// user interface
	input [ADDR_WDTH:0] arr_size,

	// to memory
	output [ADDR_WDTH-1:0] ar_address,
 	input [DATA_WDTH-1:0] r_data,

	// to write_submodule
 	output [ADDR_WDTH-1:0] write_addr,
 	output [DATA_WDTH-1:0] write_data,

	// controller interface
	input ld_elem2compare,
 	input ld_return_read_data,
 	input ld_j,
 	input sl_decrd_to_j,
 	input ld_i,
 	input sl_incd_to_i,
 	input sl_elem2compare_to_write_data,
 	input sl_j_to_arg_read_addr,
 	input ld_arg_read_addr,
 	input sl_j_plus_1_to_write_addr,
 	input ld_elem2insert,

	output i_lt_arr_size,
 	output elem2insert_gt_elem2compare,
 	output j_gte_0,
 	
);
// module body here
endmodule
    