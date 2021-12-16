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
module D_EXT(input wire [15:0] imm16,
           input wire [1:0] EXTop,
           output reg [31:0] ext_imm16);


always @(*) begin
    case(EXTop)
        2'b00: ext_imm16 = {{16{1'b0}},imm16[15:0]};
        2'b01: ext_imm16 = {{16{imm16[15]}},imm16[15:0]};
        2'b10: ext_imm16 = {imm16[15:0],{16{1'b0}}};
    endcase
end


endmodule
