`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/27/2022 06:15:51 PM
// Design Name: 
// Module Name: RAM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RAM(
    input clk,
    input reset,
    input [3:0] ADDR,
    inout [7:0] DATA,
    output [7:0] DATA_OUT,
    input latch,
    input enable
    );

reg [7:0] ram [0:15];

initial begin
    $display("Loading RAM.");
    $readmemh("fib.mem", ram);
end

always @(posedge clk) begin
    if (reset) begin
        $readmemh("fib.mem", ram);
    end else begin
        if (latch) begin
            ram[ADDR] <= DATA;
        end
    end
end

assign DATA = (enable)? ram[ADDR] : 8'bZZZZZZZZ;
assign DATA_OUT = ram[ADDR];

endmodule
