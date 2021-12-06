`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    12:21:24 11/28/2021
// Design Name:
// Module Name:    W_REG
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
module W_REG(input wire clk,
             input wire reset,
             input wire WE,
             input wire [31:0] IR_in,
             input wire [31:0] AO_in,
             input wire [31:0] DR_in,
             input wire [31:0] WPC_in,
             input wire [31:0] PC4_in,
             output reg [31:0] IR_out,
             output reg [31:0] AO_out,
             output reg [31:0] DR_out,
             output reg [31:0] WPC_out,
             output reg [31:0] PC4_out);
    
    always @(posedge clk) begin
        if (reset) begin
            IR_out  <= 0;
            AO_out  <= 0;
            DR_out  <= 0;
            WPC_out <= 0;
            PC4_out <= 0;
        end
        else begin
            if (WE) begin
                IR_out  <= IR_in;
                AO_out  <= AO_in;
                DR_out  <= DR_in;
                WPC_out <= WPC_in;
                PC4_out <= PC4_in;
            end
        end
    end
    
    
endmodule
