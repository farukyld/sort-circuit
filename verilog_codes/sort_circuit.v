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

// Connections to controller
// Coming soon...

// Connections to datapath
// Coming soon...

endmodule
