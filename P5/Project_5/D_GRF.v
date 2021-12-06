`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    20:57:19 11/11/2021
// Design Name:
// Module Name:    GRF
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
module D_GRF(input wire [4:0] A1,
           input wire [4:0] A2,
           input wire [4:0] A3,
           input wire [31:0] WD,
           output wire [31:0] RD1,
           output wire [31:0] RD2,
           input wire clk,
           input wire reset,
           input wire WE,
           input wire [31:0] WPC);

reg [31:0] rf [0:31];

// 读取
assign RD1 = rf[A1];
assign RD2 = rf[A2];


// 写入
integer i;

always @(posedge clk) begin
    if (reset == 1) begin
        for(i = 0;i<32;i = i+1) begin
            rf[i] <= 32'b0;
        end
    end
    else begin
        if (WE == 1 && A3 != 0) begin
            rf[A3]             <= WD;
            $display("%d@%h: $%d <= %h", $time, WPC, A3, WD);
        end
    end
end


endmodule
