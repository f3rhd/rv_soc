/*
 * SPDX-FileCopyrightText: 2026 f3rhd 
 *
 * SPDX-License-Identifier: MIT
 */

`ifndef GRAPHICS_INTERFACE_SVH
`define GRAPHICS_INTERFACE_SVH
interface graphics_if;
    logic [32:0] graphics_instruction;
    logic graphics_instruction_write;
    logic graphics_buffer_full;
    logic graphics_init_done;
    logic graphics_init;
    logic display_sck;
    logic display_sda;
    logic display_res;
    logic display_dc;
    logic display_cs;

    modport graphics_unit (
        input graphics_instruction,
        input graphics_instruction_write,
        input graphics_init,
        output graphics_buffer_full,
        output graphics_init_done,
        output display_sck,
        output display_sda,
        output display_res,
        output display_dc,
        output display_cs
    );
    modport processor (
        input graphics_buffer_full,
        input graphics_init_done,
        output graphics_instruction,
        output graphics_instruction_write
    );
endinterface
`endif
