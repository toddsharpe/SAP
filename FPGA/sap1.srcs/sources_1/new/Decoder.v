`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/27/2022 07:28:24 PM
// Design Name: 
// Module Name: Decoder
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

//TODO: make SV file or fix function
module Decoder(
    input [3:0] DATA,
    input [2:0] STEP,
    input C,
    input Z,
    output [15:0] DECODED_OUT,

    //Control signals
    output flags_latch,
    output pc_latch,
    output pc_enable,
    output pc_inc,
    output output_latch,
    output b_reg_latch,
    output alu_sub,
    output alu_enable,
    output a_reg_enable,
    output a_reg_latch,
    output ir_latch,
    output ir_enable,
    output ram_enable,
    output ram_latch,
    output mar_latch,
    output halt
    );

reg [15:0] microcode [0:512];

initial begin
    $display("Loading microcode.");
    $readmemb("ucode.mem", microcode);
end

wire [15:0] decoded;
assign decoded = microcode[{Z, C, DATA, STEP}];

assign flags_latch = decoded[0];    //FI
assign pc_latch = decoded[1];       //J
assign pc_enable = decoded[2];      //CO
assign pc_inc = decoded[3];         //CE
assign output_latch = decoded[4];   //OI
assign b_reg_latch = decoded[5];    //BI
assign alu_sub = decoded[6];        //SU
assign alu_enable = decoded[7];     //EO
assign a_reg_enable = decoded[8];   //AO
assign a_reg_latch = decoded[9];    //AI
assign ir_latch = decoded[10];      //II
assign ir_enable = decoded[11];     //IO
assign ram_enable = decoded[12];    //RO
assign ram_latch = decoded[13];     //RI
assign mar_latch = decoded[14];     //MI
assign halt = decoded[15];          //HLT

assign DECODED_OUT = decoded;

endmodule
