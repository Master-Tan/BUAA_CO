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
// Create Date:    19:11:04 12/05/2021 
// Design Name: 
// Module Name:    Mult_Div 
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
module E_Mult_Div(
	    input wire clk,
	    input wire reset,
        input wire [31:0] IR,
        input wire [31:0] SrcA,
        input wire [31:0] SrcB,
        input wire start,
        output reg Busy,
        output reg [31:0] M_D
    );

reg [31:0] Hi;
reg [31:0] Lo;
reg [31:0] cnt;
reg [63:0] Result;

initial begin
    Hi <= 32'b0;
    Lo <= 32'b0;
    cnt <= 32'b0;
    Result <= 64'b0;
    Busy <= 1'b0;
    M_D <= 32'b0;
end

always @(*) begin
    if(IR[`opcode]==`OP_rtype & IR[`funct]==`FUNC_mfhi) begin
        M_D = Hi;
    end
    else if(IR[`opcode]==`OP_rtype & IR[`funct]==`FUNC_mflo) begin
        M_D = Lo;
    end
    else if(IR[`opcode]==`OP_rtype & IR[`funct]==`FUNC_mthi) begin
        Hi = SrcA;
    end
    else if(IR[`opcode]==`OP_rtype & IR[`funct]==`FUNC_mtlo) begin
        Lo = SrcA;
    end
    else begin
        M_D = 32'b0;
    end
end

always @(posedge clk) begin
    if(reset) begin
        Hi <= 0;
        Lo <= 0;
        cnt <= 32'b0;
        Result <= 64'b0;
        Busy <= 1'b0;
        M_D <= 32'b0;
    end
    else if(Busy != 1'b1) begin
        if(start == 1'b1) begin
            if(IR[`opcode]==`OP_rtype & IR[`funct]==`FUNC_mult) begin//mult
                Result <= $signed(SrcA)*$signed(SrcB);
                cnt <= 5;
            end
            if(IR[`opcode]==`OP_rtype & IR[`funct]==`FUNC_multu) begin//multu
                Result <= SrcA*SrcB;
                cnt <= 5;
            end
            if(IR[`opcode]==`OP_rtype & IR[`funct]==`FUNC_div) begin//div
                Result <= {$signed(SrcA)%$signed(SrcB),$signed(SrcA)/$signed(SrcB)};
                cnt <= 10;
            end
            if(IR[`opcode]==`OP_rtype & IR[`funct]==`FUNC_divu) begin//divu
                Result <= {SrcA%SrcB,SrcA/SrcB};
                cnt <= 10;
            end
            Busy <= 1;
        end
    end
    else if(Busy == 1) begin
        if(cnt > 0) begin
            cnt = cnt - 1;
            if(cnt == 0) begin
                {Hi,Lo} <= Result;
                Busy <= 0;
            end
        end
    end
end

endmodule
