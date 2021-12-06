`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:33:46 10/21/2021 
// Design Name: 
// Module Name:    P1_L0_gray 
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
module gray(
	input Clk,
	input Reset,
	input En,
	output reg [2:0] Output,
	output reg Overflow
    );
	reg [2:0] out1,out2;
	integer i;
	initial begin
		out1 <= 1;
		Overflow <= 0;
		Output <= 3'b000;
	end
	always @(*) begin
		out2 = {out1[2],out1[2:1]^out1[1:0]};
		
	end
	always @(posedge Clk) begin
		if (Reset==1) begin
			Output <= 3'b000;
			Overflow <= 1'b0;
			out1 <= 1;
		end
		else if (En == 1) begin
			Output <= out2;
			if (Output == 3'b100) Overflow <= 1'b1; 
			out1 <= out1 +1;
		end
	end
endmodule
