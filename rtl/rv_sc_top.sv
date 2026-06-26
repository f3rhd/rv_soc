`include "../include/bootloader_interface.svh"
`include "../include/graphics_interface.svh"
module rv_sc_top (
    input logic clk,
    input logic reset,
    input logic boot,
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
    output logic [3:0] an
);
    localparam unsigned SYSTEM_CLK_HZ = 100_000_000;
    localparam unsigned BAUD_RATE = 115200;
    localparam unsigned HISTORY_SIZE = 10;
    localparam unsigned I_CACHE_SIZE = 1024 * 4;
    localparam unsigned D_CACHE_SIZE = 1 << 10;
    localparam unsigned BTB_SIZE = 128;

    bootloader_if bootloaderi ();
    graphics_if graphicsi ();
    logic boot_edge;
    logic reset_edge;

    assign sck                          = graphicsi.display_sck;
    assign sda                          = graphicsi.display_sda;
    assign res                          = graphicsi.display_res;
    assign dc                           = graphicsi.display_dc;
    assign cs                           = graphicsi.display_cs;
    assign bootloaderi.bootloader_begin = boot_edge;
    assign graphicsi.graphics_init      = boot_edge;
    assign bootloaderi.rx               = rx;
    assign tx                           = bootloaderi.tx;

    button_edge_detect button_edge_detect_boot (
        .clk   (clk),
        .i_btn (boot),
        .o_edge(boot_edge)
    );
    button_edge_detect button_edge_detect_reset (
        .clk   (clk),
        .i_btn (reset),
        .o_edge(reset_edge)
    );

    bootloader #(
        .SYSTEM_CLK_HZ(SYSTEM_CLK_HZ  /* default 100_000_000 */),
        .BAUD_RATE    (BAUD_RATE  /* default 115200 */)
    ) bootloader (
        .clk          (clk),
        .i_reset      (reset_edge),
        .bootloader_if(bootloaderi)
    );
    rv_processor #(
        .HISTORY_SIZE(HISTORY_SIZE  /* default 10 */),
        .I_CACHE_SIZE(I_CACHE_SIZE  /* default 1024 */),
        .D_CACHE_SIZE(D_CACHE_SIZE  /* default 1 << 10 */),
        .BTB_SIZE    (BTB_SIZE  /* default 128 */)
    ) rv_processor (
        .clk          (clk),
        .reset        (reset_edge),
        .bootloader_if(bootloaderi),
        .graphics_if  (graphicsi)
    );
    graphics_unit graphics_unit (
        .clk        (clk),
        .i_reset    (reset_edge),
        .graphics_if(graphicsi)
    );
    seven_seg_display seven_seg_display (
        .clk  (clk),
        .rst_n(reset),
        .in   (graphicsi.graphics_init_done & bootloaderi.program_load_done),
        .o_seg(seg),
        .o_an (an)
    );
endmodule
