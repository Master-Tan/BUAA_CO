`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:01:26 12/03/2021 
// Design Name: 
// Module Name:    DataEXT 
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
module DataEXT(
        input wire [1:0] A,
        input wire [31:0] Din,
        input wire [2:0] Op,
        output reg [31:0] Dout
    );


always @(*) begin
    Dout = 32'b0;
    if(Op == 3'b000) begin
        Dout = Din;
    end
    else if(Op == 3'b001) begin
        Dout = {{24{1'b0}},Din[(A*8)+:8]};
    end
    else if(Op == 3'b010) begin
        Dout = {{24{Din[(A*8)+7]}},Din[(A*8)+:8]};
    end
    else if(Op == 3'b011) begin
        Dout = {{16{1'b0}},Din[(A[1]*16)+:16]};
    end
    else if(Op == 3'b100) begin
        Dout = {{16{Din[(A[1]*16)+15]}},Din[(A[1]*16)+:16]};
    end
end


endmodule
