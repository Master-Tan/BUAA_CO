`timescale 1ns / 1ps
`default_nettype none
`include "const.v"
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    10:51:29 11/28/2021
// Design Name:
// Module Name:    D_NPC
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
module D_NPC(input wire [31:0] PC_F,
             input wire [31:0] PC4_D,
             input wire [15:0] I16,
             input wire [25:0] I26,
             input wire [2:0] D_NPC_sel,
             input wire b_jump,
             output reg [31:0] NPC_out);

    wire [31:0] PC_D;
    assign PC_D = PC4_D - 4;
    always @(*) begin
        case(D_NPC_sel)
            `BR_addr: begin
                NPC_out = {PC_D[31:28], I26, 2'b0};
            end
            `BR_branch: begin
                if(b_jump) begin
                    NPC_out = PC_D + 4 + {{14{I16[15]}}, I16, 2'b0};
                end
                else begin
                    NPC_out = PC_F + 4;
                end
            end
            default: NPC_out = PC_F + 4;
        endcase
    end

    
endmodule
