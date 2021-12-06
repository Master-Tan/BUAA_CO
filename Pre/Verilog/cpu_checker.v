`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    13:45:05 10/06/2021
// Design Name:
// Module Name:    cpu_checker
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

`define S0 4'd0
`define S1 4'd1
`define S2 4'd2
`define S3 4'd3
`define S4 4'd4
`define S5 4'd5
`define S6 4'd6
`define S7 4'd7
`define S8 4'd8
`define S9 4'd9
`define S10 4'd10
`define S11 4'd11
`define S12 4'd12
`define S13 4'd13
`define S14 4'd14
`define S15 4'd15

module cpu_checker(input clk,
                   input reset,
                   input [7:0] char,
                   output [1:0] format_type);
    
    reg [3:0] status;
    reg [3:0] status2;
    reg [7:0] num;
    reg [7:0] num2;
    initial
    begin
        status  <= `S0;
        status2 <= `S0;
        num     <= 0;
        num2    <= 0;
    end
    
    always@(posedge clk)
    begin
        if (reset == 1) begin
            status  <= `S0;
            status2 <= `S0;
            num     <= 0;
            num2    <= 0;
        end
        else begin
            if ((char <= "9" && char >= "0") || (char <= "f" && char >= "a")) begin
                if (char <= "9" && char >= "0") begin
                    if (num == 9) begin
                        num <= 9;
                    end
                    else begin
                        num = num + 1;
                    end
                end
                else begin
                    num <= 0;
                end
                begin
                    if (num2 == 9) begin
                        num2 <= 9;
                    end
                    else begin
                        num2 = num2 + 1;
                    end
                end
            end
            else begin
                num = 0;
                num2 = 0;
            end
            case(status)
                `S0 :  begin
                    if (char == "^")
                    begin
                        status <= `S1;
                    end
                    else
                    begin
                        status <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S1 : begin
                    if (num > 0 && num < 5)
                    begin
                        status <= `S2;
                    end
                    else
                    begin
                        status <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S2 : begin
                    if (char == "@")
                    begin
                        status <= `S3;
                    end
                    else if (num > 0 && num < 5)
                    begin
                        status <= `S2;
                    end
                    else
                    begin
                        status <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S3 : begin
                    if (num2 == 8)
                    begin
                        status <= `S4;
                    end
                    else if (num2 > 0 && num2 <8)
                    begin
                        status <= `S3;
                    end
                    else
                    begin
                        status <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S4 : begin
                    if (char == ":")
                    begin
                        status <= `S5;
                    end
                    else
                    begin
                        status <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S5 : begin
                    if (char == " ")
                    begin
                        status <= `S5;
                    end
                    else if (char == "$")
                    begin
                        status <= `S6;
                    end
                    else
                    begin
                        status <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S6 : begin
                    if (num > 0 && num < 5)
                    begin
                        status <= `S7;
                    end
                    else
                    begin
                        status <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S7 : begin
                    if (char == " ")
                    begin
                        status <= `S8;
                    end
                    else if (char == "<")
                    begin
                        status <= `S9;
                    end
                    else if (num > 0 && num < 5)
                    begin
                        status <= `S7;
                    end
                    else
                    begin
                        status <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S8 : begin
                    if (char == " ")
                    begin
                        status <= `S8;
                    end
                    else if (char == "<")
                    begin
                        status <= `S9;
                    end
                    else
                    begin
                        status <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S9 : begin
                    if (char == "=")
                    begin
                        status <= `S10;
                    end
                    else
                    begin
                        status <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S10 : begin
                    if (char == " " && num2 == 0)
                    begin
                        status <= `S10;
                    end
                    else if (num2 == 8)
                    begin
                        status <= `S11;
                    end
                    else if (char != " " && num2 > 0 && num2 <8)
                    begin
                        status <= `S10;
                    end
                    else
                    begin
                        status <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S11 : begin
                    if (char == "#")
                    begin
                        status <= `S12;
                    end
                    else
                    begin
                        status <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S12 : begin
                    if (char == "^")
                    begin
                        status <= `S1;
                    end
                    else
                    begin
                        status <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
            endcase

            case(status2)
                `S0 :  begin
                    if (char == "^")
                    begin
                        status2 <= `S1;
                    end
                    else
                    begin
                        status2 <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S1 : begin
                    if (num > 0 && num < 5)
                    begin
                        status2 <= `S2;
                    end
                    else
                    begin
                        status2 <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S2 : begin
                    if (char == "@")
                    begin
                        status2 <= `S3;
                    end
                    else if (num > 0 && num < 5)
                    begin
                        status2 <= `S2;
                    end
                    else
                    begin
                        status2 <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S3 : begin
                    if (num2 == 8)
                    begin
                        status2 <= `S4;
                    end
                    else if (num2 > 0 && num2 <8)
                    begin
                        status2 <= `S3;
                    end
                    else
                    begin
                        status2 <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S4 : begin
                    if (char == ":")
                    begin
                        status2 <= `S5;
                    end
                    else
                    begin
                        status2 <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S5 : begin
                    if (char == " ")
                    begin
                        status2 <= `S5;
                    end
                    else if (char == "*")
                    begin
                        status2 <= `S6;
                    end
                    else
                    begin
                        status2 <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S6 : begin
                    if (num2 == 8)
                    begin
                        status2 <= `S7;
                    end
                    else if (num2 > 0 && num2 < 8)
                    begin
                        status2 <= `S6;
                    end
                    else
                    begin
                        status2 <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S7 : begin
                    if (char == " ")
                    begin
                        status2 <= `S8;
                    end
                    else if (char == "<")
                    begin
                        status2 <= `S9;
                    end
                    else
                    begin
                        status2 <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S8 : begin
                    if (char == " ")
                    begin
                        status2 <= `S8;
                    end
                    else if (char == "<")
                    begin
                        status2 <= `S9;
                    end
                    else
                    begin
                        status2 <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S9 : begin
                    if (char == "=")
                    begin
                        status2 <= `S10;
                    end
                    else
                    begin
                        status2 <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S10 : begin
                    if (char == " " && num2 == 0)
                    begin
                        status2 <= `S10;
                    end
                    else if (num2 == 8)
                    begin
                        status2 <= `S11;
                    end
                    else if (char != " " && num2 > 0 && num2 <8)
                    begin
                        status2 <= `S10;
                    end
                    else
                    begin
                        status2 <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S11 : begin
                    if (char == "#")
                    begin
                        status2 <= `S12;
                    end
                    else
                    begin
                        status2 <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
                `S12 : begin
                    if (char == "^")
                    begin
                        status2 <= `S1;
                    end
                    else
                    begin
                        status2 <= `S0; //对于一切非正常输出，回到状态0
                    end
                end
            endcase

        end

    end
    
    assign format_type = (status2 == `S12) ? 2'b10 :
    (status == `S12) ? 2'b01 : 2'b00;
    
    
endmodule
