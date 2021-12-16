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
             output reg b_jump);


always @(*) begin
    case(type)
        `B_beq: begin
            if(D1 == D2) begin
                b_jump = 1;
            end
            else begin
                b_jump = 0;
            end
        end
        `B_bne: begin
            if(D1 != D2) begin
                b_jump = 1;
            end
            else begin
                b_jump = 0;
            end
        end
        `B_blez: begin
            if($signed(D1) <= 0) begin
                b_jump = 1;
            end
            else begin
                b_jump = 0;
            end
        end
        `B_bgtz: begin
            if($signed(D1) > 0) begin
                b_jump = 1;
            end
            else begin
                b_jump = 0;
            end
        end
        `B_bltz: begin
            if($signed(D1) < 0) begin
                b_jump = 1;
            end
            else begin
                b_jump = 0;
            end
        end
        `B_bgez: begin
            if($signed(D1) >= 0) begin
                b_jump = 1;
            end
            else begin
                b_jump = 0;
            end
        end
    endcase
end


endmodule
