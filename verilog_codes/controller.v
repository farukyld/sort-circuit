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
 	
    output switch_case_def
);


localparam WAIT_START = 'd0;
localparam OUTER_LOOP_CHECK = 'd1;
localparam DONE = 'd2;
localparam INNER_LOOP_CHECK = 'd3;
localparam DECRMT_J = 'd4;
localparam INC_I = 'd5;
localparam ASSIGN_I = 'd6;
localparam ASSIGN_J = 'd7;
localparam WAIT_AR_READY = 'd8;
localparam WAIT_R_VALID = 'd9;
localparam ERR = 'd10;
localparam COMPLETE_AR = 'd11;
localparam READ_FUNCTION = 'd12;
localparam PROCESS_R_DATA_RESP = 'd13;
localparam RETURN_READ_FN = 'd14;
localparam READ_ARR_J = 'd15;
localparam READ_ARR_I = 'd16;
localparam ASSIGN_ELEM2INSERT = 'd17;
localparam ASSIGN_ELEM2COMPARE = 'd18;
localparam CHECK_IF_CORRECT_PLACE = 'd19;
localparam WAIT_SUBMODULE_RETURN1 = 'd20;
localparam SHIFT_ELEM2INSERT_LEFT = 'd21;
localparam WAIT_SUBMODULE_RETURN2 = 'd22;
localparam SHIFT_ELEM2COMPARE_RIGHT = 'd23;
localparam SWICH_CASE_DEFAULT = 'd24;


wire sl_to_arg_return_state;
wire ld_arg_return_state;
reg [STATE_WDTH-1:0] arg_return_state, next_return_state;

wire sl_to_state;
reg [STATE_WDTH-1:0] current_state = WAIT_START;
reg [STATE_WDTH-1:0] gen_state;
wire [STATE_WDTH-1:0] next_state;

wire is_cs_wait_start,
	is_cs_outer_loop_check,
	is_cs_done,
	is_cs_inner_loop_check,
	is_cs_decrmt_j,
	is_cs_inc_i,
	is_cs_assign_i,
	is_cs_assign_j,
	is_cs_wait_ar_ready,
	is_cs_wait_r_valid,
	is_cs_err,
	is_cs_complete_ar,
	is_cs_read_function,
	is_cs_process_r_data_resp,
	is_cs_return_read_fn,
	is_cs_read_arr_j,
	is_cs_read_arr_i,
	is_cs_assign_elem2insert,
	is_cs_assign_elem2compare,
	is_cs_check_if_correct_place,
	is_cs_wait_submodule_return1,
	is_cs_shift_elem2insert_left,
	is_cs_wait_submodule_return2,
	is_cs_shift_elem2compare_right,
	is_cs_swich_case_default;

// decode the state to generate outputs easily.
assign is_cs_wait_start
 = WAIT_START == current_state;
assign is_cs_outer_loop_check
 = OUTER_LOOP_CHECK == current_state;
assign is_cs_done
 = DONE == current_state;
assign is_cs_inner_loop_check
 = INNER_LOOP_CHECK == current_state;
assign is_cs_decrmt_j
 = DECRMT_J == current_state;
assign is_cs_inc_i
 = INC_I == current_state;
assign is_cs_assign_i
 = ASSIGN_I == current_state;
assign is_cs_assign_j
 = ASSIGN_J == current_state;
assign is_cs_wait_ar_ready
 = WAIT_AR_READY == current_state;
assign is_cs_wait_r_valid
 = WAIT_R_VALID == current_state;
assign is_cs_err
 = ERR == current_state;
assign is_cs_complete_ar
 = COMPLETE_AR == current_state;
assign is_cs_read_function
 = READ_FUNCTION == current_state;
assign is_cs_process_r_data_resp
 = PROCESS_R_DATA_RESP == current_state;
assign is_cs_return_read_fn
 = RETURN_READ_FN == current_state;
assign is_cs_read_arr_j
 = READ_ARR_J == current_state;
assign is_cs_read_arr_i
 = READ_ARR_I == current_state;
assign is_cs_assign_elem2insert
 = ASSIGN_ELEM2INSERT == current_state;
assign is_cs_assign_elem2compare
 = ASSIGN_ELEM2COMPARE == current_state;
assign is_cs_check_if_correct_place
 = CHECK_IF_CORRECT_PLACE == current_state;
assign is_cs_wait_submodule_return1
 = WAIT_SUBMODULE_RETURN1 == current_state;
assign is_cs_shift_elem2insert_left
 = SHIFT_ELEM2INSERT_LEFT == current_state;
assign is_cs_wait_submodule_return2
 = WAIT_SUBMODULE_RETURN2 == current_state;
assign is_cs_shift_elem2compare_right
 = SHIFT_ELEM2COMPARE_RIGHT == current_state;
assign is_cs_swich_case_default
 = SWICH_CASE_DEFAULT == current_state;


// output logic
assign ld_return_read_data = is_cs_process_r_data_resp;
assign sl_j_plus_1_to_write_addr = is_cs_shift_elem2compare_right;
assign sl_elem2compare_to_write_data = is_cs_shift_elem2compare_right;
assign sl_incd_to_i = is_cs_inc_i;
assign ld_i = is_cs_inc_i | is_cs_assign_i;
assign sl_decrd_to_j = is_cs_decrmt_j;
assign ld_j = is_cs_decrmt_j | is_cs_assign_j;
assign ld_elem2insert = is_cs_assign_elem2insert;
assign ld_elem2compare = is_cs_assign_elem2compare;
assign sl_j_to_arg_read_addr = is_cs_read_arr_j;
assign ld_arg_read_addr = is_cs_read_arr_i | is_cs_read_arr_j;
assign write_submodule_start 
    = is_cs_shift_elem2compare_right | is_cs_shift_elem2insert_left;
assign r_ready = is_cs_complete_ar | is_cs_wait_r_valid;
assign ar_valid = is_cs_read_function | is_cs_wait_ar_ready;
assign done = is_cs_done;
assign error = is_cs_err;

assign switch_case_def = is_cs_swich_case_default;

// internal control logic
assign sl_to_arg_return_state = is_cs_read_arr_j;
assign ld_arg_return_state = is_cs_read_arr_i | is_cs_read_arr_j;
assign sl_to_state = is_cs_return_read_fn;

assign next_state = sl_to_state ? arg_return_state : gen_state;


// state transition and synchron blocks
always@ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= WAIT_START;
        arg_return_state <= 'd0;
    end else begin
        current_state <= next_state;
        if (ld_arg_return_state) 
            arg_return_state <= sl_to_arg_return_state ? 
                ASSIGN_ELEM2COMPARE : ASSIGN_ELEM2INSERT;
    end
end


// next state generation
always@ ( * ) begin
    case (state)
        WAIT_START: 
            gen_state <= start ? ASSIGN_I : WAIT_START;

        ASSIGN_I:
            gen_state <= OUTER_LOOP_CHECK;
        
        OUTER_LOOP_CHECK: 
            gen_state <= i_lt_arr_size ? READ_ARR_I : DONE;
        
        DONE:
            gen_state <= DONE;
        
        READ_ARR_I:
            gen_state <= READ_FUNCTION; 
        
        ASSIGN_ELEM2INSERT: 
            gen_state <= ASSIGN_J;
        
        ASSIGN_J:
            gen_state <= INNER_LOOP_CHECK;

        INNER_LOOP_CHECK:
            gen_state <= j_gte_0 ? READ_ARR_J : INC_I;
        
        READ_ARR_J:
            gen_state <= READ_FUNCTION; 
        
        ASSIGN_ELEM2COMPARE: 
            gen_state <= CHECK_IF_CORRECT_PLACE;

        CHECK_IF_CORRECT_PLACE: 
            gen_state <= elem2insert_gt_elem2compare ? 
                INC_I : SHIFT_ELEM2INSERT_LEFT;

        SHIFT_ELEM2INSERT_LEFT:
            gen_state <= WAIT_SUBMODULE_RETURN1;

        WAIT_SUBMODULE_RETURN1: 
            gen_state <= write_submodule_done ? 
                SHIFT_ELEM2COMPARE_RIGHT : WAIT_SUBMODULE_RETURN1;
        
        SHIFT_ELEM2COMPARE_RIGHT:
            gen_state <= write_submodule_b_resp ?
                WAIT_SUBMODULE_RETURN2 : ERR;
        
        WAIT_SUBMODULE_RETURN2: 
            gen_state <= write_submodule_done ? 
                DECRMT_J : WAIT_SUBMODULE_RETURN2;

        DECRMT_J:
            gen_state <= write_submodule_b_resp ? 
                INNER_LOOP_CHECK : ERR;
        
        INC_I: 
            gen_state <= OUTER_LOOP_CHECK;

        READ_FUNCTION: 
            gen_state <= WAIT_AR_READY;

        WAIT_AR_READY: 
            gen_state <= ar_ready ? 
                COMPLETE_AR : WAIT_AR_READY;

        COMPLETE_AR: 
            gen_state <= WAIT_R_VALID;
        
        WAIT_R_VALID: 
            gen_state <= r_valid ? 
                PROCESS_R_DATA_RESP : WAIT_R_VALID;

        PROCESS_R_DATA_RESP:
            gen_state <= r_resp ? 
                RETURN_READ_FN : ERR;
        
        ERR: 
            gen_state <= ERR;
        
        RETURN_READ_FN: 
            gen_state <= x;

        default:
            gen_state <= SWICH_CASE_DEFAULT;
    endcase
end

endmodule
