/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

`ifndef BOOTLOADER_INTERFACE_SVH
`define BOOTLOADER_INTERFACE_SVH
interface bootloader_if;
    logic [31:0] instruction;
    logic [31:0] static_data;
    logic static_data_ready;
    logic core_reset;
    logic instruction_ready;
    logic load_done;
    logic rx;
    logic tx;

    modport bootloader (
        output instruction,
        output instruction_ready,
        output load_done,
        output core_reset,
        output static_data,
        output static_data_ready,
        input rx,
        output tx
    );
    modport processor (
        input instruction,
        input instruction_ready,
        input load_done, 
        input static_data,
        input static_data_ready
    );
endinterface
`endif
