`include "PC.v"
`include "IM.v"
`include "GRF.v"
`include "Control_Unit.v"
`include "MUX.v"
`include "EXT.v"
`include "ALU.v"
`include "DM.v"

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
            input wire reset);
    
    wire   [31:0]      pc, npc                          ;
    wire   [31:0]      Instr                            ;
    wire   [31:0]      RD1, RD2, ALU_Result, ALU_2      ;
    wire   [4:0]       RegAddr                          ;
    wire   [31:0]      RegData, MemData, MemAddr, DMData;
    wire   [31:0]      ext_imm16                        ;
    wire   [31:0]      BeqOrPC                          ;
    wire   ALUSrc, RegWrite, MemWrite, Zero, EXTop, ToHigh_16, Branch, Beq;
    wire   [1:0]      DMop, RegDst, MemtoReg, Jump      ;
    wire   [2:0]      ALU_Control                       ;
    
    assign Beq     = Zero & Branch;
    assign MemData = RD2;
    
    MUX2_32 My_1_MUX2_32(.S(ALUSrc), .D0(RD2), .D1(ext_imm16), .Out(ALU_2));
    MUX2_32 My_2_MUX2_32(.S(ToHigh_16), .D0(ALU_Result), .D1({Instr[15:0],{16{1'b0}}}), .Out(MemAddr));
    MUX2_32 My_3_MUX2_32(.S(Beq), .D0(pc+4), .D1(pc+4+(ext_imm16<<2)), .Out(BeqOrPC));
    MUX4_5 My_1_MUX4_5(.S(RegDst), .D0(Instr[20:16]), .D1(Instr[15:11]), .D2(5'd31), .Out(RegAddr));
    MUX4_32 My_1_MUX4_32(.S(MemtoReg), .D0(MemAddr), .D1(DMData), .D2(pc+4), .Out(RegData));
    MUX4_32 My_2_MUX4_32(.S(Jump), .D0(BeqOrPC), .D1({pc[31:28],Instr[25:0],2'b00}), .D2(RD1),.Out(npc));
    
    PC My_PC(.clk(clk), .reset(reset), .NPC(npc), .PC(pc));
    IM My_IM(.PC(pc), .Instr(Instr));
    GRF My_GRF(.A1(Instr[25:21]), .A2(Instr[20:16]), .A3(RegAddr),
    .WD(RegData), .RD1(RD1), .RD2(RD2), .clk(clk), .reset(reset),
    .WE(RegWrite), .PC(pc));
    Control_Unit My_Control_Unit(.opcode(Instr[31:26]), .funct(Instr[5:0]), .MemtoReg(MemtoReg),
    .DMop(DMop), .MemWrite(MemWrite), .Branch(Branch), .ALU_Control(ALU_Control), .ALUSrc(ALUSrc),
    .RegDst(RegDst), .ToHigh_16(ToHigh_16), .EXTop(EXTop), .RegWrite(RegWrite), .Jump(Jump));
    EXT My_EXT(.imm16(Instr[15:0]), .EXTop(EXTop), .ext_imm16(ext_imm16));
    ALU My_ALU(.SrcA(RD1), .SrcB(ALU_2), .ALU_Control(ALU_Control), .Zero(Zero), .ALU_Result(ALU_Result));
    DM My_DM(.clk(clk), .WE(MemWrite), .PC(pc), .DMop(DMop), .A(MemAddr), .WriteW(MemData), .reset(reset), .ReadData(DMData));
    
    
endmodule
