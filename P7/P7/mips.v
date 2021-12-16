`include "CPU.v"
`include "Bridge.v"
`include "Timer0.v"
`include "Timer1.v"

`timescale 1ns / 1ps

`default_nettype none

//////////////////////////////////  ////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:09:31 12/11/2021 
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

module mips(
        input wire clk,                       // 时钟信号
        input wire reset,                     // 同步复位信号
        input wire interrupt,                 // 外部中断信号
        output wire [31:0] macroscopic_pc,    // 宏观 PC（见下文�

        output wire [31:0] i_inst_addr,       // 取指 PC
        input wire [31:0] i_inst_rdata,      // i_inst_addr 对应�2 位指�

        output wire [31:0] m_data_addr,       // 数据存储器待写入地址
        input wire [31:0] m_data_rdata,      // m_data_addr 对应�2 位数�
        output wire [31:0] m_data_wdata,      // 数据存储器待写入数据
        output wire [3 :0] m_data_byteen,     // 字节使能信号

        output wire [31:0] m_inst_addr,       // M 级PC

        output wire w_grf_we,                 // grf 写使能信�
        output wire [4 :0] w_grf_addr,        // grf 待写入寄存器编号
        output wire [31:0] w_grf_wdata,       // grf 待写入数�

        output wire [31:0] w_inst_addr        // W �PC
);
    wire [5:0] HWInt;

    wire [31:0] PC_M;
    assign macroscopic_pc = PC_M;

    assign HWInt = {3'b0, interrupt, IRQ1, IRQ0};

    CPU my_CPU(
        .clk(clk),
        .reset(reset),
        .i_inst_rdata(i_inst_rdata),
        .i_inst_addr(i_inst_addr),
        .w_grf_we(w_grf_we),
        .w_grf_addr(w_grf_addr),
        .w_grf_wdata(w_grf_wdata),
        .w_inst_addr(w_inst_addr),

        .m_data_addr(m_data_addr),       // 数据存储器待写入地址
        .m_data_rdata(m_data_rdata),      // m_data_addr 对应�2 位数�
        .m_data_wdata(m_data_wdata),      // 数据存储器待写入数据
        .m_data_byteen(m_data_byteen),     // 字节使能信号

        .m_inst_addr(m_inst_addr),       // M 级PC

        .HWInt(HWInt),

        .PrAddr(PrAddr),
        .PrWD(PrWD),
        .PrWE(PrWE),
        .PrPC(PrPC),
        .PrRD(PrRD),

        .PC_M(PC_M)
    );

    wire [31:0] PrAddr;
    wire [31:0] PrWD;
    wire [3:0] PrWE;
    wire [31:0] PrPC;
    wire [31:0] PrRD;

    wire [31:0] Timer_Addr, Timer_WD, Timer0_RD, Timer1_RD;
    wire WeTimer0, WeTimer1;

    wire IRQ0, IRQ1;

    Bridge my_Bridge(
        .PrAddr(PrAddr),
        .PrWD(PrWD),
        .PrWE(PrWE),
        .PrPC(PrPC),
        .PrRD(PrRD),

        .Timer_Addr(Timer_Addr),
        .Timer_WD(Timer_WD),
        .Timer0_RD(Timer0_RD),
        .Timer1_RD(Timer1_RD),
        .WeTimer0(WeTimer0),
        .WeTimer1(WeTimer1)
    );



    Timer0 my_Timer0(
        .clk(clk),
        .reset(reset),
        .Addr(Timer_Addr[31:2]),
        .WE(WeTimer0),
        .Din(Timer_WD),
        .Dout(Timer0_RD),
        .IRQ(IRQ0)
    );

    Timer1 my_Timer1(
        .clk(clk),
        .reset(reset),
        .Addr(Timer_Addr[31:2]),
        .WE(WeTimer1),
        .Din(Timer_WD),
        .Dout(Timer1_RD),
        .IRQ(IRQ1)
    );

endmodule
