`timescale 1ns / 1ps

`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:17:53 12/11/2021 
// Design Name: 
// Module Name:    CP0 
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
module CP0(
        input wire [4:0] A1,             // 读CP0寄存器编号 执行MFC0指令时产生
        input wire [4:0] A2,             // 写CP0寄存器编号 执行MTC0指令时产生
        input wire bdIn,
        input wire We,                   // CP0写使能 执行MTC0指令时产生
        input wire [31:0] DIn,           // CP0寄存器的写入数据 执行MTC0指令时产生 数据来自GPR
        input wire [31:0] PC,            // 中断/异常时的PC 
        input wire [6:2] ExcCode,        // 中断/异常的类型 
        input wire [5:0] HWInt,          // 6个设备中断 
        input wire EXLClr,               // 用于清除SR的EXL(EXL为0) 执行ERET指令时产生
        input wire clk,
        input wire reset,
        output wire Interrupt,            // 中断请求 由 CP0 模块确认响应中断
        output wire [31:0] EPC,           // EPC寄存器输出至NPC
        output wire [31:0] DOut,          // CP0寄存器的输出数据 执行MFC0指令时产生，输出数据至GRF
        output reg Stop
);



// SR = {16'b0, IM, 8'b0, EXL, IE}
reg [31:0] SR;         // 表示系统的状态，比如能不能发生异常
`define IM SR[15:10]   // 允许发生中断的类型
`define EXL SR[1]      // 表示是否中断异常中
`define IE SR[0]       // 表示是否允许中断

// Cause = {BD, 15'b0, IP, 3'b0,EC,2'b0}
reg [31:0] Cause;      // 记录异常的信息，比如是否处于延迟槽以及异常的原因
`define BD Cause[31]   // 表示延迟槽标记
`define IP Cause[15:10]// hwint_pend 表示发生了哪个中断
`define EC Cause[6:2]  // ExcCode 表示异常原因

// EPC = epc
reg [31:0] epc;        // 记录发生异常的位置，便于处理完中断异常的时候返回

// PRID = prid
reg [31:0] prid;       // 是一个可以随便定义的寄存器，表示你的 CPU 型号

initial begin          // 初始化
    SR      <= 32'b0;
    Cause   <= 32'b0;
    epc     <= 32'b0;
    prid    <= 32'h2037_3864;
    Stop    <= 0;
end

// mtf0 时读取数据
assign DOut = (A1 == 12) ? SR:
              (A1 == 13) ? Cause:
              (A1 == 14) ? EPCout:
              (A1 == 15) ? prid:
              0;

wire IntReq;  // 是否 允许当前中断 且 不在中断异常中 且 允许中断发生
assign IntReq = ((HWInt & `IM) != 0) & (!`EXL) & `IE;

wire ExcReq;  // 是否 存在异常 且 不在中断中
assign ExcReq = (ExcCode != 0) & (!`EXL);

assign Interrupt  = IntReq | ExcReq; // 确认是否响应中断

wire [31:0] EPCout; // 如果BD信号为真时，应该输出上一条指令(跳转指令)的PC
assign EPCout = (Interrupt) ? (bdIn ? PC-4 : PC) : epc;

assign EPC = {EPCout[31:2], 2'b0}; // 对齐PC

always@(posedge clk)begin

    Stop <= (IntReq & HWInt[2]==1'b1 & SR[12]);

    if(reset)begin
        SR      <= 0;
        Cause   <= 0;
        epc     <= 0;
        prid    <= 32'h2037_3864;
        Stop    <= 0;
    end
    else begin
        if (EXLClr) `EXL <= 1'b0; // 重置 外接M_eret信号

        if (Interrupt) begin // IntReq | ExcReq;   发生异常的处理方法：
            `EC <= IntReq ? 5'b0 : ExcCode;
            `EXL <= 1'b1;         // 表示正在中断
            `BD <= bdIn;
            epc <= EPCout;
        end
        else if (We) begin // mtc0 & !(IntReq | ExcReq) 不中断 且 写使能有效时（即为mtc0指令）
            if(A2 == 12) begin
                SR <= DIn;
            end
            else if(A2 == 14) begin
                epc <= DIn;
            end
            else begin
            end
        end

        `IP <= HWInt;    // 每个周期更新外界接收到的中断类型输入

    end
end

endmodule
