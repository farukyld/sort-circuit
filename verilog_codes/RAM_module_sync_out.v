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
    input [DATA_WDTH-1:0] wr_data,
    output reg [DATA_WDTH-1:0] rd_data
);

reg [DATA_WDTH-1:0] RAM [2**ADDR_WDTH-1:0]; 

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        rd_data <= 0; // reset data
    else begin 
        if(rd_enable)
            rd_data <= RAM[address]; // read from RAM
        if(wr_enable)
            RAM[address] <= wr_data; // write to RAM
    end
end

initial begin
	$readmemb("initial_ram_state.mem", RAM);
end


endmodule

`endif
