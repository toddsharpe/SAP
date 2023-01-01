`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/31/2022 06:17:59 PM
// Design Name: 
// Module Name: InstructionRegister
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

//Will only put the 4 LSB on the bus.
module InstructionRegister(
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

assign DATA = (enable)? {4'b0000, r[3:0]} : 8'bZZZZZZZZ;
assign REG_OUT = r;

endmodule
