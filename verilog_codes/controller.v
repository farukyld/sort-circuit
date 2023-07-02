`define STATE_WDTH 6

module controller #(
    parameter ADDR_WDTH = 4,
    parameter DATA_WDTH = 32,
    parameter RESP_WDTH = 1)
(
    // Clock
    input wire clk,

    // Reset
    input wire rst_n,

    // User interface
    input wire start,
    output wire done,
    output wire error,

    // Memory interface
        // Read transaction
            // AR channel
    output wire ar_valid,
    input  wire ar_ready,
            // R channel
    input  wire r_valid,
    output wire r_ready,

        // Write transaction
            // AW channel
    output wire aw_valid,
    input  wire aw_ready,
            // W channel
    output wire w_valid,
    input  wire w_ready,
            // B channel
    input  wire b_valid,
    input wire [RESP_WDTH-1:0] b_resp,
    output wire b_ready,

    // From datapath (Comparison results)
    input wire elem2insert_gt_elem2compare,
    input wire j_gte_0,
    input wire i_lt_arr_size,

    // To datapath (Control signals)
        // About register i
    output wire sl_1_incd_to_i,
    output wire ld_i,

        // About register j
    output wire sl_i_minus_1_decrd_to_j,
    output wire ld_j,

        // About register elem2insert
    output wire ld_elem2insert,

        // About register elem2compare
    output wire ld_elem2compare,

        // About register arg_read_addr
    output wire sl_i_j_to_arg_read_addr,
    output wire ld_arg_read_addr,

        // about register return_read_data
    output wire ld_return_read_data,


        // About register arg_write_addr
    output wire sl_j_j_plus_1_to_arg_write_addr,
    output wire ld_arg_write_addr,

        // About register arg_write_data
    output wire sl_elem2insert_elem2compare_to_arg_write_data,
    output wire ld_arg_write_data
);


wire [1:0] sl_to_arg_return_state;
wire ld_arg_return_state;
reg [STATE_WDTH-1:0] arg_return_state;

wire sl_to_state;
reg [STATE_WDTH-1:0] state;
// The internal logic of the controller module goes here.
endmodule
