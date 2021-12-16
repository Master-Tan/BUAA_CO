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
                    input wire [4:0] rt,
                    input wire [31:0] IR,
                    output reg RegWrite,
                    output reg [2:0] DMop_R,
                    output reg [2:0] DMop_S,
                    output reg [3:0] ALU_Control,
                    output reg [2:0] CMP_type,
                    output reg [2:0] NPC_sel,
                    output reg [1:0] EXTop,
                    output reg [1:0] PC_sel,
                    output reg ALU_Asel,
                    output reg ALU_Bsel,
                    output reg start,
                    output reg M_D_sel,
                    output reg [1:0] A3_RFsel,
                    output reg [1:0] RF_WDsel
            );

initial  begin
	PC_sel <= 2'b00;
end


always@(*) begin

    RegWrite         = 1'b0;
    DMop_R           = 3'b000;
    DMop_S           = 3'b000;
    ALU_Control      = 4'b0010;
    CMP_type         = 3'b000;
    NPC_sel          = 3'b000;
    EXTop            = 2'b00;
    PC_sel           = 2'b00;
    ALU_Asel         = 1'b0;
    ALU_Bsel         = 1'b0;
    start            = 1'b0;
    M_D_sel          = 1'b0;
    A3_RFsel         = 2'b00;
    RF_WDsel         = 2'b00;

    if(IR[31:21] == `OP_mtc0) begin
        RegWrite         = 1'b0;
        DMop_S           = 3'b000;
        PC_sel           = 2'b00;
        start            = 1'b0;
    end

    else if(IR[31:21] == `OP_mfc0) begin
        RegWrite         = 1'b1;
        DMop_S           = 3'b000;
        PC_sel           = 2'b00;
        start            = 1'b0;
        A3_RFsel         = 2'b00;
        RF_WDsel         = 2'b11;
    end

    else begin
        case(opcode)
            `OP_rtype: begin
                case(funct)
                    `FUNC_add: begin
                        RegWrite         = 1'b1;
                        DMop_S           = 3'b000;
                        ALU_Control      = 4'b0010;
                        PC_sel           = 2'b00;
                        ALU_Asel         = 1'b0;
                        ALU_Bsel         = 1'b0;
                        M_D_sel          = 1'b0;
                        A3_RFsel         = 2'b01;
                        RF_WDsel         = 2'b00;
                    end

                    `FUNC_addu: begin
                        RegWrite         = 1'b1;
                        DMop_S           = 3'b000;
                        ALU_Control      = 4'b0010;
                        PC_sel           = 2'b00;
                        ALU_Asel         = 1'b0;
                        ALU_Bsel         = 1'b0;
                        M_D_sel          = 1'b0;
                        A3_RFsel         = 2'b01;
                        RF_WDsel         = 2'b00;
                    end

                    `FUNC_sub: begin
                        RegWrite         = 1'b1;
                        DMop_S           = 3'b000;
                        ALU_Control      = 4'b0110;
                        PC_sel           = 2'b00;
                        ALU_Asel         = 1'b0;
                        ALU_Bsel         = 1'b0;
                        M_D_sel          = 1'b0;
                        A3_RFsel         = 2'b01;
                        RF_WDsel         = 2'b00;
                    end

                    `FUNC_subu: begin
                        RegWrite         = 1'b1;
                        DMop_S           = 3'b000;
                        ALU_Control      = 4'b0110;
                        PC_sel           = 2'b00;
                        ALU_Asel         = 1'b0;
                        ALU_Bsel         = 1'b0;
                        M_D_sel          = 1'b0;
                        A3_RFsel         = 2'b01;
                        RF_WDsel         = 2'b00;
                    end

                    `FUNC_and: begin
                        RegWrite         = 1'b1;
                        DMop_S           = 3'b000;
                        ALU_Control      = 4'b0000;
                        PC_sel           = 2'b00;
                        ALU_Asel         = 1'b0;
                        ALU_Bsel         = 1'b0;
                        M_D_sel          = 1'b0;
                        A3_RFsel         = 2'b01;
                        RF_WDsel         = 2'b00;
                    end

                    `FUNC_or: begin
                        RegWrite         = 1'b1;
                        DMop_S           = 3'b000;
                        ALU_Control      = 4'b0001;
                        PC_sel           = 2'b00;
                        ALU_Asel         = 1'b0;
                        ALU_Bsel         = 1'b0;
                        M_D_sel          = 1'b0;
                        A3_RFsel         = 2'b01;
                        RF_WDsel         = 2'b00;
                    end

                    `FUNC_xor: begin
                        RegWrite         = 1'b1;
                        DMop_S           = 3'b000;
                        ALU_Control      = 4'b0011;
                        PC_sel           = 2'b00;
                        ALU_Asel         = 1'b0;
                        ALU_Bsel         = 1'b0;
                        M_D_sel          = 1'b0;
                        A3_RFsel         = 2'b01;
                        RF_WDsel         = 2'b00;
                    end

                    `FUNC_nor: begin
                        RegWrite         = 1'b1;
                        DMop_S           = 3'b000;
                        ALU_Control      = 4'b0100;
                        PC_sel           = 2'b00;
                        ALU_Asel         = 1'b0;
                        ALU_Bsel         = 1'b0;
                        M_D_sel          = 1'b0;
                        A3_RFsel         = 2'b01;
                        RF_WDsel         = 2'b00;
                    end

                    `FUNC_slt: begin
                        RegWrite         = 1'b1;
                        DMop_S           = 3'b000;
                        ALU_Control      = 4'b0101;
                        PC_sel           = 2'b00;
                        ALU_Asel         = 1'b0;
                        ALU_Bsel         = 1'b0;
                        M_D_sel          = 1'b0;
                        A3_RFsel         = 2'b01;
                        RF_WDsel         = 2'b00;
                    end

                    `FUNC_sltu: begin
                        RegWrite         = 1'b1;
                        DMop_S           = 3'b000;
                        ALU_Control      = 4'b0111;
                        PC_sel           = 2'b00;
                        ALU_Asel         = 1'b0;
                        ALU_Bsel         = 1'b0;
                        M_D_sel          = 1'b0;
                        A3_RFsel         = 2'b01;
                        RF_WDsel         = 2'b00;
                    end

                    `FUNC_jr: begin
                        RegWrite         = 1'b0;
                        DMop_S           = 3'b000;
                        ALU_Control      = 4'b0010;
                        PC_sel           = 2'b10;
                    end

                    `FUNC_jalr: begin
                        RegWrite         = 1'b1;
                        DMop_S           = 3'b000;
                        PC_sel           = 2'b10;
                        ALU_Asel         = 1'b0;
                        ALU_Bsel         = 1'b0;
                        M_D_sel          = 1'b0;
                        A3_RFsel         = 2'b01;
                        RF_WDsel         = 2'b10;
                    end

                    `FUNC_sll: begin
                        RegWrite         = 1'b1;
                        DMop_S           = 3'b000;
                        ALU_Control      = 4'b1001;
                        PC_sel           = 2'b00;
                        ALU_Asel         = 1'b1;
                        ALU_Bsel         = 1'b0;
                        M_D_sel          = 1'b0;
                        A3_RFsel         = 2'b01;
                        RF_WDsel         = 2'b00;
                    end

                    `FUNC_srl: begin
                        RegWrite         = 1'b1;
                        DMop_S           = 3'b000;
                        ALU_Control      = 4'b1010;
                        PC_sel           = 2'b00;
                        ALU_Asel         = 1'b1;
                        ALU_Bsel         = 1'b0;
                        M_D_sel          = 1'b0;
                        A3_RFsel         = 2'b01;
                        RF_WDsel         = 2'b00;
                    end

                    `FUNC_sra: begin
                        RegWrite         = 1'b1;
                        DMop_S           = 3'b000;
                        ALU_Control      = 4'b1011;
                        PC_sel           = 2'b00;
                        ALU_Asel         = 1'b1;
                        ALU_Bsel         = 1'b0;
                        M_D_sel          = 1'b0;
                        A3_RFsel         = 2'b01;
                        RF_WDsel         = 2'b00;
                    end

                    `FUNC_sllv: begin
                        RegWrite         = 1'b1;
                        DMop_S           = 3'b000;
                        ALU_Control      = 4'b1001;
                        PC_sel           = 2'b00;
                        ALU_Asel         = 1'b0;
                        ALU_Bsel         = 1'b0;
                        M_D_sel          = 1'b0;
                        A3_RFsel         = 2'b01;
                        RF_WDsel         = 2'b00;
                    end

                    `FUNC_srlv: begin
                        RegWrite         = 1'b1;
                        DMop_S           = 3'b000;
                        ALU_Control      = 4'b1010;
                        PC_sel           = 2'b00;
                        ALU_Asel         = 1'b0;
                        ALU_Bsel         = 1'b0;
                        M_D_sel          = 1'b0;
                        A3_RFsel         = 2'b01;
                        RF_WDsel         = 2'b00;
                    end

                    `FUNC_srav: begin
                        RegWrite         = 1'b1;
                        DMop_S           = 3'b000;
                        ALU_Control      = 4'b1011;
                        PC_sel           = 2'b00;
                        ALU_Asel         = 1'b0;
                        ALU_Bsel         = 1'b0;
                        M_D_sel          = 1'b0;
                        A3_RFsel         = 2'b01;
                        RF_WDsel         = 2'b00;
                    end

                    `FUNC_mthi: begin
                        RegWrite         = 1'b0;
                        DMop_S           = 3'b000;
                        PC_sel           = 2'b00;
                        start            = 1'b0;
                    end

                    `FUNC_mtlo: begin
                        RegWrite         = 1'b0;
                        DMop_S           = 3'b000;
                        PC_sel           = 2'b00;
                        start            = 1'b0;
                    end

                    `FUNC_mfhi: begin
                        RegWrite         = 1'b1;
                        DMop_S           = 3'b000;
                        PC_sel           = 2'b00;
                        start            = 1'b0;
                        M_D_sel          = 1'b1;
                        A3_RFsel         = 2'b01;
                        RF_WDsel         = 2'b00;
                    end

                    `FUNC_mflo: begin
                        RegWrite         = 1'b1;
                        DMop_S           = 3'b000;
                        PC_sel           = 2'b00;
                        start            = 1'b0;
                        M_D_sel          = 1'b1;
                        A3_RFsel         = 2'b01;
                        RF_WDsel         = 2'b00;
                    end

                    `FUNC_mult: begin
                        RegWrite         = 1'b0;
                        DMop_S           = 3'b000;
                        PC_sel           = 2'b00;
                        start            = 1'b1;
                    end

                    `FUNC_multu: begin
                        RegWrite         = 1'b0;
                        DMop_S           = 3'b000;
                        PC_sel           = 2'b00;
                        start            = 1'b1;
                    end

                    `FUNC_div: begin
                        RegWrite         = 1'b0;
                        DMop_S           = 3'b000;
                        PC_sel           = 2'b00;
                        start            = 1'b1;
                    end

                    `FUNC_divu: begin
                        RegWrite         = 1'b0;
                        DMop_S           = 3'b000;
                        PC_sel           = 2'b00;
                        start            = 1'b1;
                    end

                    default: begin
                        RegWrite         = 1'b0;
                        DMop_R           = 3'b000;
                        DMop_S           = 3'b000;
                        ALU_Control      = 4'b0010;
                        CMP_type         = 3'b000;
                        NPC_sel          = 3'b000;
                        EXTop            = 2'b00;
                        PC_sel           = 2'b00;
                        ALU_Asel         = 1'b0;
                        ALU_Bsel         = 1'b0;
                        start            = 1'b0;
                        M_D_sel          = 1'b0;
                        A3_RFsel         = 2'b00;
                        RF_WDsel         = 2'b00;
                    end    

                endcase
            end

            `OP_lw: begin
                RegWrite         = 1'b1;
                DMop_R           = 3'b000;
                DMop_S           = 3'b000;
                ALU_Control      = 4'b0010;
                EXTop            = 2'b01;
                PC_sel           = 2'b00;
                ALU_Asel         = 1'b0;
                ALU_Bsel         = 1'b1;
                M_D_sel          = 1'b0;
                A3_RFsel         = 2'b00;
                RF_WDsel         = 2'b01;
            end

            `OP_lb: begin
                RegWrite         = 1'b1;
                DMop_R           = 3'b010;
                DMop_S           = 3'b000;
                ALU_Control      = 4'b0010;
                EXTop            = 2'b01;
                PC_sel           = 2'b00;
                ALU_Asel         = 1'b0;
                ALU_Bsel         = 1'b1;
                M_D_sel          = 1'b0;
                A3_RFsel         = 2'b00;
                RF_WDsel         = 2'b01;
            end

            `OP_lbu: begin
                RegWrite         = 1'b1;
                DMop_R           = 3'b001;
                DMop_S           = 3'b000;
                ALU_Control      = 4'b0010;
                EXTop            = 2'b01;
                PC_sel           = 2'b00;
                ALU_Asel         = 1'b0;
                ALU_Bsel         = 1'b1;
                M_D_sel          = 1'b0;
                A3_RFsel         = 2'b00;
                RF_WDsel         = 2'b01;
            end

            `OP_lh: begin
                RegWrite         = 1'b1;
                DMop_R           = 3'b100;
                DMop_S           = 3'b000;
                ALU_Control      = 4'b0010;
                EXTop            = 2'b01;
                PC_sel           = 2'b00;
                ALU_Asel         = 1'b0;
                ALU_Bsel         = 1'b1;
                M_D_sel          = 1'b0;
                A3_RFsel         = 2'b00;
                RF_WDsel         = 2'b01;
            end

            `OP_lhu: begin
                RegWrite         = 1'b1;
                DMop_R           = 3'b011;
                DMop_S           = 3'b000;
                ALU_Control      = 4'b0010;
                EXTop            = 2'b01;
                PC_sel           = 2'b00;
                ALU_Asel         = 1'b0;
                ALU_Bsel         = 1'b1;
                M_D_sel          = 1'b0;
                A3_RFsel         = 2'b00;
                RF_WDsel         = 2'b01;
            end
            
            `OP_sw: begin
                RegWrite         = 1'b0;
                DMop_S           = 3'b001;
                ALU_Control      = 4'b0010;
                EXTop            = 2'b01;
                PC_sel           = 2'b00;
                ALU_Asel         = 1'b0;
                ALU_Bsel         = 1'b1;
                M_D_sel          = 1'b0;
            end

            `OP_sb: begin
                RegWrite         = 1'b0;
                DMop_S           = 3'b010;
                ALU_Control      = 4'b0010;
                EXTop            = 2'b01;
                PC_sel           = 2'b00;
                ALU_Asel         = 1'b0;
                ALU_Bsel         = 1'b1;
                M_D_sel          = 1'b0;
            end

            `OP_sh: begin
                RegWrite         = 1'b0;
                DMop_S           = 3'b011;
                ALU_Control      = 4'b0010;
                EXTop            = 2'b01;
                PC_sel           = 2'b00;
                ALU_Asel         = 1'b0;
                ALU_Bsel         = 1'b1;
                M_D_sel          = 1'b0;
            end

            `OP_lui: begin
                RegWrite         = 1'b1;
                DMop_S           = 3'b000;
                ALU_Control      = 4'b1000;
                EXTop            = 2'b10;
                PC_sel           = 2'b00;
                ALU_Asel         = 1'b0;
                ALU_Bsel         = 1'b1;
                M_D_sel          = 1'b0;
                A3_RFsel         = 2'b00;
                RF_WDsel         = 2'b00;
            end
            
            `OP_beq: begin
                RegWrite         = 1'b0;
                DMop_S           = 3'b000;
                CMP_type         = `B_beq;
                NPC_sel          = 3'b010;
                PC_sel           = 2'b01;
            end
            
            `OP_bne: begin
                RegWrite         = 1'b0;
                DMop_S           = 3'b000;
                CMP_type         = `B_bne;
                NPC_sel          = 3'b010;
                PC_sel           = 2'b01;
            end
            
            `OP_blez: begin
                RegWrite         = 1'b0;
                DMop_S           = 3'b000;
                CMP_type         = `B_blez;
                NPC_sel          = 3'b010;
                PC_sel           = 2'b01;
            end

            `OP_bgtz: begin
                RegWrite         = 1'b0;
                DMop_S           = 3'b000;
                CMP_type         = `B_bgtz;
                NPC_sel          = 3'b010;
                PC_sel           = 2'b01;
            end

            6'b000001: begin
                if(rt == `RT_bltz) begin
                    RegWrite         = 1'b0;
                    DMop_S           = 3'b000;
                    CMP_type         = `B_bltz;
                    NPC_sel          = 3'b010;
                    PC_sel           = 2'b01;
                end
                else if(rt == `RT_bgez) begin
                    RegWrite         = 1'b0;
                    DMop_S           = 3'b000;
                    CMP_type         = `B_bgez;
                    NPC_sel          = 3'b010;
                    PC_sel           = 2'b01;
                end
            end
            
            `OP_addi: begin
                RegWrite         = 1'b1;
                DMop_S           = 3'b000;
                ALU_Control      = 4'b0010;
                EXTop            = 2'b01;
                PC_sel           = 2'b00;
                ALU_Asel         = 1'b0;
                ALU_Bsel         = 1'b1;
                M_D_sel          = 1'b0;
                A3_RFsel         = 2'b00;
                RF_WDsel         = 2'b00;
            end

            `OP_addiu: begin
                RegWrite         = 1'b1;
                DMop_S           = 3'b000;
                ALU_Control      = 4'b0010;
                EXTop            = 2'b01;
                PC_sel           = 2'b00;
                ALU_Asel         = 1'b0;
                ALU_Bsel         = 1'b1;
                M_D_sel          = 1'b0;
                A3_RFsel         = 2'b00;
                RF_WDsel         = 2'b00;
            end

            `OP_andi: begin
                RegWrite         = 1'b1;
                DMop_S           = 3'b000;
                ALU_Control      = 4'b0000;
                EXTop            = 2'b00;
                PC_sel           = 2'b00;
                ALU_Asel         = 1'b0;
                ALU_Bsel         = 1'b1;
                M_D_sel          = 1'b0;
                A3_RFsel         = 2'b00;
                RF_WDsel         = 2'b00;
            end

            `OP_ori: begin
                RegWrite         = 1'b1;
                DMop_S           = 3'b000;
                ALU_Control      = 4'b0001;
                EXTop            = 2'b00;
                PC_sel           = 2'b00;
                ALU_Asel         = 1'b0;
                ALU_Bsel         = 1'b1;
                M_D_sel          = 1'b0;
                A3_RFsel         = 2'b00;
                RF_WDsel         = 2'b00;
            end

            `OP_xori: begin
                RegWrite         = 1'b1;
                DMop_S           = 3'b000;
                ALU_Control      = 4'b0011;
                EXTop            = 2'b00;
                PC_sel           = 2'b00;
                ALU_Asel         = 1'b0;
                ALU_Bsel         = 1'b1;
                M_D_sel          = 1'b0;
                A3_RFsel         = 2'b00;
                RF_WDsel         = 2'b00;
            end

            `OP_slti: begin
                RegWrite         = 1'b1;
                DMop_S           = 3'b000;
                ALU_Control      = 4'b0101;
                EXTop            = 2'b01;
                PC_sel           = 2'b00;
                ALU_Asel         = 1'b0;
                ALU_Bsel         = 1'b1;
                M_D_sel          = 1'b0;
                A3_RFsel         = 2'b00;
                RF_WDsel         = 2'b00;
            end

            `OP_sltiu: begin
                RegWrite         = 1'b1;
                DMop_S           = 3'b000;
                ALU_Control      = 4'b0111;
                EXTop            = 2'b01;
                PC_sel           = 2'b00;
                ALU_Asel         = 1'b0;
                ALU_Bsel         = 1'b1;
                M_D_sel          = 1'b0;
                A3_RFsel         = 2'b00;
                RF_WDsel         = 2'b00;
            end
            
            `OP_j: begin
                RegWrite         = 1'b0;
                DMop_S           = 3'b000;
                NPC_sel          = 3'b001;
                PC_sel           = 2'b01;	
            end

            `OP_jal: begin
                RegWrite         = 1'b1;
                DMop_S           = 3'b000;
                NPC_sel          = 3'b001;
                PC_sel           = 2'b01;
                A3_RFsel         = 2'b10;
                RF_WDsel         = 2'b10;
            end

            default: begin
                RegWrite         = 1'b0;
                DMop_R           = 3'b000;
                DMop_S           = 3'b000;
                ALU_Control      = 4'b0010;
                CMP_type         = 3'b000;
                NPC_sel          = 3'b000;
                EXTop            = 2'b00;
                PC_sel           = 2'b00;
                ALU_Asel         =  1'b0;
                ALU_Bsel         = 1'b0;
                start            = 1'b0;
                M_D_sel          = 1'b0;
                A3_RFsel         = 2'b00;
                RF_WDsel         = 2'b00;
            end    
            
        endcase
    end
end	


endmodule
