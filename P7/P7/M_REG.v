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
module M_REG(
        input wire [4:0] ExcCode_in,
        input wire bd_in,
        output reg [4:0] ExcCode_out,
        output reg bd_out,
        
        input wire ExcOvDM_in,
        output reg ExcOvDM_out,
        
        input wire Interrupt,
        input wire clk,
        input wire reset,
        input wire WE,
        input wire [31:0] V2_in,
        input wire [31:0] AO_in,
        input wire [31:0] IR_in,
        input wire [31:0] WPC_in,
        input wire [31:0] PC4_in,
        output reg [31:0] V2_out,
        output reg [31:0] AO_out,
        output reg [31:0] IR_out,
        output reg [31:0] WPC_out,
        output reg [31:0] PC4_out
);
    
    always @(posedge clk) begin
        if (reset | Interrupt) begin
            V2_out  <= 0;
            AO_out  <= 0;
            IR_out  <= 0;
            WPC_out <= Interrupt ? 32'h0000_4180 : 0;
            PC4_out <= Interrupt ? 32'h0000_4184 : 0;;
            ExcCode_out <= 0;
            bd_out  <= 0;
            ExcOvDM_out <= 0;
        end
        else begin
            if (WE) begin
                V2_out  <= V2_in;
                AO_out  <= AO_in;
                IR_out  <= IR_in;
                WPC_out <= WPC_in;
                PC4_out <= PC4_in;
                ExcCode_out <= ExcCode_in;
                bd_out  <= bd_in;
                ExcOvDM_out <= ExcOvDM_in; 
            end
        end
    end
    
    
endmodule
