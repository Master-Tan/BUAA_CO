`include "const.v"

`timescale 1ns / 1ps
`default_nettype none

`define opcode 31:26
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define funct 5:0
`define i16 15:0
`define i26 25:0

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:45:00 11/29/2021 
// Design Name: 
// Module Name:    Hazard_Unit 
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
module Hazard_Unit(
		input wire clk,
    	input wire reset,
        input wire [31:0] IR_D,
	    input wire [31:0] IR_E,
	    input wire [31:0] IR_M,
	    input wire [31:0] IR_W,
		input wire start,
		input wire Busy,
	    output wire StallF,
	    output wire StallD,
	    output wire FlushE,
	    output wire [2:0] F_RS_sel,	
	    output wire [2:0] F_RT_sel,
	    output wire [2:0] F_ALUA_Esel,	
	    output wire [2:0] F_ALUB_Esel,	
	    output wire [2:0] F_WD_Msel
    );

wire cal_r_D, cal_r_E, cal_r_M, cal_r_W;
wire cal_i_D, cal_i_E, cal_i_M, cal_i_W;
wire load_D, load_E, load_M, load_W;
wire store_D, store_E, store_M, store_W;
wire b_D, b_E, b_M, b_W;
wire jal_D, jal_E, jal_M, jal_W;
wire jalr_D, jalr_E, jalr_M, jalr_W;
wire jr_D, jr_E, jr_M, jr_W;
wire mf_D, mf_E, mf_M, mf_W;
wire mfc0_D, mfc0_E, mfc0_M, mfc0_W;
wire mtc0_D, mtc0_E, mtc0_M, mtc0_W;

assign cal_r_D = (IR_D[`opcode]==`OP_rtype & IR_D[`funct]!=`FUNC_jalr & IR_D[`funct]!=`FUNC_jr & IR_D!=0);
assign cal_r_E = (IR_E[`opcode]==`OP_rtype & IR_E[`funct]!=`FUNC_jalr & IR_E[`funct]!=`FUNC_jr & IR_E!=0);
assign cal_r_M = (IR_M[`opcode]==`OP_rtype & IR_M[`funct]!=`FUNC_jalr & IR_M[`funct]!=`FUNC_jr & IR_M!=0);
assign cal_r_W = (IR_W[`opcode]==`OP_rtype & IR_W[`funct]!=`FUNC_jalr & IR_W[`funct]!=`FUNC_jr & IR_W!=0);

assign cal_i_D = (IR_D[`opcode]==`OP_ori | IR_D[`opcode]==`OP_addi | IR_D[`opcode]==`OP_addiu | IR_D[`opcode]==`OP_andi | IR_D[`opcode]==`OP_xori | IR_D[`opcode]==`OP_slti | IR_D[`opcode]==`OP_lui | IR_D[`opcode]==`OP_sltiu);
assign cal_i_E = (IR_E[`opcode]==`OP_ori | IR_E[`opcode]==`OP_addi | IR_E[`opcode]==`OP_addiu | IR_E[`opcode]==`OP_andi | IR_E[`opcode]==`OP_xori | IR_E[`opcode]==`OP_slti | IR_E[`opcode]==`OP_lui | IR_E[`opcode]==`OP_sltiu);
assign cal_i_M = (IR_M[`opcode]==`OP_ori | IR_M[`opcode]==`OP_addi | IR_M[`opcode]==`OP_addiu | IR_M[`opcode]==`OP_andi | IR_M[`opcode]==`OP_xori | IR_M[`opcode]==`OP_slti | IR_M[`opcode]==`OP_lui | IR_M[`opcode]==`OP_sltiu);
assign cal_i_W = (IR_W[`opcode]==`OP_ori | IR_W[`opcode]==`OP_addi | IR_W[`opcode]==`OP_addiu | IR_W[`opcode]==`OP_andi | IR_W[`opcode]==`OP_xori | IR_W[`opcode]==`OP_slti | IR_W[`opcode]==`OP_lui | IR_W[`opcode]==`OP_sltiu);

assign load_D = (IR_D[`opcode]==`OP_lw | IR_D[`opcode]==`OP_lb | IR_D[`opcode]==`OP_lbu | IR_D[`opcode]==`OP_lh | IR_D[`opcode]==`OP_lhu);
assign load_E = (IR_E[`opcode]==`OP_lw | IR_E[`opcode]==`OP_lb | IR_E[`opcode]==`OP_lbu | IR_E[`opcode]==`OP_lh | IR_E[`opcode]==`OP_lhu);
assign load_M = (IR_M[`opcode]==`OP_lw | IR_M[`opcode]==`OP_lb | IR_M[`opcode]==`OP_lbu | IR_M[`opcode]==`OP_lh | IR_M[`opcode]==`OP_lhu);
assign load_W = (IR_W[`opcode]==`OP_lw | IR_W[`opcode]==`OP_lb | IR_W[`opcode]==`OP_lbu | IR_W[`opcode]==`OP_lh | IR_W[`opcode]==`OP_lhu);

assign store_D = (IR_D[`opcode]==`OP_sw | IR_D[`opcode]==`OP_sh | IR_D[`opcode]==`OP_sb);
assign store_E = (IR_E[`opcode]==`OP_sw | IR_E[`opcode]==`OP_sh | IR_E[`opcode]==`OP_sb);
assign store_M = (IR_M[`opcode]==`OP_sw | IR_M[`opcode]==`OP_sh | IR_M[`opcode]==`OP_sb);
assign store_W = (IR_W[`opcode]==`OP_sw | IR_W[`opcode]==`OP_sh | IR_W[`opcode]==`OP_sb);

assign b_D = (IR_D[`opcode]==`OP_beq | IR_D[`opcode]==`OP_bne | IR_D[`opcode]==`OP_blez | IR_D[`opcode]==`OP_bgtz | (IR_D[`opcode]==6'b000001&&(IR_D[`rt]==`RT_bltz | IR_D[`rt]==`RT_bgez)));
assign b_E = (IR_E[`opcode]==`OP_beq | IR_E[`opcode]==`OP_bne | IR_E[`opcode]==`OP_blez | IR_E[`opcode]==`OP_bgtz | (IR_E[`opcode]==6'b000001&&(IR_E[`rt]==`RT_bltz | IR_E[`rt]==`RT_bgez)));
assign b_M = (IR_M[`opcode]==`OP_beq | IR_M[`opcode]==`OP_bne | IR_M[`opcode]==`OP_blez | IR_M[`opcode]==`OP_bgtz | (IR_M[`opcode]==6'b000001&&(IR_M[`rt]==`RT_bltz | IR_M[`rt]==`RT_bgez)));
assign b_W = (IR_W[`opcode]==`OP_beq | IR_W[`opcode]==`OP_bne | IR_W[`opcode]==`OP_blez | IR_W[`opcode]==`OP_bgtz | (IR_W[`opcode]==6'b000001&&(IR_W[`rt]==`RT_bltz | IR_W[`rt]==`RT_bgez)));

assign jal_D = (IR_D[`opcode]==`OP_jal);
assign jal_E = (IR_E[`opcode]==`OP_jal);
assign jal_M = (IR_M[`opcode]==`OP_jal);
assign jal_W = (IR_W[`opcode]==`OP_jal);

assign jalr_D = (IR_D[`opcode]==`OP_rtype & IR_D[`funct]==`FUNC_jalr);
assign jalr_E = (IR_E[`opcode]==`OP_rtype & IR_E[`funct]==`FUNC_jalr);
assign jalr_M = (IR_M[`opcode]==`OP_rtype & IR_M[`funct]==`FUNC_jalr);
assign jalr_W = (IR_W[`opcode]==`OP_rtype & IR_W[`funct]==`FUNC_jalr);

assign jr_D = (IR_D[`opcode]==`OP_rtype & IR_D[`funct]==`FUNC_jr);
assign jr_E = (IR_E[`opcode]==`OP_rtype & IR_E[`funct]==`FUNC_jr);
assign jr_M = (IR_M[`opcode]==`OP_rtype & IR_M[`funct]==`FUNC_jr);
assign jr_W = (IR_W[`opcode]==`OP_rtype & IR_W[`funct]==`FUNC_jr);

assign mfc0_D = (IR_D[31:21]==`OP_mfc0);
assign mfc0_E = (IR_E[31:21]==`OP_mfc0);
assign mfc0_M = (IR_M[31:21]==`OP_mfc0);
assign mfc0_W = (IR_W[31:21]==`OP_mfc0);

assign mtc0_D = (IR_D[31:21]==`OP_mtc0);
assign mtc0_E = (IR_E[31:21]==`OP_mtc0);
assign mtc0_M = (IR_M[31:21]==`OP_mtc0);
assign mtc0_W = (IR_W[31:21]==`OP_mtc0);

//暂停
wire stall_b,stall_cal_r,stall_cal_i,stall_load,stall_store,stall_jr,stall_jalr,stall_busy,stall_eret;

assign stall_b = (b_D & cal_r_E & (IR_D[`rs]==IR_E[`rd] | IR_D[`rt]==IR_E[`rd])) | 
						(b_D & cal_i_E & (IR_D[`rs]==IR_E[`rt] | IR_D[`rt]==IR_E[`rt])) | 
						(b_D & (load_E | mfc0_E) & (IR_D[`rs]==IR_E[`rt] | IR_D[`rt]==IR_E[`rt])) | 
						(b_D & (load_M | mfc0_M) & (IR_D[`rs]==IR_M[`rt] | IR_D[`rt]==IR_M[`rt]));
assign stall_cal_r = cal_r_D & (load_E | mfc0_E) & (IR_D[`rs]==IR_E[`rt] | IR_D[`rt]==IR_E[`rt]);
assign stall_cal_i = cal_i_D & (load_E | mfc0_E) & IR_D[`rs]==IR_E[`rt];
assign stall_load = load_D & (load_E | mfc0_E) & IR_D[`rs]==IR_E[`rt];
assign stall_store = store_D & (load_E | mfc0_E) & IR_D[`rs]==IR_E[`rt];
assign stall_jr = (jr_D & cal_r_E & IR_D[`rs]==IR_E[`rd]) | 
					(jr_D & cal_i_E & IR_D[`rs]==IR_E[`rt]) | 
					(jr_D & (load_E | mfc0_E) & IR_D[`rs]==IR_E[`rt]) | 
					(jr_D & (load_M | mfc0_M) & IR_D[`rs]==IR_M[`rt]);
assign stall_jalr =  (jalr_D & cal_r_E & IR_D[`rs]==IR_E[`rd]) | 
					(jalr_D & cal_i_E & IR_D[`rs]==IR_E[`rt]) | 
					(jalr_D & (load_E | mfc0_E) & IR_D[`rs]==IR_E[`rt]) | 
					(jalr_D & (load_M | mfc0_M) & IR_D[`rs]==IR_M[`rt]);
assign stall_busy = (IR_D[`opcode]==`OP_rtype & (IR_D[`funct]==`FUNC_mult | IR_D[`funct]==`FUNC_multu | IR_D[`funct]==`FUNC_div | IR_D[`funct]==`FUNC_divu | 
					IR_D[`funct]==`FUNC_mtlo | IR_D[`funct]==`FUNC_mthi | IR_D[`funct]==`FUNC_mfhi | IR_D[`funct]==`FUNC_mflo)) & (Busy | start);

assign stall_eret = (IR_D==`OP_eret) & ((IR_E[31:21]==`OP_mtc0 & (IR_E[`rd] == 5'd14)) || (IR_M[31:21]==`OP_mtc0 & (IR_M[`rd] == 5'd14)));

wire stall;							
assign stall = stall_b | stall_cal_r | stall_cal_i | stall_load | stall_store | stall_jr | stall_jalr | stall_busy | stall_eret;

assign StallF = stall;
assign StallD = stall;
assign FlushE = stall;

//转发
wire RS_D, RT_D, RS_E, RT_E, RT_M;

assign RS_D = (cal_r_D | cal_i_D | load_D | store_D | b_D  | (IR_D[`opcode]==`OP_rtype & (IR_D[`funct]==`FUNC_jr | IR_D[`funct]==`FUNC_jalr)));
assign RT_D = (cal_r_D | store_D | b_D | mtc0_D);
assign RS_E = (cal_r_E | cal_i_E | load_E | store_E);
assign RT_E = (cal_r_E | store_E | mtc0_E);
assign RT_M = (store_M | mtc0_M);


assign F_RS_sel = (RS_D & jal_E & IR_D[`rs]==31 & IR_D[`rs]!=0) ? 3 :
				(RS_D & jalr_E & IR_D[`rs]==IR_E[`rd] & IR_D[`rs]!=0) ? 3 :
				(RS_D & cal_r_M & IR_D[`rs]==IR_M[`rd] & IR_D[`rs]!=0) ? 1 :
				(RS_D & cal_i_M & IR_D[`rs]==IR_M[`rt] & IR_D[`rs]!=0) ? 1 :
				(RS_D & jal_M & IR_D[`rs]==31 & IR_D[`rs]!=0) ? 4 :
				(RS_D & jalr_M & IR_D[`rs]==IR_M[`rd] & IR_D[`rs]!=0) ? 4 :
				(RS_D & mfc0_M & IR_D[`rs]==IR_M[`rt] & IR_D[`rs]!=0) ? 2 :
				(RS_D & cal_r_W & IR_D[`rs]==IR_W[`rd] & IR_D[`rs]!=0) ? 2 :
				(RS_D & cal_i_W & IR_D[`rs]==IR_W[`rt] & IR_D[`rs]!=0) ? 2 :
				(RS_D & load_W & IR_D[`rs]==IR_W[`rt] & IR_D[`rs]!=0) ? 2 :
				(RS_D & mfc0_W & IR_D[`rs]==IR_W[`rt] & IR_D[`rs]!=0) ? 2 :
				(RS_D & jal_W & IR_D[`rs]==31 & IR_D[`rs]!=0) ? 5 :
				(RS_D & jalr_W & IR_D[`rs]==IR_W[`rd] & IR_D[`rs]!=0) ? 5 :
				0 ;
assign F_RT_sel = (RT_D & jal_E & IR_D[`rt]==31 & IR_D[`rt]!=0) ? 3 :
				(RT_D & jalr_E & IR_D[`rt]==IR_E[`rd] & IR_D[`rt]!=0) ? 3 :
				(RT_D & cal_r_M & IR_D[`rt]==IR_M[`rd] & IR_D[`rt]!=0) ? 1 :
				(RT_D & cal_i_M & IR_D[`rt]==IR_M[`rt] & IR_D[`rt]!=0) ? 1 :
				(RT_D & jal_M & IR_D[`rt]==31 & IR_D[`rt]!=0) ? 4 :
				(RT_D & jalr_M & IR_D[`rt]==IR_M[`rd] & IR_D[`rt]!=0) ? 4 :
				(RT_D & cal_r_W & IR_D[`rt]==IR_W[`rd] & IR_D[`rt]!=0) ? 2 :
				(RT_D & cal_i_W & IR_D[`rt]==IR_W[`rt] & IR_D[`rt]!=0) ? 2 :
				(RT_D & load_W & IR_D[`rt]==IR_W[`rt] & IR_D[`rt]!=0) ? 2 :
				(RT_D & mfc0_W & IR_D[`rt]==IR_W[`rt] & IR_D[`rt]!=0) ? 2 :
				(RT_D & jal_W & IR_D[`rt]==31 & IR_D[`rt]!=0) ? 5 :
				(RT_D & jalr_W & IR_D[`rt]==IR_W[`rd] & IR_D[`rt]!=0) ? 5 :
				0; 
assign F_ALUA_Esel = (RS_E & cal_r_M & IR_E[`rs]==IR_M[`rd] & IR_E[`rs]!=0) ? 1 :
				(RS_E & cal_i_M & IR_E[`rs]==IR_M[`rt] & IR_E[`rs]!=0) ? 1 :
				(RS_E & jal_M & IR_E[`rs]==31 & IR_E[`rs]!=0) ? 4 :
				(RS_E & jalr_M & IR_E[`rs]==IR_M[`rd] & IR_E[`rs]!=0) ? 4 :
				(RS_E & cal_r_W & IR_E[`rs]==IR_W[`rd] & IR_E[`rs]!=0) ? 2 :
				(RS_E & cal_i_W & IR_E[`rs]==IR_W[`rt] & IR_E[`rs]!=0) ? 2 :
				(RS_E & load_W & IR_E[`rs]==IR_W[`rt] & IR_E[`rs]!=0) ? 2 :
				(RS_E & mfc0_W & (IR_E[`rs]==IR_W[`rt]) & IR_E[`rs]!=0) ? 2 :
				(RS_E & jal_W & IR_E[`rs]==31 & IR_E[`rs]!=0) ? 5 :
				(RS_E & jalr_W & IR_E[`rs]==IR_W[`rd] & IR_E[`rs]!=0) ? 5 :
				0;
assign F_ALUB_Esel = (RT_E & cal_r_M & IR_E[`rt]==IR_M[`rd] & IR_E[`rt]!=0) ? 1 :
				(RT_E & cal_i_M & IR_E[`rt]==IR_M[`rt] & IR_E[`rt]!=0) ? 1 :
				(RT_E & jal_M & IR_E[`rt]==31 & IR_E[`rt]!=0) ? 4 :
				(RT_E & jalr_M & IR_E[`rt]==IR_M[`rd] & IR_E[`rt]!=0) ? 4 :
				(RT_E & cal_r_W & IR_E[`rt]==IR_W[`rd] & IR_E[`rt]!=0) ? 2 :
				(RT_E & cal_i_W & IR_E[`rt]==IR_W[`rt] & IR_E[`rt]!=0) ? 2 :
				(RT_E & load_W & IR_E[`rt]==IR_W[`rt] & IR_E[`rt]!=0) ? 2 :
				(RT_E & mfc0_W & (IR_E[`rt]==IR_W[`rt]) & IR_E[`rt]!=0) ? 2 :
				(RT_E & jal_W & IR_E[`rt]==31 & IR_E[`rt]!=0) ? 5 :
				(RT_E & jalr_W & IR_E[`rt]==IR_W[`rd] & IR_E[`rt]!=0) ? 5 :
				0;
assign F_WD_Msel = (RT_M & cal_r_W & IR_M[`rt]==IR_W[`rd] & IR_M[`rt]!=0) ? 2 :
				(RT_M & cal_i_W & IR_M[`rt]==IR_W[`rt] & IR_M[`rt]!=0) ? 2 :
				(RT_M & load_W & IR_M[`rt]==IR_W[`rt] & IR_M[`rt]!=0) ? 2 :
				(RT_M & mfc0_W & (IR_M[`rt]==IR_W[`rt]) & IR_M[`rt]!=0) ? 2 :
				(RT_M & jal_W & IR_M[`rt]==31 & IR_M[`rt]!=0) ? 5 :
				(RT_M & jalr_W & IR_M[`rt]==IR_W[`rd] & IR_M[`rt]!=0) ? 5 :
				0;

endmodule
