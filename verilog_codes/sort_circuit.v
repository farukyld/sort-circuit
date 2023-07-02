module sort_circuit #(
    parameter ADDR_WDTH = 4,
    parameter DATA_WDTH = 32,
    parameter RESP_WDTH = 1)
(
    // Clock
    input wire clk,

    // Reset
    input wire rst_n,

    // User interface
    input wire [ADDR_WDTH-1:0] arr_size,
    input wire start,
    output wire done,
    output wire error,

    // Memory interface
        // Read transaction
            // AR channel
    output wire ar_valid,
    input  wire ar_ready,
    output wire [ADDR_WDTH-1:0] ar_address,
            // R channel
    input  wire r_valid,
    output wire r_ready,
    input wire [RESP_WDTH-1:0] r_resp,
    input  wire [DATA_WDTH-1:0] r_data,

        // Write transaction
            // AW channel
    output wire aw_valid,
    input  wire aw_ready,
    output wire [ADDR_WDTH-1:0] aw_address,
            // W channel
    output wire w_valid,
    input  wire w_ready,
    output wire [DATA_WDTH-1:0] w_data
);

    // Inter-module signals
    wire sl_1_incd_to_i, ld_i;
    wire sl_i_minus_1_decrd_to_j, ld_j;
    wire ld_elem2insert;
    wire ld_elem2compare;
    wire sl_i_j_to_arg_read_addr, ld_arg_read_addr;
    wire ld_return_read_data;
    wire sl_j_j_plus_1_to_arg_write_addr, ld_arg_write_addr;
    wire sl_elem2insert_elem2compare_to_arg_write_data, ld_arg_write_data;
    wire elem2insert_gt_elem2compare, j_gte_0, i_lt_arr_size;

    // Instantiate datapath
    datapath #(
        .ADDR_WDTH(ADDR_WDTH),
        .DATA_WDTH(DATA_WDTH),
        .RESP_WDTH(RESP_WDTH)
    ) dp (
        .clk(clk),
        .rst_n(rst_n),
        .arr_size(arr_size),

        // Memory interface
            // Read transaction
        .ar_address(ar_address),
        .r_data(r_data),

            // Write transaction
        .aw_address(aw_address),
        .w_data(w_data),

        // Comparison results
        .elem2insert_gt_elem2compare(elem2insert_gt_elem2compare),
        .j_gte_0(j_gte_0),
        .i_lt_arr_size(i_lt_arr_size),

        // Control signals
            // Register i
        .sl_1_incd_to_i(sl_1_incd_to_i),
        .ld_i(ld_i),

            // Register j
        .sl_i_minus_1_decrd_to_j(sl_i_minus_1_decrd_to_j),
        .ld_j(ld_j),

            // Register elem2insert
        .ld_elem2insert(ld_elem2insert),

            // Register elem2compare
        .ld_elem2compare(ld_elem2compare),

            // Register arg_read_addr
        .sl_i_j_to_arg_read_addr(sl_i_j_to_arg_read_addr),
        .ld_arg_read_addr(ld_arg_read_addr),

            // Register return_read_data
        .ld_return_read_data(ld_return_read_data),

            // Register arg_write_addr
        .sl_j_j_plus_1_to_arg_write_addr(sl_j_j_plus_1_to_arg_write_addr),
        .ld_arg_write_addr(ld_arg_write_addr),

            // Register arg_write_data
        .sl_elem2insert_elem2compare_to_arg_write_data(sl_elem2insert_elem2compare_to_arg_write_data),
        .ld_arg_write_data(ld_arg_write_data)
    );

    // Instantiate controller
    controller #(
        .ADDR_WDTH(ADDR_WDTH),
        .DATA_WDTH(DATA_WDTH),
        .RESP_WDTH(RESP_WDTH)
    ) ctrl (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .done(done),
        .error(error),

        // Memory interface
            // Read transaction
        .ar_valid(ar_valid),
        .ar_ready(ar_ready),
        .r_valid(r_valid),
        .r_ready(r_ready),
        .r_resp(r_resp),

            // Write transaction
        .aw_valid(aw_valid),
        .aw_ready(aw_ready),
        .w_valid(w_valid),
        .w_ready(w_ready),

        // Comparison results
        .elem2insert_gt_elem2compare(elem2insert_gt_elem2compare),
        .j_gte_0(j_gte_0),
        .i_lt_arr_size(i_lt_arr_size),

        // Control signals
            // Register i
        .sl_1_incd_to_i(sl_1_incd_to_i),
        .ld_i(ld_i),

            // Register j
        .sl_i_minus_1_decrd_to_j(sl_i_minus_1_decrd_to_j),
        .ld_j(ld_j),

            // Register elem2insert
        .ld_elem2insert(ld_elem2insert),

            // Register elem2compare
        .ld_elem2compare(ld_elem2compare),

            // Register arg_read_addr
        .sl_i_j_to_arg_read_addr(sl_i_j_to_arg_read_addr),
        .ld_arg_read_addr(ld_arg_read_addr),

            // Register return_read_data
        .ld_return_read_data(ld_return_read_data),

            // Register arg_write_addr
        .sl_j_j_plus_1_to_arg_write_addr(sl_j_j_plus_1_to_arg_write_addr),
        .ld_arg_write_addr(ld_arg_write_addr),

            // Register arg_write_data
        .sl_elem2insert_elem2compare_to_arg_write_data(sl_elem2insert_elem2compare_to_arg_write_data),
        .ld_arg_write_data(ld_arg_write_data)
    );

endmodule
