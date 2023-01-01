`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/27/2022 07:32:02 AM
// Design Name: 
// Module Name: button_pressed
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


module button_pressed(
    input clk,
    input button,
    output pressed
    );

wire button_debounce;
wire pulse;

debounce debounce(
    .clk(clk),
    .sw_in(button),
    .sw_debounced(button_debounce)
    );

button_pulse button_pulse(
    .clk(clk),
    .button(button_debounce),
    .pulse(pulse)
    );

assign pressed = pulse;
endmodule
