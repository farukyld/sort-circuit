`ifndef TB_DEFINED
`define TB_DEFINED

`include "sort_circuit.v"
`include "memory.v"


module tb_;

reg clk;
reg rst_n;

// Define the width of the parameters
parameter ADDR_WDTH = 4;
parameter DATA_WDTH = 32;
parameter RESP_WDTH = 1;

// Define the external signals
reg always_success;
reg always_error;
reg [ADDR_WDTH:0] arr_size;
reg start;

wire done;
wire err;

// Interconnect signals
wire ar_valid;
wire ar_ready;
wire [ADDR_WDTH-1:0] ar_address;

wire r_valid;
wire r_ready;
wire [DATA_WDTH-1:0] r_data;
wire [RESP_WDTH-1:0] r_resp;

wire aw_valid;
wire aw_ready;
wire [ADDR_WDTH-1:0] aw_address;

wire [DATA_WDTH-1:0] w_data;
wire w_valid;
wire w_ready;

wire b_valid;
wire b_ready;
wire [RESP_WDTH-1:0] b_resp;

wire switch_case_default_memory;
wire switch_case_default_sorter;


// Instantiate the sort_circuit module
sort_circuit #(
    .ADDR_WDTH(ADDR_WDTH),
    .DATA_WDTH(DATA_WDTH),
    .RESP_WDTH(RESP_WDTH)
) sort_circuit_inst (
    .clk(clk),
    .rst_n(rst_n),
    .arr_size(arr_size),
    .start(start),
    .done(done),
    .err(err),
    .ar_ready(ar_ready),
    .ar_address(ar_address),
    .ar_valid(ar_valid),
    .r_data(r_data),
    .r_resp(r_resp),
    .r_valid(r_valid),
    .r_ready(r_ready),
    .aw_ready(aw_ready),
    .aw_address(aw_address),
    .aw_valid(aw_valid),
    .w_data(w_data),
    .w_valid(w_valid),
    .w_ready(w_ready),
    .b_valid(b_valid),
    .b_resp(b_resp),
    .b_ready(b_ready),
    .swich_case_default(switch_case_default_sorter)
);

// Instantiate the memory module
memory #(
    .ADDR_WDTH(ADDR_WDTH),
    .DATA_WDTH(DATA_WDTH),
    .RESP_WDTH(RESP_WDTH)
) memory_inst (
    .clk(clk),
    .rst_n(rst_n),
    .always_success(always_success),
    .always_error(always_error),
    .ar_ready(ar_ready),
    .ar_address(ar_address),
    .ar_valid(ar_valid),
    .r_data(r_data),
    .r_resp(r_resp),
    .r_valid(r_valid),
    .r_ready(r_ready),
    .aw_ready(aw_ready),
    .aw_address(aw_address),
    .aw_valid(aw_valid),
    .w_data(w_data),
    .w_valid(w_valid),
    .w_ready(w_ready),
    .b_valid(b_valid),
    .b_resp(b_resp),
    .b_ready(b_ready),
    .swich_case_default(switch_case_default_memory)
);


localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk = ~clk;

initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb_);
end

integer i;

initial begin
    #1 rst_n<=1'bx;clk<=1'bx;
    #(CLK_PERIOD*3) rst_n<=1;
    always_success <= 1'b1;
    always_error <= 1'b0;
    arr_size <= 'd16;
    #(CLK_PERIOD*3) rst_n<=0;clk<=0;
    repeat(5) @(posedge clk);
    rst_n<=1;
    start <= 1;

    @(posedge clk);
    
    @(posedge done or posedge switch_case_default_memory or posedge switch_case_default_sorter);
    #5
    $display("after sort");
    for (i =0;i<16;i = i + 1)
        $display(memory_inst.ram.RAM[i]);

    $finish(2);
end

endmodule

`endif
