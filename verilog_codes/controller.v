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
reg [STATE_WDTH-1:0] current_state;

localparam WAIT_START = 4'd0;
localparam OUTER_LOOP_CHECK = 4'd1;
localparam DONE = 4'd2;
localparam INNER_LOOP_CHECK = 4'd3;
localparam DECRMT_J = 4'd4;
localparam INC_I = 4'd5;
localparam ASSIGN_I = 4'd6;
localparam ASSIGN_J = 4'd7;
localparam WAIT_AR_READY = 4'd8;
localparam WAIT_R_VALID = 4'd9;
localparam ERR = 4'd10;
localparam COMPLETE_AR = 4'd11;
localparam READ_FUNCTION = 4'd12;
localparam PROCESS_R_DATA_RESP = 4'd13;
localparam RETURN_READ_FN = 4'd14;
localparam READ_ARR_J = 4'd15;
localparam READ_ARR_I = 4'd16;
localparam ASSIGN_ELEM2INSERT = 4'd17;
localparam ASSIGN_ELEM2COMPARE = 4'd18;
localparam CHECK_IF_CORRECT_PLACE = 4'd19;
localparam WAIT_SUBMODULE_RETURN1 = 4'd20;
localparam SHIFT_ELEM2INSERT_LEFT = 4'd21;
localparam WAIT_SUBMODULE_RETURN2 = 4'd22;
localparam SHIFT_ELEM2COMPARE_RIGHT = 4'd23;
localparam SWICH_CASE_DEFAULT = 4'd24;


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
	is_cs_shift_elem2compare_right;
	is_cs_swich_case_default;


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
ld_return_read_data = is_cs_process_r_data_resp;
sl_j_plus_1_to_write_addr = is_cs_shift_elem2compare_right;
sl_elem2compare_to_write_data = is_cs_shift_elem2compare_right;
sl_incd_to_i = is_cs_inc_i;
ld_i = is_cs_inc_i | is_cs_assign_i;
sl_decrd_to_j = is_cs_decrmt_j;
ld_j = is_cs_decrmt_j | is_cs_assign_j;
ld_elem2insert = is_cs_assign_elem2insert;
ld_elem2compare = is_cs_assign_elem2compare;
sl_j_to_arg_read_addr = is_cs_read_arr_j;
ld_arg_read_addr = is_cs_read_arr_i | is_cs_read_arr_j;
write_submodule_start = is_cs_shift_elem2compare_right | is_cs_shift_elem2insert_left;
r_ready = is_cs_complete_ar | is_cs_wait_r_valid;
ar_valid = is_cs_read_function | is_cs_wait_ar_ready;
done = is_cs_done;
error = is_cs_err;

// internal control logic
sl_to_arg_return_state = is_cs_read_arr_j;
ld_arg_return_state = is_cs_read_arr_i | is_cs_read_arr_j;
sl_to_state = is_cs_return_read_fn;


// state transition logic
always@ (posedge clk or negedge rst_n) begin
    if (!rst_n)
        // Insert reset logic here
    else
        case (state)
            WAIT_START: begin
                // Insert logic here
            end
            
            OUTER_LOOP_CHECK: begin
                // Insert logic here
            end
            
            DONE: begin
                // Insert logic here
            end
            
            INNER_LOOP_CHECK: begin
                // Insert logic here
            end
            
            DECRMT_J: begin
                // Insert logic here
            end
            
            INC_I: begin
                // Insert logic here
            end
            
            ASSIGN_I: begin
                // Insert logic here
            end
            
            ASSIGN_J: begin
                // Insert logic here
            end
            
            WAIT_AR_READY: begin
                // Insert logic here
            end
            
            WAIT_R_VALID: begin
                // Insert logic here
            end
            
            ERR: begin
                // Insert logic here
            end
            
            COMPLETE_AR: begin
                // Insert logic here
            end
            
            READ_FUNCTION: begin
                // Insert logic here
            end
            
            PROCESS_R_DATA_RESP: begin
                // Insert logic here
            end
            
            RETURN_READ_FN: begin
                // Insert logic here
            end
            
            READ_ARR_J: begin
                // Insert logic here
            end
            
            READ_ARR_I: begin
                // Insert logic here
            end
            
            ASSIGN_ELEM2INSERT: begin
                // Insert logic here
            end
            
            ASSIGN_ELEM2COMPARE: begin
                // Insert logic here
            end
            
            CHECK_IF_CORRECT_PLACE: begin
                // Insert logic here
            end
            
            WAIT_SUBMODULE_RETURN1: begin
                // Insert logic here
            end
            
            SHIFT_ELEM2INSERT_LEFT: begin
                // Insert logic here
            end
            
            WAIT_SUBMODULE_RETURN2: begin
                // Insert logic here
            end
            
            SHIFT_ELEM2COMPARE_RIGHT: begin
                // Insert logic here
            end

            default: begin
                // Optional: handle unexpected state
            end
        endcase
end



endmodule
    