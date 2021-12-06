`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:15:27 10/21/2021 
// Design Name: 
// Module Name:    P1_L1_BlockChecker 
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

`define S0 4'b0000
`define S1 4'b0001
`define S2 4'b0010
`define S3 4'b0011
`define S4 4'b0100
`define S5 4'b0101
`define S6 4'b0110
`define S7 4'b0111
`define S8 4'b1000
`define S9 4'b1001
`define S10 4'b1010
`define S11 4'b1100
`define S12 4'b1101

module BlockChecker(
	input wire clk,
	input wire reset,
	input wire [7:0] in,
	output wire result
    );
	 
	reg [31:0] cnt; 
	reg [3:0] state;
	reg [3:0] next;
	initial begin
		state <= `S12;
		cnt <= 32'b0;
	end
	
	always @(*) begin
		case(state)
			`S0: begin
				if (in==" ") next = `S12;
				else next = `S0;
			end
			`S1: begin
				if (in=="e"||in=="E") next = `S2;
				else if (in==" ") next = `S12;
				else next = `S0;
			end
			`S2: begin
				if (in=="g"||in=="G") next = `S3;
				else if (in==" ") next = `S12;
				else next = `S0;
			end
			`S3: begin
				if (in=="i"||in=="I") next = `S4;
				else if (in==" ") next = `S12;
				else next = `S0;
			end
			`S4: begin
				if (in=="n"||in=="N") next = `S5;
				else if (in==" ") next = `S12;
				else next = `S0;
			end
			`S5: begin
				if (in==" ") next = `S10;
				else next = `S0;
			end
			`S6: begin
				if (in=="n"||in=="N") next = `S7;
				else if (in==" ") next = `S12;
				else next = `S0;
			end
			`S7: begin
				if (in=="d"||in=="D") next = `S8;
				else if (in==" ") next = `S12;
				else next= `S0;
			end
			`S8: begin
				if (in==" " && cnt == 0) next = `S9;
				else if (in==" ")next = `S11;
				else next = `S0;
			end
			`S9: next = `S9;
			`S10: begin
				if (in=="b"||in=="B") next = `S1;
				else if (in=="e"||in=="E") next = `S6;
				else if (in==" ") next = `S12;
				else next = `S0;
			end
			`S11: begin
				if (in=="b"||in=="B") next = `S1;
				else if (in=="e"||in=="E") next = `S6;
				else if (in==" ") next = `S12;
				else next = `S0;
			end
			`S12: begin
				if (in=="b"||in=="B") next = `S1;
				else if (in=="e"||in=="E") next = `S6;
				else if (in==" ") next = `S12;
				else next = `S0;
			end
			default:;
		endcase
	end
		
	
	always @(posedge clk, posedge reset) begin
		if (reset == 1) begin
			state <= `S12;
			cnt <= 0;
		end
		else begin
			state <= next;
			if (next==`S10) begin 
				cnt <= cnt +1;
			end
			else if (next==`S11) begin
				cnt <= cnt -1;
			end
			else if (next==`S9) begin
				cnt <= 3'b111;
			end
			else cnt <= cnt;
		end
	end

assign result = (((state == `S8 && cnt == 1) || (cnt == 0 && state != `S8)) && (state != `S5)) ? 1 : 0;

endmodule
