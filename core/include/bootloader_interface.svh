/*
 * SPDX-FileCopyrightText: 2026 f3rhd 
 *
 * SPDX-License-Identifier: MIT
 */

`ifndef BOOTLOADER_INTERFACE_SVH
`define BOOTLOADER_INTERFACE_SVH
interface bootloader_if;
    logic [31:0] instruction;
    logic instruction_ready;
    logic program_load_done;
    logic bootloader_begin;
    logic rx;
    logic tx;

    modport bootloader (
        output instruction,
        output instruction_ready,
        output program_load_done,
        input bootloader_begin,
        input rx,
        output tx
    );
    modport processor (
        input instruction,
        input instruction_ready,
        input program_load_done 
    );
endinterface
`endif
