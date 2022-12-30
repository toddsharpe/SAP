`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/27/2022 07:23:06 PM
// Design Name: 
// Module Name: ProgramCounter
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


module ProgramCounter(
    input clk,
    input reset,
    inout [3:0] DATA,
    output [7:0] REG_OUT,
    input latch, //J - jump, PC in
    input enable, //CO - program counter out
    input inc //CE - count enable, increment,
    );

reg [3:0] r;

always @(posedge clk) begin
    if (reset) begin
        r <= 0;
    end else if (latch) begin
        r <= DATA;
    end else if (inc) begin
        r <= r + 1; //1 byte instructions
    end
end

assign DATA = (enable)? r : 8'bZZZZZZZZ;
assign REG_OUT = r;
endmodule
