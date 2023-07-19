`define MEMORY_STATE_WIDTH 5

module memory #(
    parameter ADDR_WDTH = 4,
    parameter DATA_WDTH = 32,
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

	output swich_case_default
);


localparam IDLE = 'd0;
localparam DECIDE_RANDOM = 'd1;
localparam AR_TRANSFER = 'd2;
localparam AW_TRANSFER = 'd3;
localparam COMPLETE_AR = 'd4;
localparam REGISTER_READ_DATA = 'd5;
localparam WAIT_R_READY = 'd6;
localparam COMPLETE_R = 'd7;
localparam COMPLETE_AW = 'd8;
localparam WAIT_W_VALID = 'd9;
localparam W_TRANSFER = 'd10;
localparam COMPLETE_W = 'd11;
localparam STORE_REG_DATA = 'd12;
localparam WAIT_B_READY = 'd13;
localparam COMPLETE_B = 'd14;
localparam RESPOND_B = 'd15;
localparam OUTPUT_READ_DATA = 'd16;
localparam RAM_OUT = 'd17;
localparam SWICH_CASE_DEFAULT = 'd18;

wire
is_cs_idle,
is_cs_decide_random,
is_cs_ar_transfer,
is_cs_aw_transfer,
is_cs_complete_ar,
is_cs_register_read_data,
is_cs_wait_r_ready,
is_cs_complete_r,
is_cs_complete_aw,
is_cs_wait_w_valid,
is_cs_w_transfer,
is_cs_complete_w,
is_cs_store_reg_data,
is_cs_wait_b_ready,
is_cs_complete_b,
is_cs_respond_b,
is_cs_output_read_data,
is_cs_RAM_out,
is_cs_swich_case_default;


reg [MEMORY_STATE_WIDTH-1:0] current_state = IDLE;
reg [MEMORY_STATE_WIDTH-1:0] gen_state;


// decode the current state to easily generate the outputs
assign is_cs_idle = IDLE == current_state;
assign is_cs_decide_random = DECIDE_RANDOM == current_state;
assign is_cs_ar_transfer = AR_TRANSFER == current_state;
assign is_cs_aw_transfer = AW_TRANSFER == current_state;
assign is_cs_complete_ar = COMPLETE_AR == current_state;
assign is_cs_register_read_data = REGISTER_READ_DATA == current_state;
assign is_cs_wait_r_ready = WAIT_R_READY == current_state;
assign is_cs_complete_r = COMPLETE_R == current_state;
assign is_cs_complete_aw = COMPLETE_AW == current_state;
assign is_cs_wait_w_valid = WAIT_W_VALID == current_state;
assign is_cs_w_transfer = W_TRANSFER == current_state;
assign is_cs_complete_w = COMPLETE_W == current_state;
assign is_cs_store_reg_data = STORE_REG_DATA == current_state;
assign is_cs_wait_b_ready = WAIT_B_READY == current_state;
assign is_cs_complete_b = COMPLETE_B == current_state;
assign is_cs_respond_b = RESPOND_B == current_state;
assign is_cs_output_read_data = OUTPUT_READ_DATA == current_state;
assign is_cs_swich_case_default = SWICH_CASE_DEFAULT == current_state;
assign is_cs_RAM_out = RAM_OUT == current_state;

// data register
wire ld_reg_data;
wire sl_w_data_to_reg_tada;
reg [DATA_WDTH-1:0] reg_data;
wire [DATA_WDTH-1:0] next_reg_data;

// address register
wire ld_reg_addr;
wire sl_aw_address_to_reg_addr;
reg [ADDR_WDTH-1:0] reg_addr;
wire [ADDR_WDTH-1:0] next_reg_addr;


// RAM 
wire [DATA_WDTH-1:0] ram_out;
wire in_enable, out_enable;

RAM_module_sync_out #(.ADDR_WDTH(ADDR_WDTH), DATA_WDTH(DATA_WDTH))
	ram (
		.clk(clk),
		.rst_n(rst_n),
		.wr_enable(in_enable),
		.rd_enable(out_enable),
		.rd_data(ram_out)
	);




always@ (posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		current_state <= IDLE;
		reg_addr <= 0;
		reg_data <= 0;
	end else begin
		current_state <= gen_state;
		reg_addr <= next_reg_addr;
		reg_data <= next_reg_data;
	end
end


// internal control
assign next_reg_data = sl_w_data_to_reg_tada ?
	w_data : ram_out;
assign ld_reg_data = is_cs_register_read_data | is_cs_w_transfer;
assign sl_w_data_to_reg_tada = ~is_cs_register_read_data;

assign next_reg_addr = sl_aw_address_to_reg_addr ?
	aw_address : ar_address;
assign ld_reg_addr = is_cs_aw_transfer | is_cs_ar_transfer;
assign sl_aw_address_to_reg_addr = is_cs_aw_transfer;

assign out_enable = is_cs_RAM_out;
assign in_enable = is_cs_store_reg_data;

// outputs
assign ar_ready = is_cs_ar_transfer;

assign r_valid = is_cs_output_read_data | is_cs_wait_r_ready;

assign r_data = reg_data;

assign r_resp = ~always_error & (always_success | ~&rnd);

assign aw_ready = is_cs_aw_transfer;

assign w_ready = is_cs_w_transfer;

assign b_valid = is_cs_respond_b | is_cs_wait_b_ready;

assign b_resp = ~always_error & (always_success | ~&rnd);

assign swich_case_default = is_cs_swich_case_default;


wire rnd;
random_generator #(.DATA_WDTH(4)) ran_gen  (
	.clk(clk),
	.rst_n(rst_n),
	.enable(1),
	.rnd(rnd)
	);



// next state generation
always @(*) begin
	case (current_state)
		IDLE: 
			if (~ar_valid & ~aw_valid)
				gen_state <= IDLE;
			else if (~ar_valid & aw_valid)
				gen_state <= AW_TRANSFER;
			else if (ar_valid & ~aw_valid)
				gen_state <= AR_TRANSFER;
			else 
				gen_state <= DECIDE_RANDOM;

		DECIDE_RANDOM:
			gen_state <= rnd[0] ? AW_TRANSFER : AR_TRANSFER;

		AR_TRANSFER:
			gen_state <= COMPLETE_AR;

		AW_TRANSFER:
			gen_state <= COMPLETE_AW;

		COMPLETE_AR:
			gen_state <= RAM_OUT;

		RAM_OUT:
			gen_state <= REGISTER_READ_DATA;

		REGISTER_READ_DATA:
			gen_state <= OUTPUT_READ_DATA;

		OUTPUT_READ_DATA:
			gen_state <= r_ready ? COMPLETE_R : WAIT_R_READY;

		WAIT_R_READY:
			gen_state <= r_ready ? COMPLETE_R : WAIT_R_READY;

		COMPLETE_R:
			gen_state <= IDLE;

		COMPLETE_AW:
			gen_state <= WAIT_W_VALID;

		WAIT_W_VALID:
			gen_state <= w_valid ? W_TRANSFER : WAIT_W_VALID;

		W_TRANSFER:
			gen_state <= COMPLETE_W;

		COMPLETE_W:
			gen_state <= STORE_REG_DATA;

		STORE_REG_DATA:
			gen_state <= RESPOND_B;
		
		RESPOND_B:
			gen_state <= b_ready ? COMPLETE_B : WAIT_B_READY;

		WAIT_B_READY:
			gen_state <= b_ready ? COMPLETE_B : WAIT_B_READY;

		COMPLETE_B:
			gen_state <= IDLE;
		
		default: 
			gen_state <= SWICH_CASE_DEFAULT;
	endcase
end


endmodule
    
