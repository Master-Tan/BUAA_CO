`include "F_PC.v"
`include "D_GRF.v"
`include "Control_Unit.v"
`include "MUX.v"
`include "D_EXT.v"
`include "E_ALU.v"
`include "Forward_MUX.v"
`include "D_REG.v"
`include "E_REG.v"
`include "M_REG.v"
`include "W_REG.v"
`include "D_CMP.v"
`include "D_NPC.v"
`include "Hazard_Unit.v"
`include "BE.v"
`include "DataEXT.v"
`include "E_Mult_Div.v"


`define opcode 31:26
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define funct 5:0
`define i16 15:0
`define i26 25:0
`define shamt 10:6

`timescale 1ns / 1ps
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    16:32:15 11/11/2021
// Design Name:
// Module Name:    mips
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
module mips(input wire clk,
            input wire reset,
            input wire [31:0] i_inst_rdata,
            input wire [31:0] m_data_rdata,
            output wire [31:0] i_inst_addr,
            output wire [31:0] m_data_addr,
            output wire [31:0] m_data_wdata,
            output wire [3:0] m_data_byteen,
            output wire [31:0] m_inst_addr,
            output wire w_grf_we,
            output wire [4:0] w_grf_addr,
            output wire [31:0] w_grf_wdata,
            output wire [31:0] w_inst_addr
        );

// control wire
    wire RegWrite;
    wire [2:0] DMop_R;
    wire [2:0] DMop_S;
    wire [3:0] DM_control;
    wire [1:0] EXTop;
    wire [3:0] ALU_Control;
    wire [2:0] NPC_sel;
    wire [2:0] CMP_type;

// wire
    // 各元件输出
    wire [31:0] PC;
    wire [31:0] IM;
    wire [31:0] ADD4;
    wire [31:0] IR_D;
    wire [31:0] WPC_D;
    wire [31:0] PC4_D;
    wire [31:0] RF_RD1;
    wire [31:0] RF_RD2;
    wire [31:0] EXT;
    wire [31:0] NPC;
    wire b_jump;
    wire [31:0] V1_E;
    wire [31:0] V2_E;
    wire [31:0] IR_E;
    wire [31:0] E32_E;
    wire [31:0] WPC_E;
    wire [31:0] PC4_E;
    wire [31:0] ALU;
    wire [31:0] V2_M;
    wire [31:0] AO_M;
    wire [31:0] IR_M;
    wire [31:0] E32_M;
    wire [31:0] WPC_M;
    wire [31:0] PC4_M;
    wire [31:0] WriteData;
    wire [31:0] D; 
    wire [31:0] DM;
    wire [31:0] IR_W;
    wire [31:0] AO_W;
    wire start;
    wire Busy;
    wire [31:0] M_D;
    wire [31:0] E32_W;
    wire [31:0] DR_W;
    wire [31:0] WPC_W;
    wire [31:0] PC4_W;
    
    // MUX 控制信号
    wire [1:0] PC_sel;
    wire ALU_Asel;
    wire ALU_Bsel;
    wire M_D_sel;
    wire [1:0] RF_WDsel;
    wire [1:0] A3_RFsel;
    
    // MUX 输出
    wire [31:0] M_PC;
    wire [31:0] M_ALU_A;
    wire [31:0] M_ALU_B;
    wire [31:0] M_M_D;
    wire [4:0] M_A3_RF;
    wire [31:0] M_RF_WD;

    // Forward_MUX 控制信号
    wire [2:0] F_RS_sel;	
	wire [2:0] F_RT_sel;	
	wire [2:0] F_ALUA_Esel;
	wire [2:0] F_ALUB_Esel;
	wire [2:0] F_WD_Msel;

    // Forward_MUX 输出
    wire [31:0] MF_RS_D;
    wire [31:0] MF_RT_D;
    wire [31:0] MF_ALUA_E;
    wire [31:0] MF_ALUB_E;
    wire [31:0] MF_WD_M;
    
    // Hazard_Unit 输出
    wire StallF;
    wire StallD;
    wire FlushE;

// MUX
    // M_PC    
    MUX4_32 my_M_PC(
        .S(PC_sel),
        .D0(ADD4),
        .D1(NPC),
        .D2(MF_RS_D),
        .Out(M_PC)
    );

    // M_ALU_A
    MUX2_32 my_M_ALU_A(
        .S(ALU_Asel),
        .D0(MF_ALUA_E),
        .D1({{27{1'b0}},IR_E[`shamt]}),
        .Out(M_ALU_A)
    );

    // M_ALU_B
    MUX2_32 my_M_ALU_B(
        .S(ALU_Bsel),
        .D0(MF_ALUB_E),
        .D1(E32_E),
        .Out(M_ALU_B)
    );

    // M_M_D
    MUX2_32 my_M_M_D(
        .S(M_D_sel),
        .D0(ALU),
        .D1(M_D),
        .Out(M_M_D)
    );
        
    // M_A3_RF
    MUX4_5 my_M_A3_RF(
        .S(A3_RFsel),
        .D0(IR_W[`rt]),
        .D1(IR_W[`rd]),
        .D2(5'h1f),
        .Out(M_A3_RF)
    );

        
    // M_RF_WD
    MUX4_32 my_M_RF_WD(
        .S(RF_WDsel),
        .D0(AO_W),
        .D1(DR_W),
        .D2(PC4_W + 4),
        .Out(M_RF_WD)
    );

// Forward_MUX
    Forward_MUX my_Forward_MUX (
        .RF_RD1(RF_RD1),
        .RF_RD2(RF_RD2),
        .V1_E(V1_E),
        .V2_E(V2_E),
        .V2_M(V2_M),

        .AO_M(AO_M),
        .M4(M_RF_WD),
        .PC8_E(PC4_E + 4),
        .PC8_M(PC4_M + 4),
        .PC8_W(PC4_W + 4),

        .F_RS_sel(F_RS_sel),	
        .F_RT_sel(F_RT_sel),	
        .F_ALUA_Esel(F_ALUA_Esel),
        .F_ALUB_Esel(F_ALUB_Esel),	
        .F_WD_Msel(F_WD_Msel),
        
        .MF_RS_D(MF_RS_D),
        .MF_RT_D(MF_RT_D),
        .MF_ALUA_E(MF_ALUA_E),
        .MF_ALUB_E(MF_ALUB_E),
        .MF_WD_M(MF_WD_M)
    );
    
// Hazard_Unit
    Hazard_Unit my_Hazard_Unit(
        .clk(clk),
        .reset(reset),
        .IR_D(IR_D),
	    .IR_E(IR_E),
	    .IR_M(IR_M),
	    .IR_W(IR_W),
		.start(start),
		.Busy(Busy),
	    .StallF(StallF),
	    .StallD(StallD),
	    .FlushE(FlushE),
	    .F_RS_sel(F_RS_sel),	
        .F_RT_sel(F_RT_sel),	
        .F_ALUA_Esel(F_ALUA_Esel),
        .F_ALUB_Esel(F_ALUB_Esel),	
        .F_WD_Msel(F_WD_Msel)
    );

//元件
    F_PC my_PC(
        .clk(clk),
        .reset(reset),
        .en(!StallF),
        .NPC(M_PC),
        .PC(PC)
    );

    // IM
    assign i_inst_addr = PC;
    assign IM = i_inst_rdata;

    assign ADD4 = PC + 4;

    D_REG my_D_REG(
        .clk(clk),
        .reset(reset),
        .WE(!StallD),
        .IR_in(IM),
        .WPC_in(PC),
        .PC4_in(ADD4),
        .IR_out(IR_D),
        .WPC_out(WPC_D),
        .PC4_out(PC4_D)
    );

    D_GRF my_RF(
        .A1(IR_D[`rs]),
        .A2(IR_D[`rt]),
        .A3(M_A3_RF),
        .WD(M_RF_WD),
        .RD1(RF_RD1),
        .RD2(RF_RD2),
        .clk(clk),
        .reset(reset),
        .WE(RegWrite),
        .WPC(WPC_W)
    );
    // 与顶层对接
    assign w_grf_we = RegWrite;
    assign w_grf_addr = M_A3_RF;
    assign w_grf_wdata = M_RF_WD;
    assign w_inst_addr = WPC_W;

    D_EXT my_EXT(
        .imm16(IR_D[`i16]),
        .EXTop(EXTop),
        .ext_imm16(EXT)
    );

    D_NPC my_NPC(
        .PC_F(PC),
        .PC4_D(PC4_D),
        .I16(IR_D[`i16]),
        .I26(IR_D[`i26]),
        .D_NPC_sel(NPC_sel),
        .b_jump(b_jump),
        .NPC_out(NPC)
    );

    D_CMP my_CMP(
        .D1(MF_RS_D),
        .D2(MF_RT_D),
        .type(CMP_type),
        .b_jump(b_jump)
    );
    
    Control_Unit my_Control_Unit_D(
        .opcode(IR_D[`opcode]),
        .funct(IR_D[`funct]),
        .rt(IR_D[`rt]),
        .CMP_type(CMP_type),
        .NPC_sel(NPC_sel),
        .EXTop(EXTop),
        .PC_sel(PC_sel)
    );

    E_REG my_E_REG(
        .clk(clk),
        .reset(reset),
        .WE(1'b1),
        .clr(FlushE),
        .V1_in(MF_RS_D),
        .V2_in(MF_RT_D),
        .IR_in(IR_D),
        .E32_in(EXT),
        .WPC_in(WPC_D),
        .PC4_in(PC4_D),
        .V1_out(V1_E),
        .V2_out(V2_E),
        .IR_out(IR_E),
        .E32_out(E32_E),
        .WPC_out(WPC_E),
        .PC4_out(PC4_E)
    );

    E_ALU my_ALU(
        .SrcA(M_ALU_A),
        .SrcB(M_ALU_B),
        .ALU_Control(ALU_Control),
        .ALU_Result(ALU)
    );

    E_Mult_Div my_E_Mult_Div(
	    .clk(clk),
	    .reset(reset),
        .IR(IR_E),
        .SrcA(M_ALU_A),
        .SrcB(M_ALU_B),
        .start(start),
        .Busy(Busy),
        .M_D(M_D)
    );

    Control_Unit my_Control_Unit_E(
        .opcode(IR_E[`opcode]),
        .funct(IR_E[`funct]),
        .ALU_Control(ALU_Control),
        .ALU_Asel(ALU_Asel),
        .ALU_Bsel(ALU_Bsel),
        .start(start),
        .M_D_sel(M_D_sel)
    );

    M_REG my_M_REG(
        .clk(clk),
        .reset(reset),
        .WE(1'b1),
        .V2_in(MF_ALUB_E),
        .AO_in(M_M_D),
        .IR_in(IR_E),
        .WPC_in(WPC_E),
        .PC4_in(PC4_E),
        .V2_out(V2_M),
        .AO_out(AO_M),
        .IR_out(IR_M),
        .WPC_out(WPC_M),
        .PC4_out(PC4_M)
    );
    // BE
    BE my_BE(
        .data(AO_M[1:0]),
        .WriteData_in(MF_WD_M),
        .Op(DMop_S),
        .DM_control(DM_control),
        .WriteData_out(WriteData)
    );

    // DM
    assign m_data_addr = AO_M;
    assign m_data_wdata = WriteData;
    assign m_data_byteen = DM_control;
    assign m_inst_addr = WPC_M;
    assign D = m_data_rdata;

    // DataEXT
    DataEXT my_DataEXT(
        .A(AO_M[1:0]),
        .Din(D),
        .Op(DMop_R),
        .Dout(DM)
    );

    Control_Unit my_Control_Unit_M(
        .opcode(IR_M[`opcode]),
        .funct(IR_M[`funct]),
        .DMop_R(DMop_R),
        .DMop_S(DMop_S)
    );

    W_REG my_W_REG(
        .clk(clk),
        .reset(reset),
        .WE(1'b1),
        .IR_in(IR_M),
        .AO_in(AO_M),
        .WPC_in(WPC_M),
        .PC4_in(PC4_M),
        .DR_in(DM),
        .IR_out(IR_W),
        .AO_out(AO_W),
        .PC4_out(PC4_W),
        .WPC_out(WPC_W),
        .DR_out(DR_W)
    );

    Control_Unit my_Control_Unit_W(
        .opcode(IR_W[`opcode]),
        .funct(IR_W[`funct]),
        .RegWrite(RegWrite),
        .A3_RFsel(A3_RFsel),
        .RF_WDsel(RF_WDsel)
    );

endmodule
