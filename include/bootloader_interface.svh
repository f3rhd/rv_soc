`ifndef BOOTLOADER_INTERFACE_SVH
`define BOOTLOADER_INTERFACE_SVH
interface bootloader_if;
    logic [31:0] instruction;
    logic instruction_ready;
    logic fetch_begin;
    logic bootloader_begin;
    logic rx;
    logic tx;

    modport bootloader (
        output instruction,
        output instruction_ready,
        output fetch_begin,
        input bootloader_begin,
        input rx,
        output tx
    );
    modport processor (
        input instruction,
        input instruction_ready,
        input fetch_begin
    );
endinterface
`endif
