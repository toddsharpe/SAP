`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/27/2022 07:30:49 AM
// Design Name: 
// Module Name: button_pulse
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


module button_pulse(
    input clk,
    input button,
    output reg pulse
    );

reg q;

always @(posedge button or posedge pulse) begin
    if (pulse) begin
        q <= 0;
    end else begin
        q <= 1;
    end
end

always @(posedge clk) begin
    pulse <= q;
end

endmodule