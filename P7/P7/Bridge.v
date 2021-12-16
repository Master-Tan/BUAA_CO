`timescale 1ns / 1ps
`default_nettype none

`define DEBUG_Timer_DATA 32'b0

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:20:10 12/11/2021 
// Design Name: 
// Module Name:    Bridge 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Bridge(
        input wire [31:0] PrAddr,
        input wire [31:0] PrWD,
        input wire [3:0] PrWE,
        inout wire [31:0] PrPC,
        output wire [31:0] PrRD,

        output wire [31:0] Timer_Addr,
        output wire [31:0] Timer_WD,
        input wire [31:0] Timer0_RD,
        input wire [31:0] Timer1_RD,
        output wire WeTimer0,
        output wire WeTimer1
    );

    wire HitTimer0;
    wire HitTimer1;

    //Timer0 00007F00-00007F0B 
    //Timer1 00007F10-00007F1B 
    assign HitTimer0 = (PrAddr[31:4] == 28'h0000_7F0);
    assign HitTimer1 = (PrAddr[31:4] == 28'h0000_7F1);

    assign PrRD = (HitTimer0) ? Timer0_RD :
                    (HitTimer1) ? Timer1_RD :
                    `DEBUG_Timer_DATA;

    assign WeTimer0 = (PrWE!=0) & HitTimer0;
    assign WeTimer1 = (PrWE!=0) & HitTimer1;

    assign Timer_Addr = PrAddr;
    assign Timer_WD = PrWD;

endmodule
