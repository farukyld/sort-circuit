module datapath #(
    parameter ADDR_WDTH = 4,
    parameter DATA_WDTH = 32,
    parameter RESP_WDTH = 1)
(
    // Clock
    input wire clk;

    // reset
    input wire rst_n;

    input wire [ADDR_WDTH-1:0] arr_size;
    // Memory interface
        // Read transaction
            // AR channel
    output wire [ADDR_WDTH-1:0] ar_address,
            // R channel
    input  wire [DATA_WDTH-1:0] r_data,

        // Write transaction
            // AW channel
    output wire [ADDR_WDTH-1:0] aw_address,
            // W channel
    output wire [DATA_WDTH-1:0] w_data,

    // control signals. 
    // inputs are used to instruct the registers, muxes etc. to 
    // realize the operations done in the c code
    // outputs are used to tell the controller the result of the
    // comparison operations.

    // comparison results
    output wire elem2insert_gt_elem2compare,
    output wire j_gte_0,
    output wire i_lt_arr_size,

    // about register i
    input wire sl_1_incd_to_i, // select 1 or incremented to i.
    input wire ld_i,

    // about register j
    input wire sl_i_minus_1_decrd_to_j, 
        // select i-1 or decremented j to j. 
    input wire ld_j,

    // about register elem2insert
    input wire ld_elem2insert, // loads value from array read.

    // about register elem2compare
    input wire ld_elem2compare, // loads value from array read.

    // about register arg_read_addr
    input wire sl_i_j_to_arg_read_addr, // select i or j to register arg_read_addr.
    input wire ld_arg_read_addr,


    // about register arg_write_addr
    input wire sl_j_j_plus_1_to_arg_write_addr, 
        // select j or j+1 to register arg_write_addr
    input wire ld_arg_write_addr,


    // about register arg_write_data
    input wire sl_elem2insert_elem2compare_to_arg_write_data,
        // select elem2insert or elem2compare to register arg_write_data
    input wire ld_arg_write_data,
)

    // I used ADDR_WDTH not ADDR_WDTH-1 consciously
    reg [ADDR_WDTH:0] r_i;
    reg [ADDR_WDTH:0] r_j;
    
    reg [DATA_WDTH-1:0] r_elem2insert;
    reg [DATA_WDTH-1:0] r_elem2compare;


    // read process registers
    reg [ADDR_WDTH-1:0] r_arg_read_addr;
    reg [DATA_WDTH-1:0] r_return_read_data;
    
    // write process registers
    reg [ADDR_WDTH-1:0] r_arg_write_addr;
    reg [DATA_WDTH-1:0] r_arg_write_data;




    // operations
    // Coming soon

endmodule