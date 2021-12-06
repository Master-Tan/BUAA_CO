`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:53:17 11/28/2021 
// Design Name: 
// Module Name:    Forward_MUX 
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
module Forward_MUX(
	input wire [31:0] RF_RD1,
	input wire [31:0] RF_RD2,
	input wire [31:0] V1_E,
	input wire [31:0] V2_E,
	input wire [31:0] V2_M,

    input wire [31:0] AO_M,
	input wire [31:0] M4,
	input wire [31:0] PC8_E,
	input wire [31:0] PC8_M,
	input wire [31:0] PC8_W,

	input wire [2:0] F_RS_sel,	
	input wire [2:0] F_RT_sel,	
	input wire [2:0] F_ALUA_Esel,
	input wire [2:0] F_ALUB_Esel,	
	input wire [2:0] F_WD_Msel,
     
	output reg[31:0] MF_RS_D,
    output reg[31:0] MF_RT_D,
    output reg[31:0] MF_ALUA_E,
    output reg[31:0] MF_ALUB_E,
    output reg[31:0] MF_WD_M
    );

	always@(*) begin

		MF_RS_D = 0;
		MF_RT_D = 0;
		MF_ALUA_E = 0;
		MF_ALUB_E = 0;
		MF_WD_M = 0;

		case(F_RS_sel) 
			3'b000: MF_RS_D = RF_RD1;
			3'b001: MF_RS_D = AO_M;
			3'b010: MF_RS_D = M4;
			3'b011: MF_RS_D = PC8_E;
			3'b100: MF_RS_D = PC8_M;
			3'b101: MF_RS_D = PC8_W;
			default : MF_RS_D = 0;
		endcase
		
		case(F_RT_sel) 
			3'b000: MF_RT_D = RF_RD2;
			3'b001: MF_RT_D = AO_M;
			3'b010: MF_RT_D = M4;
			3'b011: MF_RT_D = PC8_E;
			3'b100: MF_RT_D = PC8_M;
			3'b101: MF_RT_D = PC8_W;
			default : MF_RT_D = 0;
		endcase
		
		case(F_ALUA_Esel) 
			3'b000: MF_ALUA_E = V1_E;
			3'b001: MF_ALUA_E = AO_M;
			3'b010: MF_ALUA_E = M4;
			3'b011: MF_ALUA_E = 32'b0;
			3'b100: MF_ALUA_E = PC8_M;
			3'b101: MF_ALUA_E = PC8_W;
			default : MF_ALUA_E = 0;
		endcase
		
		case(F_ALUB_Esel) 
			3'b000: MF_ALUB_E = V2_E;
			3'b001: MF_ALUB_E = AO_M;
			3'b010: MF_ALUB_E = M4;
			3'b011: MF_ALUB_E = 32'b0;
			3'b100: MF_ALUB_E = PC8_M;
			3'b101: MF_ALUB_E = PC8_W;
			default : MF_ALUB_E = 0;
		endcase
		
		case(F_WD_Msel) 
			3'b000 : MF_WD_M = V2_M;
			3'b001 : MF_WD_M = 32'b0;
			3'b010 : MF_WD_M = M4;
			3'b011 : MF_WD_M = 32'b0;
			3'b100 : MF_WD_M = 32'b0;
			3'b101 : MF_WD_M = PC8_W;
			default : MF_WD_M = 0;
		endcase
	end
endmodule

