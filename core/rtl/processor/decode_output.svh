/*
 * SPDX-FileCopyrightText: 2026 f3rhd 
 *
 * SPDX-License-Identifier: MIT
 */

`ifndef DECODE_RESULT_H
`define DECODE_RESULT_H
/*
    7'h000000 - invalid
    ALU operations: [6:5] = 2'b00 {
        7'b00_00001 - add
        7'b00_00010 - sub
        7'b00_00011 - shift left logical
        7'b00_00100 - set less than
        7'b00_00101 - set less than unsigned
        7'b00_00110 - xor 
        7'b00_00111 - shift right logical
        7'b00_01000 - shift right arithmetic
        7'b00_01001 - or
        7'b00_01010 - and
        7'b00_01011 - add upper immediate to program counter
        7'b00_01100 - load upper immediate
        7'b00_01110 - multiply
        7'b00_01111 - multiply high signed signed
        7'b00_10000 - multiply high signed unsigned
        7'b00_10001 - multiply high unsigned unsigned
        7'b00_10010 - divide (signed)
        7'b00_10011 - divide unsigned
        7'b00_10100 - remainder signed
        7'b00_10101 - remainder unsigned
    }
    Branch operations : [6:5] = 2'b01  {

        [3] = 1'b0 indicates conditional branches:
            7'b01_00_001 - branch if equal
            7'b01_00_010 - branch if not equal
            7'b01_00_011 - branch if less than
            7'b01_00_100 - branch if greater or equal
            7'b01_00_101 - branch if less than unsigned
            7'b01_00_110 - branch if greater or equal unsigned
        [3] = 1'b1 indicates unconditional branches (jumps):
            7'b01_01_000 - jump and link register (jalr)
            7'b01_01_001 - jump and link (jal)
    }
    Memory Instructions : [6:5] = 2'b10  {

        [3] = 1'b0 indicates store:
            7'b10_00_000 - store integer byte 
            7'b10_00_001 - store integer half 
            7'b10_00_010 - store integer word 
            7'b10_00_100 - store float word 
        [3] = 1'b1 indicates load:
            7'b10_01_000 - load integer byte
            7'b10_01_001 - load integer half
            7'b10_01_010 - load integer word
            7'b10_01_011 - load integer byte unsigned 
            7'b10_01_100 - load integer half unsigned
            7'b10_01_101 - load float word
    }
    Float instructions : [6:5] = 2'b11 {
        [4:3] = 2'b00 : R4 instructions
            7'b11_00_110 - fmadd
            7'b11_00_001 - fmsub
            7'b11_00_010 - fnmsub
            7'b11_00_100 - fnmadd
        [4:3] = 2'b01 : arithmetic instructions
            7'b11_01_000 - fadd
            7'b11_01_001 - fsub
            7'b11_01_010 - fmul
            7'b11_01_011 - fdiv
            7'b11_01_100 - fsgnj
            7'b11_01_101 - fsgnjn
            7'b11_01_110 - fsgnjx
        [4:3] = 2'b10 : comparison instructions
            7'b11_10_000 - fmin
            7'b11_10_001 - fmax
            7'b11_10_010 - feq
            7'b11_10_100 - flt
            7'b11_10_101 - fle
        [4:3]  = 2'b11 : others
            7'b11_11_000 - fsqrt
            7'b11_11_001 - fclass
            7'b11_11_010 - fcvt.w.s
            7'b11_11_011 - fcvt.wu.s
            7'b11_11_100 - fcvt.s.w
            7'b11_11_101 - fcvt.s.wu
            7'b11_11_110 - fmv.x.w
            7'b11_11_111 - fmv.w.x
    }
*/
typedef enum logic [6:0] {
    // Invalid / Default
    OP_INVALID               = 7'b00_00000,

    // ------------------------------------------------------------------------
    // ALU Operations: [6:5] = 2'b00
    // ------------------------------------------------------------------------
    ALU_ADD                  = 7'b00_00001,
    ALU_SUB                  = 7'b00_00010,
    ALU_SLL                  = 7'b00_00011, // Shift left logical
    ALU_SLT                  = 7'b00_00100, // Set less than
    ALU_SLTU                 = 7'b00_00101, // Set less than unsigned
    ALU_XOR                  = 7'b00_00110,
    ALU_SRL                  = 7'b00_00111, // Shift right logical
    ALU_SRA                  = 7'b00_01000, // Shift right arithmetic
    ALU_OR                   = 7'b00_01001,
    ALU_AND                  = 7'b00_01010,
    ALU_AUIPC                = 7'b00_01011, // Add upper immediate to PC
    ALU_LUI                  = 7'b00_01100, // Load upper immediate
    ALU_MUL                  = 7'b00_01110,
    ALU_MULH                 = 7'b00_01111, // Multiply high signed-signed
    ALU_MULHSU               = 7'b00_10000, // Multiply high signed-unsigned
    ALU_MULHU                = 7'b00_10001, // Multiply high unsigned-unsigned
    ALU_DIV                  = 7'b00_10010, // Divide signed
    ALU_DIVU                 = 7'b00_10011, // Divide unsigned
    ALU_REM                  = 7'b00_10100, // Remainder signed
    ALU_REMU                 = 7'b00_10101, // Remainder unsigned

    // ------------------------------------------------------------------------
    // Branch Operations: [6:5] = 2'b01
    // ------------------------------------------------------------------------
    // Conditional Branches: [3] = 1'b0
    BR_BEQ                   = 7'b01_00001,
    BR_BNE                   = 7'b01_00010,
    BR_BLT                   = 7'b01_00011,
    BR_BGE                   = 7'b01_00100,
    BR_BLTU                  = 7'b01_00101,
    BR_BGEU                  = 7'b01_00110,
    // Unconditional Branches / Jumps: [3] = 1'b1
    BR_JALR                  = 7'b01_01000,
    BR_JAL                   = 7'b01_01001,

    // ------------------------------------------------------------------------
    // Memory Instructions: [6:5] = 2'b10
    // ------------------------------------------------------------------------
    // Stores: [3] = 1'b0
    MEM_SB                   = 7'b10_00000, // Store byte
    MEM_SH                   = 7'b10_00001, // Store half
    MEM_SW                   = 7'b10_00010, // Store word
    MEM_FSW                  = 7'b10_00100, // Store float word
    // Loads: [3] = 1'b1
    MEM_LB                   = 7'b10_01000, // Load byte
    MEM_LH                   = 7'b10_01001, // Load half
    MEM_LW                   = 7'b10_01010, // Load word
    MEM_LBU                  = 7'b10_01011, // Load byte unsigned
    MEM_LHU                  = 7'b10_01100, // Load half unsigned
    MEM_FLW                  = 7'b10_01101, // Load float word

    // ------------------------------------------------------------------------
    // Float Instructions: [6:5] = 2'b11
    // ------------------------------------------------------------------------
    // R4 Instructions: [4:3] = 2'b00
    FP_FMADD                 = 7'b11_00110,
    FP_FMSUB                 = 7'b11_00001,
    FP_FNMSUB                = 7'b11_00010,
    FP_FNMADD                = 7'b11_00100,
    // Arithmetic: [4:3] = 2'b01
    FP_FADD                  = 7'b11_01000,
    FP_FSUB                  = 7'b11_01001,
    FP_FMUL                  = 7'b11_01010,
    FP_FDIV                  = 7'b11_01011,
    FP_FSGNJ                 = 7'b11_01100,
    FP_FSGNJN                = 7'b11_01101,
    FP_FSGNJX                = 7'b11_01110,
    // Comparison: [4:3] = 2'b10
    FP_FMIN                  = 7'b11_10000,
    FP_FMAX                  = 7'b11_10001,
    FP_FEQ                   = 7'b11_10010,
    FP_FLT                   = 7'b11_10100,
    FP_FLE                   = 7'b11_10101,
    // Others: [4:3] = 2'b11
    FP_FSQRT                 = 7'b11_11000,
    FP_FCLASS                = 7'b11_11001,
    FP_FCVT_W_S              = 7'b11_11010,
    FP_FCVT_WU_S             = 7'b11_11011,
    FP_FCVT_S_W              = 7'b11_11100,
    FP_FCVT_S_WU             = 7'b11_11101,
    FP_FMV_X_W               = 7'b11_11110,
    FP_FMV_W_X               = 7'b11_11111
} opcode_e;

typedef struct packed {
    logic [31:0] instruction_addr;
    logic [31:0] extended_imm_val;
    logic [4:0] src1;
    logic [4:0] src2;
    logic [4:0] dest;
    opcode_e operation;
    logic uses_imm;
    logic read_rs1;
    logic read_rs2;
    logic invalid;
    logic int_reg_write;
    logic mem_write;
    logic mem_read;
    logic btb_write;
    // Float stuff
    logic float_reg_write;
    logic [4:0] src3; 
    logic [2:0] round_mode;
    logic read_fs1;
    logic read_fs2;
    logic read_fs3;
} decoded_instruction_t;
typedef struct packed {
    logic [9:0] pht_index;
    logic btb_was_hit;
    logic prediction;
} prediction_data_t;
typedef struct packed {
    decoded_instruction_t instruction_data;
    prediction_data_t     prediction_data;
} decode_output_t;

`endif // DECODE_RESULT_H
