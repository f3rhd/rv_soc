/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

`ifndef SPI_TX_ENGINE_SVH
`define SPI_TX_ENGINE_SVH 
module spi_tx_engine #(
    parameter unsigned SYSTEM_CLK_HZ = 100_000_000,
    parameter unsigned SPI_CLK_HZ    = 12_500_000,
    parameter unsigned DATA_WIDTH    = 8
) (
    input  logic                    clk,
    input  logic                    i_reset,
    input  logic [DATA_WIDTH - 1:0] i_data,
    input  logic                    i_send_data,
    output logic                    o_sck,
    output logic                    o_sda,
    output logic                    o_tx_busy
);
    localparam unsigned SPI_TICK_TRIGGER_VALUE = SYSTEM_CLK_HZ / (SPI_CLK_HZ * 2);

    logic [$clog2(SPI_TICK_TRIGGER_VALUE)-1:0] spi_tick_counter;
    logic spi_tick;

    logic [DATA_WIDTH-1:0] shift_reg;
    logic [$clog2(DATA_WIDTH):0] sent_bit_counter;
    logic tx_active;
    always_ff @(posedge clk) begin
        if (i_reset) begin
            spi_tick_counter <= '0;
            spi_tick         <= 1'b0;
        end else begin
            spi_tick <= 1'b0;
            if (tx_active) begin
                if (spi_tick_counter >= SPI_TICK_TRIGGER_VALUE - 1) begin
                    spi_tick         <= 1'b1;
                    spi_tick_counter <= '0;
                end else begin
                    spi_tick_counter <= spi_tick_counter + 1'b1;
                end
            end else begin
                spi_tick_counter <= '0;
            end
        end
    end

    always_ff @(posedge clk) begin
        if (i_reset) begin
            shift_reg        <= '0;
            sent_bit_counter <= '0;
            tx_active        <= 1'b0;
            o_sck            <= 1'b0;
            o_sda            <= 1'b0;
            o_tx_busy        <= 1'b0;
        end else begin
            if (!tx_active & i_send_data) begin
                tx_active        <= 1'b1;
                o_tx_busy        <= 1'b1;
                shift_reg        <= i_data;
                sent_bit_counter <= '0;
                o_sck            <= 1'b0;
                o_sda            <= i_data[DATA_WIDTH-1];
            end else if (spi_tick) begin
                if (sent_bit_counter == DATA_WIDTH & o_sck == 1) begin
                    tx_active        <= 1'b0;
                    o_tx_busy        <= 1'b0;
                    o_sck            <= 1'b0;
                    sent_bit_counter <= 0;
                end else begin
                    o_sck <= ~o_sck;
                    if (o_sck == 1'b1) begin
                        shift_reg <= {shift_reg[DATA_WIDTH-2:0], 1'b0};
                        o_sda     <= shift_reg[DATA_WIDTH-2];
                    end else begin
                        sent_bit_counter <= sent_bit_counter + 1'b1;
                    end
                end
            end
        end
    end
endmodule
`endif

