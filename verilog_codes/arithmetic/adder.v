`ifndef ADDER_DEFINED
`define ADDER_DEFINED
module adder #(parameter WIDTH = 32) 
(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input carry_in,
    output [WIDTH-1:0] sum,
    output carry_out
);
    assign {carry_out, sum} = a + b + carry_in;
endmodule

`endif
