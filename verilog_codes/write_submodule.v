`define WRITE_SUBMODULE_STATE_WDTH 4

module write_submodule #(
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
 	
	output swich_case_default
);

localparam IDLE = 'd0;
localparam WAIT_AW_READY_OR_W_READY = 'd1;
localparam COMPLETE_W_WAIT_AW_READY = 'd2;
localparam WAIT_B_VALID = 'd3;
localparam COMPLETE_AW = 'd4;
localparam PROCESS_B_RESP = 'd5;
localparam COMPLETE_AW_AND_W = 'd6;
localparam COMPLETE_AW_WAIT_W_READY = 'd7;
localparam COMPLETE_W = 'd8;
localparam SEND_ADDR_AND_DATA = 'd9;
localparam SWICH_CASE_DEFAULT = 'd10;

reg [STATE_WDTH-1:0] current_state = IDLE;
reg [STATE_WDTH-1:0] gen_state;



wire 
is_cs_idle,
is_cs_wait_aw_ready_or_w_ready,
is_cs_complete_w_wait_aw_ready,
is_cs_wait_b_valid,
is_cs_complete_aw,
is_cs_process_b_resp,
is_cs_complete_aw_and_w,
is_cs_complete_aw_wait_w_ready,
is_cs_complete_w,
is_cs_send_addr_and_data,
is_cs_swich_case_default;

// decode the state to generate outputs easily.
assign is_cs_idle =  IDLE == current_state;
assign is_cs_wait_aw_ready_or_w_ready =  WAIT_AW_READY_OR_W_READY == current_state;
assign is_cs_complete_w_wait_aw_ready =  COMPLETE_W_WAIT_AW_READY == current_state;
assign is_cs_wait_b_valid =  WAIT_B_VALID == current_state;
assign is_cs_complete_aw =  COMPLETE_AW == current_state;
assign is_cs_process_b_resp =  PROCESS_B_RESP == current_state;
assign is_cs_complete_aw_and_w =  COMPLETE_AW_AND_W == current_state;
assign is_cs_complete_aw_wait_w_ready =  COMPLETE_AW_WAIT_W_READY == current_state;
assign is_cs_complete_w =  COMPLETE_W == current_state;
assign is_cs_send_addr_and_data =  SEND_ADDR_AND_DATA == current_state;
assign is_cs_swich_case_default =  SWICH_CASE_DEFAULT == current_state;


// outputs
wire ld_reg_b_resp;
reg [RESP_WDTH-1:0] reg_b_resp;
assign resp = reg_b_resp;

wire ld_reg_addr;
reg [ADDR_WDTH-1:0] reg_addr;
assign aw_address = reg_addr;

wire ld_reg_data;
reg [DATA_WDTH-1:0] reg_data;
assign w_data = reg_data;

assign done = is_cs_idle;

assign aw_valid = is_cs_send_addr_and_data | 
	is_cs_wait_aw_ready_or_w_ready | is_cs_complete_w_wait_aw_ready;

assign b_ready = is_cs_complete_aw | is_cs_complete_w | 
	is_cs_wait_b_valid | is_cs_complete_aw_and_w;

assign w_valid = is_cs_send_addr_and_data | 
	is_cs_wait_aw_ready_or_w_ready | is_cs_complete_aw_wait_w_ready;

assign swich_case_default = is_cs_swich_case_default;

// internal control signals
assign ld_reg_b_resp = 1'b1;

assign ld_reg_data = is_cs_idle;

assign ld_reg_addr = is_cs_idle;


// state transition and synchron blocks
always@ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
		// reset the other registers also
    end else begin
        current_state <= gen_state;
		// assign the other registers also
		if (ld_reg_b_resp)
			reg_b_resp <= b_resp;
		if (ld_reg_addr)
			reg_addr <= addr;
		if (ld_reg_data)
			reg_data <= data;
    end
end

// next state generation
always@ ( * ) begin
    case (current_state)
        IDLE: 
            gen_state <= start ? SEND_ADDR_AND_DATA : IDLE;

        SEND_ADDR_AND_DATA:
            gen_state <= WAIT_AW_READY_OR_W_READY;

        WAIT_AW_READY_OR_W_READY:
            if (~aw_ready & ~w_ready)
                gen_state <= WAIT_AW_READY_OR_W_READY;
            else if (~aw_ready & w_ready)
                gen_state <= COMPLETE_W_WAIT_AW_READY;
            else if (aw_ready & ~w_ready)
                gen_state <= COMPLETE_AW_WAIT_W_READY;
            else 
                gen_state <= COMPLETE_AW_AND_W;
        
        COMPLETE_W_WAIT_AW_READY:
            gen_state <= aw_ready ? COMPLETE_AW : COMPLETE_W_WAIT_AW_READY;
        
        COMPLETE_AW_WAIT_W_READY:
            gen_state <= w_ready ? COMPLETE_W : COMPLETE_AW_WAIT_W_READY;
        
        COMPLETE_W:
            gen_state <= WAIT_B_VALID;

        COMPLETE_AW_AND_W:
            gen_state <= WAIT_B_VALID;
        
        COMPLETE_AW:
            gen_state <= WAIT_B_VALID;
        
         WAIT_B_VALID:
            gen_state <= b_valid ? PROCESS_B_RESP : WAIT_B_VALID;

        PROCESS_B_RESP:
            gen_state <= IDLE;
        
        default:
            gen_state <= SWITCH_CASE_DEFAULT;
    endcase
end

endmodule
