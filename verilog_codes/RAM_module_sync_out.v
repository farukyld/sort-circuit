`ifndef RAM_MODULE_SYNC_OUT_DEFINED
`define RAM_MODULE_SYNC_OUT_DEFINED

module RAM_module_sync_out #(
    parameter ADDR_WDTH = 4,
    parameter DATA_WDTH = 32
)(
    input clk,
    input rst_n,
    input wr_enable,
    input rd_enable,
    input [ADDR_WDTH-1:0] address,
    input signed [DATA_WDTH-1:0] wr_data,
    output reg signed [DATA_WDTH-1:0] rd_data
);

reg signed [DATA_WDTH-1:0] RAM [0:2**ADDR_WDTH-1]; 

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        rd_data <= 0; // reset data
    else begin 
        if(rd_enable)
            rd_data <= RAM[address]; // read from RAM
        if(wr_enable) begin
            RAM[address] <= wr_data; // write to RAM
        end

    end
end

integer i;

initial begin
	$readmemb("initial_ram_state.mem", RAM);
    $display("ram read");
    for (i = 0; i < 2**ADDR_WDTH; i = i + 1) begin
        $display("RAM[%0d] = %0d", i, RAM[i]);
    end
end


endmodule

`endif
