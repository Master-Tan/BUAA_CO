`timescale 1ns / 1ps
`default_nettype none

`define SIZE 4096
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    20:54:25 11/11/2021
// Design Name:
// Module Name:    IM
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
module F_IM(
    input wire [31:0] PC,
    output wire [31:0] Instr);

reg [31:0] im [0:`SIZE-1];

integer i;

initial begin
    for(i = 0;i<`SIZE;i = i + 1) begin
        im[i] = 32'h00000000;
    end
    $readmemh("code.txt",im);
end

wire [31:0] real_PC;
assign real_PC = PC - 32'h3000;

assign Instr = im[real_PC[13:2]];

endmodule
