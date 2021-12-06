`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:16:03 10/21/2021 
// Design Name: 
// Module Name:    P1_L0_string 
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
`define S0 2'b00
`define S1 2'b01
`define S2 2'b10
`define S3 2'b11
module string(
	input clk,
	input clr,
	input [7:0] in,
	output out
    );
	 
	reg [1:0] state;
	reg [1:0] next;
	
	initial begin
		state <= `S0;
	end
	
	wire ascii;
	assign ascii = (in=="*"||in=="+") ? 1 : 0;
	
	always @(*) begin
		case(state)
			`S0: next = ascii == 1 ? `S1 : `S2;
			`S1: next = `S1;
			`S2: next = ascii == 1 ? `S3 : `S1;
			`S3: next = ascii == 1 ? `S1 : `S2;
			default:;
		endcase
	end
	
	always @(posedge clk,posedge clr) begin
		if (clr == 1) begin
			state <= `S0;
		end
		else begin
			state <= next;
		end
	end
	
	assign out = state==`S2 ? 1 : 0;
	
endmodule
