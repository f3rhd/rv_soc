/*
 * SPDX-FileCopyrightText: 2026 f3rhd 
 *
 * SPDX-License-Identifier: MIT
 */

`include "graphics_interface.svh"
`include "graphics_decode_output.svh"
module graphics_unit #(
    parameter unsigned GRAPHICS_INSTRUCTION_BUFFER_SIZE = 256 * 4,
    parameter unsigned SYSTEM_CLK_HZ = 100_000_000,
    parameter unsigned SPI_CLK_HZ = 25_000_000
) (
    input logic clk,
    input logic i_reset,
    graphics_if.graphics_unit graphics_if
);

    logic instruction_buffer_advance_head;
    logic [32:0] instruction_buffer_instruction;
    logic instruction_buffer_instruction_is_valid;
    logic decode_output_bubble;
    logic execute_complete;
    logic local_gfx_reset;

    graphics_decode_output_t decode_output;


    always_ff @(posedge clk) begin
        local_gfx_reset <= i_reset;
    end
    graphics_instruction_buffer #(
        .BUFFER_SIZE(GRAPHICS_INSTRUCTION_BUFFER_SIZE  /* default 256 * 4 */)
    ) graphics_instruction_buffer (
        .clk                   (clk),
        .i_reset               (local_gfx_reset),
        .i_instruction         (graphics_if.graphics_instruction),
        .i_instruction_write   (graphics_if.graphics_instruction_write),
        .i_advance_head        (instruction_buffer_advance_head),
        .o_instruction         (instruction_buffer_instruction),
        .o_instruction_is_valid(instruction_buffer_instruction_is_valid),
        .o_buffer_is_full      (graphics_if.graphics_buffer_full)
    );

    graphics_decode graphics_decode (
        .clk                (clk),
        .i_output_bubble    (decode_output_bubble | local_gfx_reset),
        .i_instruction      (instruction_buffer_instruction),
        .i_instruction_valid(instruction_buffer_instruction_is_valid),
        .decode_output      (decode_output)
    );

    graphics_execute #(
        .SYSTEM_CLK_HZ(SYSTEM_CLK_HZ /* default 100_000_000 */),
        .SPI_CLK_HZ   (SPI_CLK_HZ /* default 25_000_000 */)
    ) graphics_execute (
        .clk               (clk),
        .i_boot            (graphics_if.graphics_init),
        .i_reset           (local_gfx_reset),
        .decode_result     (decode_output),
        .o_execute_complete(execute_complete),
        .o_sck             (graphics_if.display_sck),
        .o_sda             (graphics_if.display_sda),
        .o_dc              (graphics_if.display_dc),
        .o_cs              (graphics_if.display_cs),
        .o_res             (graphics_if.display_res),
        .o_init_done       (graphics_if.graphics_init_done)
    );
    assign instruction_buffer_advance_head = execute_complete;
    assign decode_output_bubble            = execute_complete;
endmodule
