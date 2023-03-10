`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/02/2023 05:03:06 PM
// Design Name: 
// Module Name: Sap1
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


module Sap1(
    input clk,
    input reset,

    //SAP
    output [2:0] step,
    output [7:0] w_bus,
    output [7:0] a_reg_out,
    output [7:0] b_reg_out,
    output [7:0] flags_out,
    output [7:0] output_reg_out,
    output [7:0] pc_reg_out,
    output [7:0] memaddr_reg_out,
    output [7:0] instruction_reg_out,
    output [7:0] ram_out,
    output [15:0] decoded_out,
    output halt
    );

    //Decoder wires
    wire alu_C;
    wire alu_Z;
    wire flags_C;
    wire flags_Z;

    //Control signals (provided by microcode)
    wire flags_latch;   //FI
    wire pc_latch;      //J
    wire pc_enable;     //CO
    wire pc_inc;        //CE
    wire output_latch;  //OI
    wire b_reg_latch;   //BI
    wire alu_sub;       //SU
    wire alu_enable;    //EO
    wire a_reg_enable;  //AO
    wire a_reg_latch;   //AI
    wire ir_latch;      //II
    wire ir_enable;     //IO
    wire ram_enable;    //RO
    wire ram_latch;     //RI
    wire mar_latch;     //MI

    Register a_reg(
        .clk(clk),
        .reset(reset),
        .DATA(w_bus),
        .REG_OUT(a_reg_out),
        .latch(a_reg_latch),
        .enable(a_reg_enable)
    );

    Register b_reg(
        .clk(clk),
        .reset(reset),
        .DATA(w_bus),
        .REG_OUT(b_reg_out),
        .latch(b_reg_latch),
        .enable(8'b00000000)
    );

    ALU alu(
        .a_reg_data(a_reg_out),
        .b_reg_data(b_reg_out),
        .DATA(w_bus),
        .enable(alu_enable),
        .sub(alu_sub),
        .C(alu_C),
        .Z(alu_Z)
    );

    FlagsRegister flags(
        .clk(clk),
        .reset(reset),
        .REG_OUT(flags_out),
        .c_in(alu_C),
        .z_in(alu_Z),
        .latch(flags_latch),
        .c_out(flags_C),
        .z_out(flags_Z)
    );

    Register output_reg(
        .clk(clk),
        .reset(reset),
        .DATA(w_bus),
        .REG_OUT(output_reg_out),
        .latch(output_latch),
        .enable(8'b00000000)
    );

    ProgramCounter pc(
        .clk(clk),
        .reset(reset),
        .DATA(w_bus[3:0]),
        .REG_OUT(pc_reg_out),
        .latch(pc_latch),
        .enable(pc_enable),
        .inc(pc_inc)
    );

    Register memaddr_reg(
        .clk(clk),
        .reset(reset),
        .DATA(w_bus),
        .REG_OUT(memaddr_reg_out),
        .latch(mar_latch),
        .enable()
    );

    RAM ram(
        .clk(clk),
        .reset(reset),
        .ADDR(memaddr_reg_out[3:0]),
        .DATA(w_bus),
        .DATA_OUT(ram_out),
        .latch(ram_latch),
        .enable(ram_enable)
    );

    InstructionRegister instruction_reg(
        .clk(clk),
        .reset(reset),
        .DATA(w_bus),
        .REG_OUT(instruction_reg_out),
        .latch(ir_latch),
        .enable(ir_enable)
    );

    InstructionStepCounter counter(
        .clk(clk),
        .reset(reset),
        .STEP(step)
    );

    Decoder decoder(
        .DATA(instruction_reg_out[7:4]),
        .STEP(step),
        .C(flags_C),
        .Z(flags_Z),
        .DECODED_OUT(decoded_out),
        .flags_latch(flags_latch),
        .pc_latch(pc_latch),
        .pc_enable(pc_enable),
        .pc_inc(pc_inc),
        .output_latch(output_latch),
        .b_reg_latch(b_reg_latch),
        .alu_sub(alu_sub),
        .alu_enable(alu_enable),
        .a_reg_enable(a_reg_enable),
        .a_reg_latch(a_reg_latch),
        .ir_latch(ir_latch),
        .ir_enable(ir_enable),
        .ram_enable(ram_enable),
        .ram_latch(ram_latch),
        .mar_latch(mar_latch),
        .halt(halt)
    );

endmodule
