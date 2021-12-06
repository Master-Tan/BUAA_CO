`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    10:44:29 10/06/2021
// Design Name:
// Module Name:    checkID
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
`define S0 2'b00
`define S1 2'b01
`define S2 2'b10
module id_fsm(input [7:0] char,
              input clk,
              output out);

reg [1:0] status;
initial
begin
    status <= `S0;
end

always@(posedge clk)
begin
    case(status)
        `S0 : begin
            if ((char < 123 && char > 96) || (char > 64 && char < 91))
            begin
                status <= `S1;
            end
            else
            begin
                status <= `S0; //对于一切非正常输出，回到状态0
            end
        end
        `S1 : begin
            if ((char < 123 && char > 96) || (char > 64 && char < 91))
            begin
                status <= `S1;
            end
            else if (char < 58 && char > 47)
            begin
                status <= `S2;
            end
            else
            begin
                status <= `S0; //对于一切非正常输出，回到状态0
            end
        end
        `S2 : begin
            if ((char < 123 && char > 96) || (char > 64 && char < 91))
            begin
                status <= `S1;
            end
            else if (char < 58 && char > 47)
            begin
                status <= `S2;
            end
            else
            begin
                status <= `S0; //对于一切非正常输出，回到状态0
            end
        end
    endcase
end

assign out = (status == `S2) ? 1'b1 : 1'b0;
endmodule
