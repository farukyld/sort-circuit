module sort_circuit #(
    parameter ADDR_WDTH = 4,
    parameter DATA_WDTH = 32,
    parameter RESP_WDTH = 1)
(
    // Clock
    input wire clk,

    // User interface    
    input wire rst_n,
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
    input  wire [DATA_WDTH-1:0] r_data,
    input  wire [RESP_WDTH-1:0] r_resp,

        // Write transaction
            // AW channel
    output wire aw_valid,
    input  wire aw_ready,
    output wire [ADDR_WDTH-1:0] aw_address,
            // W channel
    output wire w_valid,
    input  wire w_ready,
    output wire [DATA_WDTH-1:0] w_data,
            // B channel
    input  wire b_valid,
    input  wire [RESP_WDTH-1:0] b_resp,
    output wire b_ready
);


    // Signals for inter-module communication
    wire sl_1_incd_to_i, ld_i, clr_i;
    wire sl_i_minus_1_decrd_to_j, ld_j, clr_j;
    wire ld_elem2insert, clr_elem2insert;
    wire ld_elem2compare, clr_elem2compare;
    wire sl_i_j_to_arr_ra;
    wire sl_j_j_plus_1_to_arr_wa;
    wire sl_elem2insert_elem2compare_to_arr_w;
    wire elem2insert_gt_elem2compare, j_gte_0, i_lt_arr_size;

    // Instantiate datapath
    datapath #(
        .ADDR_WDTH(ADDR_WDTH),
        .DATA_WDTH(DATA_WDTH),
        .RESP_WDTH(RESP_WDTH)
    ) dp (
        .clk(clk),

        // user interface
        .rst_n(rst_n),
        .arr_size(arr_size),

        // read transaction
        .ar_address(ar_address),
        .r_data(r_data),
        
        // write transaction
        .aw_address(aw_address),
        .w_data(w_data),
        
        // comparison results
        .elem2insert_gt_elem2compare(elem2insert_gt_elem2compare),
        .j_gte_0(j_gte_0),
        .i_lt_arr_size(i_lt_arr_size),
        
        // control reg i
        .sl_1_incd_to_i(sl_1_incd_to_i),
        .ld_i(ld_i),
        .clr_i(clr_i),
        
        // control reg j
        .sl_i_minus_1_decrd_to_j(sl_i_minus_1_decrd_to_j),
        .ld_j(ld_j),
        .clr_j(clr_j),
        
        // control reg elem2insert
        .ld_elem2insert(ld_elem2insert),
        .clr_elem2insert(clr_elem2insert),
        
        // control reg elem2compare
        .ld_elem2compare(ld_elem2compare),
        .clr_elem2compare(clr_elem2compare),
        
        // control read address
        .sl_i_j_to_arr_ra(sl_i_j_to_arr_ra),
        
        // control write address
        .sl_j_j_plus_1_to_arr_wa(sl_j_j_plus_1_to_arr_wa),
        
        // control write data
        .sl_elem2insert_elem2compare_to_arr_w(sl_elem2insert_elem2compare_to_arr_w)
    );

    // Instantiate controller
    controller #(
        .ADDR_WDTH(ADDR_WDTH),
        .DATA_WDTH(DATA_WDTH),
        .RESP_WDTH(RESP_WDTH)
    ) ctrl (
        .clk(clk),

        // user interface
        .rst_n(rst_n),
        .start(start),
        .done(done),
        .error(error),
        
        // read transaction
            // read address
        .ar_valid(ar_valid),
        .ar_ready(ar_ready),

            // read data
        .r_valid(r_valid),
        .r_ready(r_ready),
        
        // write transaction
            // write address
        .aw_valid(aw_valid),
        .aw_ready(aw_ready),

            // write data
        .w_valid(w_valid),
        .w_ready(w_ready),
        
            // write response
        .b_valid(b_valid),
        .b_resp(b_resp),
        .b_ready(b_ready),
        
        // comparison results
        .elem2insert_gt_elem2compare(elem2insert_gt_elem2compare),
        .j_gte_0(j_gte_0),
        .i_lt_arr_size(i_lt_arr_size),
        
        // control reg i
        .sl_1_incd_to_i(sl_1_incd_to_i),
        .ld_i(ld_i),
        .clr_i(clr_i),
        
        // control reg j
        .sl_i_minus_1_decrd_to_j(sl_i_minus_1_decrd_to_j),
        .ld_j(ld_j),
        .clr_j(clr_j),
        
        // control reg elem2insert
        .ld_elem2insert(ld_elem2insert),
        .clr_elem2insert(clr_elem2insert),
        
        // control reg elem2compare
        .ld_elem2compare(ld_elem2compare),
        .clr_elem2compare(clr_elem2compare),
        
        // control read address
        .sl_i_j_to_arr_ra(sl_i_j_to_arr_ra),
        
        // control write address
        .sl_j_j_plus_1_to_arr_wa(sl_j_j_plus_1_to_arr_wa),
        
        // control write data
        .sl_elem2insert_elem2compare_to_arr_w(sl_elem2insert_elem2compare_to_arr_w)
    );



endmodule
