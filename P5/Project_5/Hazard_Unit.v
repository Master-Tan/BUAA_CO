`include "const.v"
`include "Control_Unit.v"

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
wire beq_D, beq_E, beq_M, beq_W;

assign cal_r_D = (IR_D[`opcode]==`OP_rtype & IR_D[`funct]!=`FUNC_jalr & IR_D[`funct]!=`FUNC_jr & IR_D!=0);
assign cal_r_E = (IR_E[`opcode]==`OP_rtype & IR_E[`funct]!=`FUNC_jalr & IR_E[`funct]!=`FUNC_jr & IR_E!=0);
assign cal_r_M = (IR_M[`opcode]==`OP_rtype & IR_M[`funct]!=`FUNC_jalr & IR_M[`funct]!=`FUNC_jr & IR_M!=0);
assign cal_r_W = (IR_W[`opcode]==`OP_rtype & IR_W[`funct]!=`FUNC_jalr & IR_W[`funct]!=`FUNC_jr & IR_W!=0);

assign cal_i_D = (IR_D[`opcode]==`OP_lui | IR_D[`opcode]==`OP_ori);
assign cal_i_E = (IR_E[`opcode]==`OP_lui | IR_E[`opcode]==`OP_ori);
assign cal_i_M = (IR_M[`opcode]==`OP_lui | IR_M[`opcode]==`OP_ori);
assign cal_i_W = (IR_W[`opcode]==`OP_lui | IR_W[`opcode]==`OP_ori);

assign load_D = (IR_D[`opcode]==`OP_lw);
assign load_E = (IR_E[`opcode]==`OP_lw);
assign load_M = (IR_M[`opcode]==`OP_lw);
assign load_W = (IR_W[`opcode]==`OP_lw);

assign store_D = (IR_D[`opcode]==`OP_sw);
assign store_E = (IR_E[`opcode]==`OP_sw);
assign store_M = (IR_M[`opcode]==`OP_sw);
assign store_W = (IR_W[`opcode]==`OP_sw);

assign beq_D = (IR_D[`opcode]==`OP_beq);
assign beq_E = (IR_E[`opcode]==`OP_beq);
assign beq_M = (IR_M[`opcode]==`OP_beq);
assign beq_W = (IR_W[`opcode]==`OP_beq);

//暂停
wire stall_b,stall_cal_r,stall_cal_i,stall_load,stall_store,stall_jr,stall_jalr;
	
assign stall_b = (beq_D & cal_r_E & (IR_D[`rs]==IR_E[`rd] | IR_D[`rt]==IR_E[`rd])) | 
						(beq_D & cal_i_E & (IR_D[`rs]==IR_E[`rt] | IR_D[`rt]==IR_E[`rt])) | 
						(beq_D & load_E & (IR_D[`rs]==IR_E[`rt] | IR_D[`rt]==IR_E[`rt])) | 
						(beq_D & load_M & (IR_D[`rs]==IR_M[`rt] | IR_D[`rt]==IR_M[`rt]));
assign stall_cal_r = (cal_r_D) & (load_E) & (IR_D[`rs]==IR_E[`rt] | IR_D[`rt]==IR_E[`rt]);
assign stall_cal_i = (cal_i_D) & (load_E) & (IR_D[`rs]==IR_E[`rt]);
assign stall_load = (load_D) & (load_E) & (IR_D[`rs]==IR_E[`rt]);
assign stall_store = (store_D) & (load_E) & (IR_D[`rs]==IR_E[`rt]);
assign stall_jr = ((IR_D[`opcode]==`OP_rtype & IR_D[`funct]==`FUNC_jr) & (cal_r_E) & (IR_D[`rs]==IR_E[`rd])) | 
					((IR_D[`opcode]==`OP_rtype & IR_D[`funct]==`FUNC_jr) & (cal_i_E) & (IR_D[`rs]==IR_E[`rt])) | 
					((IR_D[`opcode]==`OP_rtype & IR_D[`funct]==`FUNC_jr) & (load_E) & (IR_D[`rs]==IR_E[`rt])) | 
					((IR_D[`opcode]==`OP_rtype & IR_D[`funct]==`FUNC_jr) & (load_M) & (IR_D[`rs]==IR_M[`rt]));
assign stall_jalr =  ((IR_D[`opcode]==`OP_rtype & IR_D[`funct]==`FUNC_jalr) & (cal_r_E) & (IR_D[`rs]==IR_E[`rd])) | 
					((IR_D[`opcode]==`OP_rtype & IR_D[`funct]==`FUNC_jalr) & (cal_i_E) & (IR_D[`rs]==IR_E[`rt])) | 
					((IR_D[`opcode]==`OP_rtype & IR_D[`funct]==`FUNC_jalr) & (load_E) & (IR_D[`rs]==IR_E[`rt])) | 
					((IR_D[`opcode]==`OP_rtype & IR_D[`funct]==`FUNC_jalr) & (load_M) & (IR_D[`rs]==IR_M[`rt]));
wire stall;							
assign stall = stall_b | stall_cal_r | stall_cal_i | stall_load | stall_store | stall_jr | stall_jalr;

assign StallF = stall;
assign StallD = stall;
assign FlushE = stall;

//转发
wire RS_D, RT_D, RS_E, RT_E, RT_M;

assign RS_D = (cal_r_D | cal_i_D | load_D | store_D | beq_D  | (IR_D[`opcode]==`OP_rtype & (IR_D[`funct]==`FUNC_jr | IR_D[`funct]==`FUNC_jalr)));
assign RT_D = (cal_r_D | store_D | beq_D);
assign RS_E = (cal_r_E | cal_i_E | load_E | store_E);
assign RT_E = (cal_r_E | store_E);
assign RT_M = (store_M);


assign F_RS_sel = (RS_D & (IR_E[`opcode]==`OP_jal) & IR_D[`rs]==31 & IR_D[`rs]!=0) ? 3 :
				(RS_D & (IR_E[`opcode]==`OP_rtype & IR_E[`funct]==`FUNC_jalr)	 &  IR_D[`rs]==IR_E[`rd] & IR_D[`rs]!=0) ? 3 :
				(RS_D &  cal_r_M & IR_D[`rs]==IR_M[`rd] & IR_D[`rs]!=0) ? 1 :
				(RS_D &  cal_i_M & IR_D[`rs]==IR_M[`rt] & IR_D[`rs]!=0) ? 1 :
				(RS_D & (IR_M[`opcode]==`OP_jal)	 &  IR_D[`rs]==31 & IR_D[`rs]!=0) ? 4 :
				(RS_D & (IR_M[`opcode]==`OP_rtype & IR_M[`funct]==`FUNC_jalr)	 &  IR_D[`rs]==IR_M[`rd] & IR_D[`rs]!=0) ? 4 :
				(RS_D &  cal_r_W & IR_D[`rs]==IR_W[`rd] & IR_D[`rs]!=0) ? 2 :
				(RS_D &  cal_i_W & IR_D[`rs]==IR_W[`rt] & IR_D[`rs]!=0) ? 2 :
				(RS_D &  load_W & IR_D[`rs]==IR_W[`rt] & IR_D[`rs]!=0) ? 2 :
				(RS_D & (IR_W[`opcode]==`OP_jal) & IR_D[`rs]==31 & IR_D[`rs]!=0) ? 5 :
				(RS_D & (IR_W[`opcode]==`OP_rtype & IR_W[`funct]==`FUNC_jalr) & IR_D[`rs]==IR_W[`rd] & IR_D[`rs]!=0) ? 5 :
				0 ;
assign F_RT_sel = (RT_D & (IR_E[`opcode]==`OP_jal) & IR_D[`rt]==31 & IR_D[`rt]!=0) ? 3 :
				(RT_D & (IR_E[`opcode]==`OP_rtype & IR_E[`funct]==`FUNC_jalr)	 &  IR_D[`rt]==IR_E[`rd] & IR_D[`rt]!=0) ? 3 :
				(RT_D &  cal_r_M & IR_D[`rt]==IR_M[`rd] & IR_D[`rt]!=0) ? 1 :
				(RT_D &  cal_i_M & IR_D[`rt]==IR_M[`rt] & IR_D[`rt]!=0) ? 1 :
				(RT_D & (IR_M[`opcode]==`OP_jal)	 &  IR_D[`rt]==31 & IR_D[`rt]!=0) ? 4 :
				(RT_D & (IR_M[`opcode]==`OP_rtype & IR_M[`funct]==`FUNC_jalr)	 &  IR_D[`rt]==IR_M[`rd] & IR_D[`rt]!=0) ? 4 :
				(RT_D &  cal_r_W & IR_D[`rt]==IR_W[`rd] & IR_D[`rt]!=0) ? 2 :
				(RT_D &  cal_i_W & IR_D[`rt]==IR_W[`rt] & IR_D[`rt]!=0) ? 2 :
				(RT_D &  load_W & IR_D[`rt]==IR_W[`rt] & IR_D[`rt]!=0) ? 2 :
				(RT_D & (IR_W[`opcode]==`OP_jal) & IR_D[`rt]==31 & IR_D[`rt]!=0) ? 5 :
				(RT_D & (IR_W[`opcode]==`OP_rtype & IR_W[`funct]==`FUNC_jalr)	 &  IR_D[`rt]==IR_W[`rd] & IR_D[`rt]!=0) ? 5 :
				0; 
assign F_ALUA_Esel = (RS_E & cal_r_M & (IR_E[`rs]==IR_M[`rd]) & IR_E[`rs]!=0) ? 1 :
				(RS_E & cal_i_M & (IR_E[`rs]==IR_M[`rt]) & IR_E[`rs]!=0) ? 1 :
				(RS_E & (IR_M[`opcode]==`OP_jal) & (IR_E[`rs]==31) & IR_E[`rs]!=0) ? 4 :
				(RS_E & (IR_M[`opcode]==`OP_rtype & IR_M[`funct]==`FUNC_jalr) & (IR_E[`rs]==IR_M[`rd]) & IR_E[`rs]!=0) ? 4 :
				(RS_E & cal_r_W & (IR_E[`rs]==IR_W[`rd]) & IR_E[`rs]!=0) ? 2 :
				(RS_E & cal_i_W & (IR_E[`rs]==IR_W[`rt]) & IR_E[`rs]!=0) ? 2 :
				(RS_E & load_W & (IR_E[`rs]==IR_W[`rt]) & IR_E[`rs]!=0) ? 2 :
				(RS_E & (IR_W[`opcode]==`OP_jal) & (IR_E[`rs]==31) & IR_E[`rs]!=0) ? 5 :
				(RS_E & (IR_W[`opcode]==`OP_rtype & IR_W[`funct]==`FUNC_jalr) & (IR_E[`rs]==IR_W[`rd]) & IR_E[`rs]!=0) ? 5 :
				0;
assign F_ALUB_Esel = (RT_E & cal_r_M & (IR_E[`rt]==IR_M[`rd]) & IR_E[`rt]!=0) ? 1 :
				(RT_E & cal_i_M & (IR_E[`rt]==IR_M[`rt]) & IR_E[`rt]!=0) ? 1 :
				(RT_E & (IR_M[`opcode]==`OP_jal) & (IR_E[`rt]==31) & IR_E[`rt]!=0) ? 4 :
				(RT_E & (IR_M[`opcode]==`OP_rtype & IR_M[`funct]==`FUNC_jalr) & (IR_E[`rt]==IR_M[`rd]) & IR_E[`rt]!=0) ? 4 :
				(RT_E & cal_r_W & (IR_E[`rt]==IR_W[`rd]) & IR_E[`rt]!=0) ? 2 :
				(RT_E & cal_i_W & (IR_E[`rt]==IR_W[`rt]) & IR_E[`rt]!=0) ? 2 :
				(RT_E & load_W & (IR_E[`rt]==IR_W[`rt]) & IR_E[`rt]!=0) ? 2 :
				(RT_E & (IR_W[`opcode]==`OP_jal) & (IR_E[`rt]==31) & IR_E[`rt]!=0) ? 5 :
				(RT_E & (IR_W[`opcode]==`OP_rtype & IR_W[`funct]==`FUNC_jalr) & (IR_E[`rt]==IR_W[`rd]) & IR_E[`rt]!=0) ? 5 :
				0;
assign F_WD_Msel = (RT_M & cal_r_W & (IR_M[`rt]==IR_W[`rd]) & IR_M[`rt]!=0) ? 2 :
				(RT_M & cal_i_W & (IR_M[`rt]==IR_W[`rt]) & IR_M[`rt]!=0) ? 2 :
				(RT_M & load_W & (IR_M[`rt]==IR_W[`rt]) & IR_M[`rt]!=0) ? 2 :
				(RT_M & (IR_W[`opcode]==`OP_jal) & (IR_M[`rt]==31) & IR_M[`rt]!=0) ? 5 :
				(RT_M & (IR_W[`opcode]==`OP_rtype & IR_W[`funct]==`FUNC_jalr) & (IR_M[`rt]==IR_W[`rd]) & IR_M[`rt]!=0) ? 5 :
				0;




// wire RType;
// wire addu,subu,ori,lw,sw,beq,jal,jr,lui,lb,sb,lh,sh,addi,jalr,j,andi;

// wire opcode = IR_D[`opcode];
// wire funct  = IR_D[`funct];

// assign RType = (opcode == `OP_rtype);
// assign addu  = RType & (funct == `FUNC_addu);
// assign subu  = RType & (funct == `FUNC_subu);
// assign ori   = (opcode == `OP_ori);
// assign lw    = (opcode == `OP_lw);
// assign sw    = (opcode == `OP_sw);
// assign beq   = (opcode == `OP_beq);
// assign jal   = (opcode == `OP_jal);
// assign jr    = RType & (funct == `FUNC_jr);
// assign lui   = (opcode == `OP_lui);
// assign lb    = (opcode == `OP_lb);
// assign sb    = (opcode == `OP_sb);
// assign sh    = (opcode == `OP_sh);
// assign lh    = (opcode == `OP_lh);
// assign addi  = (opcode == `OP_addi);
// assign jalr  = RType & (funct == `FUNC_jalr);
// assign j     = (opcode == `OP_j);
// assign andi  = (opcode == `OP_andi);

// wire Tuse_RS0, Tuse_RS1, Tuse_RT0, Tuse_RT1, Tuse_RT2;

// assign Tuse_RS0 = beq | jr;
// assign Tuse_RS1 = addu | subu | andi | ori | lw | sw;
// assign Tuse_RT0 = beq;
// assign Tuse_RT1 = addu | subu;
// assign Tuse_RT2 = sw;

// reg [1:0] Tnew_E, Tnew_M;

// always @(posedge clk) begin
// 	if(reset) begin
// 		Tnew_E <= 0;
// 		Tnew_M <= 0;
// 	end
// 	else begin
// 		if(addu | subu | andi | ori) begin
// 			Tnew_E <= 2'b01;
// 		end
// 		else if(lw) begin
// 			Tnew_E <= 2'b10;
// 		end
// 		else if(jal | lui) begin
// 			Tnew_E <= 2'b00;
// 		end
// 		else begin
// 			;
// 		end

// 		Tnew_M <= Tnew_E;
// 	end
// end

// wire Stall_RS0_E1, Stall_RS0_E2, Stall_RS0_M1, Stall_RS1_E2;
// wire Stall_RT0_E1, Stall_RT0_E2, Stall_RT0_M1, Stall_RT1_E2;
// wire W_E, W_M, W_W;

// Control_Unit C1(.opcode(IR_E[`opcode]),
//                 .funct(IR_E[`funct]),
// 				.RegWrite(W_E)
// 			);
// Control_Unit C2(.opcode(IR_M[`opcode]),
// 				.funct(IR_M[`funct]),
// 				.RegWrite(W_M)
// 			);
// Control_Unit C3(.opcode(IR_W[`opcode]),
// 				.funct(IR_W[`funct]),
// 				.RegWrite(W_W)
// 			);

// assign Stall_RS0_E1 = Tuse_RS0 & (Tnew_E ==2'b01) & (IR_D[`rs] == IR_E[`rd]) & W_E;
// assign Stall_RS0_E2 = Tuse_RS0 & (Tnew_E ==2'b10) & (IR_D[`rs] == IR_E[`rd]) & W_E;
// assign Stall_RS0_M1 = Tuse_RS0 & (Tnew_M ==2'b01) & (IR_D[`rs] == IR_M[`rd]) & W_M;
// assign Stall_RS1_E2 = Tuse_RS1 & (Tnew_E ==2'b10) & (IR_D[`rs] == IR_E[`rd]) & W_E;

// assign Stall_RT0_E1 = Tuse_RT0 & (Tnew_E ==2'b01) & (IR_D[`rt] == IR_E[`rd]) & W_E;
// assign Stall_RT0_E2 = Tuse_RT0 & (Tnew_E ==2'b10) & (IR_D[`rt] == IR_E[`rd]) & W_E;
// assign Stall_RT0_M1 = Tuse_RT0 & (Tnew_M ==2'b01) & (IR_D[`rt] == IR_M[`rd]) & W_M;
// assign Stall_RT1_E2 = Tuse_RT1 & (Tnew_E ==2'b10) & (IR_D[`rt] == IR_E[`rd]) & W_E;

// wire Stall_RS;
// assign Stall_RS = Stall_RS0_E1 | Stall_RS0_E2 | Stall_RS0_M1 | Stall_RS1_E2;

// wire Stall_RT;
// assign Stall_RT = Stall_RT0_E1 | Stall_RT0_E2 | Stall_RT0_M1 | Stall_RT1_E2;

// wire stall = Stall_RT | Stall_RS;

// assign F_RS_sel = ((IR_D[`rs] == IR_M[`rd] & IR_M[`rd] != 0) & Tnew_M ==2'b00) & W_M ? 3'd2 :
// 		 	  (IR_D[`rs] == IR_W[`rd] & IR_W[`rd] != 0) & W_W ? 3'd1 :
// 			  3'd0;
// assign F_RT_sel = ((IR_D[`rt] == IR_M[`rd] & IR_M[`rd] != 0) & Tnew_M ==2'b00) & W_M ? 3'd2 :
// 		 	  (IR_D[`rt] == IR_W[`rd] & IR_W[`rd] != 0) & W_W ? 3'd1 :
// 			  3'd0;
// assign F_ALUA_Esel = ((IR_E[`rs] == IR_M[`rd] & IR_M[`rd] != 0) & Tnew_M ==2'b00) & W_M ? 3'd2 :
// 		 	  (IR_E[`rs] == IR_W[`rd] & IR_W[`rd] != 0) & W_W ? 3'd1 :
// 			  3'd0;
// assign F_ALUB_Esel = ((IR_E[`rt] == IR_M[`rd]  & IR_M[`rd] != 0) & Tnew_M ==2'b00) & W_M ? 3'd2 :
// 		 	  (IR_E[`rt] == IR_W[`rd] & IR_W[`rd] != 0) & W_W ? 3'd1 :
// 			  3'd0;
// assign F_WD_Msel = (IR_M[`rt] == IR_W[`rd]  & IR_W[`rd] != 0) & W_W ? 3'd1 :
// 			  3'd0;

endmodule
