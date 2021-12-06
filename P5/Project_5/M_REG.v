`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    10:54:38 11/28/2021
// Design Name:
// Module Name:    M_REG
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
module M_REG(input wire clk,
             input wire reset,
             input wire WE,
             input wire [31:0] V2_in,
             input wire [31:0] AO_in,
             input wire [31:0] IR_in,
             input wire [31:0] E32_in,
             input wire [31:0] WPC_in,
             input wire [31:0] PC4_in,
             output reg [31:0] V2_out,
             output reg [31:0] AO_out,
             output reg [31:0] IR_out,
             output reg [31:0] E32_out,
             output reg [31:0] WPC_out,
             output reg [31:0] PC4_out);
    
    always @(posedge clk) begin
        if (reset) begin
            V2_out  <= 0;
            AO_out  <= 0;
            IR_out  <= 0;
            E32_out <= 0;
            WPC_out <= 0;
            PC4_out <= 0;
        end
        else begin
            if (WE) begin
                V2_out  <= V2_in;
                AO_out  <= AO_in;
                IR_out  <= IR_in;
                E32_out <= E32_in;
                WPC_out <= WPC_in;
                PC4_out <= PC4_in;
            end
        end
    end
    
    
endmodule
