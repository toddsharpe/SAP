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

    //SAP1 Input
    wire cpu_clk;
    wire reset;

    //SAP1 Output
    wire [2:0] step;
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
    wire halt;

    //SAP1
    Sap1 sap1(
        .clk(cpu_clk),
        .reset(reset),
        .step(step),
        .w_bus(w_bus),
        .a_reg_out(a_reg_out),
        .b_reg_out(b_reg_out),
        .flags_out(flags_out),
        .output_reg_out(output_reg_out),
        .pc_reg_out(pc_reg_out),
        .memaddr_reg_out(memaddr_reg_out),
        .instruction_reg_out(instruction_reg_out),
        .ram_out(ram_out),
        .decoded_out(decoded_out),
        .halt(halt)
    );

    //VIO
    vio_sap1 vio (
        .clk(clk),                          // input wire clk
        .probe_in0(step),                   // input wire [2 : 0] probe_in0
        .probe_in1(w_bus),                  // input wire [7 : 0] probe_in1
        .probe_in2(a_reg_out),              // input wire [7 : 0] probe_in2
        .probe_in3(b_reg_out),              // input wire [7 : 0] probe_in3
        .probe_in4(flags_out),              // input wire [7 : 0] probe_in4
        .probe_in5(output_reg_out),         // input wire [7 : 0] probe_in5
        .probe_in6(pc_reg_out),             // input wire [7 : 0] probe_in6
        .probe_in7(memaddr_reg_out),        // input wire [7 : 0] probe_in7
        .probe_in8(instruction_reg_out),    // input wire [7 : 0] probe_in8
        .probe_in9(ram_out),                // input wire [7 : 0] probe_in9
        .probe_in10(decoded_out),           // input wire [15 : 0] probe_in10
        .probe_in11(halt)                   // input wire [0 : 0] probe_in11
    );

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
    assign reset = sw15;
    assign led = halt ? {16'hFFFF} : (reset ? {16'h0000} : decoded_out);

endmodule


