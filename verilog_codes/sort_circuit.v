
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

// internal wires

// datapath-write_submodule
wire [ADDR_WDTH-1:0] write_addr;
wire [DATA_WDTH-1:0] write_data;

// controller-write_submobule
wire write_submodule_done;
wire [RESP_WDTH-1:0] write_submodule_resp;
wire write_submodule_start;

// controller datapath
wire ld_elem2compare;
wire ld_return_read_data;
wire ld_j;
wire sl_decrd_to_j;
wire ld_i;
wire sl_incd_to_i;
wire sl_elem2compare_to_write_data;
wire sl_j_to_arg_read_addr;
wire ld_arg_read_addr;
wire sl_j_plus_1_to_write_addr;
wire ld_elem2insert;

wire i_lt_arr_size;
wire elem2insert_gt_elem2compare;
wire j_gte_0;


controller ctrl(
	.clk(clk),
	.rst_n(rst_n),
	// user interface
	.start(start),
	.done(done),
	.err(err),
	// memory interface
	.ar_valid(ar_valid),
	.ar_ready(ar_ready),

	.r_valid(r_valid),
	.r_ready(r_ready),

	// to write_submodule
	.write_submodule_start(write_submodule_start),
	.write_submodule_b_resp(write_submodule_resp),
	.write_submodule_done(write_submodule_done),

	// datapath interface
	.i_lt_arr_size(i_lt_arr_size),
	.elem2insert_gt_elem2compare(elem2insert_gt_elem2compare),
	.j_gte_0(j_gte_0),
	
	
	.ld_elem2compare(ld_elem2compare),
	.ld_return_read_data(ld_return_read_data),
	.ld_j(ld_j),
	.sl_decrd_to_j(sl_decrd_to_j),
	.ld_i(ld_i),
	.sl_incd_to_i(sl_incd_to_i),
	.sl_elem2compare_to_write_data(sl_elem2compare_to_write_data),
	.sl_j_to_arg_read_addr(sl_j_to_arg_read_addr),
	.ld_arg_read_addr(ld_arg_read_addr),
	.sl_j_plus_1_to_write_addr(sl_j_plus_1_to_write_addr),
	.ld_elem2insert(ld_elem2insert),

	.swich_case_default()
);

datapath#(.ADDR_WDTH(ADDR_WDTH), .DATA_WDTH(DATA_WDTH), .RESP_WDTH(RESP_WDTH)) dp(
	.clk(clk),
	.rst_n(rst_n),

	// user interface
	.arr_size(arr_size),
	
	// to memory
	.ar_address(ar_address),
	.r_data(r_data),
	
	// to write_submodue
	.write_addr(write_addr),
	.write_data(write_data),
	
	// controller interface
	.ld_elem2compare(ld_elem2compare),
	.ld_return_read_data(ld_return_read_data),
	.ld_j(ld_j),
	.sl_decrd_to_j(sl_decrd_to_j),
	.ld_i(ld_i),
	.sl_incd_to_i(sl_incd_to_i),
	.sl_elem2compare_to_write_data(sl_elem2compare_to_write_data),
	.sl_j_to_arg_read_addr(sl_j_to_arg_read_addr),
	.ld_arg_read_addr(ld_arg_read_addr),
	.sl_j_plus_1_to_write_addr(sl_j_plus_1_to_write_addr),
	.ld_elem2insert(ld_elem2insert),
	
	.i_lt_arr_size(i_lt_arr_size),
	.elem2insert_gt_elem2compare(elem2insert_gt_elem2compare),
	.j_gte_0(j_gte_0)
);

write_submodule#(.ADDR_WDTH(ADDR_WDTH), .DATA_WDTH(DATA_WDTH), .RESP_WDTH(RESP_WDTH)) ws(
	.clk(clk),
	.rst_n(rst_n),

	// memory interface
	.aw_valid(aw_valid),
	.aw_ready(aw_ready),
	.aw_address(aw_address),
	
	.w_valid(w_valid),
	.w_ready(w_ready),
	.w_data(w_data),
	
	.b_valid(b_valid),
	.b_ready(b_ready),
	.b_resp(b_resp),
	
	// controller interface
	.start(write_submodule_start),
	.resp(write_submodule_resp),
	.done(write_submodule_done),

	// datapath interface
	.data(write_data),
	.addr(write_addr),

	.swich_case_default()
);

endmodule
