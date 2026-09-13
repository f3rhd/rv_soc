/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

`include "common/graphics_interface.svh"
`include "common/graphics_decode_output.svh"
module graphics_unit #(
    parameter unsigned GRAPHICS_INSTRUCTION_BUFFER_SIZE = 256 * 4,
    parameter unsigned SYSTEM_CLK_HZ = 100_000_000,
    parameter unsigned SPI_CLK_HZ = 25_000_000,
    parameter signed DISPLAY_WIDTH = 128,
    parameter signed DISPLAY_HEIGHT = 160
) (
    input  logic                     clk,
    input  logic                     i_reset,
    input  logic                     i_soft_reset,
           graphics_if.graphics_unit graphics_if,
    output logic                     st7735_sck,
    output logic                     st7735_sda,
    output logic                     st7735_res,
    output logic                     st7735_dc,
    output logic                     st7735_cs
);

    logic instruction_buffer_advance_head;
    logic [31:0] instruction_buffer_instruction;
    logic instruction_buffer_instruction_is_valid;
    logic decode_output_bubble;
    logic execute_complete;

    graphics_decode_output_t decode_output;
    rasterizer_if rasterizer_if ();


    graphics_instruction_buffer #(
        .BUFFER_SIZE(GRAPHICS_INSTRUCTION_BUFFER_SIZE  /* default 256 * 4 */)
    ) graphics_instruction_buffer (
        .clk                   (clk),
        .i_reset               (i_reset | i_soft_reset),
        .i_instruction         (graphics_if.graphics_instruction),
        .i_instruction_write   (graphics_if.graphics_instruction_write),
        .i_advance_head        (instruction_buffer_advance_head),
        .o_instruction         (instruction_buffer_instruction),
        .o_instruction_is_valid(instruction_buffer_instruction_is_valid),
        .o_buffer_is_full      (graphics_if.graphics_buffer_full)
    );

    graphics_decode graphics_decode (
        .clk(clk),
        .i_output_bubble(decode_output_bubble | i_reset | i_soft_reset),
        .i_instruction(instruction_buffer_instruction),
        .i_instruction_valid(instruction_buffer_instruction_is_valid),
        .decode_output(decode_output)
    );



    rasterizer #(
        .DISPLAY_WIDTH (DISPLAY_WIDTH  /* default 128 */),
        .DISPLAY_HEIGHT(DISPLAY_HEIGHT  /* default 160 */)
    ) rasterizer (
        .clk        (clk),
        .reset      (i_soft_reset | i_reset),
        .rasterizeri(rasterizer_if)
    );

    st7735_controller #(
        .SYSTEM_CLK_HZ(SYSTEM_CLK_HZ /* default 100_000_000 */),
        .SPI_CLK_HZ   (SPI_CLK_HZ /* default 25_000_000 */)
    ) st7735_controller (
        .clk               (clk),
        .i_boot            (graphics_if.graphics_init),
        .i_reset           (i_reset),
        .i_soft_reset      (i_soft_reset),
        .decode_result     (decode_output),
        .rasterizeri       (rasterizer_if),
        .o_execute_complete(execute_complete),
        .o_sck             (st7735_sck),
        .o_sda             (st7735_sda),
        .o_dc              (st7735_dc),
        .o_cs              (st7735_cs),
        .o_res             (st7735_res),
        .o_init_done       (graphics_if.graphics_init_done)
    );
    assign instruction_buffer_advance_head = execute_complete;
    assign decode_output_bubble            = execute_complete;
endmodule
