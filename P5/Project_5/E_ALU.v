`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    20:49:14 11/11/2021
// Design Name:
// Module Name:    ALU
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
module E_ALU(input wire [31:0] SrcA,
           input wire [31:0] SrcB,
           input wire [2:0] ALU_Control,
           output reg [31:0] ALU_Result);

always @(*) begin
    case(ALU_Control)
        3'b000: ALU_Result = SrcA & SrcB;
        3'b001: ALU_Result = SrcA | SrcB;
        3'b010: ALU_Result = SrcA + SrcB;
        3'b011: ALU_Result = 32'b0;
        3'b100: ALU_Result = 32'b0;
        3'b101: ALU_Result = 32'b0;
        3'b110: ALU_Result = SrcA - SrcB;
        3'b111: ALU_Result = 32'b0;
    endcase
end

endmodule
