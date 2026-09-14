/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */
`include "rasterizer_interface.svh"

module rasterizer #(
    parameter signed DISPLAY_WIDTH  = 128,
    parameter signed DISPLAY_HEIGHT = 160
) (
    input logic clk,
    input logic reset,
    rasterizer_if.rasterizer rasterizeri
);

    enum logic [3:0] {
        S_IDLE,
        S_TRIANGLE_PREP,
        S_TRIANGLE_MAIN,
        S_ADVANCE_TO_NEXT_ROW,
        S_TRIANGLE_FILL_SPAN,
        S_WAIT_CONTROLLER,
        S_LINE_UPDATE,
        S_PIXEL_DISPATCH
    } rasterizer_state;

    enum logic [2:0] {
        S_INIT_ESSENTIALS,
        S_FILL_SPAN_PREP,
        S_ADVANCE_TO_NEXT_ROW_LONG_EDGE,
        S_ADVANCE_TO_NEXT_ROW_SHORT_EDGE,
        S_ITERATE,
        S_INIT_BOTTOM_HALF_EDGE
    } fill_state;

    triangle_data_t triangle_data;
    line_data_t line_data;
    fill_span_data_t span_data;
    line_data_t active_line_data;
    point_data_t [0:2] sorted_triangle_points;

    logic [13:0] iterator;
    logic [13:0] iterator_finish;
    logic first_loop_done;
    logic registered_y_start;
    logic [13:0] y_start;
    logic [2:0] triangle_phase_counter;
    logic [1:0] triangle_span_phase_counter;
    logic [17:0] next_err;
    logic [13:0] next_x0;
    logic [13:0] next_y0;

    point_data_t [0:1] long_edge_points;
    point_data_t [0:1] short_edge_points;
    struct {
        logic [17:0] long_edge;
        logic [17:0] short_edge;
    } edge_errors;

    always_comb begin : triangle_prep_comparator_chain
        sorted_triangle_points = triangle_data.points;
        if (sorted_triangle_points[0].y > sorted_triangle_points[1].y) begin
            {sorted_triangle_points[0].x, sorted_triangle_points[1].x} = {
                sorted_triangle_points[1].x, sorted_triangle_points[0].x
            };
            {sorted_triangle_points[0].y, sorted_triangle_points[1].y} = {
                sorted_triangle_points[1].y, sorted_triangle_points[0].y
            };
        end
        if (sorted_triangle_points[0].y > sorted_triangle_points[2].y) begin
            {sorted_triangle_points[0].x, sorted_triangle_points[2].x} = {
                sorted_triangle_points[2].x, sorted_triangle_points[0].x
            };
            {sorted_triangle_points[0].y, sorted_triangle_points[2].y} = {
                sorted_triangle_points[2].y, sorted_triangle_points[0].y
            };
        end
        if (sorted_triangle_points[1].y > sorted_triangle_points[2].y) begin
            {sorted_triangle_points[1].x, sorted_triangle_points[2].x} = {
                sorted_triangle_points[2].x, sorted_triangle_points[1].x
            };
            {sorted_triangle_points[1].y, sorted_triangle_points[2].y} = {
                sorted_triangle_points[2].y, sorted_triangle_points[1].y
            };
        end

    end

    wire [17:0] w_err2 = line_data.err << 1;
    logic hit_long_edge;
    logic hit_short_edge;
    always_comb begin : bresenham_step
        next_err = line_data.err;
        next_x0  = line_data.p0.x;
        next_y0  = line_data.p0.y;
        if ($signed(w_err2) >= $signed(line_data.dy)) begin
            next_err += {{4{line_data.dy[13]}}, line_data.dy};
            next_x0 += line_data.sx;
        end
        if ($signed(w_err2) <= $signed(line_data.dx)) begin
            next_err += {{4{line_data.dx[13]}}, line_data.dx};
            next_y0 += line_data.sy;
        end
    end
    logic init_err;
    always_comb begin
        active_line_data.p0  = 0;
        active_line_data.p1  = 0;
        active_line_data.err = 0;
        init_err             = 0;
        case (rasterizer_state)
            S_TRIANGLE_MAIN: begin
                if (triangle_data.hollow) begin
                    init_err = 1;
                    case (triangle_phase_counter)
                        'd0: begin
                            active_line_data.p0.x = triangle_data.points[0].x;
                            active_line_data.p0.y = triangle_data.points[0].y;
                            active_line_data.p1.x = triangle_data.points[1].x;
                            active_line_data.p1.y = triangle_data.points[1].y;
                        end
                        'd1: begin
                            active_line_data.p0.x = triangle_data.points[0].x;
                            active_line_data.p0.y = triangle_data.points[0].y;
                            active_line_data.p1.x = triangle_data.points[2].x;
                            active_line_data.p1.y = triangle_data.points[2].y;
                        end
                        'd2: begin
                            active_line_data.p0.x = triangle_data.points[1].x;
                            active_line_data.p0.y = triangle_data.points[1].y;
                            active_line_data.p1.x = triangle_data.points[2].x;
                            active_line_data.p1.y = triangle_data.points[2].y;
                        end
                        'd3: begin
                        end
                    endcase
                end else begin
                    case (fill_state)
                        S_ADVANCE_TO_NEXT_ROW_LONG_EDGE: begin
                            active_line_data.p0  = long_edge_points[0];
                            active_line_data.p1  = long_edge_points[1];
                            active_line_data.err = edge_errors.long_edge;
                            if (!hit_long_edge) init_err = 1;
                        end
                        S_INIT_BOTTOM_HALF_EDGE: begin
                            active_line_data.p0 = short_edge_points[0];
                            active_line_data.p1 = short_edge_points[1];
                            init_err            = 1;
                        end
                        S_ADVANCE_TO_NEXT_ROW_SHORT_EDGE: begin
                            active_line_data.p0  = short_edge_points[0];
                            active_line_data.p1  = short_edge_points[1];
                            active_line_data.err = edge_errors.short_edge;
                            if (!hit_short_edge) init_err = 1;
                        end
                        default: begin
                        end
                    endcase
                end
            end
            default: ;
        endcase
        active_line_data.dx = (active_line_data.p0.x < active_line_data.p1.x) ? active_line_data.p1.x - active_line_data.p0.x : active_line_data.p0.x - active_line_data.p1.x;
        active_line_data.dy = (active_line_data.p0.y < active_line_data.p1.y) ? active_line_data.p0.y - active_line_data.p1.y : active_line_data.p1.y - active_line_data.p0.y;
        active_line_data.sx = (active_line_data.p0.x < active_line_data.p1.x) ? 1 : {14{1'b1}};
        active_line_data.sy = (active_line_data.p0.y < active_line_data.p1.y) ? 1 : {14{1'b1}};
        if (init_err) begin
            active_line_data.err = {{4{active_line_data.dx[13]}},active_line_data.dx} + {{4{active_line_data.dy[13]}},active_line_data.dy};
        end
    end

    always_ff @(posedge clk) begin
        rasterizeri.rasterizer_done  <= 0;
        rasterizeri.pixel_data_ready <= 0;
        if (reset) begin
            rasterizer_state <= S_IDLE;
        end else begin
            unique case (rasterizer_state)
                S_IDLE: begin
                    triangle_data               <= 0;
                    line_data                   <= 0;
                    span_data                   <= 0;
                    triangle_span_phase_counter <= 0;
                    triangle_phase_counter      <= 0;
                    registered_y_start          <= 0;
                    first_loop_done             <= 0;
                    hit_short_edge              <= 0;
                    hit_long_edge               <= 0;
                    fill_state                  <= S_INIT_ESSENTIALS;
                    if (rasterizeri.rasterizer_begin) begin
                        triangle_data    <= rasterizeri.triangle_data;
                        rasterizer_state <= S_TRIANGLE_PREP;
                    end
                end
                S_TRIANGLE_PREP: begin
                    triangle_data.points <= sorted_triangle_points;
                    rasterizer_state     <= S_TRIANGLE_MAIN;
                end
                S_TRIANGLE_MAIN: begin
                    if (triangle_data.hollow) begin
                        triangle_phase_counter <= triangle_phase_counter + 1;
                        line_data              <= active_line_data;
                        if (triangle_phase_counter == 3) begin
                            rasterizer_state            <= S_IDLE;
                            rasterizeri.rasterizer_done <= 1;
                        end else begin
                            rasterizer_state <= S_PIXEL_DISPATCH;
                        end
                    end else begin
                        unique case (fill_state)
                            S_INIT_ESSENTIALS: begin
                                iterator <= triangle_data.points[0].y;
                                iterator_finish <= triangle_data.points[1].y;
                                long_edge_points <= {
                                    triangle_data.points[0],
                                    triangle_data.points[2]
                                };
                                short_edge_points <= {
                                    triangle_data.points[0],
                                    triangle_data.points[1]
                                };
                                fill_state <= S_FILL_SPAN_PREP;
                            end
                            S_FILL_SPAN_PREP: begin
                                rasterizer_state <= S_TRIANGLE_FILL_SPAN;
                                span_data.xa     <= long_edge_points[0].x;

                                if (!first_loop_done && triangle_data.points[0].y == triangle_data.points[1].y) begin
                                    span_data.xb <= triangle_data.points[1].x;
                                end else if (first_loop_done && triangle_data.points[1].y == triangle_data.points[2].y) begin
                                    span_data.xb <= triangle_data.points[2].x;
                                end else begin
                                    span_data.xb <= short_edge_points[0].x;
                                end
                                span_data.y <= iterator;
                                fill_state  <= S_ADVANCE_TO_NEXT_ROW_LONG_EDGE;
                            end
                            S_ADVANCE_TO_NEXT_ROW_LONG_EDGE: begin
                                hit_long_edge <= 1;
                                line_data <= active_line_data;
                                fill_state <= S_ADVANCE_TO_NEXT_ROW_SHORT_EDGE;
                                rasterizer_state <= S_ADVANCE_TO_NEXT_ROW;
                            end
                            // line_data now holds the state of the long_edge so register it 
                            S_ADVANCE_TO_NEXT_ROW_SHORT_EDGE: begin
                                hit_short_edge <= 1;
                                long_edge_points <= {
                                    line_data.p0, line_data.p1
                                };
                                edge_errors.long_edge <= line_data.err;
                                line_data <= active_line_data;
                                fill_state <= S_ITERATE;
                                rasterizer_state <= S_ADVANCE_TO_NEXT_ROW;
                            end
                            // line_data now holds the state of the short_edge so register it
                            S_ITERATE: begin
                                short_edge_points <= {
                                    line_data.p0, line_data.p1
                                };
                                edge_errors.short_edge <= line_data.err;
                                fill_state <= S_FILL_SPAN_PREP;
                                if ($signed(
                                        iterator
                                    ) > $signed(
                                        iterator_finish
                                    )) begin
                                    if (first_loop_done) begin
                                        rasterizer_state            <= S_IDLE;
                                        rasterizeri.rasterizer_done <= 1;
                                    end else begin
                                        iterator <= triangle_data.points[1].y;
                                        iterator_finish <= triangle_data.points[2].y;
                                        first_loop_done <= 1;
                                        short_edge_points <= {
                                            triangle_data.points[1],
                                            triangle_data.points[2]
                                        };
                                        fill_state <= S_INIT_BOTTOM_HALF_EDGE;
                                    end
                                end else begin
                                    iterator <= iterator + 1;
                                end
                            end
                            S_INIT_BOTTOM_HALF_EDGE: begin
                                line_data  <= active_line_data;
                                fill_state <= S_ITERATE;
                            end
                        endcase
                    end
                end
                S_ADVANCE_TO_NEXT_ROW: begin
                    if (!registered_y_start) begin
                        registered_y_start <= 1;
                        y_start            <= line_data.p0.y;
                    end else begin
                        if(line_data.p0.y != y_start || (line_data.p0.x == line_data.p1.x && line_data.p0.y == line_data.p1.y)) begin
                            rasterizer_state   <= S_TRIANGLE_MAIN;
                            registered_y_start <= 0;
                        end else begin
                            line_data.err  <= next_err;
                            line_data.p0.x <= next_x0;
                            line_data.p0.y <= next_y0;
                        end
                    end
                end
                S_TRIANGLE_FILL_SPAN: begin
                    if (span_data.y[13] || $signed(
                            span_data.y
                        ) >= DISPLAY_HEIGHT) begin
                        rasterizer_state <= S_TRIANGLE_MAIN;
                    end else begin
                        unique case (triangle_span_phase_counter)
                            'd0: begin : swapping
                                if ($signed(
                                        span_data.xa
                                    ) > $signed(
                                        span_data.xb
                                    )) begin
                                    span_data.xa <= span_data.xb;
                                    span_data.xb <= span_data.xa;
                                end
                                triangle_span_phase_counter <= triangle_span_phase_counter + 1;
                            end
                            'd1: begin : bound_checking
                                if (span_data.xa[13]) begin
                                    span_data.xa <= 0;
                                end
                                if ($signed(
                                        span_data.xb
                                    ) > $signed(
                                        DISPLAY_WIDTH - 1
                                    )) begin
                                    span_data.xb <= DISPLAY_WIDTH - 1;
                                end
                                triangle_span_phase_counter <= triangle_span_phase_counter + 1;
                            end
                            'd2: begin
                                rasterizeri.pixel_data.x     <= span_data.xa;
                                rasterizeri.pixel_data.y     <= span_data.y;
                                rasterizeri.pixel_data_ready <= 1;
                                triangle_span_phase_counter  <= 3;
                            end
                            'd3: begin
                                if(span_data.xa == span_data.xb && rasterizeri.pixel_draw_complete) begin
                                    triangle_span_phase_counter <= 0;
                                    rasterizer_state <= S_TRIANGLE_MAIN;
                                end
                                else if (rasterizeri.pixel_draw_complete) begin
                                    span_data.xa <= span_data.xa + 1;
                                    triangle_span_phase_counter <= 2;
                                end
                            end
                        endcase
                    end
                end
                // Following states are for hollow drawal
                S_PIXEL_DISPATCH: begin
                    rasterizeri.pixel_data.x     <= line_data.p0.x;
                    rasterizeri.pixel_data.y     <= line_data.p0.y;
                    rasterizeri.pixel_data_ready <= 1;
                    rasterizer_state             <= S_WAIT_CONTROLLER;
                end
                S_WAIT_CONTROLLER: begin
                    if (rasterizeri.pixel_draw_complete) begin
                        rasterizer_state <= S_LINE_UPDATE;
                    end
                end
                S_LINE_UPDATE: begin
                    if (line_data.p0.x == line_data.p1.x && line_data.p0.y == line_data.p1.y) begin
                        rasterizer_state <= S_TRIANGLE_MAIN;
                    end else begin
                        line_data.err    <= next_err;
                        line_data.p0.x   <= next_x0;
                        line_data.p0.y   <= next_y0;
                        rasterizer_state <= S_PIXEL_DISPATCH;
                    end
                end
            endcase
        end
    end

endmodule
