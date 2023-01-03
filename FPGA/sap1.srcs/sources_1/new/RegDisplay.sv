`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2022 09:19:21 PM
// Design Name: 
// Module Name: RegDisplay
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


module RegDisplay
    #(parameter REG_COUNT = 2) (
    input clk,
    input incBtn,
    input decBtn,
    input [7:0] reg_outs[0:REG_COUNT-1],
    output [15:0] led_out
    );

    wire inc_pressed;
    wire dec_pressed;

    button_pressed incBtn_pressed(
        .clk(clk),
        .button(incBtn),
        .pressed(inc_pressed)
    );

    button_pressed decBtn_pressed(
        .clk(clk),
        .button(decBtn),
        .pressed(dec_pressed)
    );

    reg [7:0] index = 0;
    always @(posedge clk)
    begin
        if (inc_pressed && (index < REG_COUNT - 1)) begin
            index = index + 1;
        end

        if (dec_pressed && (index > 0)) begin
            index = index - 1;
        end
    end

    assign led_out[15:8] = index;
    assign led_out[7:0] = reg_outs[index];

endmodule
