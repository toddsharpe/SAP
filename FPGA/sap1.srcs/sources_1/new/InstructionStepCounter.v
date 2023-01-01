`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/30/2022 06:56:33 AM
// Design Name: 
// Module Name: InstructionStepCounter
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


module InstructionStepCounter(
    input clk,
    input reset,
    output [2:0] STEP
    );

reg [2:0] step;

always @(posedge clk) begin
    if (reset) begin
        step <= 0;
    end else begin
        step <= step + 1;
    end
end

assign STEP = step;

endmodule
