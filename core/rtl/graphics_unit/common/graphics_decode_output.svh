/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

`ifndef GRAPHICS_DECODE_OUTPUT_SVH
`define GRAPHICS_DECODE_OUTPUT_SVH
typedef union packed {
    logic [27:0] color;  
    struct packed {
        logic  [13:0] x;
        logic  [13:0] y;
    } point;
} graphics_union_t;
typedef enum logic [1:0] {
    P0,
    P1 ,
    P2 ,
    CLR 
} instr_id_e;
typedef struct packed {
    graphics_union_t instr;
    instr_id_e instr_id;
    logic valid;
    logic hollow;
} graphics_decode_output_t;
`endif
