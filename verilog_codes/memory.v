module memory #(
    parameter ADDR_WDTH = 4,
    parameter DATA_WDTH = 32,
    parameter RESP_WDTH = 1)
(
    // Clock
    input wire clk,
    input wire rst_n,

    // Memory interface
        // Read transaction
            // AR channel
    input  wire ar_valid,
    output wire ar_ready,
    input  wire [ADDR_WDTH-1:0] ar_address,
            // R channel
    output wire r_valid,
    input  wire r_ready,
    output wire [RESP_WDTH-1:0] r_resp,
    output wire [DATA_WDTH-1:0] r_data,

        // Write transaction
            // AW channel
    input  wire aw_valid,
    output wire aw_ready,
    input  wire [ADDR_WDTH-1:0] aw_address,
            // W channel
    input  wire w_valid,
    output wire w_ready,
    input  wire [DATA_WDTH-1:0] w_data
);

    // Memory module logic here
    // ...

endmodule
