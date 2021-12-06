`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:12:08 10/21/2021 
// Design Name: 
// Module Name:    P1_L0_EXT 
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
module ext(
	input [15:0] imm,
	input [1:0] EOp,
	output reg [31:0] ext
    );
	always @(*) begin
		case(EOp)
			0: ext = ($signed(imm))<0?{{16{1'b1}},imm}:{{16{1'b0}},imm};
			1: ext = {{16{1'b0}},imm};
			2:	ext = {imm,{16{1'b0}}};
			3: begin
				ext = ($signed(imm))<0?{{16{1'b1}},imm}:{{16{1'b0}},imm};
				ext = ext << 2;
			end
			default:;
		endcase
	end

endmodule
