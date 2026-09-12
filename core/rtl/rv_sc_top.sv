/*
 * SPDX-FileCopyrightText: 2026 f3rhd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

`include "bootloader/bootloader_interface.svh"
`include "graphics_unit/graphics_interface.svh"
`include "gpio_interface.svh"
module rv_sc_top (
    input logic clk,
    input logic rx,
    output logic tx,
    // graphics display ports
    output logic sck,
    output logic sda,
    output logic res,
    output logic dc,
    output logic cs,
    // 7 segment display ports 
    output logic [6:0] seg,
    output logic [3:0] an,
    output logic [15:0] led,
    // gpio pins [0:GPIO_PIN_AMOUNT-1]
    inout wire [0:26] pins_io
);
    localparam unsigned SYSTEM_CLK_HZ = 100_000_000;
    localparam unsigned GRAPHICS_SPI_CLK_HZ = 25_000_000;
    localparam unsigned BAUD_RATE = 115200;
    localparam unsigned HISTORY_SIZE = 8;
    localparam unsigned I_CACHE_SIZE = 1024 * 32;
    localparam unsigned D_CACHE_SIZE = 1024 * 32 * 4;
    localparam unsigned BTB_SIZE = 32;
    localparam unsigned GRAPHICS_INSTRUCTION_BUFFER_SIZE = 8192 / 4 * 4;
    localparam unsigned GPIO_PIN_AMOUNT = 27;

    bootloader_if bootloaderi ();
    graphics_if graphicsi ();
    gpio_if gpioi ();
    logic [15:0] segment_value;
    logic sys_reset;
    logic sys_reset_done = 0;

    always_ff @(posedge clk) begin
        sys_reset <= 0;
        if (!sys_reset_done) begin
            sys_reset      <= 1;
            sys_reset_done <= 1;
        end
        graphicsi.graphics_init <= 0;
        if (sys_reset_done && !graphicsi.graphics_init_done) begin
            graphicsi.graphics_init <= 1;
        end
    end

    assign sck            = graphicsi.display_sck;
    assign sda            = graphicsi.display_sda;
    assign res            = graphicsi.display_res;
    assign dc             = graphicsi.display_dc;
    assign cs             = graphicsi.display_cs;
    assign bootloaderi.rx = rx;
    assign tx             = bootloaderi.tx;

    bootloader #(
        .SYSTEM_CLK_HZ(SYSTEM_CLK_HZ  /* default 100_000_000 */),
        .BAUD_RATE    (BAUD_RATE  /* default 115200 */)
    ) bootloader (
        .clk          (clk),
        .i_reset      (sys_reset),
        .bootloader_if(bootloaderi)
    );
    rv_processor #(
        .HISTORY_SIZE(HISTORY_SIZE  /* default 10 */),
        .I_CACHE_SIZE(I_CACHE_SIZE  /* default 1024 */),
        .D_CACHE_SIZE(D_CACHE_SIZE  /* default 1 << 10 */),
        .BTB_SIZE    (BTB_SIZE  /* default 128 */)
    ) rv_processor (
        .clk          (clk),
        .reset        (bootloaderi.core_reset || sys_reset),
        .bootloader_if(bootloaderi),
        .graphics_if  (graphicsi),
        .gpio_if      (gpioi),
        .o_reg16_f4   (led),
        .o_reg16_f8   (segment_value)
    );
    graphics_unit #(
        .GRAPHICS_INSTRUCTION_BUFFER_SIZE(GRAPHICS_INSTRUCTION_BUFFER_SIZE /* default 256 * 4 */),
        .SYSTEM_CLK_HZ(SYSTEM_CLK_HZ  /* default 100_000_000 */),
        .SPI_CLK_HZ(GRAPHICS_SPI_CLK_HZ  /* default 25_000_000 */)
    ) graphics_unit (
        .clk        (clk),
        .i_reset    (sys_reset),
        .graphics_if(graphicsi)
    );
    seven_seg_display seven_seg_display (
        .clk(clk),
        .reset(bootloaderi.core_reset || sys_reset),
        .i_display_val(segment_value),
        .o_seg(seg),
        .o_an(an)
    );
    gpio_controller #(
        .PIN_AMOUNT(GPIO_PIN_AMOUNT  /* default 27 */)
    ) gpio_controller (
        .clk    (clk),
        .i_reset(bootloaderi.core_reset || sys_reset),
        .gpioi  (gpioi),
        .pins_io(pins_io)
    );
endmodule
