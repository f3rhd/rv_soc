`timescale 1ns / 1ps
module tb_top;
    logic clk = 0;
    logic reset = 0;
    always #5 clk = ~clk;


    localparam HISTORY_SIZE = 10;
    localparam I_CACHE_SIZE = 1024;
    localparam D_CACHE_SIZE = 1 << 16;
    localparam BTB_SIZE = 128;
    basys3_riscv_pipeline #(
        .HISTORY_SIZE(HISTORY_SIZE  /* default 10 */),
        .I_CACHE_SIZE(I_CACHE_SIZE  /* default 1024 */),
        .D_CACHE_SIZE(D_CACHE_SIZE  /* default 1 << 16 */),
        .BTB_SIZE    (BTB_SIZE  /* default 128 */)
    ) basys3_riscv_pipeline (
        .clk  (clk),
        .reset(reset)
    );

    initial begin

        $readmemh(
            "C:/Users/me/Xarabaxana/rv32ia-basys3-pipeline/tests/full_r_instruction_test.hex",
            basys3_riscv_pipeline.fetch.memory);
        reset = 1;
        repeat (2) @(posedge clk);
        reset = 0;
        #2;
        $stop;
    end
endmodule
