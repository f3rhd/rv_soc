`ifndef DECODE_RESULT_H
`define DECODE_RESULT_H
typedef struct packed {
    logic [31:0] instruction_addr;
    logic [31:0] extended_imm_val;
    logic [4:0] src1;
    logic [4:0] src2;
    logic [4:0] dest;
    logic [6:0] operation;
    logic uses_imm;
    logic is_reg_to_reg_imm;
    logic invalid;
    logic reg_write;
    logic mem_write;
    logic mem_read;
    logic btb_write;
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
/*
    For optimization we are going to use use bit splitting
    We can check the type of an instruction using only [6:5] bits along the pipeline
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
            7'b10_00_000 - store byte
            7'b10_00_001 - store half
            7'b10_00_010 - store word
        [3] = 1'b1 indicates load:
            7'b10_01_000 - load byte
            7'b10_01_001 - load half
            7'b10_01_010 - load word
            7'b10_01_011 - load byte unsigned 
            7'b10_01_100 - load half unsigned
    }

*/
`endif // DECODE_RESULT_H
