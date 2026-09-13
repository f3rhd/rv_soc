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
        S_TRIANGLE_FILL_SPAN,
        S_WAIT_CONTROLLER,
        S_LINE_PREP,
        S_LINE_UPDATE,
        S_PIXEL_DISPATCH
    } rasterizer_state;

    triangle_data_t triangle_data;
    line_data_t line_data;
    fill_span_data_t span_data;
    logic [1:0] triangle_phase_counter;

    wire [13:0] w_dx = (line_data.p0.x < line_data.p1.x) ? line_data.p1.x - line_data.p0.x : line_data.p0.x - line_data.p1.x;
    wire [13:0] w_dy = (line_data.p0.y < line_data.p1.y) ? line_data.p1.y - line_data.p0.y : line_data.p0.y - line_data.p1.y;
    wire [13:0] w_sx = (line_data.p0.x < line_data.p1.x) ? 1 : {12{1'b1}};
    wire [13:0] w_sy = (line_data.p0.y < line_data.p1.y) ? 1 : {12{1'b1}};
    wire [17:0] w_err_prep = w_dx + (~w_dy + 1'b1);
    wire [17:0] w_err2 = line_data.err << 1;
    wire [1:0] line_data_update_case = {
        $signed(w_err2) >= $signed(line_data.dy),
        $signed(w_err2) <= $signed(line_data.dx)
    };

    always_ff @(posedge clk) begin
        rasterizeri.rasterizer_done  <= 0;
        rasterizeri.pixel_data_ready <= 0;
        if (reset) begin
            rasterizer_state <= S_IDLE;
        end else begin
            unique case (rasterizer_state)
                S_IDLE: begin
                    triangle_data          <= 0;
                    line_data              <= 0;
                    span_data              <= 0;
                    triangle_phase_counter <= 0;
                    if (rasterizeri.rasterizer_begin) begin
                        triangle_data    <= rasterizeri.triangle_data;
                        rasterizer_state <= S_TRIANGLE_PREP;
                    end
                end
                S_TRIANGLE_PREP: begin
                    triangle_phase_counter <= triangle_phase_counter + 1;
                    if (triangle_phase_counter == 2) begin
                        rasterizer_state       <= S_TRIANGLE_MAIN;
                        triangle_phase_counter <= 0;
                    end
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
                        end
                    endcase

                end
                S_TRIANGLE_MAIN: begin
                    if (triangle_data.hollow) begin
                        // we are going to use triangle_phase_counter here as well. 
                        // It's going to be used to count the number of lines drawn in hollow call
                        triangle_phase_counter <= triangle_phase_counter + 1;
                        rasterizer_state       <= S_LINE_PREP;
                        if (triangle_phase_counter == 3) begin
                            rasterizer_state            <= S_IDLE;
                            rasterizeri.rasterizer_done <= 1;
                        end
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
                        endcase
                    end else begin

                    end
                end
                S_TRIANGLE_FILL_SPAN: begin
                    if (span_data.y[11] || $signed(
                            span_data.y
                        ) >= DISPLAY_HEIGHT) begin
                        rasterizer_state <= S_TRIANGLE_MAIN;
                    end else begin
                        triangle_phase_counter <= triangle_phase_counter + 1;
                        if (triangle_phase_counter == 2) begin
                            line_data.p0.x         <= span_data.xa;
                            line_data.p0.y         <= span_data.y;
                            line_data.p1.x         <= span_data.xb;
                            line_data.p1.y         <= span_data.y;
                            rasterizer_state       <= S_LINE_PREP;
                            triangle_phase_counter <= 0;
                        end else begin
                            unique case (triangle_phase_counter)
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
                            endcase
                        end
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
                                line_data.err <= line_data.err + {{4{line_data.dx[11]}},line_data.dx};
                                line_data.p0.y <= line_data.p0.y + line_data.sy;
                            end
                            2'b10: begin
                                line_data.p0.x <= line_data.p0.x + line_data.sx;
                                line_data.err <= line_data.err + {{4{line_data.dy[11]}},line_data.dy};
                            end
                            2'b11: begin
                                line_data.err <= line_data.err + {{4{line_data.dy[11]}},line_data.dy} + {{4{line_data.dx[11]}},line_data.dx};
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
