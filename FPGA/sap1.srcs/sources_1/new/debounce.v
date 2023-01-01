`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/27/2022 07:26:48 AM
// Design Name: 
// Module Name: debounce
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


module debounce(
    input clk,
    input sw_in,
    output sw_debounced
    );

parameter DEBOUNCE_TIME = 5000000;

reg [31:0] debounce_counter;
reg state;

always @(posedge clk) begin
    if (sw_in != state && debounce_counter < DEBOUNCE_TIME) begin
        debounce_counter <= debounce_counter + 1;
    end else if (debounce_counter == DEBOUNCE_TIME) begin
        state <= sw_in;
        debounce_counter <= 0;
    end else begin
        debounce_counter <= 0;
    end
end

assign sw_debounced = state;
endmodule
