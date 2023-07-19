`ifndef DATAPATH_DEFINED
`define DATAPATH_DEFINED

`include "arithmetic/adder.v"
`include "arithmetic/substractor.v"
`include "arithmetic/signed_comparator.v"
`include "arithmetic/unsigned_comparator.v"

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
 	output j_gte_0
);

reg signed [DATA_WDTH-1:0] elem2insert, elem2compare, read_return_data;
reg [ADDR_WDTH:0] i,j;
reg [ADDR_WDTH-1:0] arg_read_addr;



wire [ADDR_WDTH:0] i_plus1;
adder i_1 (
	.a(1),
	.b(i),
	.carry_in(0),
	.sum(i_plus1),
	.carry_out());

wire [ADDR_WDTH:0] next_j, minuend;
assign minuend = sl_decrd_to_j ? j : i;
substractor i_or_j_1 (
	.minuend(minuend),
	.substrahend(1),
	.borrow_in(0),
	.difference(next_j),
	.borrow_out()
);




always@ (posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		arg_read_addr <= 0;
		read_return_data <= 0;
		elem2compare <= 0;
		elem2insert <= 0;
		i <= 0;
		j <= 0;
	end else begin
		if (ld_arg_read_addr)
			arg_read_addr <= sl_j_to_arg_read_addr ?
				j : i;
		if (ld_elem2compare)
			elem2compare <= read_return_data;
		if (ld_elem2insert)
			elem2insert <= read_return_data;
		if (ld_i)
			i <= sl_incd_to_i ? 
				i_plus1 : 1;
		if (ld_j)
			j <= next_j;
		if (ld_return_read_data)
			read_return_data <= r_data;
	end
end

assign ar_address = arg_read_addr;

adder j_0_or_1 (
	.a(j),
	.b(0),
	.carry_in(sl_j_plus_1_to_write_addr),
	.sum(write_addr),
	.carry_out()
);

assign write_data = sl_elem2compare_to_write_data ?
	elem2compare : elem2insert;

unsigned_comparator i_size (
	.a(i),
	.b(arr_size),
	.lt(i_lt_arr_size),
	.gt(),.eq()
);

signed_comparator cmp_elements (
	.a(elem2insert),
	.b(elem2compare),
	.gt(elem2insert_gt_elem2compare),
	.lt(),.eq()
);

wire j_lt_0;
unsigned_comparator check_j (.a(j),.b(0),.lt(j_lt_0),.gt(),.eq());
assign j_gte_0 = ~j_lt_0;

endmodule

`endif
