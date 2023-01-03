`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/21/2022 05:21:09 AM
// Design Name: 
// Module Name: main
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


module main(
    input clk,
    input btnC,
    input btnU,
    input btnD,
    input [4:0] sw,
    input sw15,
    output [3:0] an,
    output [6:0] seg,
    output [15:0] led
    );

    //SAP
    wire reset;
    wire [7:0] w_bus;
    wire [7:0] a_reg_out;
    wire [7:0] b_reg_out;
    wire [7:0] flags_out;
    wire [7:0] output_reg_out;
    wire [7:0] pc_reg_out;
    wire [7:0] memaddr_reg_out;
    wire [7:0] instruction_reg_out;
    wire [7:0] ram_out;
    wire [15:0] decoded_out;

    //Decoder wires
    wire [2:0] step;
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
    wire halt;          //HLT

    //Display
    wire [15:0] led_out;

    RegDisplay #(.REG_COUNT(10)) regDisplay(
        .clk(clk),
        .incBtn(btnU),
        .decBtn(btnD),
        .reg_outs(
            {
                output_reg_out,         //0
                step,                   //1
                pc_reg_out,             //2
                instruction_reg_out,    //3
                w_bus,                  //4
                a_reg_out,              //5
                b_reg_out,              //6
                flags_out,              //7
                memaddr_reg_out,        //8
                ram_out                 //9
            }),
        .led_out(led_out));
    
    LedSegmentsController segDisplay(.clk(clk), .value(led_out), .an(an), .seg(seg));

    //Clocks
    wire manual_clk;
    wire clk_8hz;
    wire clk_16hz;
    wire clk_32hz;
    wire clk_64hz;
    wire clk_128hz;
    wire cpu_clk;

    button_pressed btnC_pressed(
        .clk(clk),
        .button(btnC),
        .pressed(manual_clk)
    );

    clock_divider #(.FREQ(8)) clk_8(
        .clk(clk),
        .reset(),
        .clk_div(clk_8hz)
    );

    clock_divider #(.FREQ(16)) clk_16(
        .clk(clk),
        .reset(),
        .clk_div(clk_16hz)
    );

    clock_divider #(.FREQ(32)) clk_32(
        .clk(clk),
        .reset(),
        .clk_div(clk_32hz)
    );

    clock_divider #(.FREQ(64)) clk_64(
        .clk(clk),
        .reset(),
        .clk_div(clk_64hz)
    );

    clock_divider #(.FREQ(128)) clk_128(
        .clk(clk),
        .reset(),
        .clk_div(clk_128hz)
    );

    assign cpu_clk = (sw[4] ? clk_128hz : 
                        (sw[3] ? clk_64hz : 
                            (sw[2] ? clk_32hz : 
                                (sw[1] ? clk_16hz : 
                                    (sw[0] ? clk_8hz :
                                        manual_clk))))) & (~halt | reset);

    Register a_reg(
        .clk(cpu_clk),
        .reset(reset),
        .DATA(w_bus),
        .REG_OUT(a_reg_out),
        .latch(a_reg_latch),
        .enable(a_reg_enable)
    );

    Register b_reg(
        .clk(cpu_clk),
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
        .clk(cpu_clk),
        .reset(reset),
        .REG_OUT(flags_out),
        .c_in(alu_C),
        .z_in(alu_Z),
        .latch(flags_latch),
        .c_out(flags_C),
        .z_out(flags_Z)
    );

    Register output_reg(
        .clk(cpu_clk),
        .reset(reset),
        .DATA(w_bus),
        .REG_OUT(output_reg_out),
        .latch(output_latch),
        .enable(8'b00000000)
    );

    ProgramCounter pc(
        .clk(cpu_clk),
        .reset(reset),
        .DATA(w_bus[3:0]),
        .REG_OUT(pc_reg_out),
        .latch(pc_latch),
        .enable(pc_enable),
        .inc(pc_inc)
    );

    Register memaddr_reg(
        .clk(cpu_clk),
        .reset(reset),
        .DATA(w_bus),
        .REG_OUT(memaddr_reg_out),
        .latch(mar_latch),
        .enable()
    );

    RAM ram(
        .clk(cpu_clk),
        .reset(reset),
        .ADDR(memaddr_reg_out[3:0]),
        .DATA(w_bus),
        .DATA_OUT(ram_out),
        .latch(ram_latch),
        .enable(ram_enable)
    );

    InstructionRegister instruction_reg(
        .clk(cpu_clk),
        .reset(reset),
        .DATA(w_bus),
        .REG_OUT(instruction_reg_out),
        .latch(ir_latch),
        .enable(ir_enable)
    );

    InstructionStepCounter counter(
        .clk(cpu_clk),
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

    //Update LEDs
    assign reset = sw15;
    assign led = halt ? {16'hFFFF} : (reset ? {16'h0000} : decoded_out);

endmodule


