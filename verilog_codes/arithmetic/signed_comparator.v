`ifndef SIGNED_COMPARATOR_DEFINED
`define SIGNED_COMPARATOR_DEFINED

module signed_comparator #(parameter DATA_WIDTH = 8) (
    input wire signed [DATA_WIDTH-1:0] a,
    input wire signed [DATA_WIDTH-1:0] b,
    output wire lt,
    output wire eq,
    output wire gt
);
    assign eq = (a == b);
    assign lt = (a < b);
    assign gt = (a > b);
endmodule

`endif
