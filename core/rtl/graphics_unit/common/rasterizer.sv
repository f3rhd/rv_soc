/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */
`include "rasterizer_interface.svh"

module bresenham_step (
    input line_data_t line_data,
    output logic [17:0] next_err,
    output logic [13:0] next_x0,
    output logic [13:0] next_y0
);

    always_comb begin
        next_err = line_data.err;
        next_x0  = line_data.p0.x;
        next_y0  = line_data.p0.y;
        if ($signed(line_data.err << 1) >= $signed(line_data.dy)) begin
            next_err += {{4{line_data.dy[13]}}, line_data.dy};
            next_x0 += line_data.sx;
        end
        if ($signed(line_data.err << 1) <= $signed(line_data.dx)) begin
            next_err += {{4{line_data.dx[13]}}, line_data.dx};
            next_y0 += line_data.sy;
        end
    end
endmodule
module next_row_advancer (
    input logic clk,
    input logic reset,
    input line_data_t i_line_data,
    input logic i_begin,
    output line_data_t o_line_result,
    output logic o_done
);
    logic registered_y_start;
    logic [13:0] y_start;
    wire [17:0] next_err;
    wire [13:0] next_x0;
    wire [13:0] next_y0;

    bresenham_step step (
        o_line_result,
        next_err,
        next_x0,
        next_y0
    );
    enum {
        IDLE,
        EXECUTE
    } state;
    always_ff @(posedge clk) begin
        o_done <= 0;
        if (reset) begin
            state <= IDLE;
        end else begin
            unique case (state)
                IDLE: begin
                    o_line_result      <= 0;
                    registered_y_start <= 0;
                    y_start            <= 0;
                    if (o_done) begin
                    end else if (i_begin) begin
                        o_line_result <= i_line_data;
                        state         <= EXECUTE;
                    end
                end
                EXECUTE: begin
                    if (!registered_y_start) begin
                        registered_y_start <= 1;
                        y_start            <= o_line_result.p0.y;
                    end else begin
                        if (o_line_result.p0.y != y_start || (o_line_result.p0.x == o_line_result.p1.x && o_line_result.p0.y == o_line_result.p1.y)) begin
                            state              <= IDLE;
                            o_done             <= 1;
                            registered_y_start <= 0;
                        end else begin
                            o_line_result.err  <= next_err;
                            o_line_result.p0.x <= next_x0;
                            o_line_result.p0.y <= next_y0;
                        end
                    end
                end
            endcase
        end
    end
endmodule
module rasterizer #(
    parameter signed DISPLAY_WIDTH  = 128,
    parameter signed DISPLAY_HEIGHT = 160
) (
    input logic clk,
    input logic reset,
    rasterizer_if.rasterizer rasterizeri
);

    enum logic [2:0] {
        S_IDLE,
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
        S_SET_SHORT_EDGE,
        S_SET_LONG_EDGE,
        S_ITERATE,
        S_INIT_BOTTOM_HALF_EDGE
    } fill_state;

    triangle_data_t triangle_data;
    line_data_t hollow_line_data;
    fill_span_data_t span_data;
    line_data_t active_line_data;
    point_data_t [0:2] sorted_triangle_points;
    line_data_t long_edge;
    line_data_t short_edge;

    logic [13:0] iterator;
    logic [13:0] iterator_finish;
    logic first_loop_done;
    logic [2:0] triangle_phase_counter;
    logic [1:0] triangle_span_phase_counter;
    logic [17:0] hollow_line_next_err;
    logic [13:0] hollow_line_next_x0;
    logic [13:0] hollow_line_next_y0;


    bresenham_step hollow_line_step (
        .line_data(hollow_line_data),
        .next_err (hollow_line_next_err),
        .next_x0  (hollow_line_next_x0),
        .next_y0  (hollow_line_next_y0)
    );

    logic short_edge_advance;
    logic short_edge_advanced;
    logic short_edge_advance_done;
    line_data_t short_edge_advance_result;

    next_row_advancer short_edge_advancer (
        .clk          (clk),
        .reset        (reset),
        .i_line_data  (short_edge),
        .i_begin      (short_edge_advance),
        .o_line_result(short_edge_advance_result),
        .o_done       (short_edge_advance_done)
    );

    logic long_edge_advance;
    logic long_edge_advance_done;
    logic long_edge_advanced;
    line_data_t long_edge_advance_result;

    next_row_advancer long_edge_advancer (
        .clk          (clk),
        .reset        (reset),
        .i_line_data  (long_edge),
        .i_begin      (long_edge_advance),
        .o_line_result(long_edge_advance_result),
        .o_done       (long_edge_advance_done)
    );

    logic hit_long_edge;
    logic hit_short_edge;
    logic init_err;

    localparam HEIGHT_BITS = $clog2(DISPLAY_HEIGHT);
    always_comb begin : triangle_prep_comparator_chain
        sorted_triangle_points = rasterizeri.triangle_data.points;
        if (sorted_triangle_points[0].y[0+:HEIGHT_BITS] > sorted_triangle_points[1].y[0+:HEIGHT_BITS]) begin
            {sorted_triangle_points[0].x, sorted_triangle_points[1].x} = {sorted_triangle_points[1].x, sorted_triangle_points[0].x};
            {sorted_triangle_points[0].y, sorted_triangle_points[1].y} = {sorted_triangle_points[1].y, sorted_triangle_points[0].y};
        end
        if (sorted_triangle_points[0].y[0+:HEIGHT_BITS] > sorted_triangle_points[2].y[0+:HEIGHT_BITS]) begin
            {sorted_triangle_points[0].x, sorted_triangle_points[2].x} = {sorted_triangle_points[2].x, sorted_triangle_points[0].x};
            {sorted_triangle_points[0].y, sorted_triangle_points[2].y} = {sorted_triangle_points[2].y, sorted_triangle_points[0].y};
        end
        if (sorted_triangle_points[1].y[0+:HEIGHT_BITS] > sorted_triangle_points[2].y[0+:HEIGHT_BITS]) begin
            {sorted_triangle_points[1].x, sorted_triangle_points[2].x} = {sorted_triangle_points[2].x, sorted_triangle_points[1].x};
            {sorted_triangle_points[1].y, sorted_triangle_points[2].y} = {sorted_triangle_points[2].y, sorted_triangle_points[1].y};
        end

    end
    logic [13:0] adjusted_xa, adjusted_xb;
    always_comb begin : span_data_xa_xb_adjustment
        adjusted_xa = span_data.xa;
        adjusted_xb = span_data.xb;
        if ($signed(adjusted_xa) > $signed(adjusted_xb)) begin
            {adjusted_xa, adjusted_xb} = {adjusted_xb, adjusted_xa};
        end
        if (adjusted_xa[13]) begin
            adjusted_xa = 0;
        end
        if ($signed(adjusted_xb) > $signed(DISPLAY_WIDTH - 1)) begin
            adjusted_xb = DISPLAY_WIDTH - 1;
        end
    end
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
                        S_SET_SHORT_EDGE: begin
                            {active_line_data.p0, active_line_data.p1, active_line_data.err} = {short_edge.p0, short_edge.p1, short_edge.err};
                            if (!hit_long_edge) init_err = 1;
                        end
                        S_INIT_BOTTOM_HALF_EDGE: begin
                            {active_line_data.p0, active_line_data.p1} = {short_edge.p0, short_edge.p1};
                            init_err                                   = 1;
                        end
                        S_SET_LONG_EDGE: begin
                            {active_line_data.p0, active_line_data.p1, active_line_data.err} = {long_edge.p0, long_edge.p1, long_edge.err};
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
            active_line_data.err = {{4{active_line_data.dx[13]}}, active_line_data.dx} + {{4{active_line_data.dy[13]}}, active_line_data.dy};
        end
    end

    always_ff @(posedge clk) begin
        rasterizeri.rasterizer_done  <= 0;
        rasterizeri.pixel_data_ready <= 0;
        rasterizeri.span_data_ready  <= 0;
        short_edge_advance           <= 0;
        long_edge_advance            <= 0;
        if (reset) begin
            rasterizer_state <= S_IDLE;
        end else begin
            unique case (rasterizer_state)
                S_IDLE: begin
                    triangle_data               <= 0;
                    hollow_line_data            <= 0;
                    span_data                   <= 0;
                    triangle_span_phase_counter <= 0;
                    triangle_phase_counter      <= 0;
                    first_loop_done             <= 0;
                    hit_short_edge              <= 0;
                    hit_long_edge               <= 0;
                    fill_state                  <= S_INIT_ESSENTIALS;
                    if (rasterizeri.rasterizer_begin) begin
                        triangle_data <= '{
                            hollow: rasterizeri.triangle_data.hollow,
                            color: rasterizeri.triangle_data.color,
                            points: sorted_triangle_points
                        };
                        rasterizer_state <= S_TRIANGLE_MAIN;
                    end
                end
                S_TRIANGLE_MAIN: begin
                    if (triangle_data.hollow) begin
                        // TODO : this is where line draw normally
                        //        instead of drawing 3 lines 2 of which will be for nothing, we can just draw 1 
                        triangle_phase_counter <= triangle_phase_counter + 1;
                        hollow_line_data       <= active_line_data;
                        if (triangle_phase_counter == 3) begin
                            rasterizer_state            <= S_IDLE;
                            rasterizeri.rasterizer_done <= 1;
                        end else begin
                            rasterizer_state <= S_PIXEL_DISPATCH;
                        end
                    end else begin
                        unique case (fill_state)
                            S_INIT_ESSENTIALS: begin
                                iterator                       <= triangle_data.points[0].y;
                                iterator_finish                <= triangle_data.points[1].y;
                                {long_edge.p0, long_edge.p1}   <= {triangle_data.points[0], triangle_data.points[2]};
                                {short_edge.p0, short_edge.p1} <= {triangle_data.points[0], triangle_data.points[1]};
                                fill_state                     <= S_FILL_SPAN_PREP;
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
                                fill_state  <= S_SET_SHORT_EDGE;
                            end
                            S_SET_SHORT_EDGE: begin
                                hit_long_edge <= 1;
                                short_edge    <= active_line_data;
                                fill_state    <= S_SET_LONG_EDGE;
                            end
                            S_SET_LONG_EDGE: begin
                                hit_short_edge     <= 1;
                                long_edge          <= active_line_data;
                                fill_state         <= S_ITERATE;
                                rasterizer_state   <= S_ADVANCE_TO_NEXT_ROW;
                                short_edge_advance <= 1;
                                long_edge_advance  <= 1;
                            end
                            S_ITERATE: begin
                                fill_state <= S_FILL_SPAN_PREP;
                                if ($signed(iterator) > $signed(iterator_finish)) begin
                                    if (first_loop_done) begin
                                        rasterizer_state            <= S_IDLE;
                                        rasterizeri.rasterizer_done <= 1;
                                    end else begin
                                        iterator                       <= triangle_data.points[1].y;
                                        iterator_finish                <= triangle_data.points[2].y;
                                        first_loop_done                <= 1;
                                        {short_edge.p0, short_edge.p1} <= {triangle_data.points[1], triangle_data.points[2]};
                                        fill_state                     <= S_INIT_BOTTOM_HALF_EDGE;
                                    end
                                end else begin
                                    iterator <= iterator + 1;
                                end
                            end
                            S_INIT_BOTTOM_HALF_EDGE: begin
                                short_edge <= active_line_data;
                                fill_state <= S_ITERATE;
                            end
                        endcase
                    end
                end
                S_ADVANCE_TO_NEXT_ROW: begin
                    if (short_edge_advance_done) begin
                        short_edge          <= short_edge_advance_result;
                        short_edge_advanced <= 1'b1;
                    end

                    if (long_edge_advance_done) begin
                        long_edge          <= long_edge_advance_result;
                        long_edge_advanced <= 1'b1;
                    end

                    if ((short_edge_advanced || short_edge_advance_done) && (long_edge_advanced || long_edge_advance_done)) begin
                        rasterizer_state    <= S_TRIANGLE_MAIN;
                        short_edge_advanced <= 1'b0;
                        long_edge_advanced  <= 1'b0;
                    end
                    if (short_edge_advance_done && long_edge_advance_done) begin
                        rasterizer_state <= S_TRIANGLE_MAIN;
                    end
                end
                S_TRIANGLE_FILL_SPAN: begin
                    if (span_data.y[13] || $signed(span_data.y) >= DISPLAY_HEIGHT) begin
                        rasterizer_state <= S_TRIANGLE_MAIN;
                    end else begin
                        unique case (triangle_span_phase_counter)
                            'd0: begin
                                rasterizeri.span_data       <= '{y: span_data.y, xa: adjusted_xa, xb: adjusted_xb};
                                rasterizeri.span_data_ready <= 1;
                                triangle_span_phase_counter <= 1;
                            end
                            'd1: begin
                                if (rasterizeri.span_draw_complete) begin
                                    rasterizer_state            <= S_TRIANGLE_MAIN;
                                    triangle_span_phase_counter <= 0;
                                end
                            end
                        endcase
                    end
                end
                // Following states are for hollow drawal
                S_PIXEL_DISPATCH: begin
                    rasterizeri.span_data.xa    <= hollow_line_data.p0.x;
                    rasterizeri.span_data.xb    <= hollow_line_data.p0.x;
                    rasterizeri.span_data.y     <= hollow_line_data.p0.y;
                    rasterizeri.span_data_ready <= 1;
                    rasterizer_state            <= S_WAIT_CONTROLLER;
                end
                S_WAIT_CONTROLLER: begin
                    if (rasterizeri.span_draw_complete) begin
                        rasterizer_state <= S_LINE_UPDATE;
                    end
                end
                S_LINE_UPDATE: begin
                    if (hollow_line_data.p0.x == hollow_line_data.p1.x && hollow_line_data.p0.y == hollow_line_data.p1.y) begin
                        rasterizer_state <= S_TRIANGLE_MAIN;
                    end else begin
                        hollow_line_data.err  <= hollow_line_next_err;
                        hollow_line_data.p0.x <= hollow_line_next_x0;
                        hollow_line_data.p0.y <= hollow_line_next_y0;
                        rasterizer_state      <= S_PIXEL_DISPATCH;
                    end
                end
            endcase
        end
    end

endmodule
