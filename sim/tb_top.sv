`timescale 1ns / 1ps
module tb_top;
    logic clk = 0;
    logic reset = 0;
    always #5 clk = ~clk;


    localparam HISTORY_SIZE = 10;
    localparam I_CACHE_SIZE = 1024;
    localparam D_CACHE_SIZE = 1 << 10;
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

    always @(posedge clk) begin
        if (basys3_riscv_pipeline.register_file_write_enable)
            $display(
                "Register File[%d] <- %d",
                basys3_riscv_pipeline.register_file_write_addr,
                basys3_riscv_pipeline.register_file_write_data
            );
        if (basys3_riscv_pipeline.memory.ei.mem_write) begin
            $display("DCache[%d] <- [%d]",
                     basys3_riscv_pipeline.memory.ei.alu_out,
                     basys3_riscv_pipeline.memory.ei.memory_write_data);
        end
        if (basys3_riscv_pipeline.memory.ei.mem_read) begin
            $display("Reading DCache[%d]",
                     basys3_riscv_pipeline.memory.ei.alu_out);
        end
    end
    initial begin

        $readmemh(
            "C:/Users/me/Xarabaxana/rv32ia-basys3-pipeline/tests/memory_test.hex",
            basys3_riscv_pipeline.fetch.memory);
        reset = 1;
        repeat (2) @(posedge clk);
        reset = 0;
        #2;
        $stop;
    end
endmodule
