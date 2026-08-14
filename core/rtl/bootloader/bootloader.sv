/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

`include "bootloader_interface.svh"
module bootloader #(
    parameter SYSTEM_CLK_HZ = 100_000_000,
    parameter BAUD_RATE = 115200
) (
    input logic clk,
    input logic i_reset,
    bootloader_if.bootloader bootloader_if
);
    typedef enum logic [1:0] {
        IDLE,
        GET_PROGRAM_SIZE,
        INSTRUCTION_BUILD
    } bootloader_state;
    bootloader_state state = IDLE;

    localparam unsigned BOOT_SIGNAL = 'h69;
    logic [7:0] rx_byte_out;
    logic rx_byte_ready;
    logic tx_begin;
    logic [2:0] instruction_byte_counter;

    logic [31:0] program_size;
    logic [2:0] program_size_byte_counter;

    logic [31:0] sent_instruction_bytes_counter;

    logic [7:0] tx_data;
    uart_rx_engine #(
        .SYSTEM_CLK_HZ(SYSTEM_CLK_HZ  /* default 100_000_000 */),
        .BAUD_RATE    (BAUD_RATE  /* default 115200 */)
    ) rx_engine (
        .clk         (clk),
        .i_reset     (i_reset),
        .i_rx        (bootloader_if.rx),
        .o_byte_out  (rx_byte_out),
        .o_byte_ready(rx_byte_ready)
    );
    uart_tx_engine #(
        .DATA_WIDTH   (8  /* default 8 */),
        .BAUD_RATE    (BAUD_RATE  /* default 115200 */),
        .SYSTEM_CLK_HZ(SYSTEM_CLK_HZ  /* default 100_000_000 */)
    ) tx_engine (
        .clk    (clk),
        .i_reset(i_reset),
        .i_begin(tx_begin),
        .i_data (tx_data),
        .tx     (bootloader_if.tx)
    );
    always_ff @(posedge clk) begin
        if (i_reset) begin
            bootloader_if.instruction       <= 0;
            bootloader_if.instruction_ready <= 0;
            bootloader_if.program_load_done <= 0;
            program_size                    <= 0;
            program_size_byte_counter       <= 0;
            sent_instruction_bytes_counter  <= 0;
            state                           <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    tx_begin                        <= 0;
                    instruction_byte_counter        <= 0;
                    program_size                    <= 0;
                    program_size_byte_counter       <= 0;
                    sent_instruction_bytes_counter  <= 0;
                    bootloader_if.instruction       <= 0;
                    bootloader_if.instruction_ready <= 0;
                    if (bootloader_if.bootloader_begin) begin
                        tx_begin <= 1;
                        tx_data  <= BOOT_SIGNAL;
                        state    <= GET_PROGRAM_SIZE;
                    end
                end
                GET_PROGRAM_SIZE: begin
                    tx_begin <= 0;
                    if (rx_byte_ready) begin
                        program_size[(3-program_size_byte_counter)*8 +: 8] <= rx_byte_out;
                        if (program_size_byte_counter == 3) begin
                            program_size_byte_counter <= 0;
                            state                     <= INSTRUCTION_BUILD;
                        end else begin
                            program_size_byte_counter <= program_size_byte_counter + 1;
                        end
                    end
                end
                INSTRUCTION_BUILD: begin
                    tx_begin                        <= 0;
                    bootloader_if.instruction_ready <= 0;

                    if (sent_instruction_bytes_counter >= program_size) begin
                        bootloader_if.program_load_done <= 1;
                        state                           <= IDLE;
                    end else if (rx_byte_ready) begin
                        bootloader_if.instruction[(3-instruction_byte_counter)*8 +: 8] <= rx_byte_out;
                        if (instruction_byte_counter == 3) begin
                            instruction_byte_counter <= 0;
                            bootloader_if.instruction_ready <= 1;
                            sent_instruction_bytes_counter <= sent_instruction_bytes_counter + 4;
                        end else begin
                            instruction_byte_counter <= instruction_byte_counter + 1;
                        end
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
