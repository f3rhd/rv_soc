/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

`ifndef GRAPHICS_DECODE_OUTPUT_SVH
`define GRAPHICS_DECODE_OUTPUT_SVH
typedef union packed {
    logic [23:0] color;  
    struct packed {
        logic  [11:0] x;
        logic  [11:0] y;
    } point;
} graphics_union_t;
typedef enum logic [3:0] {
    P0 = 4'b0001,
    P1 = 4'b0010,
    P2 = 4'b0100,
    CLR = 4'b1000
} instr_id_e;
typedef struct packed {
    graphics_union_t instr;
    instr_id_e instr_id;
    logic valid;
    logic hollow;
} graphics_decode_output_t;
`endif
