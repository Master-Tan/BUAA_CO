`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    20:42:33 11/11/2021
// Design Name:
// Module Name:    PC
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
module F_PC(
        input wire eret_D,
        input wire [31:0] EPC,
        output wire ExcAdEL_F,
        input wire clk,
        input wire reset,
        input wire en,
        input wire [31:0] NPC,
        output reg [31:0] PC
);
    
    initial begin
        PC = 32'h0000_3000;
    end

    assign ExcAdEL_F = ((PC[1:0] != 0) | (PC < 32'h0000_3000) | (PC > 32'h0000_6FFF)) && (!eret_D);

    always @(posedge clk) begin
        if (reset == 1) begin
            PC <= 32'h0000_3000;
        end
        else begin
            if (en) begin
                PC <= eret_D ? EPC : NPC;
            end
        end
    end
    
endmodule
