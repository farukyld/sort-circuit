`ifndef SUBSTRACTOR_DEFINED
`define SUBSTRACTOR_DEFINED

module substractor #(parameter WIDTH = 32) 
(
    input [WIDTH-1:0] minuend,substrahend,
    input borrow_in,
    output [WIDTH-1:0] difference,
    output borrow_out
);
    assign {borrow_out, difference} = a - b - borrow_in;
endmodule

`endif
