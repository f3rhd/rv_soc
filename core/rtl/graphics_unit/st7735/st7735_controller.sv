/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

`include "../common/graphics_decode_output.svh"
module st7735_controller #(
    parameter unsigned SYSTEM_CLK_HZ = 100_000_000,
    parameter unsigned SPI_CLK_HZ = 25_000_000
) (
    input logic clk,
    input logic i_boot,
    input logic i_reset,
    input graphics_decode_output_t decode_result,
    output logic o_execute_complete,
    output logic o_sck,
    output logic o_sda,
    output logic o_dc,
    output logic o_cs,
    output logic o_res,
    output logic o_init_done
);

    localparam unsigned DATA_WIDTH = 8;
    localparam unsigned TICKS_PER_MS = SYSTEM_CLK_HZ / 1000;
    localparam unsigned TICK_BITS = $clog2(TICKS_PER_MS);


    logic [DATA_WIDTH-1:0] tx_data;
    logic tx_busy;
    logic tx_begin;
    logic [2:0] sent_byte_counter;
    logic sent_command;
    logic is_caset;
    logic pixel_draw_complete;

    logic dly_start, dly_done;
    logic [          7:0] dly_ms;
    logic [TICK_BITS-1:0] dly_tick_cnt;
    logic [          7:0] dly_ms_cnt;
    logic                 dly_active;
    logic tx_busy_prev, tx_done;

    localparam unsigned ROM_DEPTH = 38;
    logic [9:0] init_rom[0:ROM_DEPTH-1];
    logic [5:0] rom_ptr;

    // we are going to fill screen with blue before handing it to execute
    localparam logic [15:0] FILL_COLOR = 16'hF800;  // Blue in BGR565
    localparam unsigned FILL_PIXELS = 20480;  // 128 * 160
    logic [23:0] fill_pix_cnt;

    typedef enum logic [1:0] {
        IDLE,
        BOOT,
        EXECUTE
    } graphics_state_e;

    typedef enum logic [2:0] {
        EXEC_DRAW_LINE_PREP,
        EXEC_DRAW_LINE,
        EXEC_DRAW_TRIANGLE_PREP,
        EXEC_PIXEL_DRAW_COORD,
        EXEC_PIXEL_DRAW_RAMRW,
        EXEC_DRAW_TRIANGLE,
        EXEC_DO_NOTHING,
        EXEC_WAIT
    } execution_state_e;
    typedef enum logic [3:0] {
        UNDEFINED,
        BOOT_HW_RST_LOW,
        BOOT_HW_RST_WAIT,
        BOOT_HW_RST_SETTLE,
        BOOT_ROM_FETCH,
        BOOT_TX_WAIT,
        BOOT_DLY_WAIT,
        BOOT_FILL_CMD,
        BOOT_FILL_CMD_WAIT,
        BOOT_FILL_PIX_HI,
        BOOT_FILL_PIX_HI_WAIT,
        BOOT_FILL_PIX_LO,
        BOOT_FILL_PIX_LO_WAIT,
        BOOT_BOOT_DONE
    } boot_state_e;

    typedef struct packed {
        logic [11:0] x;
        logic [11:0] y;
    } point_data_t;

    typedef struct packed {
        logic hollow;
        logic [15:0] color;
        point_data_t [0:2] points;
    } triangle_data_t;

    typedef struct packed {
        logic [11:0] dx;
        logic [11:0] sx;
        logic [11:0] dy;
        logic [11:0] sy;
        logic [15:0] err;
        point_data_t p0;
        point_data_t p1;
    } line_data_t;

    graphics_state_e graphics_state;
    boot_state_e boot_state;
    execution_state_e exec_state = EXEC_DO_NOTHING;
    execution_state_e send_byte_return = EXEC_DO_NOTHING;
    triangle_data_t triangle_data;
    line_data_t line_data;
    point_data_t pixel_data;


    wire [11:0] w_dx = (line_data.p0.x < line_data.p1.x) ? line_data.p1.x - line_data.p0.x : line_data.p0.x - line_data.p1.x;
    wire [11:0] w_dy = (line_data.p0.y < line_data.p1.y) ? line_data.p1.y - line_data.p0.y : line_data.p0.y - line_data.p1.y;
    wire [11:0] w_sx = (line_data.p0.x < line_data.p1.x) ? 1 : {12{1'b1}};
    wire [11:0] w_sy = (line_data.p0.y < line_data.p1.y) ? 1 : {12{1'b1}};
    wire [15:0] w_err_prep = w_dx + (~w_dy + 1'b1);
    wire [15:0] w_err2 = line_data.err << 1;
    wire [1:0] line_data_update_case = {
        $signed(w_err2) >= $signed(line_data.dy),
        $signed(w_err2) <= $signed(line_data.dx)
    };
    logic [1:0] triangle_prep_phase_counter;

    spi_tx_engine #(
        .SYSTEM_CLK_HZ(SYSTEM_CLK_HZ),
        .SPI_CLK_HZ   (SPI_CLK_HZ),
        .DATA_WIDTH   (DATA_WIDTH)
    ) spi_tx_engine (
        .clk        (clk),
        .i_reset    (i_reset),
        .i_data     (tx_data),
        .i_send_data(tx_begin),
        .o_sck      (o_sck),
        .o_sda      (o_sda),
        .o_tx_busy  (tx_busy)
    );

    always_ff @(posedge clk) begin
        tx_busy_prev <= tx_busy;
        tx_done      <= tx_busy_prev & ~tx_busy;
    end


    always_ff @(posedge clk) begin
        dly_done <= 0;
        if (i_reset) begin
            dly_active   <= 0;
            dly_tick_cnt <= 0;
            dly_ms_cnt   <= 0;
        end else if (dly_start && !dly_active) begin
            dly_active   <= 1;
            dly_tick_cnt <= 0;
            dly_ms_cnt   <= 0;
        end else if (dly_active) begin
            if (dly_tick_cnt == TICKS_PER_MS[TICK_BITS-1:0] - 1) begin
                dly_tick_cnt <= 0;
                if (dly_ms_cnt == dly_ms - 1) begin
                    dly_active <= 0;
                    dly_done   <= 1;
                end else begin
                    dly_ms_cnt <= dly_ms_cnt + 1;
                end
            end else begin
                dly_tick_cnt <= dly_tick_cnt + 1;
            end
        end
    end
    // Init ROM 
    // [9:8]: 2'b10=delay  2'b00=command(DC=0)  2'b01=data(DC=1)
    initial begin
        int i;
        i             = 0;
        init_rom[i++] = {2'b00, 8'h01};  // SW reset
        init_rom[i++] = {2'b10, 8'd150};  // wait 150 ms
        init_rom[i++] = {2'b00, 8'h11};  // Sleep out
        init_rom[i++] = {2'b10, 8'd255};  // wait 255 ms
        init_rom[i++] = {2'b00, 8'hB1};  // FRMCTR1
        init_rom[i++] = {2'b01, 8'h01};
        init_rom[i++] = {2'b01, 8'h2C};
        init_rom[i++] = {2'b01, 8'h2D};
        init_rom[i++] = {2'b00, 8'hB4};  // INVCTR
        init_rom[i++] = {2'b01, 8'h07};
        init_rom[i++] = {2'b00, 8'hC0};  // PWCTR1
        init_rom[i++] = {2'b01, 8'hA2};
        init_rom[i++] = {2'b01, 8'h02};
        init_rom[i++] = {2'b01, 8'h84};
        init_rom[i++] = {2'b00, 8'hC1};  // PWCTR2
        init_rom[i++] = {2'b01, 8'hC5};
        init_rom[i++] = {2'b00, 8'hC2};  // PWCTR3
        init_rom[i++] = {2'b01, 8'h0A};
        init_rom[i++] = {2'b01, 8'h00};
        init_rom[i++] = {2'b00, 8'h3A};  // COLMOD 16-bit
        init_rom[i++] = {2'b01, 8'h05};
        init_rom[i++] = {2'b00, 8'h36};  // MADCTL — BGR order
        init_rom[i++] = {2'b01, 8'h08};
        init_rom[i++] = {2'b00, 8'h2A};  // CASET 0..127
        init_rom[i++] = {2'b01, 8'h00};
        init_rom[i++] = {2'b01, 8'h00};
        init_rom[i++] = {2'b01, 8'h00};
        init_rom[i++] = {2'b01, 8'h7F};
        init_rom[i++] = {2'b00, 8'h2B};  // RASET 0..159
        init_rom[i++] = {2'b01, 8'h00};
        init_rom[i++] = {2'b01, 8'h00};
        init_rom[i++] = {2'b01, 8'h00};
        init_rom[i++] = {2'b01, 8'h9F};
        init_rom[i++] = {2'b00, 8'h13};  // NORON
        init_rom[i++] = {2'b10, 8'd10};  // wait 10 ms
        init_rom[i++] = {2'b00, 8'h29};  // DISPON
        init_rom[i++] = {2'b10, 8'd100};  // wait 100 ms
        init_rom[i++] = {2'b10, 8'd1};  // dummy pad
    end

    always_ff @(posedge clk) begin
        tx_begin            <= 0;
        dly_start           <= 0;
        pixel_draw_complete <= 0;
        o_execute_complete  <= 0;

        if (i_reset) begin
            tx_data           <= 0;
            o_cs              <= 1;
            o_res             <= 0;
            o_dc              <= 0;
            o_init_done       <= 0;
            is_caset          <= 0;
            sent_byte_counter <= 0;
            exec_state        <= EXEC_DO_NOTHING;
            send_byte_return  <= EXEC_DO_NOTHING;
            graphics_state    <= IDLE;
            boot_state        <= UNDEFINED;
            sent_command      <= 0;
        end else begin
            unique case (graphics_state)
                IDLE: begin
                    tx_data           <= 0;
                    o_cs              <= 1;
                    sent_byte_counter <= 0;
                    exec_state        <= EXEC_DO_NOTHING;
                    boot_state        <= UNDEFINED;
                    sent_command      <= 0;
                    if (i_boot) begin
                        graphics_state <= BOOT;
                        rom_ptr        <= 0;
                        fill_pix_cnt   <= 0;
                        boot_state     <= BOOT_HW_RST_LOW;
                    end
                end
                BOOT: begin
                    case (boot_state)
                        UNDEFINED: begin
                        end
                        BOOT_HW_RST_LOW: begin
                            o_res      <= 0;
                            o_cs       <= 1;
                            dly_ms     <= 8'd150;
                            dly_start  <= 1;
                            boot_state <= BOOT_HW_RST_WAIT;
                        end

                        BOOT_HW_RST_WAIT: begin
                            if (dly_done) begin
                                o_res      <= 1;
                                dly_ms     <= 8'd120;
                                dly_start  <= 1;
                                boot_state <= BOOT_HW_RST_SETTLE;
                            end
                        end

                        BOOT_HW_RST_SETTLE: begin
                            if (dly_done) boot_state <= BOOT_ROM_FETCH;
                        end

                        BOOT_ROM_FETCH: begin
                            if (rom_ptr == ROM_DEPTH) begin
                                o_cs       <= 1;
                                boot_state <= BOOT_FILL_CMD;
                            end else begin
                                automatic logic [9:0] e = init_rom[rom_ptr];
                                rom_ptr <= rom_ptr + 1;
                                if (e[9]) begin
                                    o_cs       <= 1;
                                    dly_ms     <= e[7:0];
                                    dly_start  <= 1;
                                    boot_state <= BOOT_DLY_WAIT;
                                end else begin
                                    o_dc       <= e[8];
                                    o_cs       <= 0;
                                    tx_data    <= e[7:0];
                                    tx_begin   <= 1;
                                    boot_state <= BOOT_TX_WAIT;
                                end
                            end
                        end

                        BOOT_TX_WAIT: begin
                            if (tx_done) boot_state <= BOOT_ROM_FETCH;
                        end

                        BOOT_DLY_WAIT: begin
                            if (dly_done) boot_state <= BOOT_ROM_FETCH;
                        end

                        // blue screen fill
                        BOOT_FILL_CMD: begin
                            fill_pix_cnt <= 0;
                            o_dc         <= 0;
                            o_cs         <= 0;
                            tx_data      <= 8'h2C;  // RAMWR
                            tx_begin     <= 1;
                            boot_state   <= BOOT_FILL_CMD_WAIT;
                        end

                        BOOT_FILL_CMD_WAIT: begin
                            if (tx_done) boot_state <= BOOT_FILL_PIX_HI;
                        end

                        BOOT_FILL_PIX_HI: begin
                            o_dc       <= 1;
                            o_cs       <= 0;
                            tx_data    <= FILL_COLOR[15:8];
                            tx_begin   <= 1;
                            boot_state <= BOOT_FILL_PIX_HI_WAIT;
                        end

                        BOOT_FILL_PIX_HI_WAIT: begin
                            if (tx_done) boot_state <= BOOT_FILL_PIX_LO;
                        end

                        BOOT_FILL_PIX_LO: begin
                            tx_data    <= FILL_COLOR[7:0];
                            tx_begin   <= 1;
                            boot_state <= BOOT_FILL_PIX_LO_WAIT;
                        end

                        BOOT_FILL_PIX_LO_WAIT: begin
                            if (tx_done) begin
                                if (fill_pix_cnt == FILL_PIXELS - 1) begin
                                    o_cs       <= 1;
                                    boot_state <= BOOT_BOOT_DONE;
                                end else begin
                                    fill_pix_cnt <= fill_pix_cnt + 1;
                                    boot_state   <= BOOT_FILL_PIX_HI;
                                end
                            end
                        end

                        BOOT_BOOT_DONE: begin
                            o_init_done    <= 1;
                            graphics_state <= EXECUTE;
                            exec_state     <= EXEC_DO_NOTHING;
                        end
                        default: graphics_state <= IDLE;
                    endcase
                end
                EXECUTE: begin
                    case (exec_state)
                        default: begin
                        end
                        EXEC_DO_NOTHING: begin
                            o_cs                        <= 1;
                            sent_byte_counter           <= 0;
                            triangle_prep_phase_counter <= 0;
                            sent_command                <= 0;
                            sent_byte_counter           <= 0;
                            pixel_draw_complete         <= 0;
                            is_caset                    <= 0;
                            if (o_execute_complete) begin
                                // do nothing for 1 cycle
                            end else if (decode_result.valid) begin
                                unique case (decode_result.instr_id)
                                    P0: begin
                                        triangle_data.points[0].x <= decode_result.instr.point.x;
                                        triangle_data.points[0].y <= decode_result.instr.point.y;
                                        o_execute_complete <= 1;
                                    end
                                    P1: begin
                                        triangle_data.points[1].x <= decode_result.instr.point.x;
                                        triangle_data.points[1].y <= decode_result.instr.point.y;
                                        o_execute_complete <= 1;
                                    end
                                    P2: begin
                                        triangle_data.points[2].x <= decode_result.instr.point.x;
                                        triangle_data.points[2].y <= decode_result.instr.point.y;
                                        o_execute_complete <= 1;
                                    end
                                    CLR: begin
                                        triangle_data.color <= decode_result.instr.color[15:0];
                                        triangle_data.hollow <= decode_result.hollow;
                                        exec_state <= EXEC_DRAW_TRIANGLE_PREP;
                                        o_cs <= 0;
                                        triangle_prep_phase_counter <= 0;
                                    end
                                endcase
                            end

                        end
                        EXEC_DRAW_TRIANGLE_PREP: begin
                            triangle_prep_phase_counter <= triangle_prep_phase_counter + 1;
                            if (triangle_prep_phase_counter == 2) begin
                                exec_state <= EXEC_DRAW_TRIANGLE;
                                triangle_prep_phase_counter <= 0;
                            end
                            unique case (triangle_prep_phase_counter)
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
                        EXEC_DRAW_TRIANGLE: begin
                            if (triangle_data.hollow) begin
                                // we are going to use triangle_prep_phase_counter here as well. 
                                // It's going to be used to count the number of lines drawn in hollow call
                                triangle_prep_phase_counter <= triangle_prep_phase_counter + 1;
                                exec_state <= EXEC_DRAW_LINE_PREP;
                                if (triangle_prep_phase_counter == 3) begin
                                    exec_state         <= EXEC_DO_NOTHING;
                                    o_execute_complete <= 1;
                                end
                                unique case (triangle_prep_phase_counter)
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
                        EXEC_DRAW_LINE_PREP: begin
                            exec_state    <= EXEC_DRAW_LINE;
                            line_data.dx  <= w_dx;
                            line_data.dy  <= ~w_dy + 1'b1;
                            line_data.sx  <= w_sx;
                            line_data.sy  <= w_sy;
                            line_data.err <= w_err_prep;
                        end
                        EXEC_DRAW_LINE: begin
                            if (!pixel_draw_complete) begin
                                pixel_data.x <= line_data.p0.x;
                                pixel_data.y <= line_data.p0.y;
                                exec_state   <= EXEC_PIXEL_DRAW_COORD;
                            end else begin
                                if (line_data.p0.x == line_data.p1.x && line_data.p0.y == line_data.p1.y) begin
                                    exec_state <= EXEC_DRAW_TRIANGLE;
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
                                end
                            end
                        end
                        EXEC_PIXEL_DRAW_COORD: begin

                            if (!sent_command) begin
                                tx_data          <= (is_caset) ? 8'h2A : 8'h2B;
                                o_dc             <= 0;
                                sent_command     <= 1;
                                tx_begin         <= 1;
                                exec_state       <= EXEC_WAIT;
                                send_byte_return <= EXEC_PIXEL_DRAW_COORD;
                            end else begin
                                if (sent_byte_counter == 5) begin
                                    if (!is_caset) begin
                                        is_caset <= 1;  // Switch to CASET 
                                    end else begin
                                        is_caset <= 0;  // Reset for next time
                                        exec_state <= EXEC_PIXEL_DRAW_RAMRW;
                                    end
                                    sent_byte_counter <= 0;
                                    sent_command      <= 0;
                                end else begin
                                    o_dc             <= 1;
                                    tx_begin         <= 1;
                                    exec_state       <= EXEC_WAIT;
                                    send_byte_return <= EXEC_PIXEL_DRAW_COORD;
                                    // High bytes are 0
                                    if (sent_byte_counter == 1 || sent_byte_counter == 3) begin
                                        tx_data <= 0;
                                    end else begin
                                        tx_data <= (is_caset) ? pixel_data.x[7:0] : pixel_data.y[7:0];
                                    end
                                end
                            end
                        end

                        EXEC_PIXEL_DRAW_RAMRW: begin
                            tx_begin         <= 1;
                            exec_state       <= EXEC_WAIT;
                            send_byte_return <= EXEC_PIXEL_DRAW_RAMRW;
                            o_dc             <= 1;
                            unique case (sent_byte_counter)
                                'd0: begin
                                    tx_data <= 8'h2c;
                                    o_dc    <= 0;
                                end
                                'd1: begin
                                    tx_data <= triangle_data.color[15:8];
                                end
                                'd2: begin
                                    tx_data <= triangle_data.color[7:0];
                                end
                                'd3: begin
                                    tx_begin            <= 0;
                                    sent_byte_counter   <= 0;
                                    exec_state          <= EXEC_DRAW_LINE;
                                    pixel_draw_complete <= 1;
                                end
                            endcase
                        end
                        EXEC_WAIT: begin
                            if (tx_done) begin
                                sent_byte_counter <= sent_byte_counter + 1;
                                // Return to caller
                                exec_state        <= send_byte_return;
                            end
                        end
                    endcase
                end
            endcase
        end
    end
endmodule
