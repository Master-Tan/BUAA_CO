`include "const.v"


`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    20:54:04 11/11/2021
// Design Name:
// Module Name:    Control_Unit
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
module Control_Unit(input wire [5:0] opcode,
                    input wire [5:0] funct,
                    output reg RegWrite,
                    output reg MemWrite,
                    output reg [1:0] DMop,
                    output reg [2:0] ALU_Control,
                    output reg [2:0] CMP_type,
                    output reg [2:0] NPC_sel,
                    output reg [1:0] EXTop,
                    output reg [1:0] PC_sel,
                    output reg ALU_Bsel,
                    output reg [1:0] A3_RFsel,
                    output reg [1:0] RF_WDsel
            );

initial  begin
	PC_sel <= 2'b00;
end


always@(*) begin

    RegWrite         = 1'b0;
    MemWrite         = 1'b0;
    DMop             = 2'b00;
    ALU_Control      = 3'b010;
    CMP_type         = 3'b000;
    NPC_sel          = 3'b000;
    EXTop            = 2'b00;
    PC_sel           = 2'b00;
    ALU_Bsel         = 1'b0;
    A3_RFsel         = 2'b00;
    RF_WDsel         = 2'b00;

    case(opcode)
        `OP_rtype: begin
            case(funct)
                `FUNC_addu: begin
                    RegWrite         = 1'b1;
                    MemWrite         = 1'b0;
                    ALU_Control      = 3'b010;
                    PC_sel           = 2'b00;
                    ALU_Bsel         = 1'b0;
                    A3_RFsel         = 2'b01;
                    RF_WDsel         = 2'b00;
                end

                `FUNC_subu: begin
                    RegWrite         = 1'b1;
                    MemWrite         = 1'b0;
                    ALU_Control      = 3'b110;
                    PC_sel           = 2'b00;
                    ALU_Bsel         = 1'b0;
                    A3_RFsel         = 2'b01;
                    RF_WDsel         = 2'b00;
                end

                `FUNC_jr: begin
                    RegWrite         = 1'b1;
                    MemWrite         = 1'b0;
                    ALU_Control      = 3'b010;
                    PC_sel           = 2'b10;
                    ALU_Bsel         = 1'b0;
                    A3_RFsel         = 2'b01;
                    RF_WDsel         = 2'b00;
                end

                default: begin
                    RegWrite         = 1'b0;
                    MemWrite         = 1'b0;
                    DMop             = 2'b00;
                    ALU_Control      = 3'b010;
                    CMP_type         = 3'b000;
                    NPC_sel          = 3'b000;
                    EXTop            = 2'b00;
                    PC_sel           = 2'b00;
                    ALU_Bsel         = 1'b0;
                    A3_RFsel         = 2'b00;
                    RF_WDsel         = 2'b00;
                end    

            endcase
        end

        `OP_lw: begin
            RegWrite         = 1'b1;
            MemWrite         = 1'b0;
            DMop             = 2'b00;
            ALU_Control      = 3'b010;
            EXTop            = 2'b01;
            PC_sel           = 2'b00;
            ALU_Bsel         = 1'b1;
            A3_RFsel         = 2'b00;
            RF_WDsel         = 2'b01;
        end
        
        `OP_sw: begin
            RegWrite         = 1'b0;
            MemWrite         = 1'b1;
            DMop             = 2'b00;
            ALU_Control      = 3'b010;
            EXTop            = 2'b01;
            PC_sel           = 2'b00;
            ALU_Bsel         = 1'b1;
        end

        `OP_lui: begin
            RegWrite         = 1'b1;
            MemWrite         = 1'b0;
            EXTop            = 2'b10;
            PC_sel           = 2'b00;
            ALU_Bsel         = 1'b1;
            A3_RFsel         = 2'b00;
            RF_WDsel         = 2'b11;
        end

        `OP_ori: begin
            RegWrite         = 1'b1;
            MemWrite         = 1'b0;
            ALU_Control      = 3'b001;
            EXTop            = 2'b00;
            PC_sel           = 2'b00;
            ALU_Bsel         = 1'b1;
            A3_RFsel         = 2'b00;
            RF_WDsel         = 2'b00;
        end

        `OP_beq: begin
            RegWrite         = 1'b0;
            MemWrite         = 1'b0;
            CMP_type         = 3'b001;
            NPC_sel          = 3'b010;
            EXTop            = 2'b01;
            PC_sel           = 2'b01;
            ALU_Bsel         = 1'b0;
        end

        `OP_addi: begin
            RegWrite         = 1'b1;
            MemWrite         = 1'b0;
            ALU_Control      = 3'b010;
            EXTop            = 2'b01;
            PC_sel           = 2'b00;
            ALU_Bsel         = 1'b1;
            A3_RFsel         = 2'b00;
            RF_WDsel         = 2'b00;
        end
        
        `OP_j: begin
            RegWrite         = 1'b0;
            MemWrite         = 1'b0;
            NPC_sel          = 3'b001;
            PC_sel           = 2'b01;	
        end

        `OP_jal: begin
            RegWrite         = 1'b1;
            MemWrite         = 1'b0;
            NPC_sel          = 3'b001;
            PC_sel           = 2'b01;
            A3_RFsel         = 2'b10;
            RF_WDsel         = 2'b10;
        end

        `OP_lb: begin
            RegWrite         = 1'b1;
            MemWrite         = 1'b0;
            DMop             = 2'b01;
            ALU_Control      = 3'b010;
            EXTop            = 2'b01;
            PC_sel           = 2'b00;
            ALU_Bsel         = 1'b1;
            A3_RFsel         = 2'b00;
            RF_WDsel         = 2'b01;
        end

        `OP_sb: begin
            RegWrite         = 1'b0;
            MemWrite         = 1'b1;
            DMop             = 2'b01;
            ALU_Control      = 3'b010;
            EXTop            = 2'b01;
            PC_sel           = 2'b00;
            ALU_Bsel         = 1'b1;
        end

        `OP_lh: begin
            RegWrite         = 1'b1;
            MemWrite         = 1'b0;
            DMop             = 2'b10;
            ALU_Control      = 3'b010;
            EXTop            = 2'b01;
            PC_sel           = 2'b00;
            ALU_Bsel         = 1'b1;
            A3_RFsel         = 2'b00;
            RF_WDsel         = 2'b01;
        end

        `OP_sh: begin
            RegWrite         = 1'b0;
            MemWrite         = 1'b1;
            DMop             = 2'b10;
            ALU_Control      = 3'b010;
            EXTop            = 2'b01;
            PC_sel           = 2'b00;
            ALU_Bsel         = 1'b1;
        end
        
        default: begin
            RegWrite         = 1'b0;
            MemWrite         = 1'b0;
            DMop             = 2'b00;
            ALU_Control      = 3'b010;
            CMP_type         = 3'b000;
            NPC_sel          = 3'b000;
            EXTop            = 2'b00;
            PC_sel           = 2'b00;
            ALU_Bsel         = 1'b0;
            A3_RFsel         = 2'b00;
            RF_WDsel         = 2'b00;
        end    

    endcase
end	


endmodule
