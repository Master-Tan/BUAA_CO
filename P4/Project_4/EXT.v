`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    20:56:22 11/11/2021
// Design Name:
// Module Name:    EXT
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
module EXT(input wire [15:0] imm16,
           input wire EXTop,
           output wire [31:0] ext_imm16);

assign ext_imm16 = (EXTop == 1'b0) ? {{16{1'b0}},imm16[15:0]} :
{{16{imm16[15]}},imm16[15:0]};


endmodule
