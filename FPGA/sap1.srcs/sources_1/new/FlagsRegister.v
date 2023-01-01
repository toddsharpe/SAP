`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/30/2022 06:47:09 AM
// Design Name: 
// Module Name: FlagsRegister
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


module FlagsRegister(
    input clk,
    input reset,
    output [7:0] REG_OUT,
    input c_in,
    input z_in,
    input latch,
    output c_out,
    output z_out
    );

reg [1:0] flags;

always @(posedge clk) begin
    if (reset) begin
        flags <= 0;
    end else begin
        if (latch) begin
            flags = {c_in, z_in};
        end
    end
end

assign {c_out, z_out} = flags;
assign REG_OUT = {c_out, z_out};

endmodule
