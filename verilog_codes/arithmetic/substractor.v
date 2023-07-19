`ifndef SUBSTRACTOR_DEFINED
`define SUBSTRACTOR_DEFINED

module substractor #(parameter DATA_WDTH = 32) 
(
    input [DATA_WDTH-1:0] minuend,substrahend,
    input borrow_in,
    output [DATA_WDTH-1:0] difference,
    output borrow_out
);
    assign {borrow_out, difference} = minuend - substrahend - borrow_in;
endmodule

`endif
