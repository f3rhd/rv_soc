/*
 * SPDX-FileCopyrightText: 2026 f3rhd 
 *
 * SPDX-License-Identifier: MIT
 */

module uart_rx_engine #(
    parameter SYSTEM_CLK_HZ = 100_000_000,
    parameter BAUD_RATE = 115200
) (
    input logic clk,
    input logic i_reset,
    input logic i_rx,
    output logic [7:0] o_byte_out,
    output logic o_byte_ready
);
    localparam unsigned CLKS_PER_BIT = SYSTEM_CLK_HZ / (BAUD_RATE);
    localparam unsigned PHASE1_WAIT = CLKS_PER_BIT * 2 - CLKS_PER_BIT / 2;
    typedef enum logic [1:0] {
        IDLE,
        READING_PHASE_1,
        READING_PHASE_2
    } rtx_state;
    logic [4:0] received_bit_counter = 0;
    logic [$clog2(PHASE1_WAIT)-1:0] phase1_counter = 0;
    logic [$clog2(CLKS_PER_BIT)-1:0] baud_counter = 0;
    rtx_state state = IDLE;

    logic [1:0] rx_sync;
    logic rx_s;

    always_ff @(posedge clk) begin
        rx_sync <= {rx_sync[0], i_rx};
    end
    assign rx_s = rx_sync[1];

    always_ff @(posedge clk) begin
        if (i_reset) begin
            received_bit_counter <= 0;
            baud_counter         <= 0;
            o_byte_out           <= 0;
            o_byte_ready         <= 0;
            phase1_counter       <= 0;
            state                <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    received_bit_counter <= 0;
                    baud_counter         <= 0;
                    o_byte_out           <= 0;
                    o_byte_ready         <= 0;
                    if (rx_s == 0) begin
                        state <= READING_PHASE_1;
                    end
                end
                READING_PHASE_1: begin
                    if (phase1_counter < PHASE1_WAIT - 1) begin
                        phase1_counter <= phase1_counter + 1;
                    end else begin
                        o_byte_out           <= o_byte_out >> 1;
                        o_byte_out[7]        <= rx_s;
                        phase1_counter       <= 0;
                        received_bit_counter <= received_bit_counter + 1;
                        state                <= READING_PHASE_2;
                    end
                end
                READING_PHASE_2: begin
                    if (baud_counter < CLKS_PER_BIT - 1) begin
                        baud_counter <= baud_counter + 1;
                    end else begin
                        if (received_bit_counter < 8) begin
                            baud_counter         <= 0;
                            received_bit_counter <= received_bit_counter + 1;
                            o_byte_out           <= o_byte_out >> 1;
                            o_byte_out[7]        <= rx_s;
                        end else if (received_bit_counter == 8) begin
                            baud_counter         <= 0;
                            received_bit_counter <= received_bit_counter + 1;
                        end else begin
                            o_byte_ready <= 1;
                            state        <= IDLE;
                        end
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
