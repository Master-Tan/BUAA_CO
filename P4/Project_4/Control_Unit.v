`define ADDU  6'b100001
`define SUBU  6'b100011
`define ORI   6'b001101
`define LW    6'b100011
`define SW    6'b101011
`define BEQ   6'b000100
`define JAL   6'b000011
`define JR    6'b001000
`define LUI   6'b001111
`define LB    6'b100000
`define SB    6'b101000
`define LH    6'b100001
`define SH    6'b101001
`define RTYPE 6'b000000
`define ADDI  6'b001000
`define JALR  6'b001001
`define J     6'b000010
`define ADD   6'b100000
`define SUB   6'b100010
`define OR_0  6'b100101
`define AND_0   6'b100100


`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    20:54:04 11/11/2021
// Design Name:
// Module Name:    Control_Unit
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
module Control_Unit(input wire [5:0] opcode,
                    input wire [5:0] funct,
                    output wire [1:0] MemtoReg,
                    output wire [1:0] DMop,
                    output wire MemWrite,
                    output wire Branch,
                    output wire [2:0] ALU_Control,
                    output wire ALUSrc,
                    output wire [1:0] RegDst,
                    output wire ToHigh_16,
                    output wire EXTop,
                    output wire RegWrite,
                    output wire [1:0] Jump);

wire RType;
wire addu,subu,ori,lw,sw,beq,jal,jr,lui,lb,sb,lh,sh,addi,jalr,j,and_0,or_0,sub,add;

assign RType = (opcode == `RTYPE);
assign addu  = RType&(funct == `ADDU);
assign subu  = RType&(funct == `SUBU);
assign ori   = (opcode == `ORI);
assign lw    = (opcode == `LW);
assign sw    = (opcode == `SW);
assign beq   = (opcode == `BEQ);
assign jal   = (opcode == `JAL);
assign jr    = RType&(funct == `JR);
assign lui   = (opcode == `LUI);
assign lb    = (opcode == `LB);
assign sb    = (opcode == `SB);
assign sh    = (opcode == `SH);
assign lh    = (opcode == `LH);
assign addi  = (opcode == `ADDI);
assign jalr  = RType&(funct == `JALR);
assign j     = (opcode == `J);
assign and_0 = (opcode == `AND_0);
assign or_0  = (opcode == `OR_0);
assign add   = (opcode == `ADD);
assign sub   = (opcode == `SUB);



assign RegWrite       = RType | lw | addi | ori | lui | lb | lh | jal;
assign EXTop          = lw | sw | addi | lui | lb | sb | lh | sh | beq;
assign RegDst[1]      = jal;
assign RegDst[0]      = RType;
assign ToHigh_16      = lui;
assign ALUSrc         = lw | sw | addi | ori | lui | lb | sb | lh | sh;
assign Branch         = beq;
assign MemWrite       = sw | sb | sh;
assign MemtoReg[1]    = jal;
assign MemtoReg[0]    = lw | lb | lh;
assign Jump[1]        = jr;
assign Jump[0]        = j | jal;
assign DMop[1]        = lh | sh;
assign DMop[0]        = lb | sb;
assign ALU_Control[2] = beq | sub | subu;
assign ALU_Control[1] = sub | add | lw | sw | beq | addi | lb | sb | lh | sh | addu | subu;
assign ALU_Control[0] = ori | or_0;

endmodule
