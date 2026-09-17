/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */
`ifndef RASTERIZER_INTERFACE_SVH
`define RASTERIZER_INTERFACE_SVH
typedef struct packed {
    logic [13:0] x;
    logic [13:0] y;
} point_data_t;
typedef struct packed {
    logic [13:0] dx;
    logic [13:0] sx;
    logic [13:0] dy;
    logic [13:0] sy;
    logic [17:0] err;
    point_data_t p0;
    point_data_t p1;
} line_data_t;

typedef struct packed {
    logic [15:0] color;
    logic [13:0] y;
    logic [13:0] xa;
    logic [13:0] xb;
} fill_span_data_t;
typedef struct packed {
    logic hollow;
    logic [15:0] color;
    point_data_t [0:2] points;
} triangle_data_t;

interface rasterizer_if;
    triangle_data_t triangle_data;
    fill_span_data_t span_data;
    logic rasterizer_begin;
    logic span_draw_complete;
    logic rasterizer_done;
    logic span_data_ready;
    logic span_fifo_full;
    modport rasterizer (
        input triangle_data,
        input rasterizer_begin,
        input span_fifo_full,
        output rasterizer_done,
        output span_data,
        output span_data_ready
    );
    modport graphics_decoder (
        input rasterizer_done,
        output rasterizer_begin,
        output triangle_data
    );
    modport span_fifo ( 
        input span_data,
        input span_data_ready,
        output span_fifo_full
    );
endinterface
`endif
