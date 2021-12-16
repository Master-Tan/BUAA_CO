`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:31:57 12/03/2021 
// Design Name: 
// Module Name:    BE 
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
module BE(
        input wire [1:0] data,
        input wire [31:0] WriteData_in,
        input wire [2:0] Op,
        output reg [3:0] DM_control,
        output reg [31:0] WriteData_out
    );

always @(*) begin
    WriteData_out = 32'b0;
    if(Op == 3'b000) begin
        DM_control = 4'b0000;
    end
    else if(Op == 3'b001) begin
        WriteData_out = WriteData_in;
        DM_control = 4'b1111;
    end
    else if(Op == 3'b010) begin
        WriteData_out = {4{WriteData_in[7:0]}};
        case(data)
            2'b00: begin
                DM_control = 4'b0001;
            end
            2'b01: begin
                DM_control = 4'b0010;
            end
            2'b10: begin
                DM_control = 4'b0100;
            end
            2'b11: begin
                DM_control = 4'b1000;
            end
        endcase
    end
    else if(Op == 3'b011) begin
        WriteData_out = {2{WriteData_in[15:0]}};
        casex(data)
            2'b0x: begin
                DM_control = 4'b0011;
            end
            2'b1x: begin
                DM_control = 4'b1100;
            end
        endcase
    end
end

endmodule
