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
        S_LINE_PREP,
        S_LINE_UPDATE,
        S_PIXEL_DISPATCH
    } rasterizer_state;

    enum logic [2:0] {
        S_INIT_FULL_HEIGHT_AND_TOP_HALF_EDGE,
        S_INIT_ITERATORS,
        S_FILL_SPAN_PREP,
        S_ADVANCE_TO_NEXT_ROW_LONG_EDGE,
        S_ADVANCE_TO_NEXT_ROW_SHORT_EDGE,
        S_ITERATE,
        S_INIT_BOTTOM_HALF_EDGE
    } fill_state;

    triangle_data_t triangle_data;
    line_data_t line_data;
    fill_span_data_t span_data;
    line_data_t short_edge;
    line_data_t long_edge;
    line_data_t next_row_subject;

    logic [13:0] iterator;
    logic [13:0] iterator_finish;
    logic first_loop_done;
    logic registered_y_start;
    logic [13:0] y_start;
    logic edge_init_extra;
    logic [2:0] triangle_phase_counter;
    logic [1:0] triangle_span_phase_counter;

    wire [13:0] w_dx = (line_data.p0.x < line_data.p1.x) ? line_data.p1.x - line_data.p0.x : line_data.p0.x - line_data.p1.x;
    wire [13:0] w_dy = (line_data.p0.y < line_data.p1.y) ? line_data.p1.y - line_data.p0.y : line_data.p0.y - line_data.p1.y;
    wire [13:0] w_sx = (line_data.p0.x < line_data.p1.x) ? 1 : {14{1'b1}};
    wire [13:0] w_sy = (line_data.p0.y < line_data.p1.y) ? 1 : {14{1'b1}};
    wire [17:0] w_err_prep = w_dx + (~w_dy + 1'b1);
    wire [17:0] w_err2 = line_data.err << 1;
    wire [1:0] line_data_update_case = {
        $signed(w_err2) >= $signed(line_data.dy),
        $signed(w_err2) <= $signed(line_data.dx)
    };
    wire [13:0] w_dx_long_edge = (long_edge.p0.x < long_edge.p1.x) ? long_edge.p1.x - long_edge.p0.x : long_edge.p0.x - long_edge.p1.x;
    wire [13:0] w_dy_long_edge = (long_edge.p0.y < long_edge.p1.y) ? long_edge.p1.y - long_edge.p0.y : long_edge.p0.y - long_edge.p1.y;
    wire [13:0] w_sx_long_edge = (long_edge.p0.x < long_edge.p1.x) ? 1 : {14{1'b1}};
    wire [13:0] w_sy_long_edge = (long_edge.p0.y < long_edge.p1.y) ? 1 : {14{1'b1}};
    wire [17:0] w_err_prep_long_edge = w_dx_long_edge + (~w_dy_long_edge + 1'b1);
    wire [17:0] w_err2_long_edge = long_edge.err << 1;
    wire [1:0] long_edge_update_case = {
        $signed(w_err2_long_edge) >= $signed(long_edge.dy),
        $signed(w_err2_long_edge) <= $signed(long_edge.dx)
    };
    wire [13:0] w_dx_short_edge = (short_edge.p0.x < short_edge.p1.x) ? short_edge.p1.x - short_edge.p0.x : short_edge.p0.x - short_edge.p1.x;
    wire [13:0] w_dy_short_edge = (short_edge.p0.y < short_edge.p1.y) ? short_edge.p1.y - short_edge.p0.y : short_edge.p0.y - short_edge.p1.y;
    wire [13:0] w_sx_short_edge = (short_edge.p0.x < short_edge.p1.x) ? 1 : {14{1'b1}};
    wire [13:0] w_sy_short_edge = (short_edge.p0.y < short_edge.p1.y) ? 1 : {14{1'b1}};
    wire [17:0] w_err_prep_short_edge = w_dx_short_edge + (~w_dy_short_edge + 1'b1);
    wire [17:0] w_err2_short_edge = short_edge.err << 1;
    wire [1:0] short_edge_update_case = {
        $signed(w_err2_short_edge) >= $signed(short_edge.dy),
        $signed(w_err2_short_edge) <= $signed(short_edge.dx)
    };

    wire is_long_edge = S_ADVANCE_TO_NEXT_ROW_SHORT_EDGE == fill_state;
    assign next_row_subject = is_long_edge ? long_edge : short_edge;
    always_ff @(posedge clk) begin
        rasterizeri.rasterizer_done  <= 0;
        rasterizeri.pixel_data_ready <= 0;
        if (reset) begin
            rasterizer_state <= S_IDLE;
        end else begin
            unique case (rasterizer_state)
                S_IDLE: begin
                    triangle_data <= 0;
                    line_data <= 0;
                    span_data <= 0;
                    triangle_span_phase_counter <= 0;
                    triangle_phase_counter <= 0;
                    registered_y_start <= 0;
                    first_loop_done <= 0;
                    edge_init_extra <= 0;
                    fill_state <= S_INIT_FULL_HEIGHT_AND_TOP_HALF_EDGE;
                    if (rasterizeri.rasterizer_begin) begin
                        triangle_data    <= rasterizeri.triangle_data;
                        rasterizer_state <= S_TRIANGLE_PREP;
                    end
                end
                S_TRIANGLE_PREP: begin
                    triangle_phase_counter <= triangle_phase_counter + 1;
                    unique case (triangle_phase_counter)
                        'd0: begin
                            if (triangle_data.points[0].y > triangle_data.points[1].y) begin
                                triangle_data.points[0].x <= triangle_data.points[1].x;
                                triangle_data.points[0].y <= triangle_data.points[1].y;
                                triangle_data.points[1].x <= triangle_data.points[0].x;
                                triangle_data.points[1].y <= triangle_data.points[0].y;
                            end
                        end
                        'd1: begin
                            if (triangle_data.points[0].y > triangle_data.points[2].y) begin
                                triangle_data.points[0].x <= triangle_data.points[2].x;
                                triangle_data.points[0].y <= triangle_data.points[2].y;
                                triangle_data.points[2].x <= triangle_data.points[0].x;
                                triangle_data.points[2].y <= triangle_data.points[0].y;
                            end
                        end
                        'd2: begin
                            if (triangle_data.points[1].y > triangle_data.points[2].y) begin
                                triangle_data.points[1].x <= triangle_data.points[2].x;
                                triangle_data.points[1].y <= triangle_data.points[2].y;
                                triangle_data.points[2].x <= triangle_data.points[1].x;
                                triangle_data.points[2].y <= triangle_data.points[1].y;
                            end
                            rasterizer_state       <= S_TRIANGLE_MAIN;
                            triangle_phase_counter <= 0;
                        end
                    endcase

                end
                S_TRIANGLE_MAIN: begin
                    if (triangle_data.hollow) begin
                        // we are going to use triangle_phase_counter here as well. 
                        // It's going to be used to count the number of lines drawn in hollow call
                        triangle_phase_counter <= triangle_phase_counter + 1;
                        rasterizer_state       <= S_LINE_PREP;
                        unique case (triangle_phase_counter)
                            'd0: begin
                                line_data.p0.x <= triangle_data.points[0].x;
                                line_data.p0.y <= triangle_data.points[0].y;
                                line_data.p1.x <= triangle_data.points[1].x;
                                line_data.p1.y <= triangle_data.points[1].y;
                            end
                            'd1: begin
                                line_data.p0.x <= triangle_data.points[0].x;
                                line_data.p0.y <= triangle_data.points[0].y;
                                line_data.p1.x <= triangle_data.points[2].x;
                                line_data.p1.y <= triangle_data.points[2].y;
                            end
                            'd2: begin
                                line_data.p0.x <= triangle_data.points[1].x;
                                line_data.p0.y <= triangle_data.points[1].y;
                                line_data.p1.x <= triangle_data.points[2].x;
                                line_data.p1.y <= triangle_data.points[2].y;
                            end
                            'd3: begin
                                rasterizer_state            <= S_IDLE;
                                rasterizeri.rasterizer_done <= 1;
                            end
                        endcase
                    end else begin

                        unique case (fill_state)
                            S_INIT_FULL_HEIGHT_AND_TOP_HALF_EDGE: begin
                                if (!edge_init_extra) begin
                                    edge_init_extra <= 1;
                                    // Full height edge
                                    long_edge.p0.x <= triangle_data.points[0].x;
                                    long_edge.p0.y <= triangle_data.points[0].y;
                                    long_edge.p1.x <= triangle_data.points[2].x;
                                    long_edge.p1.y <= triangle_data.points[2].y;
                                    // Top half edge
                                    short_edge.p0.x <= triangle_data.points[0].x;
                                    short_edge.p0.y <= triangle_data.points[0].y;
                                    short_edge.p1.x <= triangle_data.points[1].x;
                                    short_edge.p1.y <= triangle_data.points[1].y;
                                end else begin
                                    long_edge.dx    <= w_dx_long_edge;
                                    long_edge.dy    <= ~w_dy_long_edge + 1'b1;
                                    long_edge.sx    <= w_sx_long_edge;
                                    long_edge.sy    <= w_sy_long_edge;
                                    long_edge.err   <= w_err_prep_long_edge;
                                    short_edge.dx   <= w_dx_short_edge;
                                    short_edge.dy   <= ~w_dy_short_edge + 1'b1;
                                    short_edge.sx   <= w_sx_short_edge;
                                    short_edge.sy   <= w_sy_short_edge;
                                    short_edge.err  <= w_err_prep_short_edge;
                                    edge_init_extra <= 0;
                                    fill_state      <= S_INIT_ITERATORS;
                                end
                            end
                            S_INIT_ITERATORS: begin
                                iterator        <= triangle_data.points[0].y;
                                iterator_finish <= triangle_data.points[1].y;
                                fill_state      <= S_FILL_SPAN_PREP;
                            end
                            S_FILL_SPAN_PREP: begin
                                rasterizer_state <= S_TRIANGLE_FILL_SPAN;
                                span_data.xa     <= long_edge.p0.x;

                                if (!first_loop_done && triangle_data.points[0].y == triangle_data.points[1].y) begin
                                    span_data.xb <= triangle_data.points[1].x;
                                end else if (first_loop_done && triangle_data.points[1].y == triangle_data.points[2].y) begin
                                    span_data.xb <= triangle_data.points[2].x;
                                end else begin
                                    span_data.xb <= short_edge.p0.x;
                                end
                                span_data.y <= iterator;
                                fill_state  <= S_ADVANCE_TO_NEXT_ROW_LONG_EDGE;
                            end
                            S_ADVANCE_TO_NEXT_ROW_LONG_EDGE: begin
                                fill_state <= S_ADVANCE_TO_NEXT_ROW_SHORT_EDGE;
                                rasterizer_state <= S_ADVANCE_TO_NEXT_ROW;
                            end
                            S_ADVANCE_TO_NEXT_ROW_SHORT_EDGE: begin
                                fill_state       <= S_ITERATE;
                                rasterizer_state <= S_ADVANCE_TO_NEXT_ROW;
                            end
                            S_ITERATE: begin
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
                                        fill_state <= S_INIT_BOTTOM_HALF_EDGE;
                                    end
                                end else begin
                                    iterator <= iterator + 1;
                                end
                            end
                            S_INIT_BOTTOM_HALF_EDGE: begin
                                if (!edge_init_extra) begin
                                    short_edge.p0.x <= triangle_data.points[1].x;
                                    short_edge.p0.y <= triangle_data.points[1].y;
                                    short_edge.p1.x <= triangle_data.points[2].x;
                                    short_edge.p1.y <= triangle_data.points[2].y;
                                    edge_init_extra <= 1;
                                end else begin
                                    short_edge.dx   <= w_dx_short_edge;
                                    short_edge.dy   <= ~w_dy_short_edge + 1'b1;
                                    short_edge.sx   <= w_sx_short_edge;
                                    short_edge.sy   <= w_sy_short_edge;
                                    short_edge.err  <= w_err_prep_short_edge;
                                    edge_init_extra <= 0;
                                    fill_state      <= S_ITERATE;
                                end
                            end
                        endcase
                    end
                end
                S_ADVANCE_TO_NEXT_ROW: begin
                    if (!registered_y_start) begin
                        registered_y_start <= 1;
                        y_start            <= next_row_subject.p0.y;
                    end else begin
                        if(next_row_subject.p0.y != y_start || (next_row_subject.p0.x == next_row_subject.p1.x && next_row_subject.p0.y == next_row_subject.p1.y)) begin
                            rasterizer_state   <= S_TRIANGLE_MAIN;
                            registered_y_start <= 0;
                        end else begin
                            unique case (is_long_edge ? long_edge_update_case : short_edge_update_case)
                                2'b00: begin
                                end
                                2'b01: begin
                                    if (is_long_edge) begin
                                        long_edge.err <= long_edge.err + {{4{long_edge.dx[13]}},long_edge.dx};
                                        long_edge.p0.y <= long_edge.p0.y + long_edge.sy;
                                    end else begin
                                        short_edge.err <= short_edge.err + {{4{short_edge.dx[13]}},short_edge.dx};
                                        short_edge.p0.y <= short_edge.p0.y + short_edge.sy;
                                    end
                                end
                                2'b10: begin
                                    if (is_long_edge) begin
                                        long_edge.p0.x <= long_edge.p0.x + long_edge.sx;
                                        long_edge.err <= long_edge.err + {{4{long_edge.dy[13]}},long_edge.dy};
                                    end else begin
                                        short_edge.p0.x <= short_edge.p0.x + short_edge.sx;
                                        short_edge.err <= short_edge.err + {{4{short_edge.dy[13]}},short_edge.dy};
                                    end
                                end
                                2'b11: begin
                                    if (is_long_edge) begin
                                        long_edge.err <= long_edge.err + {{4{long_edge.dy[13]}},long_edge.dy} + {{4{long_edge.dx[13]}},long_edge.dx};
                                        long_edge.p0.y <= long_edge.p0.y + long_edge.sy;
                                        long_edge.p0.x <= long_edge.p0.x + long_edge.sx;
                                    end else begin
                                        short_edge.err <= short_edge.err + {{4{short_edge.dy[13]}},short_edge.dy} + {{4{short_edge.dx[13]}},short_edge.dx};
                                        short_edge.p0.y <= short_edge.p0.y + short_edge.sy;
                                        short_edge.p0.x <= short_edge.p0.x + short_edge.sx;
                                    end
                                end
                            endcase
                        end
                    end
                end
                S_TRIANGLE_FILL_SPAN: begin
                    if (span_data.y[13] || $signed(
                            span_data.y
                        ) >= DISPLAY_HEIGHT) begin
                        rasterizer_state <= S_TRIANGLE_MAIN;
                    end else begin
                        triangle_span_phase_counter <= triangle_span_phase_counter + 1;
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
                            end
                            'd2: begin
                                line_data.p0.x              <= span_data.xa;
                                line_data.p0.y              <= span_data.y;
                                line_data.p1.x              <= span_data.xb;
                                line_data.p1.y              <= span_data.y;
                                rasterizer_state            <= S_LINE_PREP;
                                triangle_span_phase_counter <= 0;
                            end
                        endcase
                    end
                end
                S_LINE_PREP: begin
                    rasterizer_state <= S_PIXEL_DISPATCH;
                    line_data.dx     <= w_dx;
                    line_data.dy     <= ~w_dy + 1'b1;
                    line_data.sx     <= w_sx;
                    line_data.sy     <= w_sy;
                    line_data.err    <= w_err_prep;
                end
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
                        unique case (line_data_update_case)
                            2'b00: begin
                            end
                            2'b01: begin
                                line_data.err <= line_data.err + {{4{line_data.dx[13]}},line_data.dx};
                                line_data.p0.y <= line_data.p0.y + line_data.sy;
                            end
                            2'b10: begin
                                line_data.p0.x <= line_data.p0.x + line_data.sx;
                                line_data.err <= line_data.err + {{4{line_data.dy[13]}},line_data.dy};
                            end
                            2'b11: begin
                                line_data.err <= line_data.err + {{4{line_data.dy[13]}},line_data.dy} + {{4{line_data.dx[13]}},line_data.dx};
                                line_data.p0.y <= line_data.p0.y + line_data.sy;
                                line_data.p0.x <= line_data.p0.x + line_data.sx;
                            end
                        endcase
                        rasterizer_state <= S_PIXEL_DISPATCH;
                    end
                end
            endcase
        end
    end

endmodule
