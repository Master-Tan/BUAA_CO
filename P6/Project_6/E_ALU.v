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
module E_ALU(
        input wire [31:0] SrcA,
        input wire [31:0] SrcB,
        input wire [3:0] ALU_Control,
        output reg [31:0] ALU_Result
    );

always @(*) begin
    case(ALU_Control)
        4'b0000: ALU_Result = SrcA & SrcB;
        4'b0001: ALU_Result = SrcA | SrcB;
        4'b0010: ALU_Result = SrcA + SrcB;
        4'b0011: ALU_Result = SrcA ^ SrcB;
        4'b0100: ALU_Result = ~(SrcA | SrcB);
        4'b0101: ALU_Result = ($signed(SrcA)<$signed(SrcB)) ? 32'b1 : 32'b0;
        4'b0110: ALU_Result = SrcA - SrcB;
        4'b0111: ALU_Result = (SrcA < SrcB) ? 32'b1 : 32'b0;
        4'b1000: ALU_Result = SrcB; // lui
        4'b1001: ALU_Result = SrcB << SrcA[4:0];
        4'b1010: ALU_Result = SrcB >> SrcA[4:0];
        4'b1011: ALU_Result = $signed($signed(SrcB) >>> SrcA[4:0]);
        4'b1100: ALU_Result = 32'b0;
        4'b1101: ALU_Result = 32'b0;
        4'b1110: ALU_Result = 32'b0;
        4'b1111: ALU_Result = 32'b0;
    endcase
end

endmodule
