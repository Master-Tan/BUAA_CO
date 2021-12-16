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
`include "CP0.v"


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
module CPU(input wire clk,
            input wire reset,
            input wire [31:0] i_inst_rdata,
            output wire [31:0] i_inst_addr,

            input wire [31:0] m_data_rdata,

            output wire [31:0] m_data_addr,
            output wire [31:0] m_data_wdata,
            output wire [3:0] m_data_byteen,
            output wire [31:0] m_inst_addr,

            output wire w_grf_we,
            output wire [4:0] w_grf_addr,
            output wire [31:0] w_grf_wdata,
            output wire [31:0] w_inst_addr,
            
            input wire [7:2] HWInt,

            output wire [31:0] PrAddr,
            output wire [31:0] PrWD,
            output wire [3:0] PrWE,
            output wire [31:0] PrPC,
            input wire [31:0] PrRD,

            output wire [31:0] PC_M
        );
    assign PC_M = WPC_M;

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
    // 各元件输�
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

    // 异常
    wire [4:0] ExcCode_F, ExcCode_D, ExcCode_E, ExcCode_M;
    wire [4:0] ExcCode_D_0, ExcCode_E_0, ExcCode_M_0;
    wire ExcAdEL_F, ExcAdEL_M;
    wire ExcRI_D;
    wire ExcOvAri_E;
    wire ExcOvDM_E, ExcOvDM_M;
    wire ExcAdES_M;
    wire bd_F, bd_D, bd_E, bd_M;
    
    wire ALUAriOverflow_E;
    wire ALUDMOverflow_E;

    wire Interrupt;
    wire [31:0] EPC;
    wire [31:0] M_CP0out, W_CP0out;

    wire eret_F, eret_D, eret_M;
    assign eret_F = (IM == `OP_eret);
    assign eret_D = (IR_D == `OP_eret);
    assign eret_M = (IR_M == `OP_eret);

    `define EXC_INT     5'd0
    `define EXC_AdEL    5'd4
    `define EXC_AdES    5'd5
    `define EXC_RI      5'd10
    `define EXC_Ov      5'd12
    `define EXC_None    5'd0

    assign ExcCode_F = ExcAdEL_F ? `EXC_AdEL : `EXC_None;

    assign ExcCode_D =  ExcCode_D_0 ? ExcCode_D_0 :
                        ExcRI_D ? `EXC_RI :
                        `EXC_None;

    assign ExcCode_E =  ExcCode_E_0 ? ExcCode_E_0 :
                        ExcOvAri_E ? `EXC_Ov :
                        `EXC_None;

    assign ExcCode_M =  ExcCode_M_0 ? ExcCode_M_0 :
                        ExcAdEL_M ? `EXC_AdEL :
                        ExcAdES_M ? `EXC_AdES :
                        `EXC_None;

    assign bd_F = (PC_sel != 2'b00);

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
        .D3(W_CP0out),
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

    reg D_set;
    always @(posedge clk) begin
        D_set <= eret_F;
    end

//元件
    F_PC my_PC(
        .eret_D(eret_D),
        .EPC(EPC),
        .ExcAdEL_F(ExcAdEL_F),
        
        .clk(clk),
        .reset(reset),
        .en(!StallF | Interrupt),
        .NPC((Interrupt | D_set) ? NPC : M_PC),
        .PC(PC)
    );


    // IM
    assign i_inst_addr = PC;
    assign IM = i_inst_rdata;

    assign ADD4 = PC + 4;

    D_REG my_D_REG(
        .ExcCode_in(ExcCode_F),
        .bd_in(bd_F),
        .ExcCode_out(ExcCode_D_0),
        .bd_out(bd_D),

        .Interrupt(Interrupt),
        .clk(clk),
        .reset(reset | (eret_D & !StallD)),
        .WE(!StallD),
        .IR_in(ExcAdEL_F ? 32'h0000_0000 : IM),
        .WPC_in(PC),
        .PC4_in(ADD4),
        .IR_out(IR_D0),
        .WPC_out(WPC_D),
        .PC4_out(PC4_D)
    );

    wire [31:0] IR_D0;
    wire cal_r_D = (IR_D0[`opcode]==`OP_rtype & (IR_D0[`funct]==`FUNC_add | IR_D0[`funct]==`FUNC_addu | IR_D0[`funct]==`FUNC_and | IR_D0[`funct]==`FUNC_div
                | IR_D0[`funct]==`FUNC_divu | IR_D0[`funct]==`FUNC_mfhi | IR_D0[`funct]==`FUNC_mflo | IR_D0[`funct]==`FUNC_mthi | IR_D0[`funct]==`FUNC_mtlo | IR_D0[`funct]==`FUNC_mult
                | IR_D0[`funct]==`FUNC_multu | IR_D0[`funct]==`FUNC_nor | IR_D0[`funct]==`FUNC_or | IR_D0[`funct]==`FUNC_sll | IR_D0[`funct]==`FUNC_sllv | IR_D0[`funct]==`FUNC_slt
                | IR_D0[`funct]==`FUNC_sltu | IR_D0[`funct]==`FUNC_sra | IR_D0[`funct]==`FUNC_srav | IR_D0[`funct]==`FUNC_srl | IR_D0[`funct]==`FUNC_srlv | IR_D0[`funct]==`FUNC_sub
                | IR_D0[`funct]==`FUNC_subu | IR_D0[`funct]==`FUNC_xor));
    wire cal_i_D = (IR_D0[`opcode]==`OP_ori | IR_D0[`opcode]==`OP_addi | IR_D0[`opcode]==`OP_addiu | IR_D0[`opcode]==`OP_andi | IR_D0[`opcode]==`OP_xori | IR_D0[`opcode]==`OP_slti | IR_D0[`opcode]==`OP_lui | IR_D0[`opcode]==`OP_sltiu);
    wire load_D = (IR_D0[`opcode]==`OP_lw | IR_D0[`opcode]==`OP_lb | IR_D0[`opcode]==`OP_lbu | IR_D0[`opcode]==`OP_lh | IR_D0[`opcode]==`OP_lhu);
    wire store_D = (IR_D0[`opcode]==`OP_sw | IR_D0[`opcode]==`OP_sh | IR_D0[`opcode]==`OP_sb);
    wire b_D = (IR_D0[`opcode]==`OP_beq | IR_D0[`opcode]==`OP_bne | IR_D0[`opcode]==`OP_blez | IR_D0[`opcode]==`OP_bgtz | (IR_D0[`opcode]==6'b000001&&(IR_D0[`rt]==`RT_bltz | IR_D0[`rt]==`RT_bgez)));
    wire jal_D = (IR_D0[`opcode]==`OP_jal);
    wire jalr_D = (IR_D0[`opcode]==`OP_rtype & IR_D0[`funct]==`FUNC_jalr);
    wire jr_D = (IR_D0[`opcode]==`OP_rtype & IR_D0[`funct]==`FUNC_jr);
    wire j_D  = (IR_D0[`opcode]==`OP_j);

    assign ExcRI_D = !(cal_r_D | cal_i_D | load_D | store_D | b_D | jal_D | jalr_D | jr_D | j_D | IR_D0[31:21] == `OP_mtc0 | IR_D0[31:21] == `OP_mfc0 | IR_D0 == `OP_eret);

    assign IR_D = ExcRI_D ? 32'h0000_0000 : IR_D0;

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
    //与顶层对�
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
        .Interrupt(Interrupt),
        .eret(eret_D),
        .EPC(EPC),

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
        .ExcCode_in(ExcCode_D),
        .bd_in(bd_D),
        .ExcCode_out(ExcCode_E_0),
        .bd_out(bd_E),

        .Interrupt(Interrupt),
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
 
    assign ALUAriOverflow_E = (IR_E[`opcode]==`OP_rtype & (IR_E[`funct]==`FUNC_add | IR_E[`funct]==`FUNC_sub)) | IR_E[`opcode]==`OP_addi;
    assign ALUDMOverflow_E = (IR_E[`opcode]==`OP_sw | IR_E[`opcode]==`OP_sh | IR_E[`opcode]==`OP_sb | IR_E[`opcode]==`OP_lw | IR_E[`opcode]==`OP_lb | IR_E[`opcode]==`OP_lbu | IR_E[`opcode]==`OP_lh | IR_E[`opcode]==`OP_lhu);

    E_ALU my_ALU(
        .ALUAriOverflow(ALUAriOverflow_E),
        .ALUDMOverflow(ALUDMOverflow_E),
        .ExcOvAri(ExcOvAri_E),
        .ExcOvDM(ExcOvDM_E),

        .SrcA(M_ALU_A),
        .SrcB(M_ALU_B),
        .ALU_Control(ALU_Control),
        .ALU_Result(ALU)
    );

    E_Mult_Div my_E_Mult_Div(
        .Interrupt(Interrupt),
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
        .ExcCode_in(ExcCode_E),
        .bd_in(bd_E),
        .ExcCode_out(ExcCode_M_0),
        .bd_out(bd_M),
        
        .ExcOvDM_in(ExcOvDM_E),
        .ExcOvDM_out(ExcOvDM_M),
        
        .Interrupt(Interrupt),
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

    //ExcAdEL_M & ExcAdES_M
    wire ErrAlign, ErrOutOfRange, ErrTimer, ErrSaveTimer;

    assign ErrAlign = ((IR_M[`opcode] == `OP_lw | IR_M[`opcode] == `OP_sw) && (AO_M[1:0] != 0)) |
                ((IR_M[`opcode] == `OP_lh | IR_M[`opcode] == `OP_lhu | IR_M[`opcode] == `OP_sh) && (AO_M[0] != 0));
    assign ErrTimer = !(IR_M[`opcode] == `OP_lw | IR_M[`opcode] == `OP_sw) & (AO_M >= 32'h0000_7F00);
    assign ErrSaveTimer = (AO_M >= 32'h0000_7F08 & AO_M <= 32'h0000_7F0b) |
                    (AO_M >= 32'h0000_7F18 & AO_M <= 32'h0000_7F1b);
    assign ErrOutOfRange = !( ((AO_M >= 32'h0000_0000) & (AO_M <= 32'h0000_2FFF)) |
                        ((AO_M >= 32'h0000_7F00) & (AO_M <= 32'h0000_7F0B)) |
                        ((AO_M >= 32'h0000_7F10) & (AO_M <= 32'h0000_7F1B)));

    wire load_M, store_M;

    assign load_M = (IR_M[`opcode]==`OP_lw | IR_M[`opcode]==`OP_lb | IR_M[`opcode]==`OP_lbu | IR_M[`opcode]==`OP_lh | IR_M[`opcode]==`OP_lhu);
    assign store_M = (IR_M[`opcode]==`OP_sw | IR_M[`opcode]==`OP_sh | IR_M[`opcode]==`OP_sb);


    assign ExcAdEL_M = load_M & (ErrAlign | ErrTimer | ExcOvDM_M | ErrOutOfRange);

    assign ExcAdES_M = store_M & (ErrAlign | ErrTimer | ErrSaveTimer | ExcOvDM_M | ErrOutOfRange);

    wire Stop;
    // CP0
    CP0 my_CP0(
        .A1(IR_M[`rd]),                //读CP0寄存器编�执行MFC0指令时产�
        .A2(IR_M[`rd]),                //写CP0寄存器编�执行MTC0指令时产�
        .bdIn(bd_M),
        .We(IR_M[31:21] == `OP_mtc0),  //CP0写使�执行MTC0指令时产�
        .DIn(MF_WD_M),                 //CP0寄存器的写入数据 执行MTC0指令时产�数据来自GPR
        .PC(WPC_M),                  //中断/异常时的PC 
        .ExcCode(ExcCode_M),           //中断/异常的类�
        .HWInt(HWInt),                 //6个设备中�
        .EXLClr(eret_M),               //用于清除SR的EXL(EXL�) 执行ERET指令时产�
        .clk(clk),
        .reset(reset),
        .Interrupt(Interrupt),         //中断请求 �CP0 模块确认响应中断
        .EPC(EPC),                     //EPC寄存器输出至NPC
        .DOut(M_CP0out),               //CP0寄存器的输出数据 执行MFC0指令时产生，输出数据至GRF
        .Stop(Stop)
    );

    

    // BE
    BE my_BE(
        .data(AO_M[1:0]),
        .WriteData_in(MF_WD_M),
        .Op(DMop_S),
        .DM_control(DM_control),
        .WriteData_out(WriteData)
    );

    assign PrAddr = AO_M;
    assign PrWD = WriteData;
    assign PrWE = Interrupt ? 4'b0000 : DM_control;
    assign PrPC = WPC_M;

    // DM
    assign m_data_addr = Stop ? 32'h0000_7F20 : AO_M;
    assign m_data_wdata = Stop ? 32'b1 : WriteData;
    assign m_data_byteen = Stop ? 4'b1111 : (Interrupt ? 4'b0000 :DM_control);
    assign m_inst_addr = WPC_M;


    assign D = (AO_M >= 32'h0000_7f00) ? PrRD : m_data_rdata;

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
        .CP0_in(M_CP0out),
        .CP0_out(W_CP0out),

        .clk(clk),
        .reset(reset | Interrupt),
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
        .IR(IR_W),
        .RegWrite(RegWrite),
        .A3_RFsel(A3_RFsel),
        .RF_WDsel(RF_WDsel)
    );

endmodule
