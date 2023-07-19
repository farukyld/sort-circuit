
// written by chatGPT
module random_generator #(
    parameter DATA_WIDTH = 32
)(
    input wire clk,
    input wire enable,
    output reg [DATA_WIDTH-1:0] rnd
);

    // Random seed
    reg [DATA_WIDTH-1:0] seed = 123456;

    // Pseudo-random number generation using a simple multiplication and modulo approach
    always @(posedge clk) begin
        if (enable) begin
            seed <= seed * 1103515245 + 12345; // Commonly used coefficients
            rnd <= seed;
        end
    end

endmodule
