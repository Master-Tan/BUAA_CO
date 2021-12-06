`timescale 1ns / 1ps
`default_nettype none

`define SIZE 3072
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    20:56:03 11/11/2021
// Design Name:
// Module Name:    DM
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
module M_DM(input wire clk,
          input wire reset,
          input wire WE,
          input wire [31:0] WPC,
          input wire [1:0] DMop,
          input wire [31:0] A,
          input wire [31:0] WriteW,
          output reg [31:0] ReadData);
    
    // RAM
    reg [31:0] dm [0:`SIZE-1];
    
    
    reg [31:0] WriteData;
    
    wire [31:0] ReadW;
    assign ReadW = dm[A[13:2]];
    
    // 写入逻辑
    always @(*) begin
        case(DMop)
            2'b00: begin
                WriteData = WriteW;
            end
            2'b01: begin
                WriteData = (A[1:0] == 2'b00) ? {ReadW[31:8],WriteW[7:0]} :
                (A[1:0] == 2'b01) ? {ReadW[31:16],WriteW[7:0],ReadW[7:0]} :
                (A[1:0] == 2'b10) ? {ReadW[31:24],WriteW[7:0],ReadW[15:0]} :
                {WriteW[7:0],ReadW[23:0]};
            end
            2'b10: begin
                WriteData = (A[1] == 1'b0) ? {ReadW[31:16],WriteW[15:0]} : {WriteW[15:0],ReadW[31:16]};
            end
            default: WriteData = 32'h00000000;
        endcase
    end
    
    // 写入
    integer i;
    
    always @(posedge clk) begin
        if (reset == 1) begin
            for (i = 0;i<`SIZE;i = i+1) begin
                dm[i] <= 32'b0;
            end
        end
        else begin
            if (WE == 1) begin
                dm[A[13:2]]        <= WriteData;
                $display("%d@%h: *%h <= %h", $time, WPC, A, WriteData);
            end
        end
    end
    
    // 读取逻辑
    always @(*) begin
        case(DMop)
            2'b00: begin
                ReadData = ReadW;
            end
            2'b01: begin
                ReadData = (A[1:0] == 2'b00) ? {{24{ReadW[7]}},ReadW[7:0]} :
                (A[1:0] == 2'b01) ? {{24{ReadW[15]}},ReadW[15:8]} :
                (A[1:0] == 2'b10) ? {{24{ReadW[23]}},ReadW[23:16]} :
                {{24{ReadW[31]}},ReadW[31:24]};
            end
            2'b10: begin
                ReadData = (A[1] == 1'b0) ? {{16{ReadW[15]}},ReadW[15:0]} :
                {{16{ReadW[31]}},ReadW[31:16]};
            end
            default:ReadData = 32'h00000000;
        endcase
    end
    
endmodule
