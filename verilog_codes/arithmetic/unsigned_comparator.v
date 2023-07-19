`ifndef UNSIGNED_COMPARATOR_DEFINED
`define UNSIGNED_COMPARATOR_DEFINED


module unsigned_comparator #(parameter DATA_WDTH = 8) (
    input wire [DATA_WDTH-1:0] a,
    input wire [DATA_WDTH-1:0] b,
    output wire lt,
    output wire eq,
    output wire gt
);
    assign eq = (a == b);
    assign lt = (a < b);
    assign gt = (a > b);
endmodule

`endif
