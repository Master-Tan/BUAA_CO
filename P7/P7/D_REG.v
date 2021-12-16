`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    10:48:27 11/28/2021
// Design Name:
// Module Name:    D_REG
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
module D_REG(
        input wire [4:0] ExcCode_in,
        input wire bd_in,
        output reg [4:0] ExcCode_out,
        output reg bd_out,

        input wire Interrupt,
        input wire clk,
        input wire reset,
        input wire WE,
        input wire [31:0] IR_in,
        input wire [31:0] WPC_in,
        input wire [31:0] PC4_in,
        output reg [31:0] IR_out,
        output reg [31:0] WPC_out,
        output reg [31:0] PC4_out
);
    
    
    always @(posedge clk) begin
        if (reset | Interrupt) begin
            IR_out  <= 0;
            WPC_out <= Interrupt ? 32'h0000_4180 : 0;
            PC4_out <= Interrupt ? 32'h0000_4184 : 0;;
            ExcCode_out <= 0;
            bd_out  <= 0;
        end
        else begin
            if (WE) begin
                IR_out  <= IR_in;
                WPC_out <= WPC_in;
                PC4_out <= PC4_in;
                ExcCode_out <= ExcCode_in;
                bd_out  <= bd_in;
            end
        end
    end
    
endmodule
