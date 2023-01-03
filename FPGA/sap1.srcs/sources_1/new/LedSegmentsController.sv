`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/22/2022 07:45:31 AM
// Design Name: 
// Module Name: LedSegmentsController
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



module LedSegmentsController(
        input clk,
        input [15:0] value,
        output [3:0] an,
        output [6:0] seg
    );
    
    reg [19:0] refresh_counter;
    always @(posedge clk)
    begin 
        refresh_counter <= refresh_counter + 1;
    end
    
    function [3:0] NibSelect(input [15:0] value, input logic[1:0] phase);
        begin
            case(phase)
            2'b00: return value[15:12]; 
            2'b01: return value[11:8]; 
            2'b10: return value[7:4]; 
            2'b11: return value[3:0]; 
            endcase
        end
    endfunction : NibSelect;
    
    function [3:0] AnSelect(input logic[1:0] phase);
        begin
            case(phase)
            2'b00: return 4'b0111;
            2'b01: return 4'b1011;
            2'b10: return 4'b1101;
            2'b11: return 4'b1110;
            endcase
        end
    endfunction : AnSelect;

    //https://www.geeksforgeeks.org/seven-segment-displays/
    //0 is lit up, 1 isn't (common annode)
    function [6:0] LedOut(input logic[3:0] b);
        begin
            case(b)
            4'b0000: return 7'b1000000; // "0"
            4'b0001: return 7'b1111001; // "1"
            4'b0010: return 7'b0100100; // "2"
            4'b0011: return 7'b0110000; // "3"
            4'b0100: return 7'b0011001; // "4"
            4'b0101: return 7'b0010010; // "5"
            4'b0110: return 7'b0000010; // "6"
            4'b0111: return 7'b1111000; // "7"
            4'b1000: return 7'b0000000; // "8"
            4'b1001: return 7'b0010000; // "9"
            4'b1010: return 7'b0001000; // "A"
            4'b1011: return 7'b0000011; // "B"
            4'b1100: return 7'b1000110; // "C"
            4'b1101: return 7'b0100001; // "D"
            4'b1110: return 7'b0000110; // "E"
            4'b1111: return 7'b0001110; // "F"
            endcase
        end
    endfunction : LedOut
    
    wire [1:0] phase = refresh_counter[19:18];
    wire [3:0] nib = NibSelect(value, phase);

    assign an = AnSelect(phase);
    assign seg = LedOut(nib);
endmodule
