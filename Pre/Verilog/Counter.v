`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:52:33 10/06/2021 
// Design Name: 
// Module Name:    Counter 
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
module Counter(
	input Clk,
    input Reset,
    input Slt,
    input En,
    output reg [63:0] Output0,
    output reg [63:0] Output1
    );

    initial
    begin
        // $dumpfile("wave.vcd");        //生成的vcd文件名称
        // $dumpvars(0,Counter);
        Output0 <= 0;
        Output1 <= 0;
        cnt <= 0;
    end

    reg [2:0] cnt;

    always @(posedge Clk) begin
        if (Reset==1) begin
            Output0 <= 0;
            Output1 <= 0;
            cnt <= 0;
        end
        else begin
            if (En==1) begin
                if (Slt==0) begin
                    Output0 <= Output0 + 1;
                end
                else begin
                    if (cnt==3) begin
                        cnt <= 0;
                        Output1 <= Output1 + 1;
                    end
                    else begin
                        cnt <= cnt + 1;
                    end
                end
            end
        end
    end


endmodule
