`timescale 1ns / 1ps
module tb_spi_tx_engine;

    localparam unsigned SYSTEM_CLK_HZ = 100_000_000;
    localparam unsigned SPI_CLK_HZ = 25_000_000;
    localparam unsigned DATA_WIDTH = 8;

    logic clk = 0;
    logic i_reset;
    logic [DATA_WIDTH - 1:0] i_data;
    logic i_send_data;
    logic o_sck;
    logic o_sda;
    logic o_tx_busy;

    spi_tx_engine #(
        .SYSTEM_CLK_HZ(SYSTEM_CLK_HZ /* default 100_000_000 */),
        .SPI_CLK_HZ   (SPI_CLK_HZ /* default 12_500_000 */),
        .DATA_WIDTH   (DATA_WIDTH /* default 8 */)
    ) spi_tx_engine (
        .clk        (clk),
        .i_reset    (i_reset),
        .i_data     (i_data),
        .i_send_data(i_send_data),
        .o_sck      (o_sck),
        .o_sda      (o_sda),
        .o_tx_busy  (o_tx_busy)
    );

    always #5 clk = ~clk;

    initial begin
        i_reset = 1;
        repeat (2) @(posedge clk);
        i_reset     = 0;


        i_data      = 8'b10101011;
        i_send_data = 1;
        #1;
        @(posedge clk);
        i_send_data = 0;
        $stop;
    end
endmodule
