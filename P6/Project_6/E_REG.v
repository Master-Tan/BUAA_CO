`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    10:51:57 11/28/2021
// Design Name:
// Module Name:    E_REG
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
module E_REG(input wire clk,
             input wire reset,
             input wire WE,
             input wire clr,
             input wire [31:0] V1_in,
             input wire [31:0] V2_in,
             input wire [31:0] IR_in,
             input wire [31:0] E32_in,
             input wire [31:0] WPC_in,
             input wire [31:0] PC4_in,
             output reg [31:0] V1_out,
             output reg [31:0] V2_out,
             output reg [31:0] IR_out,
             output reg [31:0] E32_out,
             output reg [31:0] WPC_out,
             output reg [31:0] PC4_out);
    
    always @(posedge clk) begin
        if (reset || clr) begin
            V1_out  <= 0;
            V2_out  <= 0;
            IR_out  <= 0;
            E32_out <= 0;
            WPC_out <= 0;
            PC4_out <= 0;
        end
        else begin
            if (WE) begin
                V1_out  <= V1_in;
                V2_out  <= V2_in;
                IR_out  <= IR_in;
                E32_out <= E32_in;
                WPC_out <= WPC_in;
                PC4_out <= PC4_in;
            end
        end
    end
    
endmodule
