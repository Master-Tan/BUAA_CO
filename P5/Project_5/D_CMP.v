`timescale 1ns / 1ps
`include "const.v"
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    10:47:37 11/28/2021
// Design Name:
// Module Name:    D_CMP
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
module D_CMP(input wire [31:0] D1,
             input wire [31:0] D2,
             input wire [2:0] type,
             output wire b_jump);


wire equal = (D1 == D2);
// 可添加不同判断条件和控制线路

assign b_jump = (type == `B_beq && equal);//或起来即可


endmodule
