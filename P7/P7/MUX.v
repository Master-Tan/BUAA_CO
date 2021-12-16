`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    03:29:49 11/12/2021
// Design Name:
// Module Name:    MUX2
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

module MUX2_1(
    input wire S,
    input wire D0,
    input wire D1,
    output wire Out
);
    
    assign Out = (S == 0) ? D0 : D1;
endmodule

module MUX2_5(
    input wire S,
    input wire [4:0] D0,
    input wire [4:0] D1,
    output wire [4:0] Out
);
    
    assign Out = (S == 0) ? D0 : D1;
endmodule

module MUX2_32(
    input wire S,
    input wire [31:0] D0,
    input wire [31:0] D1,
    output wire [31:0] Out
);
    
    assign Out = (S == 0) ? D0 : D1;
endmodule

module MUX4_5(
    input wire [1:0] S,
    input wire [4:0] D0,
    input wire [4:0] D1,
    input wire [4:0] D2,
    input wire [4:0] D3,
    output wire [4:0] Out
);
    
    assign Out = (S[0] == 0 && S[1] == 0) ? D0 :
    (S[0] == 1 && S[1] == 0) ? D1 :
    (S[0] == 0 && S[1] == 1) ? D2 :
    D3 ;
    
endmodule

module MUX4_32(
    input wire [1:0] S,
    input wire [31:0] D0,
    input wire [31:0] D1,
    input wire [31:0] D2,
    input wire [31:0] D3,
    output wire [31:0] Out
);
    
    assign Out = (S[0] == 0 && S[1] == 0) ? D0 :
    (S[0] == 1 && S[1] == 0) ? D1 :
    (S[0] == 0 && S[1] == 1) ? D2 :
    D3 ;
    
endmodule