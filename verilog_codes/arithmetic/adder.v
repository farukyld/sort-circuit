`ifndef ADDER_DEFINED
`define ADDER_DEFINED
module adder #(parameter DATA_WDTH = 32) 
(
    input [DATA_WDTH-1:0] a,
    input [DATA_WDTH-1:0] b,
    input carry_in,
    output [DATA_WDTH-1:0] sum,
    output carry_out
);
    assign {carry_out, sum} = a + b + carry_in;
endmodule

`endif
