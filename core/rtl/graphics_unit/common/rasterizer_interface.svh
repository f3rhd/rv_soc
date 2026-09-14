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
    point_data_t pixel_data;
    fill_span_data_t span_data;
    logic rasterizer_begin;
    logic span_draw_complete;
    logic rasterizer_done;
    logic pixel_data_ready;
    logic span_data_ready;
    logic pixel_draw_complete;
    modport rasterizer (
        input triangle_data,
        input rasterizer_begin,
        input span_draw_complete,
        input pixel_draw_complete,
        output pixel_data,
        output rasterizer_done,
        output pixel_data_ready,
        output span_data,
        output span_data_ready
    );
    modport controller (
        input span_data,
        input span_data_ready,
        input pixel_data,
        input pixel_data_ready,
        input rasterizer_done,
        output triangle_data,
        output pixel_draw_complete,
        output rasterizer_begin,
        output span_draw_complete
    );
endinterface
`endif
