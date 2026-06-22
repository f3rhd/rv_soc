`timescale 1ns / 1ps
`include "../include/bootloader_interface.svh"
`include "../include/graphics_interface.svh"
module tb_basys3_riscv_processor;
    logic clk = 0;
    logic reset = 0;
    always #5 clk = ~clk;


    localparam HISTORY_SIZE = 10;
    localparam I_CACHE_SIZE = 1024;
    localparam D_CACHE_SIZE = 1 << 10;
    localparam BTB_SIZE = 128;
    bootloader_if bootloader_if ();
    graphics_if graphcis_if ();
    basys3_riscv_processor #(
        .HISTORY_SIZE(HISTORY_SIZE  /* default 10 */),
        .I_CACHE_SIZE(I_CACHE_SIZE  /* default 1024 */),
        .D_CACHE_SIZE(D_CACHE_SIZE  /* default 1 << 16 */),
        .BTB_SIZE    (BTB_SIZE  /* default 128 */)
    ) basys3_riscv_pipeline (
        .clk(clk),
        .reset(reset),
        .bootloader_if(bootloader_if),
        .graphics_if(graphics_if)
    );

    always @(posedge clk) begin
        if (basys3_riscv_pipeline.register_file_write_enable && basys3_riscv_pipeline.register_file_write_addr != 0)
            $display(
                "Register File[%d] <- %d",
                basys3_riscv_pipeline.register_file_write_addr,
                basys3_riscv_pipeline.register_file_write_data
            );
        if (basys3_riscv_pipeline.memory.ei.mem_write) begin
            $display("DCache[%d] <- %d",
                     basys3_riscv_pipeline.memory.ei.alu_out,
                     basys3_riscv_pipeline.memory.ei.memory_write_data);
        end
        if (basys3_riscv_pipeline.memory.ei.mem_read) begin
            $display("Reading DCache[%d]",
                     basys3_riscv_pipeline.memory.ei.alu_out);
        end
        if (basys3_riscv_pipeline.stage_controller_stall_vector != 0) begin
            $display("Stall vector : %b",
                     basys3_riscv_pipeline.stage_controller_stall_vector);
        end
        if (basys3_riscv_pipeline.stage_controller_flush_vector != 0) begin
            $display("Flush vector : %b",
                     basys3_riscv_pipeline.stage_controller_flush_vector);
        end
        if (basys3_riscv_pipeline.prediction_redirect) begin
            $display(
                "Predictor is redirecting pc to due to dissagrement with fetch unit%d",
                basys3_riscv_pipeline.prediction_redirect_target);
        end
        if (basys3_riscv_pipeline.execution_if.predictor_update) begin
            $display("PHT[%d] <~ %d",
                     basys3_riscv_pipeline.execution_if.pht_index,
                     basys3_riscv_pipeline.execution_if.actual_branch_result);
        end
        if (basys3_riscv_pipeline.execution_if.btb_write) begin
            $display(
                "BranchTableBank[%d] <- instruction_addr : %h | target_addr : %h | is_jump : %h",
                basys3_riscv_pipeline.execution_if.branch_addr_way,
                basys3_riscv_pipeline.execution_if.branch_instruction_addr,
                basys3_riscv_pipeline.execution_if.redirection_address,
                basys3_riscv_pipeline.execution_if.btb_write_jump);
        end
        if (basys3_riscv_pipeline.execution_if.redirect) begin
            $display("Execution stage is redirecting pc to address %d",
                     basys3_riscv_pipeline.execution_if.redirection_address);
        end
        if (basys3_riscv_pipeline.fetch_btb_hit & basys3_riscv_pipeline.fetch_instruction_valid) begin
            $display("Instruction[%d] was hit in btb.",
                     basys3_riscv_pipeline.fetch_instruction_addr);
        end
    end

    initial begin

        $readmemh(
            "C:/Users/me/Xarabaxana/rv32ia-basys3-pipeline/tests/factorial_test.hex",
            basys3_riscv_pipeline.fetch.instructions);

        graphics_if.init_done           = 1;
        reset                           = 1;
        bootloader_if.fetch_begin       = 0;
        bootloader_if.instruction       = 0;
        bootloader_if.instruction_ready = 0;

        repeat (2) @(posedge clk);
        reset                           = 0;

        bootloader_if.fetch_begin       = 1;
        bootloader_if.instruction       = 0;
        bootloader_if.instruction_ready = 0;

        @(posedge clk);
        #2;
        bootloader_if.fetch_begin = 0;
        $stop;
    end
endmodule
