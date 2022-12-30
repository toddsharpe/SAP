`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/27/2022 06:04:22 AM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [7:0] a_reg_data,
    input [7:0] b_reg_data,
    inout [7:0] DATA,
    input enable,
    input sub,
    output C, 
    output Z
    );

wire [8:0] alu_plus = a_reg_data + b_reg_data;
wire [8:0] alu_minus = a_reg_data - b_reg_data;

wire [7:0] alu_result;
assign {C, alu_result} = (sub)? alu_minus : alu_plus;
assign Z = ({C, alu_result} == 9'd0) ? 1'b1 : 1'b0;

assign DATA = (enable)? alu_result : 8'bZZZZZZZZ;

endmodule
