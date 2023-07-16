`define STATE_WDTH 5

module controller #(
    parameter ADDR_WDTH = 4,
    parameter DATA_WDTH = 32,
    parameter RESP_WDTH = 1)

(
 	input clk,
	input rst_n,
	// user interface
 	input start,
	output done,
 	output error,

	// memory interface
 	output ar_valid,
 	input ar_ready,

 	input r_valid,
 	input [RESP_WDTH-1:0] r_resp,
 	output r_ready,

	// to write submodule
 	input write_submodule_done,
 	input [RESP_WDTH-1:0] write_submodule_b_resp,
 	output write_submodule_start,

	// datapath interface
 	input elem2insert_gt_elem2compare,
 	input j_gte_0,
 	input i_lt_arr_size,

	output ld_return_read_data,
 	output sl_j_plus_1_to_write_addr,
 	output sl_elem2compare_to_write_data,
 	output sl_incd_to_i,
 	output ld_i,
 	output sl_decrd_to_j,
 	output ld_j,
 	output ld_elem2insert,
 	output ld_elem2compare,
 	output sl_j_to_arg_read_addr,
 	output ld_arg_read_addr,

);


wire sl_to_arg_return_state;
wire ld_arg_return_state;
reg [STATE_WDTH-1:0] arg_return_state;

wire sl_to_state;
// reg [STATE_WDTH-1:0] state;

// module body here
endmodule
    