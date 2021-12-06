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
module PC(input wire clk,
          input wire reset,
          input wire [31:0] NPC,
          output reg [31:0] PC);
    
    initial begin
        PC = 32'h0000_3000;
    end
    
    always @(posedge clk) begin
        if (reset == 1) begin
            PC <= 32'h0000_3000;
        end
        else begin
            PC <= NPC;
        end
    end
    
endmodule
