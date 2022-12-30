`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/24/2022 10:33:40 PM
// Design Name: 
// Module Name: Register
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

//https://www.youtube.com/watch?v=sa1id9DIick
module Register(
    input clk,
    input reset,
    inout [7:0] DATA,
    output [7:0] REG_OUT,
    input latch,
    input enable
    );

reg [7:0] r;

always @(posedge clk) begin
    if (reset) begin
        r <= 0;
    end else begin
        if (latch) begin
            r <= DATA;
        end
    end
end

assign DATA = (enable)? r : 8'bZZZZZZZZ;
assign REG_OUT = r;

endmodule
