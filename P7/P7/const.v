//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    13:15:27 11/28/2021
// Design Name:
// Module Name:    constants
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
//
// Instr
`define OP_rtype   6'b000000
`define OP_lb      6'b100000
`define OP_lbu     6'b100100
`define OP_lh      6'b100001
`define OP_lhu     6'b100101
`define OP_lw      6'b100011
`define OP_sb      6'b101000
`define OP_sh      6'b101001
`define OP_sw      6'b101011
`define OP_addi    6'b001000
`define OP_addiu   6'b001001
`define OP_andi    6'b001100
`define OP_lui     6'b001111
`define OP_ori     6'b001101
`define OP_slti    6'b001010
`define OP_sltiu   6'b001011
`define OP_xori    6'b001110
`define OP_beq     6'b000100
`define OP_bne     6'b000101
`define OP_blez    6'b000110
`define OP_bgtz    6'b000111
`define OP_j       6'b000010
`define OP_jal     6'b000011

`define OP_mtc0    11'b010000_00100
`define OP_mfc0    11'b010000_00000
`define OP_eret    32'b010000_1000_0000_0000_0000_0000_011000

`define FUNC_add   6'b100000
`define FUNC_addu  6'b100001
`define FUNC_and   6'b100100
`define FUNC_nor   6'b100111
`define FUNC_or    6'b100101
`define FUNC_sll   6'b000000
`define FUNC_sllv  6'b000100
`define FUNC_slt   6'b101010
`define FUNC_sltu  6'b101011
`define FUNC_sra   6'b000011
`define FUNC_srav  6'b000111
`define FUNC_srl   6'b000010
`define FUNC_srlv  6'b000110
`define FUNC_sub   6'b100010
`define FUNC_subu  6'b100011
`define FUNC_xor   6'b100110
`define FUNC_jalr  6'b001001
`define FUNC_jr    6'b001000
`define FUNC_mult  6'b011000
`define FUNC_multu 6'b011001
`define FUNC_div   6'b011010
`define FUNC_divu  6'b011011
`define FUNC_mthi  6'b010001
`define FUNC_mtlo  6'b010011
`define FUNC_mfhi  6'b010000
`define FUNC_mflo  6'b010010

`define RT_bltz    5'b00000
`define RT_bgez    5'b00001

// DM
`define DM_w    3'b000
`define DM_h    3'b001
`define DM_hu   3'b010
`define DM_b    3'b011
`define DM_bu   3'b100


// B_type
`define B_beq   3'd1
`define B_bne   3'd2
`define B_blez  3'd3
`define B_bgtz  3'd4
`define B_bltz  3'd5
`define B_bgez  3'd6
