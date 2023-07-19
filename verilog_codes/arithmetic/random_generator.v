`ifndef RANDOM_GENERATOR_DEFINED
`define RANDOM_GENERATOR_DEFINED
// written by chatGPT
module random_generator #(
    parameter DATA_WIDTH = 32
)(
    input wire clk,
    input wire rst_n,
    input wire enable,
    output reg [DATA_WIDTH-1:0] rnd
);

    // Random seed
    localparam RANDOM_SEED = 123456;
    reg [DATA_WIDTH-1:0] seed = RANDOM_SEED;

    // Pseudo-random number generation using a simple multiplication and modulo approach
    always @(posedge clk or negedge rst_n)  begin
        if (~rst_n)
            seed = RANDOM_SEED;
        else if (enable) begin
            seed <= seed * 1103515245 + 12345; // Commonly used coefficients
            rnd <= seed;
        end
    end

endmodule

`endif
